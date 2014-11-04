//
//  MBProgressHUD+Toast.h
//  adrexo
//
//  Created by Frédéric JOUANNAUD on 16/07/12.
//  Copyright (c) 2012 SQLI. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Toast)

+ (MBProgressHUD *)toastMessage:(NSString *)_message withView:(UIView *)_view andDuration:(NSTimeInterval)_delay;
+ (void)toastMessage:(NSString *)_message andDuration:(NSTimeInterval)_delay;

@end
