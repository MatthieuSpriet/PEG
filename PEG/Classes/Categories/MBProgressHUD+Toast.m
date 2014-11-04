//
//  MBProgressHUD+Toast.m
//  adrexo
//
//  Created by Frédéric JOUANNAUD on 16/07/12.
//  Copyright (c) 2012 SQLI. All rights reserved.
//

#import "MBProgressHUD+Toast.h"

@implementation MBProgressHUD (Toast)

+ (MBProgressHUD *)toastMessage:(NSString *)_message withView:(UIView *)_view andDuration:(NSTimeInterval)_delay
{	
	UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
	
	MBProgressHUD *toastHud = [[MBProgressHUD alloc] initWithView:_view];
	[_view addSubview:toastHud];
	[toastHud removeFromSuperViewOnHide];
	
	UIView	*customView =  [[UIView alloc] initWithFrame:CGRectMake(.0, .0, 160.0, 160.0)];
	UILabel *label = [[UILabel alloc] initWithFrame:customView.frame];
	[label setTextAlignment:NSTextAlignmentCenter /* pm201402 was UITextAlignmentCenter*/];
	[label setTextColor:[UIColor whiteColor]];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setNumberOfLines:10];
	[label setText:_message];
	[label setFont:font];
	[customView addSubview:label];
	
	[toastHud setMargin:3.0];
	[toastHud setCustomView:customView];
	
	[toastHud setMode:MBProgressHUDModeCustomView];
	[toastHud show:YES];
	[toastHud hide:YES afterDelay:_delay];
	
	return toastHud;
}


+ (void)toastMessage:(NSString *)_message andDuration:(NSTimeInterval)_delay
{	
	[MBProgressHUD toastMessage:_message withView:(UIWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0] andDuration:_delay];
}

@end
