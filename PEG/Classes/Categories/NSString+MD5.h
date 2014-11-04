//
//  NSString+MD5.h
//  SPIR
//
//  Created by Antoine Marcadet on 19/03/12.
//  Copyright (c) 2012 SQLI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

- (NSString *)md5String;
+ (NSString *)md5StringWithString:(NSString *)str;

@end
