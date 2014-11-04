//
//  SPIRTechnicalException.h
//  SPIR
//
//  Created by Antoine Marcadet on 27/02/12.
//  Copyright (c) 2012 SQLI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPIRException.h"

/*!
 La classe SPIRTechnicalException doit être utilisée lorsque des exceptions techniques doivent être levées.
 
 Voici quelques exemples :
 
 - Flux XML incorrect
 - Absence d'une balise dans un flux XML
 - Erreur technique SOAP:FAULT renvoyé dans un WebService
 
 Pour lever des exceptions techniques vous devez utiliser SPIRFunctionalException.
 
 Voir la classe SPIRException pour des explications plus détaillées sur la gestion des exceptions.
 */
@interface SPIRTechnicalException : SPIRException

@end
