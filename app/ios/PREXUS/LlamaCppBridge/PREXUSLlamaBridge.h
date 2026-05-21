#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const PREXUSLlamaBridgeErrorDomain;

typedef NS_ERROR_ENUM(PREXUSLlamaBridgeErrorDomain, PREXUSLlamaBridgeError) {
    PREXUSLlamaBridgeErrorUnavailable = 1,
    PREXUSLlamaBridgeErrorModelLoadFailed = 2,
    PREXUSLlamaBridgeErrorGenerationFailed = 3,
    PREXUSLlamaBridgeErrorCancelled = 4
};

@interface PREXUSLlamaCancellationToken : NSObject
- (void)cancel;
@end

/// Lightweight generation metrics for evaluation runs (PREXUS_LOCAL_INFERENCE_BENCHMARK=1).
@interface PREXUSLlamaGenerationMetrics : NSObject
@property (nonatomic, readonly) NSTimeInterval coldLoadMs;
@property (nonatomic, readonly) NSTimeInterval firstTokenLatencyMs;
@property (nonatomic, readonly) NSTimeInterval totalGenerationMs;
@property (nonatomic, readonly) NSInteger generatedTokenCount;
@property (nonatomic, readonly) double decodeTokensPerSecond;
@end

@interface PREXUSLlamaBridge : NSObject

@property (nonatomic, readonly, getter=isReady) BOOL ready;
@property (nonatomic, readonly, nullable) PREXUSLlamaGenerationMetrics *lastGenerationMetrics;

- (nullable instancetype)initWithModelPath:(NSString *)modelPath error:(NSError * _Nullable * _Nullable)error;
- (nullable NSString *)generateFromPrompt:(NSString *)prompt
                                maxTokens:(NSInteger)maxTokens
                              cancellation:(NSObject *)cancellationToken
                                    error:(NSError * _Nullable * _Nullable)error;
- (void)unload;

@end

NS_ASSUME_NONNULL_END
