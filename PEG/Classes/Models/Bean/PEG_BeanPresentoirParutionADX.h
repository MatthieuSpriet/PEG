//
//  PEG_BeanPresentoirParutionADX.h
//  PEG
//
//  Created by Horsmedia3 on 30/05/14.
//  Copyright (c) 2014 spir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PEG_BeanPresentoirParutionADX : NSObject

@property (nonatomic, strong) NSNumber* IdPresentoir;
@property (nonatomic, strong) NSNumber* idLieu;
@property (nonatomic, strong) NSNumber* idLieuPassageADX;
@property (nonatomic, strong) NSNumber* idEditionRef;
@property (nonatomic, strong) NSNumber* idParution;
@property (nonatomic, strong) NSNumber* idParutionPrec;
@property (nonatomic, strong) NSNumber* idParutionRef;
@property (nonatomic, strong) NSNumber* idParutionRefPrec;
@property (nonatomic, strong) NSString* codeTypePresentoir;
@property (nonatomic, strong) NSString* libParution;
@property (nonatomic, strong) NSString* libEdition;

@end
