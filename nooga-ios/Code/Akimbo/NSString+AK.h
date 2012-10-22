//
//  NSString+AK.h
//  AkimboCore
//
//  Created by Wes Okes on 8/10/12.
//
//

#import <Foundation/Foundation.h>

@interface NSString (AK)

- (NSString *)md5HexDigest;

/**
 * Encode the given string to be safe for use as a URL
 *
 * @param aString The string to encode
 * @return The encoded string
 */
- (NSString *)urlEncode;
- (NSDictionary *)queryParams;
- (NSString *)regexReplace:(NSString *)pattern withTemplate:(NSString *)template;
- (NSString *)slugify;
- (NSString *)capitalize;

/**
 * Replace occurences of {key} with values from a dictionary
 *
 * @param dict The dictionary containing the keys and values for replacing
 * @return The formatted string
 */
- (NSString *)formatWithDictionary:(NSDictionary *)dict;

@end
