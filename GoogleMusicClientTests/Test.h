#ifndef Hark_Test_h
#define Hark_Test_h

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

// All tests should be using hamcrest :)
#define HC_SHORTHAND
#import <OCHamcrestExtensions/OCHamcrest.h>

// remove this when https://github.com/elliotchance/OCHamcrestExtensions/issues/7 is fixed
#import <OCHamcrestExtensions/HCEmptyString.h>

#define lacksKey(key) isNot(hasKey(key))

#endif
