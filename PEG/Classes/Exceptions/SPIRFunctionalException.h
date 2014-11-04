//
//  SPIRFunctionalException.h
//  SPIR
//
//  Created by Antoine Marcadet on 27/02/12.
//  Copyright (c) 2012 SQLI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPIRException.h"

/*!
 La classe SPIRFunctionalException doit être utilisée lorsque des exceptions fonctionnelles doivent être levées.
 
 Voici quelques exemples :
 
 - Une liste d'éléments obligatoires est vide
 - (à poursuivre...)
 
 Pour lever des exceptions techniques vous devez utiliser SPIRTechnicalException.
 
 Voir la classe SPIRException pour des explications plus détaillées sur la gestion des exceptions.
 */
@interface SPIRFunctionalException : SPIRException

@end
