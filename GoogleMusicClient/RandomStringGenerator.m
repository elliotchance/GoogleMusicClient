#import "RandomStringGenerator.h"

@implementation RandomStringGenerator

+ (NSString *)charactersForOptions:(enum RandomStringGeneratorOption)option
{
    NSMutableString *result = [[NSMutableString alloc] init];
    if(option & RandomStringGeneratorOptionLowerCaseAlphabet) {
        [result appendString:@"abcdefghijklmnopqrstuvwxyz"];
    }
    if(option & RandomStringGeneratorOptionUpperCaseAlphabet) {
        [result appendString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    }
    if(option & RandomStringGeneratorOptionNumbers) {
        [result appendString:@"0123456789"];
    }
    if(option & RandomStringGeneratorOptionLowerCaseHexadecimal) {
        [result appendString:@"abcdef0123456789"];
    }
    if(option & RandomStringGeneratorOptionUpperCaseHexadecimal) {
        [result appendString:@"ABCDEF0123456789"];
    }
    return result;
}

+ (NSString *)randomStringOfLength:(NSUInteger)length options:(enum RandomStringGeneratorOption)options
{
    NSString *characters = [RandomStringGenerator charactersForOptions:options];
    return [RandomStringGenerator randomStringOfLength:length usingCharacters:characters];
}

+ (NSString *)randomStringOfLength:(NSUInteger)length usingCharacters:(NSString *)characters
{
    if([characters length] == 0) {
        characters = [RandomStringGenerator charactersForOptions:RandomStringGeneratorOptionLowerCaseHexadecimal];
    }
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    for(int i = 0; i < length; i++) {
        [randomString appendFormat: @"%C", [characters characterAtIndex: arc4random() % [characters length]]];
    }
    return randomString;
}

@end
