//
//  BeanLieuPassage+.m
//  PEG
//
//  Created by Horsmedia3 on 24/01/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import "BeanLieuPassage+.h"
#import "PEG_EnumFlagMAJ.h"
#import "BeanAction.h"
#import "BeanTournee.h"		// ARC pm140218
#import "NSManagedObject+safeSetValuesForKeysWithDictionary.h"

@implementation BeanLieuPassage (addListActionObject)

//Cette methode permet de mettre à l'état modifiée la tournée si une action est ajoutée
//De cette manière, la tournée complète sera transmise
-(void) addListActionObject:(BeanAction*)p_BeanAction
{
    //Equivalent de :[super addListActionObject:p_BeanAction];
    //NSSet *changedObjects = [[NSSet alloc] initWithObjects:&p_BeanAction count:1];
    NSMutableSet *changedObjects = [[NSMutableSet alloc] init];
    //[changedObjects setByAddingObjectsFromSet:self.listAction];
    for (BeanAction* v_BA in self.listAction) {
        [changedObjects addObject:v_BA];
    }
    [changedObjects addObject:p_BeanAction];
    
    
    [self willChangeValueForKey:@"listAction"
                withSetMutation:NSKeyValueUnionSetMutation
                   usingObjects:changedObjects];
    [self setPrimitiveValue:changedObjects forKey:@"listAction"];
    [self didChangeValueForKey:@"listAction"
               withSetMutation:NSKeyValueUnionSetMutation
                  usingObjects:changedObjects];
    if(![p_BeanAction.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Unchanged])
    {
        //Cela permet de passer la chaine de la tournee en modif pour la synchro
        [[self parentTournee] setFlagMAJ:PEG_EnumFlagMAJ_Modified];
    }
}

-(void) setFlagMAJ:(NSString*)p_FlagMAJ
{
    [super setFlagMAJ:p_FlagMAJ];
    if(![p_FlagMAJ isEqualToString:PEG_EnumFlagMAJ_Unchanged])
    {
        //Cela permet de passer la chaine de la tournee en modif pour la synchro
        [[self parentTournee] setFlagMAJ:PEG_EnumFlagMAJ_Modified];
    }
}

@end
