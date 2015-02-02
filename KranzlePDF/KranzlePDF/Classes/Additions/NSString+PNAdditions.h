//
//  NSString+SDAdditions.h
//  

#import <Foundation/Foundation.h>


@interface NSString (PNStringAdditions)
    
- (BOOL)isEmailAddress;
- (BOOL)isValidName;

- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

- (NSString *)JSONEncodedString;
- (BOOL)isRestrictedFileName;

- (NSString *)trimedString;

- (NSString *)limitedLengthFileName;

@end
