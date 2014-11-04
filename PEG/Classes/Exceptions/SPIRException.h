//
//  SPIRException.h
//  SPIR
//
//  Created by Antoine Marcadet on 29/02/12.
//  Copyright (c) 2012 SQLI. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 La classe SPIRException peut être utilisée dans un bloc try catch pour standardiser la gestion des exceptions SPIRTechnicalException et SPIRFunctionalException.
 
 Exemple :
 
	@try 
	{
		// code générant une exception
	}
	@catch (SPIRException *exception)
	{
		// affichage d'un message à l'utilisateur
	}
 
 Si vous souhaitez gérer différement les exceptions fonctionnelles et techniques vous pouvez écrire ceci :
 
	@try 
	{
		// code générant une exception
	}
	@catch (SPIRTechnicalException *exception)
	{
		// affichage d'un message à l'utilisateur
	}
	@catch (SPIRFunctionalException *exception)
	{
		// affichage d'un message à l'utilisateur
	}
 
 */
@interface SPIRException : NSException

@end
