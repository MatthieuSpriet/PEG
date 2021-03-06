//
//  PEG_BeanImage.m
//  PEG
//
//  Created by 10_200_11_120 on 23/09/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_BeanImage.h"
#import "PEG_ServicesMerchandisingRequests.h"
#import "PEGException.h"
#import "PEGWebServices.h"

@implementation PEG_BeanImage

-(void)updateImage:(UIImage *)image{
    self.Image=nil;
    self.Image = image;
}

- (void) GetBeanImageWithObserver:(id<PEG_BeanImageDataSource>)p_ObserverOwner
{
    self.observer = p_ObserverOwner;
    
    
    [[PEGWebServices sharedWebServices] getImageStreamByIdPointLivraison:self.IdImage
    succes:^(UIImage *p_image) {
        @try
        {
            @autoreleasepool {
                [self performSelectorOnMainThread:@selector(updateImage:) withObject:p_image waitUntilDone:YES];
            }
        }
        @catch (SPIRException *exception)
        {
        }
        if (self.observer && [self.observer respondsToSelector:@selector(fillFinishedGetBeanImage)])
        {
            [self.observer fillFinishedGetBeanImage];
        }
    }
    failure:^(NSError *error) {
        if (self.observer && [self.observer respondsToSelector:@selector(finishedWithErrorGetBeanImage)])
        {
            [self.observer finishedWithErrorGetBeanImage];
        }
    }];
}

- (void) SaveBeanImageWithObserver:(id<PEG_BeanImageDataSource>)p_ObserverOwner
{
    @try
    {
        self.observer = p_ObserverOwner;
        
        [[PEGWebServices sharedWebServices]
         saveBeanImage:self
         succes:^(void) {
             if (self.observer && [self.observer respondsToSelector:@selector(fillFinishedSaveBeanImage:)])
             {
                 [self.observer fillFinishedSaveBeanImage:self];
             }
         }
         failure:^(NSError *error) {
             if (self.observer && [self.observer respondsToSelector:@selector(finishedWithErrorSaveBeanImage:)])
             {
                 [self.observer finishedWithErrorSaveBeanImage:self];
             }
         }];
    }
    @catch (NSException* p_exception)
    {
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"SaveBeanImageWithObserver" andExparams:nil];
    }
}

-(NSMutableDictionary* ) objectToJson
{
    
    NSData *imageData = UIImageJPEGRepresentation(self.Image, 0.0);
    
    const unsigned char *bytes = [imageData bytes];
    NSUInteger length = [imageData length];
    NSMutableArray *byteArray = [NSMutableArray array];
    for (NSUInteger i = 0; i<length; i++)
    {
        [byteArray addObject:[NSNumber numberWithUnsignedChar:bytes[i]]];
    }
    
    imageData = nil; //Tentative de liberer
    bytes = nil;
    
    NSMutableDictionary* v_Return=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   self.NomImage,@"nomImage",
                                   [NSString stringWithFormat:@"%i",self.Send ],@"Send",
                                   byteArray,@"Image",
                                   
                                   nil];

    return v_Return ;
}

-(id) initWithJson :(NSDictionary*)p_json
{
    self.Image = nil;
    
    NSString* v_value= [p_json stringForKeyPath:@"nomImage"];
    self.NomImage = v_value;
    
    self.Send = [p_json boolForKeyPath:@"Send"];
    
    UIImage* v_retour;
    
    NSArray *strings = [p_json arrayForKeyPath:@"Image"];
    
    unsigned c = strings.count;
    uint8_t *bytes = malloc(sizeof(*bytes) * c);
    
    unsigned i;
    for (i = 0; i < c; i++)
    {
        NSString *str = [strings objectAtIndex:i];
        int byte = [str intValue];
        bytes[i] = byte;
    }
    
    NSData *imageData = [NSData dataWithBytesNoCopy:bytes length:c freeWhenDone:YES];
    v_retour = [UIImage imageWithData:imageData];
    
    
    self.Image=v_retour;
    
    return self;
}


@end
