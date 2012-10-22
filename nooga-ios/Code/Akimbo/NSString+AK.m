//
//  NSString+AK.m
//  AkimboCore
//
//  http://stackoverflow.com/questions/652300/using-md5-hash-on-a-string-in-cocoa
//
//

#import "NSString+AK.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (AK)

- (NSString *)md5HexDigest
{
    NSString *encodedStr = self;
    if (encodedStr == nil) {
        encodedStr = @"";
    }
    const char* str = [encodedStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

- (NSString *)urlEncode
{
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSDictionary *)queryParams
{
    NSURL *url = [NSURL URLWithString:self];
    if (url == nil) {
        return nil;
    }
    
    NSString *paramString = [url query];
    NSArray *paramArray = [paramString componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *param in paramArray) {
        NSArray *keyValue = [param componentsSeparatedByString:@"="];
        [params setValue:[keyValue objectAtIndex:1] forKey:[keyValue objectAtIndex:0]];
    }
    return params;
}

- (NSString *)regexReplace:(NSString *)pattern withTemplate:(NSString *)template
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *replacedString = [regex stringByReplacingMatchesInString:self
                                               options:0
                                                 range:NSMakeRange(0, [self length])
                                          withTemplate:template];
    return replacedString;
}

- (NSString *)slugify
{
    // Remove non-word and non-digit
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\w\\d]+"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:self
                                                               options:0
                                                                 range:NSMakeRange(0, [self length])
                                                          withTemplate:@"-"];
    return modifiedString;
}

- (NSString *)capitalize
{
    return [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self substringToIndex:1] uppercaseString]];
    
}

- (NSString *)formatWithDictionary:(NSDictionary *)dict
{
    dict = [dict mutableCopy];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\{\\{([^}]*)\\}\\}"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    
    NSString *modifiedString = self;
    NSArray *matches = [regex matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    for (int i = matches.count-1; i >= 0; i--) {
        NSTextCheckingResult *match = [matches objectAtIndex:i];
        NSString *key = [modifiedString substringWithRange:[match rangeAtIndex:1]];
        if ([dict valueForKey:key] == nil) {
            [dict setValue:@"" forKey:key];
        }
        modifiedString = [modifiedString stringByReplacingCharactersInRange:[match rangeAtIndex:0] withString:[dict valueForKey:key]];
    }
    return modifiedString;
}

@end
