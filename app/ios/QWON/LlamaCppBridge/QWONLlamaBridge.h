#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const QWONLlamaBridgeErrorDomain;

typedef NS_ERROR_ENUM(QWONLlamaBridgeErrorDomain, QWONLlamaBridgeError) {
    QWONLlamaBridgeErrorUnavailable = 1,
    QWONLlamaBridgeErrorModelLoadFailed = 2,
    QWONLlamaBridgeErrorGenerationFailed = 3,
    QWONLlamaBridgeErrorCancelled = 4
};

@interface QWONLlamaCancellationToken : NSObject
- (void)cancel;
@end

/// Lightweight generation metrics for evaluation runs (PREXUS_LOCAL_INFERENCE_BENCHMARK=1).
@interface QWONLlamaGenerationMetrics : NSObject
@property (nonatomic, readonly) NSTimeInterval coldLoadMs;
@property (nonatomic, readonly) NSTimeInterval firstTokenLatencyMs;
@property (nonatomic, readonly) NSTimeInterval totalGenerationMs;
@property (nonatomic, readonly) NSInteger generatedTokenCount;
@property (nonatomic, readonly) double decodeTokensPerSecond;
@end

@interface QWONLlamaBridge : NSObject

@property (nonatomic, readonly, getter=isReady) BOOL ready;
@property (nonatomic, readonly, nullable) QWONLlamaGenerationMetrics *lastGenerationMetrics;

- (nullable instancetype)initWithModelPath:(NSString *)modelPath error:(NSError * _Nullable * _Nullable)error;
- (nullable NSString *)generateFromPrompt:(NSString *)prompt
                                maxTokens:(NSInteger)maxTokens
                              cancellation:(NSObject *)cancellationToken
                                    error:(NSError * _Nullable * _Nullable)error;
- (void)unload;

@end

NS_ASSUME_NONNULL_END
