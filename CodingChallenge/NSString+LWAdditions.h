//
//  NSString+LWAdditions.h
//  LifeWalletMobile
//
//  Created by Kyle Carriedo on 3/10/15.
//  Copyright (c) 2015 LifeWallet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (LWAdditions)
/*
 * A convenience method that returns:
 * - (id)valueForKey:(NSString *)key;
 * But in the case of NSNull, return nil instead.
 */
+ (id)valueOrNilForKey:(NSString *)key fromContainer:(id)container;

+ (BOOL)isEqualStrings:(NSString *)stringOne secondString:(NSString *)stringTwo;

+ (NSString *)randomAlphanumericStringWithLength:(NSInteger)length;

+ (BOOL)isEmptyString:(NSString *)string;

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval;

+ (NSString *)trim:(NSString *)string;

+ (NSString *)stringWithFirstLetterCapitalized:(NSString *)string;

+ (NSString *)stringByReplacingNewLineCharactersWithHTMLBreakTags:(NSString *)string;

+ (NSString *)stringByReplacingHTMLBreakTagsWithNewLineCharacters:(NSString *)string;

+ (NSString *)stringByRemovingSpaces:(NSString *)string; //removes " " and whitespace

- (NSString *)urlEncodedString;

- (NSString *)MD5;

- (BOOL)contains:(NSString *)childString;

- (unsigned long long)unsignedLongLongValue;

- (BOOL)containsSubstring:(NSString *)substring;

- (BOOL)isWhitespace;

/*
 * Get nice formatted times
 */
+ (NSString*)stringWithDuration:(NSTimeInterval)duration;


// Returns itself.  Useful when we get values for keys that we thought were NSNumbers
- (NSString *)stringValue;

/*
 * Return time interval from string formatted h:mm:ss in seconds.
 * Not meant to change according to any internationalization.
 */
+ (NSTimeInterval)durationWithHMSString:(NSString *)durationString;

/*
 * Human readable string for given size in bytes.
 * For example:
 * 128 -> 128 bytes
 * 1024 -> 1 KB
 * 1024 * 1024 -> 1 MB
 * 1024 * 1024 * 1024 -> 1 GB
 */
+ (NSString *)stringWithBytesize:(UInt64)size;

/*
 * Formatted currency using device locale
 * $100.00
 */
+ (NSString *)stringWithCurrency:(NSDecimalNumber *)number;

/*
 * NSNumber from currency string using device locale
 * $100.00 -> NSNumber
 */
+ (NSNumber *)numberForCurrencyString:(NSString *)string;

/*
 * Makes a dictionary of key/value from HTTP URL query string of the form: key1=param1&key2=param2
 */
- (NSDictionary *)dictionaryByDecomposingQueryStringWithURLDecode:(BOOL)decode;

/*
 * Returns the range of the string without the leading article
 */
- (NSRange)rangeOfSignificantSubstring;

/*
 * Test to see if string has HTML
 */
- (BOOL)hasHTML;

+ (NSString*)percentEncodeURL:(NSString *)string;

/*
 * Formate underscores with spaces "_" to " "
 */
+ (NSString *)formatUnderscrores:(NSString *)underscoreString;

+ (int)getLength:(NSString*)mobileNumber;
+ (NSString*)formatNumber:(NSString*)mobileNumber;

+ (int)getLengthForHeight:(NSString*)height;
+ (NSString*)formatHeight:(NSString*)height;
+ (NSString*)removeInchesSymbol:(NSString*)height;

#pragma mark - String Formatters for Constants
+ (NSString *)formatLineOfBizStringForServer:(NSString *)lobStringToBeFormatted;

+ (NSString *)formatInsuranceTypesStringForServer:(NSString *)insTypeStringToBeFormatted;

+ (NSString *)formatLineOfBizStringFromServer:(NSString *)lobStringToBeFormatted;

+ (NSString *)formatInsuranceTypesStringFromServer:(NSString *)insTypeStringToBeFormatted;

+ (CGFloat)pixelWidthForString:(NSString*)str fontType:(UIFont *)uiFont ForWidth:(CGFloat)width;

+ (NSString *)roundNumberWithAtMostTwoDecimalPrecisionAndAmnt:(NSString *)amount;

@end
