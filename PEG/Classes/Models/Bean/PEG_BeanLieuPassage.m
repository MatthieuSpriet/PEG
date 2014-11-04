

//
//  PEG_BeanLieuPassage.m
//  PEG
//
//  Created by 10_200_11_120 on 18/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_BeanLieuPassage.h"
#import "PEG_FTechnical.h"
#import "PEGException.h"
#import "PEG_BeanActionPresentoir.h"
#import "PEG_EnumFlagMAJ.h"
#import "PEGAppDelegate.h"

@implementation PEG_BeanLieuPassage

-(NSString*) description
{
	return [NSString stringWithFormat:@"<%@ %p> {IdLieuPassage :%@, IdLieu: %@, IdTournee :%@, NbOrdrePassage : %@, NbNewOrdrePassage : %@, FlagCreerMerch : %i, DateValeur : %@, LiCommentaire : %@, FlagMAJ : %@,DatePassageReel : %@, ListActionPresentoir : %@}",
            NSStringFromClass([self class]),
            self,
            self.IdLieuPassage,
            self.IdLieu,
            self.IdTournee,
            self.NbOrdrePassage,
            self.NbNewOrdrePassage,
            self.FlagCreerMerch,
            self.DateValeur,
            self.LiCommentaire,
            self.FlagMAJ,
            self.DatePassageReel,
            self.ListActionPresentoir];
}

-(id) initBeanWithJson :(NSDictionary*)p_json
{
    @try{
        self = [self init];
        if (self)
        {
            self.IdLieuPassage = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdLieuPassage"]];
            self.IdLieu = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdLieu"]];
            self.IdTournee = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdTournee"]];
            self.NbOrdrePassage = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"NbOrdrePassage"]];
            //if([p_json stringForKeyPath:@"NbNewOrdrePassage"] != nil )
            self.NbNewOrdrePassage = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"NbNewOrdrePassage"]];
            //if([p_json stringForKeyPath:@"FlagCreerMerch"] != nil )
            self.FlagCreerMerch = [p_json boolForKeyPath:@"FlagCreerMerch"];
            //if((![[p_json stringForKeyPath:@"DateValeur"] isEqualToString:@""]) || [p_json stringForKeyPath:@"DateValeur"] != nil ) self.DateValeur = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"DateValeur"]];
            self.DateValeur = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"DateValeur"]];
            //if([p_json stringForKeyPath:@"LiCommentaire"] != nil )
            self.LiCommentaire = [p_json stringForKeyPath:@"LiCommentaire"];
            //if([p_json respondsToSelector:NSSelectorFromString(@"FlagMAJ")])
            self.FlagMAJ = [p_json stringForKeyPath:@"FlagMAJ"];
            self.DatePassageReel = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"DatePassageReel"]];
            
            self.ListActionPresentoir =[[NSMutableArray alloc] init];
            NSArray* v_ListActionPresentoir = [p_json arrayForKeyPath:@"ListActionPresentoir"];
            for (NSDictionary* v_Item in v_ListActionPresentoir)
            {
                PEG_BeanActionPresentoir* v_Bean = [[PEG_BeanActionPresentoir alloc] initBeanWithJson:v_Item];
                [self.ListActionPresentoir addObject:v_Bean];
                [v_Bean release];
            }
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"PEG_BeanLieuPassage.initBeanWithJson Lieu: %@",self.description] andExparams:nil];
    }
    
    return self;
}

-(BeanLieuPassage*) initCDWithJson :(NSDictionary*)p_json
{
    BeanLieuPassage *v_Bean =nil;
    @try{
        
        //On n'insert que si la ligne n'existe pas
        PEGAppDelegate *app = [UIApplication sharedApplication].delegate;
        
        //On vérifie si la ligne existe déjà
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanLieuPassage" inManagedObjectContext:app.managedObjectContext]];
        NSString* v_IdLieuPassage = [p_json stringForKeyPath:@"IdLieuPassage"];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idLieuPassage == %@",v_IdLieuPassage]];
        
        v_Bean = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
        if(v_Bean != nil)
        {
            //La ligne existe déjà on ne fait rien
        }
        else
        {
            v_Bean = (BeanLieuPassage *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanLieuPassage" inManagedObjectContext:app.managedObjectContext];
            [v_Bean setIdLieuPassage:[[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdLieuPassage"]]];
            [v_Bean setIdLieu:[[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdLieu"]]];
            [v_Bean setIdTournee:[[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdTournee"]]];
            [v_Bean setNbOrdrePassage:[[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"NbOrdrePassage"]]];
            [v_Bean setNbNewOrdrePassage:[[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"NbNewOrdrePassage"]]];
            [v_Bean setFlagCreerMerch:[[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"FlagCreerMerch"] ]];
            [v_Bean setDateValeur:[PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"DateValeur"]]];
            [v_Bean setLiCommentaire:[p_json stringForKeyPath:@"LiCommentaire"]];
            [v_Bean setDatePassageReel:[PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"DatePassageReel"]]];
            [v_Bean setFlagMAJ:[p_json stringForKeyPath:@"FlagMAJ"]];
            
            NSArray* v_List = [p_json arrayForKeyPath:@"ListActionPresentoir"];
            for (NSDictionary* v_Item in v_List)
            {
                PEG_BeanActionPresentoir* v_BeanItem = [PEG_BeanActionPresentoir alloc];
                BeanActionPresentoir* v_BeanCD = [v_BeanItem initCDWithJson:v_Item];
                [v_Bean addListActionPresentoirObject:v_BeanCD];
                [v_BeanItem release];
            }

        }
        //CoreData
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"PEG_BeanTournee.initBeanWithJson IdTournee: %@",self.IdTournee] andExparams:nil];
    }
    return v_Bean;}


-(NSMutableDictionary* ) objectToJson
{
    NSMutableArray* v_ListActionPresentoir = [NSMutableArray array];
    for(PEG_BeanActionPresentoir* v_BeanActionPresentoir in self.ListActionPresentoir)
    {
        [v_ListActionPresentoir addObject:[v_BeanActionPresentoir objectToJson]];
    }
    
    /*NSMutableDictionary* v_Return = [NSMutableDictionary dictionaryWithObjectsAndKeys:
     self.IdLieuPassage,@"IdLieuPassage",
     self.IdLieu,@"IdLieu",
     self.IdTournee,@"IdTournee",
     self.NbOrdrePassage,@"NbOrdrePassage",
     self.NbNewOrdrePassage,@"NbNewOrdrePassage",
     [[NSNumber alloc ] initWithBool:self.FlagCreerMerch],@"FlagCreerMerch",
     [PEG_FTechnical getJsonFromDate:self.DateValeur],@"DateValeur",
     self.LiCommentaire,@"LiCommentaire",
     self.FlagMAJ,@"FlagMAJ",
     [PEG_FTechnical getJsonFromDate:self.DatePassageReel],@"DatePassageReel",
     v_ListActionPresentoir,@"ListActionPresentoir",
     nil];*/
    
    NSMutableDictionary* v_Return2 =[[NSMutableDictionary alloc] init];
    if (self.IdLieuPassage != nil)[v_Return2 setObject:self.IdLieuPassage forKey:@"IdLieuPassage"];
    if (self.IdLieu != nil)[v_Return2 setObject:self.IdLieu forKey:@"IdLieu"];
    if (self.IdTournee != nil)[v_Return2 setObject:self.IdTournee forKey:@"IdTournee"];
    if (self.NbOrdrePassage != nil)[v_Return2 setObject:self.NbOrdrePassage forKey:@"NbOrdrePassage"];
    if (self.NbNewOrdrePassage != nil)[v_Return2 setObject:self.NbNewOrdrePassage forKey:@"NbNewOrdrePassage"];
    if ([[NSNumber alloc ] initWithBool:self.FlagCreerMerch] != nil)[v_Return2 setObject:[[NSNumber alloc ] initWithBool:self.FlagCreerMerch] forKey:@"FlagCreerMerch"];
    if ([PEG_FTechnical getJsonFromDate:self.DateValeur] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.DateValeur] forKey:@"DateValeur"];
    if (self.LiCommentaire != nil)[v_Return2 setObject:self.LiCommentaire forKey:@"LiCommentaire"];
    if (self.FlagMAJ != nil)[v_Return2 setObject:self.FlagMAJ forKey:@"FlagMAJ"];
    if ([PEG_FTechnical getJsonFromDate:self.DatePassageReel] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.DatePassageReel] forKey:@"DatePassageReel"];
    if (v_ListActionPresentoir != nil && v_ListActionPresentoir.count > 0)[v_Return2 setObject:v_ListActionPresentoir forKey:@"ListActionPresentoir"];
    
    
    return v_Return2;
    
}

-(NSMutableDictionary* ) objectModifiedToJson
{
    NSMutableArray* v_ListActionPresentoir = [NSMutableArray array];
    for(PEG_BeanActionPresentoir* v_BeanActionPresentoir in self.ListActionPresentoir)
    {
        if(![v_BeanActionPresentoir.FlagMAJ isEqualToString:PEG_EnumFlagMAJ_Unchanged])
        {
            [v_ListActionPresentoir addObject:[v_BeanActionPresentoir objectToJson]];
        }
    }
    
    
    NSMutableDictionary* v_Return2 =nil;
    
    if(v_ListActionPresentoir.count != 0 || ![self.FlagMAJ isEqualToString:PEG_EnumFlagMAJ_Unchanged])
    {
        v_Return2 =[[NSMutableDictionary alloc] init];
        if (self.IdLieuPassage != nil)[v_Return2 setObject:self.IdLieuPassage forKey:@"IdLieuPassage"];
        if (self.IdLieu != nil)[v_Return2 setObject:self.IdLieu forKey:@"IdLieu"];
        if (self.IdTournee != nil)[v_Return2 setObject:self.IdTournee forKey:@"IdTournee"];
        if (self.NbOrdrePassage != nil)[v_Return2 setObject:self.NbOrdrePassage forKey:@"NbOrdrePassage"];
        if (self.NbNewOrdrePassage != nil)[v_Return2 setObject:self.NbNewOrdrePassage forKey:@"NbNewOrdrePassage"];
        if ([[NSNumber alloc ] initWithBool:self.FlagCreerMerch] != nil)[v_Return2 setObject:[[NSNumber alloc ] initWithBool:self.FlagCreerMerch] forKey:@"FlagCreerMerch"];
        if ([PEG_FTechnical getJsonFromDate:self.DateValeur] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.DateValeur] forKey:@"DateValeur"];
        if (self.LiCommentaire != nil)[v_Return2 setObject:self.LiCommentaire forKey:@"LiCommentaire"];
        if (self.FlagMAJ != nil)[v_Return2 setObject:self.FlagMAJ forKey:@"FlagMAJ"];
        if ([PEG_FTechnical getJsonFromDate:self.DatePassageReel] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.DatePassageReel] forKey:@"DatePassageReel"];
        if (v_ListActionPresentoir != nil && v_ListActionPresentoir.count > 0)[v_Return2 setObject:v_ListActionPresentoir forKey:@"ListActionPresentoir"];
    }
    
    return v_Return2;
    
}

/*-(NSNumber*) GetQtePrevueByPresentoir:(NSNumber*)p_IdPresentoir andParution:(NSNumber*)p_IdParution
{
    NSNumber* v_retour;
    @try
    {
        int v_Qte = 0;
        for (PEG_BeanActionPresentoir* v_Item in self.ListActionPresentoir)
        {
            if([v_Item.IdParution isEqualToNumber:p_IdParution])
            {
                if([v_Item.IdPresentoir isEqualToNumber:p_IdPresentoir])
                {
                    v_Qte += [v_Item.QuantitePrevue intValue];
                }
            }
        }
        v_retour = [[NSNumber alloc]initWithInt:v_Qte];
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"PEG_BeanLieuPassage.GetQtePrevueByPresentoir LieuPassage:%@",self.description] andExparams:nil];
    }
    return v_retour;
}

-(NSNumber*) GetQteDistriByPresentoir:(NSNumber*)p_IdPresentoir andParution:(NSNumber*)p_IdParution
{
    NSNumber* v_retour;
    @try
    {
        int v_Qte = 0;
        for (PEG_BeanActionPresentoir* v_Item in self.ListActionPresentoir)
        {
            if([v_Item.IdPresentoir isEqualToNumber:p_IdPresentoir]
               && [v_Item.IdParution isEqualToNumber:p_IdParution])
            {
                v_Qte += [v_Item.QuantiteDistribuee intValue];
            }
        }
        v_retour = [NSNumber numberWithInt:v_Qte];
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"PEG_BeanLieuPassage.GetQteDistriByPresentoir LieuPassage:%@",self.description] andExparams:nil];
    }
    return v_retour;
}

-(NSNumber*) GetQteRetourByPresentoir:(NSNumber*)p_IdPresentoir andParution:(NSNumber*)p_IdParution
{
    NSNumber* v_retour;
    @try
    {
        int v_Qte = 0;
        for (PEG_BeanActionPresentoir* v_Item in self.ListActionPresentoir)
        {
            if([v_Item.IdPresentoir isEqualToNumber:p_IdPresentoir]
               && [v_Item.IdParution isEqualToNumber:p_IdParution])
            {
                v_Qte += [v_Item.QuantiteRecuperee intValue];
            }
        }
        v_retour = [NSNumber numberWithInt:v_Qte];
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"PEG_BeanLieuPassage.GetQteRetourByPresentoir LieuPassage:%@",self.description] andExparams:nil];
    }
    return v_retour;
}*/

@end
