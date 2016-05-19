//
//  NSString+LWAdditions.m
//  LifeWalletMobile
//
//  Created by Kyle Carriedo on 3/10/15.
//  Copyright (c) 2015 LifeWallet. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NSString+LWAdditions.h"
#import <CoreText/CoreText.h>

NSString *kNSStringNumberFormatter = @"NSStringNumberFormatter";
NSString * const kLWDurationNumberFormatterKey = @"kLWDurationNumberFormatterKey";


@implementation NSString (LWAdditions)

+ (id)valueOrNilForKey:(NSString *)key fromContainer:(id)container
{
    id value = [container valueForKey:key];
    return [value isEqual:[NSNull null]] ? nil : value;
}

- (unsigned long long)unsignedLongLongValue
{
    return strtoull([self UTF8String], NULL, 0);
}

- (BOOL)containsSubstring:(NSString *)substring
{
    return [self rangeOfString:substring options:NSLiteralSearch].location != NSNotFound;
}

- (BOOL)isWhitespace
{
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0;
}

- (NSString *)stringValue
{
    return self;
}

+ (NSNumberFormatter*)durationFormatter
{
    NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
    NSNumberFormatter *formatter = [threadDict objectForKey:kLWDurationNumberFormatterKey];
    if (!formatter)
    {
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setLocale:[NSLocale currentLocale]];
        [threadDict setObject:formatter forKey:kLWDurationNumberFormatterKey];
    }
    return formatter;
}

+ (NSString *)stringWithDuration:(NSTimeInterval)duration
{
    int	seconds = (int)duration;
    int	hours = (seconds / 3600);
    int	minutes = (seconds / 60) % 60;
    seconds = (seconds % 60);
    
    NSNumberFormatter *formatter = [self durationFormatter];
    
    [formatter setMinimumIntegerDigits:1];
    
    NSString *hoursString = [formatter stringFromNumber:[NSNumber numberWithInt:hours]];
    NSString	*durationString = nil;
    if (hours > 0)
    {
        [formatter setMaximumIntegerDigits:2];
        [formatter setMinimumIntegerDigits:2];
        NSString *minutesString = [formatter stringFromNumber:[NSNumber numberWithInt:minutes]];
        NSString *secondsString = [formatter stringFromNumber:[NSNumber numberWithInt:seconds]];
        NSString	*format = NSLocalizedString(@"DURATION_FORMAT_HOURS", @"%@:%@:%@");
        durationString = [NSString stringWithFormat:format, hoursString, minutesString, secondsString];
    }
    else
    {
        NSString *minutesString = [formatter stringFromNumber:[NSNumber numberWithInt:minutes]];
        [formatter setMaximumIntegerDigits:2];
        [formatter setMinimumIntegerDigits:2];
        NSString *secondsString = [formatter stringFromNumber:[NSNumber numberWithInt:seconds]];
        NSString	*format = NSLocalizedString(@"DURATION_FORMAT_MINUTES", @"%@:%@");
        durationString = [NSString stringWithFormat:format, minutesString, secondsString];
    }
    return durationString;
}


+ (NSTimeInterval)durationWithHMSString:(NSString *)durationString
{
    NSArray * substrings = [durationString componentsSeparatedByString:@":"];
    int hours = 0;
    int minutes = 0;
    int seconds = 0;
    NSAssert2(substrings.count <= 3, @"Invalid duration string %@ with %lu subcomponents", durationString, (unsigned long)substrings.count);
    if (substrings.count > 0)
    {
        seconds = [[substrings objectAtIndex:(substrings.count - 1)] intValue];
        if (substrings.count > 1)
        {
            minutes = [[substrings objectAtIndex:(substrings.count - 2)] intValue];
            if (substrings.count > 2)
            {
                hours = [[substrings objectAtIndex:(substrings.count - 3)] intValue];
            }
        }
    }
    
    return (NSTimeInterval)hours * 60 * 60 + minutes * 60 + seconds;
}

+ (NSString *)stringWithCurrency:(NSDecimalNumber *)number {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[NSLocale currentLocale]];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *localeCurrencyString = [numberFormatter stringFromNumber:number];
    return localeCurrencyString;
}

+ (NSNumber *)numberForCurrencyString:(NSString *)string {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[NSLocale currentLocale]];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSNumber *localeCurrencyString = [numberFormatter numberFromString:string];
    return localeCurrencyString;
}

+ (NSString *)stringWithBytesize:(UInt64)size
{
    static const float COMPUTER_KILO = 1024;
    float floatSize = (float)size;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:1];
    
    if (floatSize < COMPUTER_KILO)
    {	// Less than 1 KB.
        NSString * formatString = NSLocalizedString(@"SIZE_BYTES_FORMAT", @"%@ bytes");
        return [NSString stringWithFormat:formatString, [formatter stringFromNumber:[NSNumber numberWithFloat:floatSize]]];
    }
    
    floatSize /= COMPUTER_KILO;
    if (floatSize < COMPUTER_KILO)
    {	// Less than 1 MB.
        NSString * formatString = NSLocalizedString(@"SIZE_KILOBYTES_FORMAT", @"%@ KB");
        return [NSString stringWithFormat:formatString, [formatter stringFromNumber:[NSNumber numberWithFloat:floatSize]]];
    }
    
    floatSize /= COMPUTER_KILO;
    if (floatSize < COMPUTER_KILO)
    {	// Less than 1 MB.
        NSString * formatString = NSLocalizedString(@"SIZE_MEGABYTES_FORMAT", @"%@ MB");
        return [NSString stringWithFormat:formatString, [formatter stringFromNumber:[NSNumber numberWithFloat:floatSize]]];
    }
    
    // Gigs
    floatSize /= COMPUTER_KILO;
    NSString * formatString = NSLocalizedString(@"SIZE_GIGABYTES_FORMAT", @"%@ GB");
    return [NSString stringWithFormat:formatString, [formatter stringFromNumber:[NSNumber numberWithFloat:floatSize]]];
}

- (NSDictionary *)dictionaryByDecomposingQueryStringWithURLDecode:(BOOL)decode
{
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    NSArray * components = [self componentsSeparatedByString:@"&"];
    for (NSString * component in components)
    {
        NSArray * keyValuePair = [component componentsSeparatedByString:@"="];
        if (keyValuePair.count == 2)
        {
            NSString * key = [keyValuePair objectAtIndex:0];
            NSString * value = [keyValuePair objectAtIndex:1];
            if (decode)
            {
                key = [key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
            [paramDict setObject:value forKey:key];
        }
    }
    return paramDict;
}

- (NSRange)rangeOfSignificantSubstring
{
    // Need to load this from a localized plist or similar
    NSSet *badPrefixes = [NSSet setWithObjects:@"an", @"a", @"the", nil];
    
    __block NSInteger startIndex = 0;
    __block BOOL foundWord = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByWords
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              startIndex = substringRange.location;
                              if (foundWord || ![badPrefixes containsObject:[substring lowercaseString]]) {
                                  *stop = YES;
                              }
                              foundWord = YES;
                          }];
    return NSMakeRange(startIndex, [self length]-startIndex);
}

- (BOOL)hasHTML
{
    static NSArray *htmlPatterns = nil;
    if (htmlPatterns == nil) {
        htmlPatterns = [@[[NSRegularExpression regularExpressionWithPattern:@"(<[^>\\n]+>)" options:0 error:nil],
                          [NSRegularExpression regularExpressionWithPattern:@"(&#\\d+;)" options:0 error:nil]
                          ] copy];
    }
    
    // Test for HTML patterns
    for (NSRegularExpression *regex in htmlPatterns) {
        NSTextCheckingResult *match = [regex firstMatchInString:self options:0 range:NSMakeRange(0, [self length])];
        if (match) {
            return true;
        }
    }
    
    // Test for HTML entities
    NSInteger numberOfHtmlEntities = sizeof(kLWHTMLEntities) / sizeof(NSString *);
    for (int i = 0; i < numberOfHtmlEntities; i++) {
        if ([self containsSubstring:kLWHTMLEntities[i]]) {
            return true;
        }
    }
    
    return false;
}


- (NSString *)MD5
{
    const char *stringPointer = [self UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(stringPointer, (CC_LONG)strlen(stringPointer), md5Buffer);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    return output;
}

+ (NSString *)randomAlphanumericStringWithLength:(NSInteger)length{
    if (length <= 0){
        return @"";
    }
    NSString *alphabet  = @"1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSMutableString *s = [NSMutableString stringWithCapacity:length];
    for (NSInteger i = 0; i < length; i++) {
        u_int32_t r = arc4random() % [alphabet length];
        unichar c = [alphabet characterAtIndex:r];
        [s appendFormat:@"%C", c];
    }
    return s;
}

+ (BOOL)isEmptyString:(NSString *)string{
    if(string == (id)[NSNull null] || [string length] == 0) { //string is empty or nil
        return YES;
    } else if([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        //string is all whitespace
        return YES;
    }
    return NO;
}

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval
{
    NSNumberFormatter *numberFormatter = [[NSThread currentThread] threadDictionary][kNSStringNumberFormatter];
    if (!numberFormatter) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        numberFormatter.locale = [NSLocale currentLocale];
        numberFormatter.minimumIntegerDigits = 2;
        
        [[NSThread currentThread] threadDictionary][kNSStringNumberFormatter] = numberFormatter;
    }
    
    NSNumber *seconds = @(((NSInteger)timeInterval) % 60);
    NSNumber *minutes = @(((NSInteger)timeInterval / 60) % 60);
    NSNumber *hours = @((NSInteger)timeInterval / 60 / 60);
    
    return [NSString stringWithFormat:@"%@:%@:%@", [numberFormatter stringFromNumber:hours],
            [numberFormatter stringFromNumber:minutes],
            [numberFormatter stringFromNumber:seconds]];
}

- (NSString *)urlEncodedString {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[[self copy] UTF8String];
    unsigned long sourceLen = strlen((const char *)source);
    for (unsigned i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

+ (NSString *)stringByRemovingSpaces:(NSString *)string {
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:[self trim:string]];
    [mutableString replaceOccurrencesOfString:@" " withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, mutableString.length)];
    return mutableString;
}

+ (NSString *)stringWithFirstLetterCapitalized:(NSString *)string{
    return [NSString stringWithFormat:@"%@%@",[[string substringToIndex:1] capitalizedString],[string substringFromIndex:1]];
}

+ (NSString *)trim:(NSString *)string{
    if (string == nil){
        return nil;
    }
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString *)stringByReplacingNewLineCharactersWithHTMLBreakTags:(NSString *)string {
    NSMutableString *text = [NSMutableString stringWithString:[self trim:string]];
    NSString *filteredString = [text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    return filteredString;
}

+ (NSString *)stringByReplacingHTMLBreakTagsWithNewLineCharacters:(NSString *)string {
    NSMutableString *text = [NSMutableString stringWithString:[self trim:string]];
    NSString *filteredString = [text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    return filteredString;
}



+ (BOOL)isEqualStrings:(NSString *)stringOne secondString:(NSString *)stringTwo
{
    if (!stringOne && !stringTwo){
        return YES;
    }
    if (!stringTwo && stringOne){
        return NO;
    }
    if (stringTwo && !stringOne){
        return NO;
    }
    return [stringOne isEqualToString:stringTwo];
}

- (BOOL)contains:(NSString *)childString
{
    NSRange range = [self rangeOfString:childString];
    return range.location != NSNotFound;
}

+ (NSString *)formatUnderscrores:(NSString *)underscoreString {
    NSMutableString *text = [NSMutableString stringWithString:[self trim:underscoreString]];
    NSString *filteredString = [text stringByReplacingOccurrencesOfString:@"_" withString:@" "];
    return filteredString;
}

// HTML Entities, from: http://www.w3.org/TR/xhtml1/dtds.html#a_dtd_Special_characters
// Ordered by uchar lowest to highest for bsearching
static NSString * const kLWHTMLEntities[] = {
    // A.2.2. Special characters
    @"&quot;",
    @"&amp;",
    @"&apos;",
    @"&lt;",
    @"&gt;",
    
    // A.2.1. Latin-1 characters
    @"&nbsp;",
    @"&iexcl;",
    @"&cent;",
    @"&pound;",
    @"&curren;",
    @"&yen;",
    @"&brvbar;",
    @"&sect;",
    @"&uml;",
    @"&copy;",
    @"&ordf;",
    @"&laquo;",
    @"&not;",
    @"&shy;",
    @"&reg;",
    @"&macr;",
    @"&deg;",
    @"&plusmn;",
    @"&sup2;",
    @"&sup3;",
    @"&acute;",
    @"&micro;",
    @"&para;",
    @"&middot;",
    @"&cedil;",
    @"&sup1;",
    @"&ordm;",
    @"&raquo;",
    @"&frac14;",
    @"&frac12;",
    @"&frac34;",
    @"&iquest;",
    @"&Agrave;",
    @"&Aacute;",
    @"&Acirc;",
    @"&Atilde;",
    @"&Auml;",
    @"&Aring;",
    @"&AElig;",
    @"&Ccedil;",
    @"&Egrave;",
    @"&Eacute;",
    @"&Ecirc;",
    @"&Euml;",
    @"&Igrave;",
    @"&Iacute;",
    @"&Icirc;",
    @"&Iuml;",
    @"&ETH;",
    @"&Ntilde;",
    @"&Ograve;",
    @"&Oacute;",
    @"&Ocirc;",
    @"&Otilde;",
    @"&Ouml;",
    @"&times;",
    @"&Oslash;",
    @"&Ugrave;",
    @"&Uacute;",
    @"&Ucirc;",
    @"&Uuml;",
    @"&Yacute;",
    @"&THORN;",
    @"&szlig;",
    @"&agrave;",
    @"&aacute;",
    @"&acirc;",
    @"&atilde;",
    @"&auml;",
    @"&aring;",
    @"&aelig;",
    @"&ccedil;",
    @"&egrave;",
    @"&eacute;",
    @"&ecirc;",
    @"&euml;",
    @"&igrave;",
    @"&iacute;",
    @"&icirc;",
    @"&iuml;",
    @"&eth;",
    @"&ntilde;",
    @"&ograve;",
    @"&oacute;",
    @"&ocirc;",
    @"&otilde;",
    @"&ouml;",
    @"&divide;",
    @"&oslash;",
    @"&ugrave;",
    @"&uacute;",
    @"&ucirc;",
    @"&uuml;",
    @"&yacute;",
    @"&thorn;",
    @"&yuml;",
    
    // A.2.2. Special characters cont'd
    @"&OElig;",
    @"&oelig;",
    @"&Scaron;",
    @"&scaron;",
    @"&Yuml;",
    
    // A.2.3. Symbols
    @"&fnof;",
    
    // A.2.2. Special characters cont'd
    @"&circ;",
    @"&tilde;",
    
    // A.2.3. Symbols cont'd
    @"&Alpha;",
    @"&Beta;",
    @"&Gamma;",
    @"&Delta;",
    @"&Epsilon;",
    @"&Zeta;",
    @"&Eta;",
    @"&Theta;",
    @"&Iota;",
    @"&Kappa;",
    @"&Lambda;",
    @"&Mu;",
    @"&Nu;",
    @"&Xi;",
    @"&Omicron;",
    @"&Pi;",
    @"&Rho;",
    @"&Sigma;",
    @"&Tau;",
    @"&Upsilon;",
    @"&Phi;",
    @"&Chi;",
    @"&Psi;",
    @"&Omega;",
    @"&alpha;",
    @"&beta;",
    @"&gamma;",
    @"&delta;",
    @"&epsilon;",
    @"&zeta;",
    @"&eta;",
    @"&theta;",
    @"&iota;",
    @"&kappa;",
    @"&lambda;",
    @"&mu;",
    @"&nu;",
    @"&xi;",
    @"&omicron;",
    @"&pi;",
    @"&rho;",
    @"&sigmaf;",
    @"&sigma;",
    @"&tau;",
    @"&upsilon;",
    @"&phi;",
    @"&chi;",
    @"&psi;",
    @"&omega;",
    @"&thetasym;",
    @"&upsih;",
    @"&piv;",
    
    // A.2.2. Special characters cont'd
    @"&ensp;",
    @"&emsp;",
    @"&thinsp;",
    @"&zwnj;",
    @"&zwj;",
    @"&lrm;",
    @"&rlm;",
    @"&ndash;",
    @"&mdash;",
    @"&lsquo;",
    @"&rsquo;",
    @"&sbquo;",
    @"&ldquo;",
    @"&rdquo;",
    @"&bdquo;",
    @"&dagger;",
    @"&Dagger;",
    // A.2.3. Symbols cont'd
    @"&bull;",
    @"&hellip;",
    
    // A.2.2. Special characters cont'd
    @"&permil;",
    
    // A.2.3. Symbols cont'd
    @"&prime;",
    @"&Prime;",
    
    // A.2.2. Special characters cont'd
    @"&lsaquo;",
    @"&rsaquo;",
    
    // A.2.3. Symbols cont'd
    @"&oline;",
    @"&frasl;",
    
    // A.2.2. Special characters cont'd
    @"&euro;",
    
    // A.2.3. Symbols cont'd
    @"&image;",
    @"&weierp;",
    @"&real;",
    @"&trade;",
    @"&alefsym;",
    @"&larr;",
    @"&uarr;",
    @"&rarr;",
    @"&darr;",
    @"&harr;",
    @"&crarr;",
    @"&lArr;",
    @"&uArr;",
    @"&rArr;",
    @"&dArr;",
    @"&hArr;",
    @"&forall;",
    @"&part;",
    @"&exist;",
    @"&empty;",
    @"&nabla;",
    @"&isin;",
    @"&notin;",
    @"&ni;",
    @"&prod;",
    @"&sum;",
    @"&minus;",
    @"&lowast;",
    @"&radic;",
    @"&prop;",
    @"&infin;",
    @"&ang;",
    @"&and;",
    @"&or;",
    @"&cap;",
    @"&cup;",
    @"&int;",
    @"&there4;",
    @"&sim;",
    @"&cong;",
    @"&asymp;",
    @"&ne;",
    @"&equiv;",
    @"&le;",
    @"&ge;",
    @"&sub;",
    @"&sup;",
    @"&nsub;",
    @"&sube;",
    @"&supe;",
    @"&oplus;",
    @"&otimes;",
    @"&perp;",
    @"&sdot;",
    @"&lceil;",
    @"&rceil;",
    @"&lfloor;",
    @"&rfloor;",
    @"&lang;",
    @"&rang;",
    @"&loz;",
    @"&spades;",
    @"&clubs;",
    @"&hearts;",
    @"&diams;"
};

#pragma mark - String Formatters for Constants
+ (NSString *)formatLineOfBizStringForServer:(NSString *)lobStringToBeFormatted {
    NSString *addedUnderScoreString = [lobStringToBeFormatted stringByReplacingOccurrencesOfString:@" "
                                                                                        withString:@"_"];
    NSString *lowercaseLobString = [addedUnderScoreString lowercaseString];
    
    return lowercaseLobString;
}

+ (NSString *)formatInsuranceTypesStringForServer:(NSString *)insTypeStringToBeFormatted {
    NSString *removedUnderScoreString = [insTypeStringToBeFormatted stringByReplacingOccurrencesOfString:@" "
                                                                                              withString:@"_"];
    NSString *lowercaseString = [removedUnderScoreString lowercaseString];
    
    return lowercaseString;
}

+ (NSString *)formatLineOfBizStringFromServer:(NSString *)lobStringToBeFormatted {
    NSString *removedUnderScoreString = [lobStringToBeFormatted stringByReplacingOccurrencesOfString:@"_"
                                                                                          withString:@" "];
    NSString *lowercaseString = [removedUnderScoreString uppercaseString];
    
    return lowercaseString;
}

+ (NSString *)formatInsuranceTypesStringFromServer:(NSString *)insTypeStringToBeFormatted {
    NSString *removedUnderScoreString = [insTypeStringToBeFormatted stringByReplacingOccurrencesOfString:@"_"
                                                                                              withString:@" "];
    NSString *capitalizeLetter = [removedUnderScoreString capitalizedString];
    return capitalizeLetter;
}

+ (NSString*)formatNumber:(NSString*)mobileNumber {
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    int length = (int)[mobileNumber length];
    if(length > 10) {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
    }
    return mobileNumber;
}

+ (int)getLength:(NSString*)mobileNumber {
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    int length = (int)[mobileNumber length];
    return length;
}

+ (NSString*)formatHeight:(NSString*)height {
    height = [height stringByReplacingOccurrencesOfString:@"'" withString:@""];
    height = [height stringByReplacingOccurrencesOfString:@"." withString:@""];
    height = [height stringByReplacingOccurrencesOfString:@" " withString:@""];
    height = [height stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    height = [height stringByReplacingOccurrencesOfString:@"/" withString:@""];

    int length = (int)[height length];
    if(length > 3) {
        height = [height substringFromIndex: length-3];
    }
    return height;
}

+ (NSString *)removeInchesSymbol:(NSString *)height {
    height = [height stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    return height;
}

+ (int)getLengthForHeight:(NSString*)height {
    height = [height stringByReplacingOccurrencesOfString:@"'" withString:@""];
    height = [height stringByReplacingOccurrencesOfString:@"." withString:@""];
    height = [height stringByReplacingOccurrencesOfString:@" " withString:@""];
    height = [height stringByReplacingOccurrencesOfString:@"\"" withString:@""];

    int length = (int)[height length];
    return length;
}

+ (NSString*)percentEncodeURL:(NSString *)string
{
    NSString *newString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    if (newString)
    {
        return newString;
    }
    
    return @"";
}

+ (CGFloat)pixelWidthForString:(NSString*)str fontType:(UIFont *)uiFont ForWidth:(CGFloat)width
{
    // Get text
    CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    CFAttributedStringReplaceString (attrString, CFRangeMake(0, 0), (CFStringRef) str );
    CFIndex stringLength = CFStringGetLength((CFStringRef) attrString);
    
    // Change font
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef) uiFont.fontName, uiFont.pointSize, NULL);
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, stringLength), kCTFontAttributeName, ctFont);
    
    // Calc the size
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
    CFRange fitRange;
    CGSize frameSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(width, CGFLOAT_MAX), &fitRange);
    
    CFRelease(ctFont);
    CFRelease(framesetter);
    CFRelease(attrString);
    
    return frameSize.width;
}

+ (NSString *)roundNumberWithAtMostTwoDecimalPrecisionAndAmnt:(NSString *)amount {
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.##"];
    NSString *numberString = [fmt stringFromNumber:[NSNumber numberWithFloat:[amount floatValue]]];
    
    return numberString;
}

@end