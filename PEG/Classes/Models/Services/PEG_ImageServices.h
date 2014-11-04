//
//  PEG_ImageServices.h
//  PEG
//
//  Created by 10_200_11_120 on 08/01/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PEG_BeanImage.h"
#import "BeanPhoto.h"

@interface PEG_ImageServices : NSObject

-(NSArray*)GetAllBeanPhotoNotSend;

-(UIImage*)GetPictureFromFileById:(int)p_IdPhoto;
-(void)SavePhotoSending:(int)p_IdPhoto;
-(void)SavePhotoSend:(int)p_IdPhoto;
-(void)SavePhotoNotSend:(int)p_IdPhoto;
-(void)SavePictureInfile:(UIImage*) p_Image ById:(NSNumber*) p_id;
-(BOOL)IsPictureExist:(int)p_IdPhoto;
@end
