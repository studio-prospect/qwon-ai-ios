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

@interface PREXUSLlamaBridge : NSObject

@property (nonatomic, readonly, getter=isReady) BOOL ready;

- (nullable instancetype)initWithModelPath:(NSString *)modelPath error:(NSError * _Nullable * _Nullable)error;
- (nullable NSString *)generateFromPrompt:(NSString *)prompt
                                maxTokens:(NSInteger)maxTokens
                              cancellation:(NSObject *)cancellationToken
                                    error:(NSError * _Nullable * _Nullable)error;
- (void)unload;

@end

NS_ASSUME_NONNULL_END
