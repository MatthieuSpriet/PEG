//
//  ADXSession.h
//  adrexo
//
//  Created by Frédéric JOUANNAUD on 29/06/12.
//  Copyright (c) 2012 SQLI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEGSession : NSObject
{
	NSString *matResp;
}
@property (nonatomic, strong) NSString *matResp;

@property (nonatomic, assign) BOOL IsAdmin;

@property (nonatomic, assign) BOOL IsSynchroOK;

- (void)replaceMatResp:(NSString *)replacement;
- (void)resetMatResp;
- (void)clearSession;

+ (PEGSession *)sharedPEGSession;

@end
