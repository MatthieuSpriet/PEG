//
//  SPIRRequestProtocol.h
//  SPIR
//
//  Created by Antoine Marcadet on 24/02/12.
//  Copyright (c) 2012 SQLI. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 Protocole auquel doivent se conformer toutes les requêtes effectuer dans les applications SPIR.
 */
@protocol SPIRRequestProtocol <NSObject>

@required

/*!
 Analyse la réponse du WebService.
 @exception SPIRTechnicalException Une exception technique, voir la documentation de SPIRException pour plus d'information.
 @exception SPIRFunctionalException Une exception fonctionnelle, voir la documentation de SPIRException pour plus d'information.
 @return L'objet résultant de la requête au WebService, cela peut être un objet métier ou bien un NSArray d'objets métier.
 */
- (id)processResponse;

@end
