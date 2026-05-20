#import "PREXUSLlamaBridge.h"

#import <atomic>
#import <string>
#import <vector>

NSString * const PREXUSLlamaBridgeErrorDomain = @"PREXUSLlamaBridgeErrorDomain";

#if PREXUS_LLAMA_CPP_AVAILABLE
#import <llama/llama.h>

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

    NSString *userMessage = PREXUSExtractUserMessage(runtimePrompt);
    llama_chat_message messages[] = {
        {
            "system",
            "You are PREXUS, a concise on-device assistant. Reply in the same language as the user."
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

@implementation PREXUSLlamaBridge {
#if PREXUS_LLAMA_CPP_AVAILABLE
    struct llama_model *_model;
    struct llama_context *_context;
#endif
    BOOL _ready;
}

- (instancetype)initWithModelPath:(NSString *)modelPath error:(NSError **)error {
    self = [super init];
    if (!self) {
        return nil;
    }

#if PREXUS_LLAMA_CPP_AVAILABLE
    llama_backend_init();

    llama_model_params modelParams = llama_model_default_params();
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
    llama_sampler_chain_add(sampler, llama_sampler_init_top_k(40));
    llama_sampler_chain_add(sampler, llama_sampler_init_temp(0.7f));
    llama_sampler_chain_add(sampler, llama_sampler_init_dist(LLAMA_DEFAULT_SEED));

    NSMutableString *output = [NSMutableString string];
    const NSInteger generationLimit = MAX(16, maxTokens);

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

        char piece[256];
        const int32_t pieceLength = llama_token_to_piece(vocab, nextToken, piece, sizeof(piece), 0, true);
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

    if (output.length == 0) {
        if (error) {
            *error = [NSError errorWithDomain:PREXUSLlamaBridgeErrorDomain
                                         code:PREXUSLlamaBridgeErrorGenerationFailed
                                     userInfo:@{NSLocalizedDescriptionKey: @"llama produced an empty completion."}];
        }
        return nil;
    }

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
    llama_backend_free();
#endif
    _ready = NO;
}

@end
