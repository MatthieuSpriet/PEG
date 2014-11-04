//
//  SPIRMessage.h
//  Components
//
//  Created by Antoine Marcadet on 04/10/11.
//  Copyright 2011 SPIR Communications S.A. All rights reserved.
//

extern NSString *const SPIRMessageKey;

/*!
 Les différents niveaux de criticité des messages SAP.
 */
typedef enum {
	SPIRMessageLevelNone = 0,
	SPIRMessageLevelError,		// messages de type E
	SPIRMessageLevelWarning,	// messages de type W
	SPIRMessageLevelInfo,		// messages de type I
	SPIRMessageLevelSuccess		// messages de type S
} SPIRMessageLevel;

/*!
 Classe décrivant les messages renvoyés par SAP.
 */
@interface SPIRMessage : NSObject <NSCopying>
{
	NSString			*text;
	SPIRMessageLevel	 level;
}

/*!
 Le texte du message SAP.
 */
@property (nonatomic, strong) NSString			*text;

/*!
 Le niveau de criticité du message SAP.
 @see type
 */
@property (nonatomic, assign) SPIRMessageLevel	 level;

/*!
 Le titre du message SAP, dépendant du niveau de criticité.
 @see level
 */
@property (weak, nonatomic, readonly) NSString		*title;

/*!
 Le niveau de criticité au format texte tel que renvoyé par SAP.
 @see level
 */
@property (nonatomic, strong) NSString			*type;
@property (nonatomic, strong) NSString			*message DEPRECATED_ATTRIBUTE;

- (id)initWithText:(NSString *)text andLevel:(SPIRMessageLevel)level;
+ (id)messageWithText:(NSString *)text andLevel:(SPIRMessageLevel)level;

@end
