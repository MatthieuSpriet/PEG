//
//  NSManagedObject+ safeSetValuesForKeysWithDictionary.h
//  Youboox
//
//  Created by Vincent Daubry on 13/07/13.
//
//

#import <Foundation/Foundation.h>
#import "PEG_EnumFlagMAJ.h"

@interface NSManagedObject (safeSetValuesForKeysWithDictionary)

- (void)safeSetManagedValuesForKeysWithDictionary:(NSDictionary *)keyedValues;// dateFormatter:(NSDateFormatter *)dateFormatter;
-(NSInteger)autoId;
-(void) setFlagMAJ:(NSString*)p_FlagMAJ;
@end
