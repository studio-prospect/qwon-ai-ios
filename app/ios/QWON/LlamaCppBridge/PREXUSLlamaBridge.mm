#import "PREXUSLlamaBridge.h"

#import <atomic>
#import <string>
#import <string.h>
#import <vector>

NSString * const PREXUSLlamaBridgeErrorDomain = @"PREXUSLlamaBridgeErrorDomain";

#if PREXUS_LLAMA_CPP_AVAILABLE
#import <llama/llama.h>

static void PREXUSEnsureLlamaBackendInitialized(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        llama_backend_init();
    });
}

static NSString *PREXUSLocalSystemPrompt(void) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"ja_JP"];
    formatter.timeZone = [NSTimeZone localTimeZone];
    formatter.dateFormat = @"yyyy年M月d日（EEEE）";
    NSString *today = [formatter stringFromDate:[NSDate date]];

    return [NSString stringWithFormat:
        @"You are PREXUS, a helpful on-device assistant. Today's date is %@. "
        @"Answer the user's question directly. Use the same language as the user. "
        @"If you are not confident about a fact, say you do not know instead of inventing names or dates. "
        @"Keep answers short (one to three sentences).",
        today];
}

static NSString *PREXUSExtractUserMessage(NSString *prompt) {
    NSString *marker = @"User:\n";
    NSRange range = [prompt rangeOfString:marker options:NSBackwardsSearch];
    if (range.location != NSNotFound) {
        return [[prompt substringFromIndex:range.location + range.length]
            stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return [prompt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

static std::string PREXUSFormattedChatPrompt(struct llama_model *model, NSString *runtimePrompt) {
    const char *templateText = llama_model_chat_template(model, nullptr);
    if (templateText == nullptr || templateText[0] == '\0') {
        return runtimePrompt.UTF8String;
    }

    NSString *systemPrompt = PREXUSLocalSystemPrompt();
    NSString *userMessage = PREXUSExtractUserMessage(runtimePrompt);
    llama_chat_message messages[] = {
        {
            "system",
            systemPrompt.UTF8String
        },
        {
            "user",
            userMessage.UTF8String
        }
    };

    std::vector<char> buffer(8192);
    int32_t required = llama_chat_apply_template(
        templateText,
        messages,
        sizeof(messages) / sizeof(messages[0]),
        true,
        buffer.data(),
        static_cast<int32_t>(buffer.size())
    );

    if (required < 0) {
        return runtimePrompt.UTF8String;
    }

    if (required >= static_cast<int32_t>(buffer.size())) {
        buffer.resize(static_cast<size_t>(required) + 1);
        required = llama_chat_apply_template(
            templateText,
            messages,
            sizeof(messages) / sizeof(messages[0]),
            true,
            buffer.data(),
            static_cast<int32_t>(buffer.size())
        );
        if (required < 0) {
            return runtimePrompt.UTF8String;
        }
    }

    return std::string(buffer.data(), static_cast<size_t>(required));
}
#endif

@implementation PREXUSLlamaGenerationMetrics {
    NSTimeInterval _coldLoadMs;
    NSTimeInterval _firstTokenLatencyMs;
    NSTimeInterval _totalGenerationMs;
    NSInteger _generatedTokenCount;
    double _decodeTokensPerSecond;
}

- (instancetype)initWithColdLoadMs:(NSTimeInterval)coldLoadMs
                firstTokenLatencyMs:(NSTimeInterval)firstTokenLatencyMs
                 totalGenerationMs:(NSTimeInterval)totalGenerationMs
              generatedTokenCount:(NSInteger)generatedTokenCount
            decodeTokensPerSecond:(double)decodeTokensPerSecond {
    self = [super init];
    if (self) {
        _coldLoadMs = coldLoadMs;
        _firstTokenLatencyMs = firstTokenLatencyMs;
        _totalGenerationMs = totalGenerationMs;
        _generatedTokenCount = generatedTokenCount;
        _decodeTokensPerSecond = decodeTokensPerSecond;
    }
    return self;
}

- (NSTimeInterval)coldLoadMs { return _coldLoadMs; }
- (NSTimeInterval)firstTokenLatencyMs { return _firstTokenLatencyMs; }
- (NSTimeInterval)totalGenerationMs { return _totalGenerationMs; }
- (NSInteger)generatedTokenCount { return _generatedTokenCount; }
- (double)decodeTokensPerSecond { return _decodeTokensPerSecond; }

@end

@implementation PREXUSLlamaCancellationToken {
    std::atomic_bool _flag;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _flag.store(false);
    }
    return self;
}

- (std::atomic_bool *)flag {
    return &_flag;
}

- (void)cancel {
    _flag.store(true);
}

- (std::atomic_bool *)atomicFlag {
    return &_flag;
}

@end

static BOOL PREXUSLocalInferenceBenchmarkEnabled(void) {
    const char *flag = getenv("PREXUS_LOCAL_INFERENCE_BENCHMARK");
    return flag != nullptr && flag[0] != '\0' && strcmp(flag, "0") != 0;
}

static void PREXUSLogBenchmarkMetrics(PREXUSLlamaGenerationMetrics *metrics) {
    if (metrics == nil) {
        return;
    }
#if DEBUG
    const BOOL shouldLog = YES;
#else
    const BOOL shouldLog = PREXUSLocalInferenceBenchmarkEnabled();
#endif
    if (!shouldLog) {
        return;
    }
    NSLog(
        @"[PREXUS][local-inference-benchmark] cold_load_ms=%.1f first_token_ms=%.1f total_gen_ms=%.1f tokens=%ld decode_tps=%.2f",
        metrics.coldLoadMs,
        metrics.firstTokenLatencyMs,
        metrics.totalGenerationMs,
        (long)metrics.generatedTokenCount,
        metrics.decodeTokensPerSecond
    );
}

@implementation PREXUSLlamaBridge {
#if PREXUS_LLAMA_CPP_AVAILABLE
    struct llama_model *_model;
    struct llama_context *_context;
#endif
    BOOL _ready;
    PREXUSLlamaGenerationMetrics *_lastGenerationMetrics;
    NSTimeInterval _coldLoadMs;
}

- (instancetype)initWithModelPath:(NSString *)modelPath error:(NSError **)error {
    self = [super init];
    if (!self) {
        return nil;
    }

#if PREXUS_LLAMA_CPP_AVAILABLE
    PREXUSEnsureLlamaBackendInitialized();

    const CFAbsoluteTime loadStart = CFAbsoluteTimeGetCurrent();

    llama_model_params modelParams = llama_model_default_params();
    modelParams.n_gpu_layers = 99;
    _model = llama_model_load_from_file(modelPath.UTF8String, modelParams);
    if (_model == nullptr) {
        if (error) {
            *error = [NSError errorWithDomain:PREXUSLlamaBridgeErrorDomain
                                         code:PREXUSLlamaBridgeErrorModelLoadFailed
                                     userInfo:@{NSLocalizedDescriptionKey: @"Failed to load GGUF model."}];
        }
        return nil;
    }

    llama_context_params contextParams = llama_context_default_params();
    contextParams.n_ctx = 2048;
    contextParams.n_batch = 512;
    contextParams.n_threads = 4;
    contextParams.n_threads_batch = 4;

    _context = llama_init_from_model(_model, contextParams);
    if (_context == nullptr) {
        llama_model_free(_model);
        _model = nullptr;
        if (error) {
            *error = [NSError errorWithDomain:PREXUSLlamaBridgeErrorDomain
                                         code:PREXUSLlamaBridgeErrorModelLoadFailed
                                     userInfo:@{NSLocalizedDescriptionKey: @"Failed to create llama context."}];
        }
        return nil;
    }

    _coldLoadMs = (CFAbsoluteTimeGetCurrent() - loadStart) * 1000.0;
    _ready = YES;
    return self;
#else
    if (error) {
        *error = [NSError errorWithDomain:PREXUSLlamaBridgeErrorDomain
                                     code:PREXUSLlamaBridgeErrorUnavailable
                                 userInfo:@{NSLocalizedDescriptionKey: @"llama.cpp XCFramework is not linked."}];
    }
    return nil;
#endif
}

- (BOOL)isReady {
    return _ready;
}

- (PREXUSLlamaGenerationMetrics *)lastGenerationMetrics {
    return _lastGenerationMetrics;
}

- (NSString *)generateFromPrompt:(NSString *)prompt
                         maxTokens:(NSInteger)maxTokens
                      cancellation:(NSObject *)cancellationToken
                             error:(NSError **)error {
#if PREXUS_LLAMA_CPP_AVAILABLE
    if (!_ready || _model == nullptr || _context == nullptr) {
        if (error) {
            *error = [NSError errorWithDomain:PREXUSLlamaBridgeErrorDomain
                                         code:PREXUSLlamaBridgeErrorUnavailable
                                     userInfo:@{NSLocalizedDescriptionKey: @"llama bridge is not ready."}];
        }
        return nil;
    }

    PREXUSLlamaCancellationToken *token = nil;
    std::atomic_bool localFlag { false };
    std::atomic_bool *cancelFlag = &localFlag;

    if ([cancellationToken isKindOfClass:[PREXUSLlamaCancellationToken class]]) {
        token = (PREXUSLlamaCancellationToken *)cancellationToken;
        cancelFlag = token.atomicFlag;
    }

    llama_memory_clear(llama_get_memory(_context), true);

    const std::string formattedPrompt = PREXUSFormattedChatPrompt(_model, prompt);
    const char *promptText = formattedPrompt.c_str();
    const int32_t promptByteLength = static_cast<int32_t>(formattedPrompt.size());

    const struct llama_vocab *vocab = llama_model_get_vocab(_model);
    const int32_t maxPromptTokens = 1024;
    std::vector<llama_token> promptTokens(maxPromptTokens);
    const int32_t tokenizedCount = llama_tokenize(
        vocab,
        promptText,
        promptByteLength,
        promptTokens.data(),
        maxPromptTokens,
        false,
        true
    );

    if (tokenizedCount <= 0) {
        if (error) {
            *error = [NSError errorWithDomain:PREXUSLlamaBridgeErrorDomain
                                         code:PREXUSLlamaBridgeErrorGenerationFailed
                                     userInfo:@{NSLocalizedDescriptionKey: @"Prompt tokenization failed."}];
        }
        return nil;
    }

    promptTokens.resize((size_t)tokenizedCount);

    llama_batch batch = llama_batch_get_one(promptTokens.data(), tokenizedCount);
    if (llama_decode(_context, batch) != 0) {
        if (error) {
            *error = [NSError errorWithDomain:PREXUSLlamaBridgeErrorDomain
                                         code:PREXUSLlamaBridgeErrorGenerationFailed
                                     userInfo:@{NSLocalizedDescriptionKey: @"Initial llama decode failed."}];
        }
        return nil;
    }

    auto sparams = llama_sampler_chain_default_params();
    struct llama_sampler *sampler = llama_sampler_chain_init(sparams);
    llama_sampler_chain_add(sampler, llama_sampler_init_penalties(64, 1.15f, 0.05f, 0.05f));
    llama_sampler_chain_add(sampler, llama_sampler_init_top_k(40));
    llama_sampler_chain_add(sampler, llama_sampler_init_top_p(0.90f, 1));
    llama_sampler_chain_add(sampler, llama_sampler_init_temp(0.20f));
    llama_sampler_chain_add(sampler, llama_sampler_init_greedy());

    NSMutableString *output = [NSMutableString string];
    const NSInteger generationLimit = MAX(16, maxTokens);
    const CFAbsoluteTime generationStart = CFAbsoluteTimeGetCurrent();
    CFAbsoluteTime firstTokenTime = 0;
    NSInteger generatedTokenCount = 0;

    for (NSInteger index = 0; index < generationLimit; index++) {
        if (cancelFlag->load()) {
            llama_sampler_free(sampler);
            if (error) {
                *error = [NSError errorWithDomain:PREXUSLlamaBridgeErrorDomain
                                             code:PREXUSLlamaBridgeErrorCancelled
                                         userInfo:@{NSLocalizedDescriptionKey: @"Generation cancelled."}];
            }
            return nil;
        }

        llama_token nextToken = llama_sampler_sample(sampler, _context, -1);
        llama_sampler_accept(sampler, nextToken);

        if (llama_vocab_is_eog(vocab, nextToken)) {
            break;
        }

        generatedTokenCount += 1;
        if (firstTokenTime == 0) {
            firstTokenTime = CFAbsoluteTimeGetCurrent();
        }

        char piece[256];
        const int32_t pieceLength = llama_token_to_piece(vocab, nextToken, piece, sizeof(piece), 0, false);
        if (pieceLength > 0) {
            [output appendString:[[NSString alloc] initWithBytes:piece
                                                          length:(NSUInteger)pieceLength
                                                        encoding:NSUTF8StringEncoding] ?: @""];
        }

        llama_batch nextBatch = llama_batch_get_one(&nextToken, 1);
        if (llama_decode(_context, nextBatch) != 0) {
            llama_sampler_free(sampler);
            if (error) {
                *error = [NSError errorWithDomain:PREXUSLlamaBridgeErrorDomain
                                             code:PREXUSLlamaBridgeErrorGenerationFailed
                                         userInfo:@{NSLocalizedDescriptionKey: @"llama decode failed during generation."}];
            }
            return nil;
        }
    }

    llama_sampler_free(sampler);

    for (NSString *stopMarker in @[
        @"<|im_end|>",
        @"<|im_start|>",
        @"<|endoftext|>"
    ]) {
        NSRange stopRange = [output rangeOfString:stopMarker];
        if (stopRange.location != NSNotFound) {
            [output deleteCharactersInRange:NSMakeRange(
                stopRange.location,
                output.length - stopRange.location
            )];
            break;
        }
    }
    NSString *trimmed = [output stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [output setString:trimmed ?: @""];

    if (output.length == 0) {
        if (error) {
            *error = [NSError errorWithDomain:PREXUSLlamaBridgeErrorDomain
                                         code:PREXUSLlamaBridgeErrorGenerationFailed
                                     userInfo:@{NSLocalizedDescriptionKey: @"llama produced an empty completion."}];
        }
        return nil;
    }

    const CFAbsoluteTime generationEnd = CFAbsoluteTimeGetCurrent();
    const NSTimeInterval totalGenerationMs = (generationEnd - generationStart) * 1000.0;
    const NSTimeInterval firstTokenLatencyMs = firstTokenTime > 0
        ? (firstTokenTime - generationStart) * 1000.0
        : totalGenerationMs;
    const NSTimeInterval decodeWindowMs = firstTokenTime > 0
        ? (generationEnd - firstTokenTime) * 1000.0
        : totalGenerationMs;
    const double decodeTokensPerSecond = decodeWindowMs > 0
        ? (static_cast<double>(generatedTokenCount) * 1000.0) / decodeWindowMs
        : 0.0;

    _lastGenerationMetrics = [[PREXUSLlamaGenerationMetrics alloc]
        initWithColdLoadMs:_coldLoadMs
        firstTokenLatencyMs:firstTokenLatencyMs
        totalGenerationMs:totalGenerationMs
        generatedTokenCount:generatedTokenCount
        decodeTokensPerSecond:decodeTokensPerSecond];
    PREXUSLogBenchmarkMetrics(_lastGenerationMetrics);

    return output;
#else
    if (error) {
        *error = [NSError errorWithDomain:PREXUSLlamaBridgeErrorDomain
                                     code:PREXUSLlamaBridgeErrorUnavailable
                                 userInfo:@{NSLocalizedDescriptionKey: @"llama.cpp XCFramework is not linked."}];
    }
    return nil;
#endif
}

- (void)unload {
#if PREXUS_LLAMA_CPP_AVAILABLE
    if (_context != nullptr) {
        llama_free(_context);
        _context = nullptr;
    }
    if (_model != nullptr) {
        llama_model_free(_model);
        _model = nullptr;
    }
#endif
    _ready = NO;
}

@end
