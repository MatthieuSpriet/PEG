//
//  PEG_BeanListeChoix.m
//  PEG
//
//  Created by 10_200_11_120 on 15/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEGAppDelegate.h"
#import "PEG_BeanChoix.h"
#import "PEG_FTechnical.h"
@implementation PEG_BeanChoix

-(NSString*) description
{
	return [NSString stringWithFormat:@"<%@ %p> {IdItemListChoix :%@,Categorie :%@,Code :%@,Libelle :%@,Restriction :%@}",
            NSStringFromClass([self class]),
            self,
            self.IdItemListChoix,
            self.Categorie,
            self.Code,
            self.Libelle,
            self.Restriction];
}

-(id) initBeanWithJson :(NSDictionary*)p_json
{
    self = [self init];
    if (self)
    {
        self.IdItemListChoix = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdItemListChoix"]];
        self.Categorie = [p_json stringForKeyPath:@"Categorie"];
        self.Code = [p_json stringForKeyPath:@"Code"];
        self.Libelle = [p_json stringForKeyPath:@"Libelle"];
        self.Restriction = [p_json stringForKeyPath:@"Restriction"];
        self.DateDebut = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"DateDebut"]];
        self.DateFin = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"DateFin"]];
        
        //CoreData
        
        //On n'insert que si la ligne n'existe pas
      /*  PEGAppDelegate *app = [UIApplication sharedApplication].delegate;
        NSFetchRequest *req = [[NSFetchRequest alloc]init];
        [req setEntity:[NSEntityDescription entityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext]];
        [req setPredicate:[NSPredicate predicateWithFormat:@"idItemListChoix == %@",[[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdItemListChoix"]]]];
         BeanChoix *std = [[app.managedObjectContext executeFetchRequest:req error:nil] lastObject];
         if(std != nil)
         {
             //[std setName:@"Rem"];
         }
         else
         {
             BeanChoix *v_BeanChoix = (BeanChoix *)[NSEntityDescription insertNewObjectForEntityForName:@"BeanChoix" inManagedObjectContext:app.managedObjectContext];
             [v_BeanChoix setIdItemListChoix:self.IdItemListChoix];
             [v_BeanChoix setCategorie:self.Categorie];
             [v_BeanChoix setCode:self.Code];
             [v_BeanChoix setLibelle:self.Libelle];
             [v_BeanChoix setDateDebut:self.DateDebut];
             [v_BeanChoix setDateFin:self.DateFin];
             [app.managedObjectContext save:nil];
         }
         //[app.managedObjectContext save:nil];
         
         
         
         
         NSFetchRequest * request = [[NSFetchRequest alloc] init];
         NSEntityDescription *myEntityQuery =
         [NSEntityDescription entityForName:@"BeanChoix"
                     inManagedObjectContext:app.managedObjectContext];
         [request setEntity:myEntityQuery];
         NSError *error = nil;
         NSArray *ArrayChoix = [app.managedObjectContext
                                executeFetchRequest:request error:&error];
         // Selection des auteurs
         NSInteger nbr = [ArrayChoix count];
         NSLog(@"Nb choix : %i", nbr);
         for (int loop = 0; loop < nbr; loop++)
         {
             BeanChoix *SuiviKM = (BeanChoix *)[ArrayChoix objectAtIndex:loop];
             NSLog(@"Le choix : %@", SuiviKM);
         }*/
         //CoreData
    }
    return self;
}

-(NSMutableDictionary* ) objectToJson
        {
            
            
            NSMutableDictionary* v_Return = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             self.IdItemListChoix,@"IdItemListChoix",
                                             self.Categorie,@"Categorie",
                                             self.Code,@"Code",
                                             self.Libelle,@"Libelle",
                                             self.Restriction,@"Restriction",
                                             [PEG_FTechnical getJsonFromDate:self.DateDebut],@"DateDebut",
                                             [PEG_FTechnical getJsonFromDate:self.DateFin],@"DateFin",
                                             nil];
            
            return v_Return;
            
        }
         @end
