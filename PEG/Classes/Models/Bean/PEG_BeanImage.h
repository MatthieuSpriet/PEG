//
//  PEG_BeanImage.h
//  PEG
//
//  Created by 10_200_11_120 on 23/09/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PEG_BeanImageDataSource;


@interface PEG_BeanImage : NSObject


@property (nonatomic, assign) int IdImage;
@property (nonatomic, strong) NSString* NomImage;
@property (nonatomic, strong) UIImage* Image;
@property (nonatomic, assign) BOOL Send;

@property (nonatomic,weak) id<PEG_BeanImageDataSource> observer;

-(NSMutableDictionary* ) objectToJson;
-(id) initWithJson :(NSDictionary*)p_json;
- (void) GetBeanImageWithObserver:(id<PEG_BeanImageDataSource>)p_ObserverOwner;
- (void) SaveBeanImageWithObserver:(id<PEG_BeanImageDataSource>)p_ObserverOwner;
@end


@protocol PEG_BeanImageDataSource <NSObject>

@optional
-(void) fillFinishedGetBeanImage;
-(void) finishedWithErrorGetBeanImage;

-(void) fillFinishedSaveBeanImage:(PEG_BeanImage*)p_BeanImage;
-(void) finishedWithErrorSaveBeanImage:(PEG_BeanImage*)p_BeanImage;


@end
