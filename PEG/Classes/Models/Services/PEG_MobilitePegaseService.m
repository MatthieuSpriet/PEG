//
//  PEG_MobilitePegaseService.m
//  PEG
//
//  Created by 10_200_11_120 on 18/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_MobilitePegaseService.h"
//#import "PEG_BeanMobilitePegase.h"
#import "PEGException.h"
#import "SPIRTechnicalException.h"
//#import "JSONKit.h"
#import "NSDictionary+ConvenientAccess.h"
//#import "PEG_BeanSuiviKMUtilisateur.h"
#import "PEG_FTechnical.h"
//#import "PEG_BeanTournee.h"
//#import "PEG_BeanLieuPassage.h"
//#import "PEG_BeanLieu.h"
#import "BeanTournee.h"
#import "PEGAppDelegate.h"
#import "PEG_GetBeanMobilitePegaseRequest.h"
#import "PEG_ServicesMerchandisingRequests.h"
#import "PEG_FMobilitePegase.h"
#import "PEGException.h"
#import "PEGSession.h"


@implementation PEG_MobilitePegaseService

-(void) AppelAssistance
{
    @try
    {
        //Florent
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0442337344"]];
        //Interway
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0442336545"]];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans AppelAssistance" andExparams:@""];
    }
}

-(BOOL) IsChangementJourDepuisDerniereSynchro
{
    BOOL v_retour = NO;
    @try
    {
        BeanMobilitePegase* v_BeanMP = [self GetBeanMobilitePegaseByMatricule:[[PEGSession sharedPEGSession] matResp]];
        //Si les dates (sans heure) ne sont pas les mêmes, il y a ey changement de jour
        if(v_BeanMP.dateSynchro != nil)
        {
            if( [[PEG_FTechnical GetDateYYYYMMDDFromDate:v_BeanMP.dateSynchro ] compare:[PEG_FTechnical GetDateYYYYMMDDFromDate:[NSDate date]]] != NSOrderedSame)
            {
                v_retour = YES;
            }
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans IsChangementJourDepuisDerniereSynchro" andExparams:@""];
    }
    return v_retour;
}

-(NSArray*) GetAllBeanMobilitePegase
{
    NSArray* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanMobilitePegase" inManagedObjectContext:app.managedObjectContext]];
        
        v_retour = [app.managedObjectContext executeFetchRequest:req error:nil];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetAllBeanMobilitePegase" andExparams:@""];
    }
    return v_retour;
}

-(BeanMobilitePegase*) GetBeanMobilitePegaseByMatricule:(NSString*)p_Matricule
{
    BeanMobilitePegase* v_retour = nil;
    @try
    {
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanMobilitePegase" inManagedObjectContext:app.managedObjectContext]];
        
        [req setPredicate:[NSPredicate predicateWithFormat:@"matricule == %@",p_Matricule]];
        v_retour = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetAllBeanMobilitePegase" andExparams:@""];
    }
    return v_retour;
}

-(BeanMobilitePegase*) GetOrCreateBeanMobilitePegaseByMatricule:(NSString*)p_Matricule
{
    BeanMobilitePegase* v_retour = nil;
    @try
    {
        v_retour = [self GetBeanMobilitePegaseByMatricule:p_Matricule];
        
        if(v_retour == nil)
        {
            PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
            v_retour = (BeanMobilitePegase *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanMobilitePegase" inManagedObjectContext:app.managedObjectContext];
            [v_retour setVersion:[[NSNumber alloc]initWithInt:0]];
            [v_retour setMatricule:p_Matricule];
            [[PEG_FMobilitePegase CreateCoreData] Save];
        }
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetOrCreateBeanMobilitePegaseByMatricule" andExparams:@""];
    }
    return v_retour;
}

#pragma mark Persistance du bean PEG_BeanMobilitePegase
/*-(void) SaveBeanMobilitePegaseInFile:(PEG_BeanMobilitePegase*) p_PEG_BeanMobilitePegase{
    
    @try{
        NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        DLog("Répertoire de sauvegarde : %@",documentsDirectory);
        //make a file name to write the data to using the documents directory:
        NSString *fileName = [NSString stringWithFormat:@"%@/BeanMobilitePegase.txt",
                              documentsDirectory];
        //create content - four lines of text
        
        NSString *content =[self FromBeanToStringByJSON:p_PEG_BeanMobilitePegase];
        //save content to the documents directory
        NSError* error = nil;
 //       [content writeToFile:fileName
 //        atomically:NO
 //        encoding:NSStringEncodingConversionAllowLossy
//         error:&error];
        if (![content writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding
                            error:&error]) {
            [[PEGException sharedInstance] ManageExceptionWithThrow:nil andMessage:[NSString stringWithFormat:@"Erreur dans SaveBeanMobilitePegaseInFile avec erreur : %@",error] andExparams:p_PEG_BeanMobilitePegase.description];
        }
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans SaveBeanMobilitePegaseInFile" andExparams:p_PEG_BeanMobilitePegase.description];
    }
    
}
-(void) SaveBeanMobiliteModifiedPegaseInFile:(PEG_BeanMobilitePegase*) p_PEG_BeanMobilitePegase{
    
    @try{
        NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        DLog("Répertoire de sauvegarde : %@",documentsDirectory);
        //make a file name to write the data to using the documents directory:
        NSString *fileName = [NSString stringWithFormat:@"%@/BeanMobiliteModifiedPegase.txt",
                              documentsDirectory];
        //create content - four lines of text
        
        NSString *content = @"";
        if (p_PEG_BeanMobilitePegase != nil)
        {
            NSMutableDictionary* v_DataSend = [p_PEG_BeanMobilitePegase objectModifiedToJson];
            if ([NSJSONSerialization isValidJSONObject:v_DataSend])
            {
                NSData* data = [NSJSONSerialization dataWithJSONObject:v_DataSend options:NSJSONWritingPrettyPrinted error:nil];
                content=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
            }else {
                
                ALog(@"JSON invalid");
                
            }
        }
        
        //save content to the documents directory
        NSError* error = nil;
        if (![content writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding
                            error:&error]) {
            [[PEGException sharedInstance] ManageExceptionWithThrow:nil andMessage:[NSString stringWithFormat:@"Erreur dans SaveBeanMobiliteModifiedPegaseInFile avec erreur : %@",error] andExparams:p_PEG_BeanMobilitePegase.description];
        }
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans SaveBeanMobiliteModifiedPegaseInFile" andExparams:p_PEG_BeanMobilitePegase.description];
    }
    
}

-(PEG_BeanMobilitePegase*) GetBeanMobilitePegaseFromFile{
    
    PEG_BeanMobilitePegase* v_PEG_BeanMobilitePegase=nil;
    
    @try{
        NSArray *paths = NSSearchPathForDirectoriesInDomains
        (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        //make a file name to write the data to using the documents directory:
        NSString *fileName = [NSString stringWithFormat:@"%@/BeanMobilitePegase.txt",
                              documentsDirectory];
        NSString *content = [[NSString alloc] initWithContentsOfFile:fileName encoding:NSUTF8StringEncoding  error:nil];
        //use simple alert from my library (see previous post for details)
        // DLog(@"=>Lecture from File: %@ ",content);
        v_PEG_BeanMobilitePegase=[self FromStringToBeanByJSON:content];
        
        [content release];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans GetBeanMobilitePegaseFromFile" andExparams:@""];
    }
    return v_PEG_BeanMobilitePegase;
}

#pragma mark Manipulation JSON du Bean du bean PEG_BeanMobilitePegase
- (void) FromNSDictionaryToBeanByJSON:(NSDictionary*) p_dico andBeanMobilitePegaseToFill:(PEG_BeanMobilitePegase*)p_ObjectToFill
{
    @try{
        if ([p_dico count]!=0)
        {
            p_ObjectToFill.ListSuiviKMUtilisateur=[[NSMutableArray alloc] init];
            NSArray* v_ListSuiviKMUtilisateur = [p_dico arrayForKeyPath:@"ListSuiviKMUtilisateur"];
            for (NSDictionary* v_ItemSuiviKMUtilisateur in v_ListSuiviKMUtilisateur)
            {
                PEG_BeanSuiviKMUtilisateur* v_BeanSuiviKMUtilisateur = [[PEG_BeanSuiviKMUtilisateur alloc] initBeanWithJson:v_ItemSuiviKMUtilisateur];
                [p_ObjectToFill.ListSuiviKMUtilisateur addObject:v_BeanSuiviKMUtilisateur];
                [v_BeanSuiviKMUtilisateur release];
            }
            
            p_ObjectToFill.ListLieu=[[NSMutableArray alloc] init];
            NSArray* v_ListLieu = [p_dico arrayForKeyPath:@"ListLieu"];
            for (NSDictionary* v_ItemLieu in v_ListLieu)
            {
                PEG_BeanLieu* v_BeanLieu = [[PEG_BeanLieu alloc] initBeanWithJson:v_ItemLieu];
                [p_ObjectToFill.ListLieu addObject:v_BeanLieu];
                [v_BeanLieu release];
            }
            
            p_ObjectToFill.ListTournee=[[NSMutableArray alloc] init];
            NSArray* v_ListTournee = [p_dico arrayForKeyPath:@"ListTournee"];
            for (NSDictionary* v_ItemTournee in v_ListTournee)
            {
                PEG_BeanTournee* v_BeanTournee = [[PEG_BeanTournee alloc] initBeanWithJson:v_ItemTournee];
                [p_ObjectToFill.ListTournee addObject:v_BeanTournee];
                [v_BeanTournee release];
            }
            
            
            p_ObjectToFill.ListConcurents=[[NSMutableArray alloc] init];
            NSArray* v_ListConcurents = [p_dico arrayForKeyPath:@"ListConcurents"];
            for (NSDictionary* v_ItemConcurents in v_ListConcurents)
            {
                PEG_BeanConcurents* v_BeanConcurent = [[PEG_BeanConcurents alloc] initBeanWithJson:v_ItemConcurents];
                [p_ObjectToFill.ListConcurents addObject:v_BeanConcurent];
                [v_BeanConcurent release];
            }
            
            p_ObjectToFill.ListCommune=[[NSMutableArray alloc] init];
            NSArray* v_ListCPCommune = [p_dico arrayForKeyPath:@"ListCommune"];
            for (NSDictionary* v_ItemCPCommune in v_ListCPCommune)
            {
                PEG_BeanCPCommune* v_BeanCPCommune = [[PEG_BeanCPCommune alloc] initBeanWithJson:v_ItemCPCommune];
                [p_ObjectToFill.ListCommune addObject:v_BeanCPCommune];
                [v_BeanCPCommune release];
            }
            
            p_ObjectToFill.ListParution=[[NSMutableArray alloc] init];
            NSArray* v_ListParution = [p_dico arrayForKeyPath:@"ListParution"];
            for (NSDictionary* v_ItemParution in v_ListParution)
            {
                PEG_BeanParution* v_BeanParution = [[PEG_BeanParution alloc] initBeanWithJson:v_ItemParution];
                [p_ObjectToFill.ListParution addObject:v_BeanParution];
                [v_BeanParution release];
            }
            
            p_ObjectToFill.ListChoix=[[NSMutableArray alloc] init];
            NSArray* v_ListChoix = [p_dico arrayForKeyPath:@"ListChoix"];
            for (NSDictionary* v_ItemChoix in v_ListChoix)
            {
                PEG_BeanChoix* v_BeanChoix= [[PEG_BeanChoix alloc] initBeanWithJson:v_ItemChoix];
                [p_ObjectToFill.ListChoix addObject:v_BeanChoix];
                [v_BeanChoix release];
            }
        }
        else
        {
            [SPIRTechnicalException raise:@"EmptyFileException" format:@"le fichier est vide"];
        }
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans FromNSDictionaryToBeanByJSON" andExparams:p_dico.description];
    }
}

- (void) FromNSDictionaryToCDByJSON:(NSDictionary*) p_dico
{
    @try{
        if ([p_dico count]!=0)
        {
            NSArray* v_ListTournee = [p_dico arrayForKeyPath:@"ListTournee"];
            for (NSDictionary* v_ItemTournee in v_ListTournee)
            {
                PEG_BeanTournee* v_BT = [PEG_BeanTournee alloc];
                //BeanTournee* v_BeanTournee =
                [v_BT initCDWithJson:v_ItemTournee];
                [v_BT release];
            }
            PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
            NSError *saveError = nil;
            if([app.managedObjectContext hasChanges])
            {
                [app.managedObjectContext save:&saveError];
            }
        }
        else
        {
            [SPIRTechnicalException raise:@"EmptyFileException" format:@"le fichier est vide"];
        }
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans FromNSDictionaryToCDByJSON" andExparams:p_dico.description];
    }
}

- (PEG_BeanMobilitePegase*)FromStringToBeanByJSON:(NSString*) p_string
{
    if (p_string == nil)
        return nil;
    
    PEG_BeanMobilitePegase* v_PEG_BeanMobilitePegase=[[PEG_BeanMobilitePegase alloc]init];
    
    @try{
        
        NSError *jSonError = nil;
        NSDictionary *result = [NSDictionary dictionaryWithDictionary:[p_string objectFromJSONStringWithParseOptions:JKParseOptionNone error:&jSonError]];
        
        if (jSonError != nil || result == nil)
        {
            // parsing du JSON, on vérifie si le parsing se passe bien
            ALog(@"Erreur de parsing JSON");
            [NSException raise:@"Erreur de parsing JSON" format:@"FromStringToBeanByJSON : Erreur de parsing JSON : %@",p_string];
        }
        [self FromNSDictionaryToBeanByJSON:result andBeanMobilitePegaseToFill:v_PEG_BeanMobilitePegase];
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans FromStringToBeanByJSON" andExparams:p_string];
    }
    //DLog(@"=>PEG_BeanMobilitePegase: %@ ",v_PEG_BeanMobilitePegase.description);
    return v_PEG_BeanMobilitePegase;
    
}
- (NSString*)FromBeanToStringByJSON:(PEG_BeanMobilitePegase*) p_PEG_BeanMobilitePegase
{
    NSString* v_retour=nil;
    @try{
        if (p_PEG_BeanMobilitePegase == nil)
            return nil;
        //on constitue la liste des element zone
        
        NSMutableDictionary* v_DataSend = [p_PEG_BeanMobilitePegase objectToJson];
        
        //DLog(@"=>Dico: %@ ",v_DataSend);
        if ([NSJSONSerialization isValidJSONObject:v_DataSend])
        {
            NSData* data = [NSJSONSerialization dataWithJSONObject:v_DataSend options:NSJSONWritingPrettyPrinted error:nil];
            v_retour=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
        }else {
            
            ALog(@"JSON invalid");
            
        }
        
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans FromBeanToStringByJSON" andExparams:p_PEG_BeanMobilitePegase.description];
    }
    return v_retour;
}



- (PEG_BeanTournee*)FromStringToBeanTourneeByJSON:(NSString*) p_string
{
    if (p_string == nil)
        return nil;
    
    PEG_BeanTournee* v_PEG_BeanTournee=[[PEG_BeanTournee alloc]init];
    
    @try{
        
        NSError *jSonError = nil;
        NSDictionary *result = [NSDictionary dictionaryWithDictionary:[p_string objectFromJSONStringWithParseOptions:JKParseOptionNone error:&jSonError]];
        
        if (jSonError != nil || result == nil)
        {
            // parsing du JSON, on vérifie si le parsing se passe bien
            ALog(@"Erreur de parsing JSON");
            [NSException raise:@"Erreur de parsing JSON" format:@"FromStringToBeanTourneeByJSON : Erreur de parsing JSON : %@",p_string];
        }
        if ([result count]!=0)
        {
            v_PEG_BeanTournee.IdTournee = [[NSNumber alloc]initWithInt:[result integerForKeyPath:@"IdTournee"]];
            v_PEG_BeanTournee.LiTournee = [result stringForKeyPath:@"LiTournee"];
            v_PEG_BeanTournee.CoTourneeType = [result stringForKeyPath:@"CoTourneeType"];
            v_PEG_BeanTournee.PremiereDistribution = [result boolForKeyPath:@"PremiereDistribution"];
            v_PEG_BeanTournee.DtDebutReelle = [PEG_FTechnical getDateFromJson:[result stringForKeyPath:@"DtDebutReelle"]];
            v_PEG_BeanTournee.IdTourneeRef = [[NSNumber alloc]initWithInt:[result integerForKeyPath:@"IdTourneeRef"]];
            v_PEG_BeanTournee.LiCommentaire = [result stringForKeyPath:@"LiCommentaire"];
            v_PEG_BeanTournee.FlagMAJ = [result stringForKeyPath:@"FlagMAJ"];
        }
        else
        {
            [SPIRTechnicalException raise:@"EmptyFileException" format:@"le fichier est vide"];
        }
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans FromStringToBeanByJSON" andExparams:p_string];
    }
    //DLog(@"=>v_PEG_BeanTournee: %@ ",v_PEG_BeanTournee.description);
    return v_PEG_BeanTournee;
    
}

- (NSString*)FromBeanTourneeToStringByJSON:(PEG_BeanTournee*) p_PEG_BeanTournee
{
    NSString* v_retour=nil;
    @try{
        if (p_PEG_BeanTournee == nil)
            return nil;
        //on constitue la liste des element zone
        NSMutableArray* v_listelemnt = [NSMutableArray array];
        
        //        for(PEG_BeanSuiviKMUtilisateur * v_elementListSuiviKMUtilisateur in p_PEG_BeanMobilitePegase.ListSuiviKMUtilisateur)
        //        {
        //            NSMutableDictionary* v_PEG_BeanSuiviKMUtilisateurDico=[NSMutableDictionary dictionaryWithObjectsAndKeys:
        //                                                                   v_elementListSuiviKMUtilisateur.Matricule,@"Matricule",
        //                                                                   [PEG_FTechnical getJsonFromDate:v_elementListSuiviKMUtilisateur.Date] ,@"Date",
        //                                                                   v_elementListSuiviKMUtilisateur.Kilometrage,@"Kilometrage",
        //                                                                   v_elementListSuiviKMUtilisateur.FlagMAJ,@"FlagMAJ",
        //                                                                   nil];
        //
        //            [v_listelemnt addObject:v_PEG_BeanSuiviKMUtilisateurDico];
        //        }
        
        NSMutableDictionary* v_DataSend=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         p_PEG_BeanTournee.IdTournee,@"IdTournee",
                                         p_PEG_BeanTournee.LiTournee,@"LiTournee",
                                         p_PEG_BeanTournee.CoTourneeType,@"CoTourneeType",
                                         p_PEG_BeanTournee.PremiereDistribution,@"PremiereDistribution",
                                         p_PEG_BeanTournee.DtDebutReelle,@"DtDebutReelle",
                                         p_PEG_BeanTournee.IdTourneeRef,@"IdTourneeRef",
                                         p_PEG_BeanTournee.LiCommentaire,@"LiCommentaire",
                                         p_PEG_BeanTournee.FlagMAJ,@"FlagMAJ",
                                         v_listelemnt,@"ListeLieuPassage",
                                         nil];
        //DLog(@"=>Dico: %@ ",v_DataSend);
        if ([NSJSONSerialization isValidJSONObject:v_DataSend])
        {
            NSData* data = [NSJSONSerialization dataWithJSONObject:v_DataSend options:NSJSONWritingPrettyPrinted error:nil];
            v_retour=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
        }else {
            
            ALog(@"JSON invalid");
            
        }
        
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans FromBeanTourneeToStringByJSON" andExparams:p_PEG_BeanTournee.description];
    }
    return v_retour;
}


- (PEG_BeanLieuPassage*)FromStringToBeanLieuPassageByJSON:(NSString*) p_string
{
    if (p_string == nil)
        return nil;
    
    PEG_BeanLieuPassage* v_PEG_BeanLieuPassage=[[PEG_BeanLieuPassage alloc]init];
    
    @try{
        
        NSError *jSonError = nil;
        NSDictionary *result = [NSDictionary dictionaryWithDictionary:[p_string objectFromJSONStringWithParseOptions:JKParseOptionNone error:&jSonError]];
        
        if (jSonError != nil || result == nil)
        {
            // parsing du JSON, on vérifie si le parsing se passe bien
            ALog(@"Erreur de parsing JSON");
            [NSException raise:@"Erreur de parsing JSON" format:@"FromStringToBeanLieuPassageByJSON : Erreur de parsing JSON : %@",p_string];
        }
        if ([result count]!=0)
        {
            v_PEG_BeanLieuPassage.IdLieuPassage = [[NSNumber alloc]initWithInt:[result integerForKeyPath:@"IdLieuPassage"]];
            v_PEG_BeanLieuPassage.IdLieu = [[NSNumber alloc]initWithInt:[result integerForKeyPath:@"IdLieu"]];
            v_PEG_BeanLieuPassage.IdTournee = [[NSNumber alloc]initWithInt:[result integerForKeyPath:@"IdTournee"]];
            v_PEG_BeanLieuPassage.NbOrdrePassage = [[NSNumber alloc]initWithInt:[result integerForKeyPath:@"NbOrdrePassage"]];
            v_PEG_BeanLieuPassage.NbNewOrdrePassage = [[NSNumber alloc]initWithInt:[result integerForKeyPath:@"NbNewOrdrePassage"]];
            v_PEG_BeanLieuPassage.FlagCreerMerch = [result boolForKeyPath:@"FlagCreerMerch"];
            v_PEG_BeanLieuPassage.DateValeur = [PEG_FTechnical getDateFromJson:[result stringForKeyPath:@"DateValeur"]];
            v_PEG_BeanLieuPassage.LiCommentaire = [result stringForKeyPath:@"LiCommentaire"];
            v_PEG_BeanLieuPassage.FlagMAJ = [result stringForKeyPath:@"FlagMAJ"];
        }
        else
        {
            [SPIRTechnicalException raise:@"EmptyFileException" format:@"le fichier est vide"];
        }
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans FromStringToBeanByJSON" andExparams:p_string];
    }
    DLog(@"=>v_PEG_BeanLieuPassage: %@ ",v_PEG_BeanLieuPassage.description);
    return v_PEG_BeanLieuPassage;
    
}

- (NSString*)FromBeanLieuPassageToStringByJSON:(PEG_BeanLieuPassage*) p_PEG_BeanLieuPassage
{
    NSString* v_retour=nil;
    @try{
        if (p_PEG_BeanLieuPassage == nil)
            return nil;
        
        NSMutableDictionary* v_DataSend=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         p_PEG_BeanLieuPassage.IdLieuPassage,@"IdLieuPassage",
                                         p_PEG_BeanLieuPassage.IdLieu,@"IdLieu",
                                         p_PEG_BeanLieuPassage.IdTournee,@"IdTournee",
                                         p_PEG_BeanLieuPassage.NbOrdrePassage,@"NbOrdrePassage",
                                         p_PEG_BeanLieuPassage.NbNewOrdrePassage,@"NbNewOrdrePassage",
                                         p_PEG_BeanLieuPassage.FlagCreerMerch,@"FlagCreerMerch",
                                         p_PEG_BeanLieuPassage.DateValeur,@"DateValeur",
                                         p_PEG_BeanLieuPassage.LiCommentaire,@"LiCommentaire",
                                         p_PEG_BeanLieuPassage.FlagMAJ,@"FlagMAJ",
                                         nil];
        DLog(@"=>Dico: %@ ",v_DataSend);
        if ([NSJSONSerialization isValidJSONObject:v_DataSend])
        {
            NSData* data = [NSJSONSerialization dataWithJSONObject:v_DataSend options:NSJSONWritingPrettyPrinted error:nil];
            v_retour=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
        }else {
            
            ALog(@"JSON invalid");
            
        }
        
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans FromBeanTourneeToStringByJSON" andExparams:p_PEG_BeanLieuPassage.description];
    }
    return v_retour;
}*/

#pragma mark Data-Access methods model
- (void) GetBeanMobilitePegaseWithObserver:(id<PEG_MobilitePegaseServiceDataSource>)p_ObserverOwner andMatricule:(NSString*) p_Matricule andDate:(NSDate*) p_date
{
    self.observerMP = p_ObserverOwner;
    
    
    PEG_GetBeanMobilitePegaseRequest* request = [PEG_GetBeanMobilitePegaseRequest requestGetBeanMobilitePegaseByMatricule:p_Matricule andDate:p_date];
    
#if ! USE_AFNetworking
    [request setStartedBlock:^
     {
     }];
#endif

    [request setCompletionBlock:^
     {
         @try
         {
             BOOL v_OK = [request processResponse];
             if(!v_OK)
             {
                 if (self.observerMP && [self.observerMP respondsToSelector:@selector(finishedWithErrorGetBeanMobilitePegase)])
                 {
                     [self.observerMP finishedWithErrorGetBeanMobilitePegase];
                 }
             }
             else
             {
                 if (self.observerMP && [self.observerMP respondsToSelector:@selector(fillFinishedGetBeanMobilitePegase)])
                 {
                     [self.observerMP fillFinishedGetBeanMobilitePegase];
                 }
             }
         }
         @catch (SPIRException *exception)
         {
             if (self.observerMP && [self.observerMP respondsToSelector:@selector(finishedWithErrorGetBeanMobilitePegase)])
             {
                 [self.observerMP finishedWithErrorGetBeanMobilitePegase];
             }
             
             // traitement de l'exception si on n'a pas de messages SAP
             if (![request hasMessages])
             {
                 //                 __block EHAlertView *alertView = [[EHAlertView alloc] initWithTitle:@"Echec de récuperation de données"
                 //                                                                             message:[NSString stringWithFormat:@"%@\nSouhaitez-vous réessayer ?", exception.reason]
                 //                                                                   cancelButtonTitle:@"Fermer"
                 //                                                                   otherButtonTitles:@"Réessayer", nil];
                 //                 [alertView setClickedButtonBlock:^(NSInteger buttonIndex)
                 //                  {
                 //                      if (buttonIndex == 1)
                 //                      {
                 //                          [self loadTarifs];
                 //                      }
                 //                      else
                 //                      {
                 //                          [self dismissModalViewControllerAnimated:YES];
                 //                      }
                 //                  }];
                 //                 [alertView show];
                 //                 [alertView release];
             }
         }
         @finally
         {
             // traitement messages SAP
             if ([request hasMessages])
             {
                 //                 SPIRMessage *message = requestTarif.mainMessage;
                 //                 EHAlertView *alertView = [[EHAlertView alloc] initWithTitle:message.title message:message.text cancelButtonTitle:@"Fermer" otherButtonTitles:nil];
                 //                 [alertView show];
                 //                 [alertView release];
             }
         }
         
     }];
    
    // traitement des erreurs réseau
    [request setFailedBlock:^
     {
         if ([request.error.domain isEqualToString:@"ASIHTTPRequestErrorDomain"] && request.error.code == 2)
         {
             [[PEGException sharedInstance] ManageExceptionWithoutThrow:nil andMessage:@"GetBeanMobilitePegaseWithObserver: TimeOut" andExparams:nil];
         }
         //self.infoGeneraleVenteFailed = YES;
         if (self.observerMP && [self.observerMP respondsToSelector:@selector(finishedWithErrorGetBeanMobilitePegase)])
         {
             [self.observerMP finishedWithErrorGetBeanMobilitePegase];
         }
         
         //         __block EHAlertView *alertView = [[EHAlertView alloc] initWithTitle:requestTarif.errorTitle
         //                                                                     message:[NSString stringWithFormat:@"%@\nSouhaitez-vous essayer ?", requestTarif.errorMessage]
         //                                                           cancelButtonTitle:@"Fermer"
         //                                                           otherButtonTitles:@"Réessayer", nil];
         //         [alertView setClickedButtonBlock:^(NSInteger buttonIndex)
         //          {
         //              if (buttonIndex == 1)
         //              {
         //                  [self loadTarifs];
         //              }
         //              else
         //              {
         //                  [self dismissModalViewControllerAnimated:YES];
         //              }
         //          }];
         //         [alertView show];
         //         [alertView release];
     }];
    
    //    // lancement de la requête
    [request startAsynchronous];
    
}

- (void) GetBeanTourneeWithObserver:(id<PEG_MobilitePegaseServiceDataSource>)p_ObserverOwner andMatricule:(NSString*) p_Matricule andDateDebut:(NSDate*) p_dateDebut andDateFin:(NSDate*) p_dateFin
{
    self.observerMP = p_ObserverOwner;
    
    
    PEG_GetBeanMobilitePegaseRequest* request = [PEG_GetBeanMobilitePegaseRequest requestGetBeanTourneeByMatricule:p_Matricule andDateDebut:p_dateDebut andDateFin:p_dateFin];
    
#if ! USE_AFNetworking
    [request setStartedBlock:^
     {
     }];
#endif

    [request setCompletionBlock:^
     {
         @try
         {
             BOOL v_OK = [request processResponseGetBeanTourneeByMatricule];
             if(!v_OK)
             {
                 if (self.observerMP && [self.observerMP respondsToSelector:@selector(finishedWithErrorGetBeanTournee)])
                 {
                     [self.observerMP finishedWithErrorGetBeanTournee];
                 }
             }
             else
             {
                 if (self.observerMP && [self.observerMP respondsToSelector:@selector(fillFinishedGetBeanTournee)])
                 {
                     [self.observerMP fillFinishedGetBeanTournee];
                 }
             }
             
         }
         @catch (SPIRException *exception)
         {
             if (self.observerMP && [self.observerMP respondsToSelector:@selector(finishedWithErrorGetBeanTournee)])
             {
                 [self.observerMP finishedWithErrorGetBeanTournee];
             }
             
             // traitement de l'exception si on n'a pas de messages SAP
             if (![request hasMessages])
             {
                 //                 __block EHAlertView *alertView = [[EHAlertView alloc] initWithTitle:@"Echec de récuperation de données"
                 //                                                                             message:[NSString stringWithFormat:@"%@\nSouhaitez-vous réessayer ?", exception.reason]
                 //                                                                   cancelButtonTitle:@"Fermer"
                 //                                                                   otherButtonTitles:@"Réessayer", nil];
                 //                 [alertView setClickedButtonBlock:^(NSInteger buttonIndex)
                 //                  {
                 //                      if (buttonIndex == 1)
                 //                      {
                 //                          [self loadTarifs];
                 //                      }
                 //                      else
                 //                      {
                 //                          [self dismissModalViewControllerAnimated:YES];
                 //                      }
                 //                  }];
                 //                 [alertView show];
                 //                 [alertView release];
             }
         }
         @finally
         {
             // traitement messages SAP
             if ([request hasMessages])
             {
                 //                 SPIRMessage *message = requestTarif.mainMessage;
                 //                 EHAlertView *alertView = [[EHAlertView alloc] initWithTitle:message.title message:message.text cancelButtonTitle:@"Fermer" otherButtonTitles:nil];
                 //                 [alertView show];
                 //                 [alertView release];
             }
         }
         
     }];
    
    // traitement des erreurs réseau
    [request setFailedBlock:^
     {
         if ([request.error.domain isEqualToString:@"ASIHTTPRequestErrorDomain"] && request.error.code == 2)
         {
             [[PEGException sharedInstance] ManageExceptionWithoutThrow:nil andMessage:@"GetBeanTourneeWithObserver: TimeOut" andExparams:nil];
         }
         //self.infoGeneraleVenteFailed = YES;
         if (self.observerMP && [self.observerMP respondsToSelector:@selector(finishedWithErrorGetBeanTournee)])
         {
             [self.observerMP finishedWithErrorGetBeanTournee];
         }
         
         //         __block EHAlertView *alertView = [[EHAlertView alloc] initWithTitle:requestTarif.errorTitle
         //                                                                     message:[NSString stringWithFormat:@"%@\nSouhaitez-vous essayer ?", requestTarif.errorMessage]
         //                                                           cancelButtonTitle:@"Fermer"
         //                                                           otherButtonTitles:@"Réessayer", nil];
         //         [alertView setClickedButtonBlock:^(NSInteger buttonIndex)
         //          {
         //              if (buttonIndex == 1)
         //              {
         //                  [self loadTarifs];
         //              }
         //              else
         //              {
         //                  [self dismissModalViewControllerAnimated:YES];
         //              }
         //          }];
         //         [alertView show];
         //         [alertView release];
     }];
    
    //    // lancement de la requête
    [request startAsynchronous];
    
}

- (void) SaveBeanMobilitePegaseWithObserver:(id<PEG_MobilitePegaseServiceDataSource>)p_ObserverOwner
{
    self.observerMP = p_ObserverOwner;
    
    
    PEG_GetBeanMobilitePegaseRequest* request = [PEG_GetBeanMobilitePegaseRequest requestSaveBeanMobilitePegase ];
    
#if ! USE_AFNetworking
    [request setStartedBlock:^
     {
     }];
#endif

#if USE_AFNetworking
	[request setSuccessBlock:^
#else
	[request setCompletionBlock:^
#endif
     {
         @try
         {
             BOOL v_OK = [request processResponseSave];
             if(v_OK)
             {
                 
                 if (self.observerMP && [self.observerMP respondsToSelector:@selector(fillFinishedSaveBeanMobilitePegase)])
                 {
                     [self.observerMP fillFinishedSaveBeanMobilitePegase];
                 }
             }
             else
             {
                 if (self.observerMP && [self.observerMP respondsToSelector:@selector(fillFinishedSaveWithErrorBeanMobilitePegase:)])
                 {
                     [self.observerMP fillFinishedSaveWithErrorBeanMobilitePegase:nil];		// pm140221 error is nil ?
                 }
             }
         }
         @catch (SPIRException *exception)
         {
             if (self.observerMP && [self.observerMP respondsToSelector:@selector(fillFinishedSaveWithErrorBeanMobilitePegase:)])
             {
                 [self.observerMP fillFinishedSaveWithErrorBeanMobilitePegase:nil];
             }
             if (![request hasMessages])
             {
                 
             }
         }
         @finally
         {
             // traitement messages SAP
             if ([request hasMessages])
             {
                 
             }
         }
         
     }];
    
    // traitement des erreurs réseau
    [request setFailedBlock:^
     {
         if ([request.error.domain isEqualToString:@"ASIHTTPRequestErrorDomain"] && request.error.code == 2)
         {
             [[PEGException sharedInstance] ManageExceptionWithoutThrow:nil andMessage:@"SaveBeanMobilitePegaseWithObserver: TimeOut" andExparams:nil];
         }
         //self.infoGeneraleVenteFailed = YES;
         if (self.observerMP && [self.observerMP respondsToSelector:@selector(fillFinishedSaveWithErrorBeanMobilitePegase:)])
         {
             [self.observerMP fillFinishedSaveWithErrorBeanMobilitePegase:request.error];
         }
         
     }];
    
    //    // lancement de la requête
    [request startAsynchronous];
    
}

#pragma mark Data-Access methods model
- (void) GetLastSuiviKMUtilisateurWithObserver:(id<PEG_BeanSuiviKMUtilisateurDataSource>)p_ObserverOwner andMatricule:(NSString*) p_Matricule
{
    self.observerKM = p_ObserverOwner;
    
    
    PEG_ServicesMerchandisingRequests* request = [PEG_ServicesMerchandisingRequests requestGetLastSuiviKilometreByMatricule:p_Matricule];
    //[self clear];
    
    
#if ! USE_AFNetworking
    [request setStartedBlock:^
     {
     }];
#endif

#if USE_AFNetworking
    [request setSuccessBlock:^
#else
    [request setCompletionBlock:^
#endif
     {
         @try
         {
             BOOL v_OK = [request processResponseGetLastSuiviKilometre];
             if(!v_OK)
             {
                 if (self.observerKM && [self.observerKM respondsToSelector:@selector(fillFinishedErrorGetLastSuiviKMUtilisateur)])
                 {
                     [self.observerKM fillFinishedErrorGetLastSuiviKMUtilisateur];
                 }
             }
             
         }
         @catch (SPIRException *exception)
         {
             //self.infoGeneraleVenteFailed = YES;
             
             // traitement de l'exception si on n'a pas de messages SAP
             if (![request hasMessages])
             {
                 //                 __block EHAlertView *alertView = [[EHAlertView alloc] initWithTitle:@"Echec de récuperation de données"
                 //                                                                             message:[NSString stringWithFormat:@"%@\nSouhaitez-vous réessayer ?", exception.reason]
                 //                                                                   cancelButtonTitle:@"Fermer"
                 //                                                                   otherButtonTitles:@"Réessayer", nil];
                 //                 [alertView setClickedButtonBlock:^(NSInteger buttonIndex)
                 //                  {
                 //                      if (buttonIndex == 1)
                 //                      {
                 //                          [self loadTarifs];
                 //                      }
                 //                      else
                 //                      {
                 //                          [self dismissModalViewControllerAnimated:YES];
                 //                      }
                 //                  }];
                 //                 [alertView show];
                 //                 [alertView release];
             }
         }
         @finally
         {
             // traitement messages SAP
             if ([request hasMessages])
             {
                 //                 SPIRMessage *message = requestTarif.mainMessage;
                 //                 EHAlertView *alertView = [[EHAlertView alloc] initWithTitle:message.title message:message.text cancelButtonTitle:@"Fermer" otherButtonTitles:nil];
                 //                 [alertView show];
                 //                 [alertView release];
             }
         }
         if (self.observerKM)
         {
             if([self.observerKM respondsToSelector:@selector(fillFinishedGetLastSuiviKMUtilisateur)])
             {
                 [self.observerKM fillFinishedGetLastSuiviKMUtilisateur];
             }
         }
         
     }];
    
    // traitement des erreurs réseau
    [request setFailedBlock:^
     {
         if ([request.error.domain isEqualToString:@"ASIHTTPRequestErrorDomain"] && request.error.code == 2)
         {
             [[PEGException sharedInstance] ManageExceptionWithoutThrow:nil andMessage:@"GetLastSuiviKMUtilisateurWithObserver: TimeOut" andExparams:nil];
         }
         //self.infoGeneraleVenteFailed = YES;
         if (self.observerKM && [self.observerKM respondsToSelector:@selector(fillFinishedErrorGetLastSuiviKMUtilisateur)])
         {
             [self.observerKM fillFinishedErrorGetLastSuiviKMUtilisateur];
         }
         
         //         __block EHAlertView *alertView = [[EHAlertView alloc] initWithTitle:requestTarif.errorTitle
         //                                                                     message:[NSString stringWithFormat:@"%@\nSouhaitez-vous essayer ?", requestTarif.errorMessage]
         //                                                           cancelButtonTitle:@"Fermer"
         //                                                           otherButtonTitles:@"Réessayer", nil];
         //         [alertView setClickedButtonBlock:^(NSInteger buttonIndex)
         //          {
         //              if (buttonIndex == 1)
         //              {
         //                  [self loadTarifs];
         //              }
         //              else
         //              {
         //                  [self dismissModalViewControllerAnimated:YES];
         //              }
         //          }];
         //         [alertView show];
         //         [alertView release];
     }];
    
    //    // lancement de la requête
    [request startAsynchronous];
    
}

@end
