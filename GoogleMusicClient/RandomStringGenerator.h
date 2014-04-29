#import <Foundation/Foundation.h>

enum RandomStringGeneratorOption
{
    RandomStringGeneratorOptionLowerCaseAlphabet    = 1 << 0,
    RandomStringGeneratorOptionUpperCaseAlphabet    = 1 << 1,
    RandomStringGeneratorOptionNumbers              = 1 << 2,
    RandomStringGeneratorOptionLowerCaseHexadecimal = 1 << 3,
    RandomStringGeneratorOptionUpperCaseHexadecimal = 1 << 4,
};

@interface RandomStringGenerator : NSObject

+ (NSString *)charactersForOptions:(enum RandomStringGeneratorOption)option;
+ (NSString *)randomStringOfLength:(NSUInteger)length options:(enum RandomStringGeneratorOption)options;
+ (NSString *)randomStringOfLength:(NSUInteger)length usingCharacters:(NSString *)characters;

@end
