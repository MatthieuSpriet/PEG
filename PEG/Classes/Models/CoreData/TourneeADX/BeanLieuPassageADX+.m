//
//  BeanLieuPassageADX+.m
//  PEG
//
//  Created by Horsmedia3 on 09/06/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import "BeanLieuPassageADX+.h"
#import "BeanActionADX.h"
#import "BeanTourneeADX.h"
#import "NSManagedObject+safeSetValuesForKeysWithDictionary.h"

@implementation BeanLieuPassageADX (addListActionObject)

//Cette methode permet de mettre à l'état modifiée la tournée si une action est ajoutée
//De cette manière, la tournée complète sera transmise
-(void) addListActionADXObject:(BeanActionADX*)p_BeanActionADX
{
    //Equivalent de :[super addListActionObject:p_BeanAction];
    //NSSet *changedObjects = [[NSSet alloc] initWithObjects:&p_BeanAction count:1];
    NSMutableSet *changedObjects = [[NSMutableSet alloc] init];
    //[changedObjects setByAddingObjectsFromSet:self.listAction];
    for (BeanActionADX* v_BA in self.listActionADX) {
        [changedObjects addObject:v_BA];
    }
    [changedObjects addObject:p_BeanActionADX];
    
    
    [self willChangeValueForKey:@"listActionADX"
                withSetMutation:NSKeyValueUnionSetMutation
                   usingObjects:changedObjects];
    [self setPrimitiveValue:changedObjects forKey:@"listActionADX"];
    [self didChangeValueForKey:@"listActionADX"
               withSetMutation:NSKeyValueUnionSetMutation
                  usingObjects:changedObjects];
    if(![p_BeanActionADX.flagMAJ isEqualToString:PEG_EnumFlagMAJ_Unchanged])
    {
        //Cela permet de passer la chaine de la tournee en modif pour la synchro
        [[self parentTourneeADX] setFlagMAJ:PEG_EnumFlagMAJ_Modified];
    }
}

-(void) setFlagMAJ:(NSString*)p_FlagMAJ
{
    [super setFlagMAJ:p_FlagMAJ];
    if(![p_FlagMAJ isEqualToString:PEG_EnumFlagMAJ_Unchanged])
    {
        //Cela permet de passer la chaine de la tournee en modif pour la synchro
        [[self parentTourneeADX] setFlagMAJ:PEG_EnumFlagMAJ_Modified];
    }
}


@end
