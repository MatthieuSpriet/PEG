//
//  NSManagedObject+ safeSetValuesForKeysWithDictionary.m
//  Youboox
//
//  Created by Vincent Daubry on 13/07/13.
//
//

#import "NSManagedObject+safeSetValuesForKeysWithDictionary.h"
#import "PEG_FTechnical.h"
#import "PEGException.h"

@implementation NSManagedObject (safeSetValuesForKeysWithDictionary)

- (void)safeSetManagedValuesForKeysWithDictionary:(NSDictionary *)keyedValues //dateFormatter:(NSDateFormatter *)dateFormatter
{
    @try{
        NSDictionary *attributes = [[self entity] attributesByName];
        for (NSString *attribute in attributes) {
            id value = [keyedValues objectForKey:attribute];
            if (value == nil) {
                continue;
            }
            NSAttributeType attributeType = [[attributes objectForKey:attribute] attributeType];
            
            if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
                value = [value stringValue];
            } else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
                value = [NSNumber numberWithInteger:[value integerValue]];
            } else if ((attributeType == NSFloatAttributeType) &&  ([value isKindOfClass:[NSString class]])) {
                value = [NSNumber numberWithDouble:[value doubleValue]];
            } else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSString class]]) /*&& (dateFormatter != nil)*/) {
                //value = [dateFormatter dateFromString:value];
                value = [PEG_FTechnical getDateFromJson:[keyedValues stringForKeyPath:attribute]];
            }
            //We don't handle nested object yet
            else if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSDictionary class]])) {
                value = nil;
            }
            //Convert NSNull to nil
            else if ([value isKindOfClass:[NSNull class]]) {
                value = nil;
            }
            
            [self setValue:value forKey:attribute];
        }
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans safeSetManagedValuesForKeysWithDictionary" andExparams:keyedValues.description];
    }
}

-(NSInteger)autoId{
    
    NSString *last_segment = [[[self objectID] URIRepresentation] lastPathComponent];
    
    //$5 = 0x11b10c80 0x11b10c80 <x-coredata://ED90C827-41EB-4825-AE5E-E76ABA1925D5/BeanPresentoir/p1891>
    NSString *number_part = [last_segment stringByReplacingOccurrencesOfString:@"p" withString:@""];
    
    NSInteger auto_id = [number_part integerValue];
    
    number_part =nil;
    last_segment=nil;
    
    return -1 * auto_id;
    
}

-(void) setFlagMAJ:(NSString*)p_FlagMAJ
{
    
    BOOL v_ChangeAutorise = true;
    
    if([[self.entity propertiesByName] objectForKey:@"flagMAJ"] != nil)
    {
        [self willAccessValueForKey:@"flagMAJ"];
        NSString *v_FlagOriginal = [self primitiveValueForKey:@"flagMAJ"];
        [self didAccessValueForKey:@"flagMAJ"];
        if([v_FlagOriginal isEqualToString:PEG_EnumFlagMAJ_Added]
           &&
           ([p_FlagMAJ isEqualToString:PEG_EnumFlagMAJ_Modified]
            || [p_FlagMAJ isEqualToString:PEG_EnumFlagMAJ_Unchanged])
           )
        {
            //On laisse en added
            v_ChangeAutorise = false;
        }
    }
    if(v_ChangeAutorise)
    {
        [self willChangeValueForKey:@"flagMAJ"];
        [self setPrimitiveValue:p_FlagMAJ forKey:@"flagMAJ"];
        [self didChangeValueForKey:@"flagMAJ"];
    }
}

@end
