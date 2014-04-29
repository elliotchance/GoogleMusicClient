#import "Test.h"
#import "RandomStringGenerator.h"

@interface TestRandomStringGenerator : XCTestCase

@end

@implementation TestRandomStringGenerator

- (void)testUsesTheCorrectCharactersForOptionNumbers
{
    assertThat([RandomStringGenerator charactersForOptions:RandomStringGeneratorOptionNumbers], equalTo(@"0123456789"));
}

- (void)testUsesTheCorrectCharactersForOptionLowerCaseAlphabet
{
    assertThat([RandomStringGenerator charactersForOptions:RandomStringGeneratorOptionLowerCaseAlphabet], equalTo(@"abcdefghijklmnopqrstuvwxyz"));
}

- (void)testUsesTheCorrectCharactersForOptionUpperCaseAlphabet
{
    assertThat([RandomStringGenerator charactersForOptions:RandomStringGeneratorOptionUpperCaseAlphabet], equalTo(@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"));
}

- (void)testUsesTheCorrectCharactersForOptionLowerCaseHexadecimal
{
    assertThat([RandomStringGenerator charactersForOptions:RandomStringGeneratorOptionLowerCaseHexadecimal], equalTo(@"abcdef0123456789"));
}

- (void)testUsesTheCorrectCharactersForOptionUpperCaseHexadecimal
{
    assertThat([RandomStringGenerator charactersForOptions:RandomStringGeneratorOptionUpperCaseHexadecimal], equalTo(@"ABCDEF0123456789"));
}

- (void)testUsesTheCorrectCharactersWhenACombinationOfOptionsIsUsed
{
    assertThat([RandomStringGenerator charactersForOptions:RandomStringGeneratorOptionLowerCaseAlphabet | RandomStringGeneratorOptionNumbers], equalTo(@"abcdefghijklmnopqrstuvwxyz0123456789"));
}

- (void)testGeneratesRandomStringWithTheRequestedLength
{
    assertThat([RandomStringGenerator randomStringOfLength:10 usingCharacters:@"-"], equalTo(@"----------"));
}

- (void)testUsesLowerCaseHexadecimalWhenNoCharactersAreProvided
{
    NSString *random = [RandomStringGenerator randomStringOfLength:10 usingCharacters:@""];
    assertThatInteger([random length], equalToInteger(10));
}

@end
