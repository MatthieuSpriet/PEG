//
//  PEG_ImageServices.m
//  PEG
//
//  Created by 10_200_11_120 on 08/01/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import "PEG_ImageServices.h"
#import "PEGException.h"
#import "PEG_FTechnical.h"
#import "PEGAppDelegate.h"
#import "PEG_FMobilitePegase.h"

@implementation PEG_ImageServices

/****** isSend ********
 Valeurs :
 0 : Non envoyé
 1 : En cours d'envoi
 2 : Envoyé avec succés
 **********************/

-(NSArray*)GetAllBeanPhotoNotSend{
    NSMutableArray* v_AllPicture=[[NSMutableArray alloc]init];
    @try{
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        [req setEntity:[NSEntityDescription entityForName:@"BeanPhoto" inManagedObjectContext:app.managedObjectContextPhoto]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"isSend == %@",[NSNumber numberWithInt:0]]];
        
        NSArray* v_ListBeanPhoto=[app.managedObjectContextPhoto executeFetchRequest:req error:nil];
        for (BeanPhoto *v_BeanPhoto in v_ListBeanPhoto) {
            //if([v_BeanPhoto.isSend integerValue]==0){       // boolValue ?
                [v_AllPicture addObject:v_BeanPhoto];
           //}
        }
        
    }
    @catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"GetAllPictureNotSend" andExparams:nil];
    }
    return v_AllPicture;
}


-(BOOL)IsPictureExist:(int)p_IdPhoto{
    
    NSString* nom=[NSString stringWithFormat:@"%d.jpg",p_IdPhoto];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:nom]; //Add the file name
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {return YES;
    }
    return NO;
}

//


-(UIImage*)GetPictureFromFileById:(int)p_IdPhoto{
    UIImage* v_retour=nil;
    @try{
        NSString* nom=[NSString stringWithFormat:@"%d.jpg",p_IdPhoto];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
        NSString *filePath = [documentsPath stringByAppendingPathComponent:nom]; //Add the file name
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            v_retour = [[UIImage alloc] initWithContentsOfFile:filePath];
            
        }
    }
    @catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"GetPictureFromFileById" andExparams:nil];
    }
    return v_retour;
    
}

// p_id is the id of a presentoir
// creates a file with name = p_id.jpg, and add a new BeanPhoto to coredata.
// there is no test it is already existing
-(void)SavePictureInfile:(UIImage*) p_Image ById:(NSNumber*) p_id{
    
    @try{
        UIImage* imageReduite=[self imageWithImage:p_Image scaledToWidth:800];
        NSData *imageData = UIImageJPEGRepresentation(imageReduite, 0.3);
        
        NSString* nom=[NSString stringWithFormat:@"%@.jpg",p_id];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
        NSString *filePath = [documentsPath stringByAppendingPathComponent:nom]; //Add the file name
        
        [imageData writeToFile:filePath atomically:YES];
        
        //Avec le traitement en Background, on perdait des photos
        // Elles étaient écrites sur disque mais pas dans la bdd
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            BeanPhoto* v_Bean;
            PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
            
            // pm_06 test if a BeanPhoto for p_id is allready present, if yes, we just set isSend to NO so that it will be send again
            // this is NOT a full solution: if user takes a third photo before the second is send, the third won't be send
            NSFetchRequest *req = [[NSFetchRequest alloc]init];
            [req setEntity:[NSEntityDescription entityForName:@"BeanPhoto" inManagedObjectContext:app.managedObjectContextPhoto]];
            [req setPredicate:[NSPredicate predicateWithFormat:@"idPresentoir == %@",p_id]];
            
            NSArray* v_array = [app.managedObjectContextPhoto executeFetchRequest:req error:nil];
            v_Bean=[v_array lastObject];
            if (v_Bean) {
                NSLog (@"SavePictureInfile BeanPhoto: %@ allready exists !", p_id);
                v_Bean.isSend=[NSNumber numberWithInt:0];
            }
            else {
                
                NSLog (@"SavePictureInfile BeanPhoto: %@ do not exists !", p_id);
                v_Bean = (BeanPhoto *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanPhoto" inManagedObjectContext:app.managedObjectContext];
                v_Bean.isSend=[NSNumber numberWithInt:0];
                v_Bean.idPresentoir=p_id;
                v_Bean.nom=nom;
            }
            [[PEG_FMobilitePegase CreateCoreData] SavePhoto];
            
        //});
    }
    @catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"SavePictureInfile" andExparams:nil];
    }
    
}

-(void)SavePhotoSending:(int)p_IdPhoto{
    @try{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSFetchRequest *req = [[NSFetchRequest alloc]init];
            PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
            [req setEntity:[NSEntityDescription entityForName:@"BeanPhoto" inManagedObjectContext:app.managedObjectContextPhoto]];
            [req setPredicate:[NSPredicate predicateWithFormat:@"idPresentoir == %i",p_IdPhoto]];
            
            NSArray* v_array = [app.managedObjectContextPhoto executeFetchRequest:req error:nil];
            
            // Au cas ou il y ai plusieurs lignes, on set tout à send
            for (BeanPhoto* v_item in v_array) {
                v_item.isSend=[NSNumber numberWithInt:1];
            }
        //beanPhoto.isSend=[NSNumber numberWithBool:YES];
            [[PEG_FMobilitePegase CreateCoreData] SavePhoto];
        });
    }
    @catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"SavePhotoSend" andExparams:nil];
    }
}

// pm_06: p_IdPhoto est en fait un identificateur de présentoire
// appelé en cas de succès de l'upload de l'image
-(void)SavePhotoSend:(int)p_IdPhoto{
    @try{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSFetchRequest *req = [[NSFetchRequest alloc]init];
            PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
            [req setEntity:[NSEntityDescription entityForName:@"BeanPhoto" inManagedObjectContext:app.managedObjectContextPhoto]];
            [req setPredicate:[NSPredicate predicateWithFormat:@"idPresentoir == %i",p_IdPhoto]];
            
            NSArray* v_array = [app.managedObjectContextPhoto executeFetchRequest:req error:nil];
            
            // Au cas ou il y ai plusieurs lignes, on set tout à send
            for (BeanPhoto* v_item in v_array) {
                v_item.isSend=[NSNumber numberWithInt:2];
            }
        //beanPhoto.isSend=[NSNumber numberWithBool:YES];
            [[PEG_FMobilitePegase CreateCoreData] SavePhoto];
        });
    }
    @catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"SavePhotoSend" andExparams:nil];
    }
}

-(void)SavePhotoNotSend:(int)p_IdPhoto{
    @try{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSFetchRequest *req = [[NSFetchRequest alloc]init];
            PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
            [req setEntity:[NSEntityDescription entityForName:@"BeanPhoto" inManagedObjectContext:app.managedObjectContextPhoto]];
            [req setPredicate:[NSPredicate predicateWithFormat:@"idPresentoir == %i",p_IdPhoto]];
            
            NSArray* v_array = [app.managedObjectContextPhoto executeFetchRequest:req error:nil];
            
            // Au cas ou il y ai plusieurs lignes, on set tout à send
            for (BeanPhoto* v_item in v_array) {
                v_item.isSend=[NSNumber numberWithInt:0];
            }
        //beanPhoto.isSend=[NSNumber numberWithBool:YES];
            [[PEG_FMobilitePegase CreateCoreData] SavePhoto];
        });
    }
    @catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"SavePhotoSend" andExparams:nil];
    }
}

-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
