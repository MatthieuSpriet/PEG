#import <Foundation/Foundation.h>

@interface PEGParametres : NSObject

@property (nonatomic,strong) NSMutableDictionary* URL;

@property (nonatomic,strong) NSMutableData *dta;

+ (PEGParametres *)sharedInstance;

-(void)start_download:(NSString *)p_environement ;
@end
