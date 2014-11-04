//
//  PEGWebServices.m
//  PEG
//
//  Created by Pierre Marty on 21/02/2014.
//  Copyright (c) 2014 spir. All rights reserved.
//

// TODO: vérifier configuration upload gzip

#import "AFNetworking.h"
#import "PEGWebServices.h"

#import "PEGParametres.h"
#import "PEGAppDelegate.h"
#import "PEG_FMobilitePegase.h"
#import "SPIRTechnicalException.h"
#import "PEG_BeanCommunication.h"
#import "PEGSession.h"
#import "PEG_FTechnical.h"


@implementation PEGWebServices

+ (PEGWebServices *)sharedWebServices
{
	static PEGWebServices * sInstance = nil;
    if (sInstance == nil) {
        sInstance = [[PEGWebServices alloc] init];
    }
    return sInstance;
}


- (id)init
{
	self = [super init];
	if (self) {
	}
	return self;
}

- (BOOL)isProcessResponseForBeanErrorOK:(NSDictionary*)p_responseDictionnary
{
    BOOL v_retour = true;
    @try{
        
        
        if(p_responseDictionnary != nil
           && p_responseDictionnary.count > 0){
            
            NSString* v_type = [[NSDictionary dictionaryWithDictionary:p_responseDictionnary] stringForKeyPath:@"Type"];
            NSString* v_msg = [[NSDictionary dictionaryWithDictionary:p_responseDictionnary] stringForKeyPath:@"Msg"];
            
            if (v_type)
            {
                if ([v_type isEqualToString:@"E"])
                {
                    if (v_msg == nil) v_msg = @"Erreur inconnue";
                    v_retour = false;
                    [[PEGException sharedInstance] ManageExceptionWithThrow:nil andMessage:@"processResponseForBeanError " andExparams:[NSString stringWithFormat:@"msg : %@",v_msg]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"processResponseForBeanError" object:v_msg];
                    [SPIRTechnicalException raise:@"processResponseForBeanError" format:@"Le WS a retourné une erreur."];
                }
            }
        }
        else
        {
            v_retour = false;
            [SPIRTechnicalException raise:@"EmptyResponseException" format:@"La réponse du serveur est vide."];
        }
        
    }@catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:@"Erreur dans processResponseForBeanError" andExparams:nil];
    }
    
    return v_retour;
}


- (AFHTTPRequestOperationManager*)requestManager
{
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	
	// request encoding
	// [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
	[manager setRequestSerializer:[AFJSONRequestSerializer serializer]];

	// accept JSON response
	AFJSONResponseSerializer * responsSerializer = [AFJSONResponseSerializer serializer];
	[manager setResponseSerializer:responsSerializer];

	return manager;
}


- (void)getLastSuiviKilometreByMatricule:(NSString*)matricule succes:(void (^)(void))succes failure:(void (^)(NSError *error))failure
{
	// url du service
	PEGParametres* sharedPEGParametres = [PEGParametres sharedInstance];
	
	NSString* urlWebservice =[sharedPEGParametres.URL stringForKey:@"WebServicesIndianaMerchandisingV2"];
	NSString* urlString = [NSString stringWithFormat:@"%@/REST/GetLastSuiviKilometreByMatricule?p_Matricule=%@",urlWebservice,matricule];
	NSLog(@"=> urlString: %@ ",urlString);
	
	AFHTTPRequestOperationManager *manager = [self requestManager];
	NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:urlString parameters:nil error:nil];
    [request setTimeoutInterval:240];
    
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try{
            NSString *responseString = [operation responseString];
            NSLog(@"success response: %@", responseObject);			// un dictionnaire déjà parsé
            NSLog(@"success responseString: %@", responseString);	// le JSON reçu sous forme texte
            
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                if([self isProcessResponseForBeanErrorOK:responseObject])
                {
                    //On persiste dans core Data à partir du JSON
                    PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
                    [[PEG_FMobilitePegase CreateCoreData] managedObjectsFromJSONStructure:responseString withObjectName:@"BeanSuiviKMUtilisateur" withManagedObjectContext:app.managedObjectContext];
                    [[PEG_FMobilitePegase CreateCoreData] Save];
                    
                    succes();
                }
            }
            else {
                [SPIRTechnicalException raise:@"EmptyResponseException" format:@"getLastSuiviKilometreByMatricule : La réponse du serveur est vide."];
                failure(nil);
            }
        }@catch(NSException* p_exception){
            
            //[self MessageErrorUser:@"GetReferentiel"];
            [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Exception saveBeanMobilitePegaseWithSucces" andExparams:nil];
            failure(nil);
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"failure error: %@", error);
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:nil andMessage:@"failure getLastSuiviKilometreByMatricule" andExparams:[NSString stringWithFormat:@"failure error: %@", error]];
        //http://nshipster.com/nserror/
		failure(error);
	}];
	
    [manager.operationQueue addOperation:operation];
}

- (void)getBeanMobilitePegaseByMatricule:(NSString*)p_Matricule andDate:(NSDate*)p_Date succes:(void (^)(void))succes failure:(void (^)(NSError *error))failure
{
	// url du service
	PEGParametres* sharedPEGParametres = [PEGParametres sharedInstance];
	
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    //[format setDateFormat:@"YYYY-MM-dd'T'HH:mm:ssZZZZ"];
    [format setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
    NSString* date = [format stringFromDate:p_Date];
    
	NSString* urlWebservice =[sharedPEGParametres.URL stringForKey:@"WebServicesIndianaMerchandisingV2"];
    NSString* urlString = [NSString stringWithFormat:@"%@/REST/GetBeanMobilitePegaseByMatriculeDate?p_NoMatricule=%@&p_DateReference=%@",urlWebservice,p_Matricule,date];
    
	NSLog(@"=> urlString: %@ ",urlString);
	
	AFHTTPRequestOperationManager *manager = [self requestManager];
	NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:urlString parameters:nil error:nil];
    [request setTimeoutInterval:600];
    
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try{
            NSString *responseString = [operation responseString];
#ifdef DEBUG
            //NSLog(@"success response: %@", responseObject);			// un dictionnaire déjà parsé
            //NSLog(@"success responseString: %@", responseString);	// le JSON reçu sous forme texte
#endif
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                if([self isProcessResponseForBeanErrorOK:responseObject])
                {
                    /********* Debut ProcessResponse ***********/
                    //On persiste dans core Data à partir du JSON
                    PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
                    NSArray* v_array = [[PEG_FMobilitePegase CreateCoreData] managedObjectsFromJSONStructure:responseString withObjectName:@"BeanMobilitePegase" withManagedObjectContext:app.managedObjectContext andDedoublonnage:false];
                    [[PEG_FMobilitePegase CreateCoreData] Save];
                    
                    for (BeanMobilitePegase* v_BMP in v_array) {
                        [v_BMP setDateSynchro:[NSDate date]];
                    }
                    [[PEG_FMobilitePegase CreateCoreData] Save];
                    
                    NSString* v_st = [[PEG_FMobilitePegase CreateCoreData] GetContenuDebugCoreData];
                    DLog("%@",v_st);
                    
                    succes();
                }
            }
            else {
                [SPIRTechnicalException raise:@"EmptyResponseException" format:@"getBeanMobilitePegaseByMatricule : La réponse du serveur est vide."];
                failure(nil);
            }
        }@catch(NSException* p_exception){
            
            //[self MessageErrorUser:@"GetReferentiel"];
            [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Exception getBeanMobilitePegaseByMatriculeSuccess" andExparams:nil];
            failure(nil);
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"failure error: %@", error);
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:nil andMessage:@"failure getBeanMobilitePegaseByMatricule" andExparams:[NSString stringWithFormat:@"failure error: %@", error]];
		failure(error);
	}];
	
    [manager.operationQueue addOperation:operation];
}

- (void)getBeanTourneeByMatricule:(NSString*)p_Matricule andDateDebut:(NSDate*)p_DateDebut andDateFin:(NSDate*)p_DateFin succes:(void (^)(void))succes failure:(void (^)(NSError *error))failure
{
	// url du service
	PEGParametres* sharedPEGParametres = [PEGParametres sharedInstance];
	
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString* dateDebut = [format stringFromDate:p_DateDebut];
    NSString* dateFin = [format stringFromDate:p_DateFin];
    
	NSString* urlWebservice =[sharedPEGParametres.URL stringForKey:@"WebServicesIndianaMerchandisingV2"];
    NSString* urlString = [NSString stringWithFormat:@"%@/REST/GetBeanTourneeByMatriculeDate?p_NoMatricule=%@&p_DateDebut=%@&p_DateFin=%@",urlWebservice,p_Matricule,dateDebut,dateFin];
    
	NSLog(@"=> urlString: %@ ",urlString);
	
	AFHTTPRequestOperationManager *manager = [self requestManager];
	NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:urlString parameters:nil error:nil];
    [request setTimeoutInterval:600];
    
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try{
            NSString *responseString = [operation responseString];
#ifdef DEBUG
            NSLog(@"success response: %@", responseObject);			// un dictionnaire déjà parsé
            NSLog(@"success responseString: %@", responseString);	// le JSON reçu sous forme texte
#endif
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                if([self isProcessResponseForBeanErrorOK:responseObject])
                {
                    /********* Debut ProcessResponse ***********/
                    //On persiste dans core Data à partir du JSON
                    PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
                    NSArray* v_managedObjects =
                    [[PEG_FMobilitePegase CreateCoreData] managedObjectsFromJSONStructure:responseString withObjectName:@"BeanMobilitePegase" withManagedObjectContext:app.managedObjectContext];
                    
                    [[PEG_FMobilitePegase CreateCoreData] Save];
                    
                    NSString* v_st = [[PEG_FMobilitePegase CreateCoreData] GetContenuDebugCoreData];
                    DLog("Insertion des tournees %@",v_st);
                    
                    //Si on a bien un BeanMobilitePegase, on supprime les lieux de passage dont le lieu n'existe plus
                    if(v_managedObjects.count == 1)
                    {
                        BeanMobilitePegase* p_BeanMP = [v_managedObjects lastObject];
                        
                        bool v_IsExistLieu = false;
                        for (BeanTournee* v_NouvelleTournee in p_BeanMP.listTournee)
                        {
                            //On enleve les lieux de passage dont les lieux n'existent plus
                            for (BeanLieuPassage* v_NouveauLieuPassage in v_NouvelleTournee.listLieuPassage)
                            {
                                v_IsExistLieu = false;
                                for (BeanLieu* v_LieuExistant in p_BeanMP.listLieu)
                                {
                                    if([v_NouveauLieuPassage.idLieu isEqualToNumber:v_LieuExistant.idLieu])
                                    {
                                        v_IsExistLieu = true;
                                        break;
                                    }
                                }
                                if(!v_IsExistLieu)
                                {
                                    [app.managedObjectContext deleteObject:v_NouveauLieuPassage];
                                }
                            }
                        }
                    }
                    
                    [[PEG_FMobilitePegase CreateCoreData] Save];
                    v_st = [[PEG_FMobilitePegase CreateCoreData] GetContenuDebugCoreData];
                    DLog("Suppression des Lieux passage sans lieu %@",v_st);
                    /********* Fin ProcessResponse ***********/
                    
                    succes();
                }
            }
            else {
                [SPIRTechnicalException raise:@"EmptyResponseException" format:@"getBeanTourneeByMatricule : La réponse du serveur est vide."];
                failure(nil);
            }
        }@catch(NSException* p_exception){
            
            //[self MessageErrorUser:@"GetReferentiel"];
            [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Exception getBeanTourneeByMatriculeSuccess" andExparams:nil];
            failure(nil);
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"failure error: %@", error);
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:nil andMessage:@"failure getBeanTourneeByMatricule" andExparams:[NSString stringWithFormat:@"failure error: %@", error]];
		failure(error);
	}];
	
    [manager.operationQueue addOperation:operation];
}

- (void)saveBeanMobilitePegaseWithSucces:(void (^)(void))succes failure:(void (^)(NSError *error))failure
{
	PEGParametres* sharedCEXParametres = [PEGParametres sharedInstance];
	NSString* urlWebservice =[sharedCEXParametres.URL stringForKey:@"WebServicesIndianaMerchandisingV2"];
	NSString* urlService=@"/REST/SaveBeanMobilitePegase_POST";
	NSString* urlString = [NSString stringWithFormat:@"%@%@", urlWebservice, urlService];
	
    DLog(@"=>urlString: %@ ",urlString);
    
	AFHTTPRequestOperationManager *manager = [self requestManager];
	
	[manager.requestSerializer setAuthorizationHeaderFieldWithUsername:[SPIRSession username] password:[SPIRSession password]];

	NSDictionary *parameters = nil;
    
	
	// laisser faire la sérialisation JSON à AFJSONRequestSerializer
	
		NSArray* array = [[PEG_FMobilitePegase CreateMobilitePegaseService] GetAllBeanMobilitePegase];
		
		NSArray *objectsArray = [[PEG_FMobilitePegase CreateCoreData] dataStructuresFromManagedObjectsModified:array];
		if (! [NSJSONSerialization isValidJSONObject:objectsArray]) {	// serialisable ?
			failure(nil);	// que fait on dans ce cas ? (ne devrait pas se produire)
			return;
		}
        
#ifdef DEBUG
        NSData* v_data = [NSJSONSerialization dataWithJSONObject:objectsArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString* v_Json = [[NSString alloc] initWithData:v_data encoding:NSUTF8StringEncoding];
        DLog(@"=>PostBody: %@",v_Json);
#endif
		
		// ATTENTION, vérifier si c'est ok de passer un array à la place dictionnaire !
		// A priori il faut juste que ce soit un objet sérialisable en JSON
		parameters = (NSDictionary*)objectsArray;

	NSMutableURLRequest *request = [manager.requestSerializer
									requestWithMethod:@"POST"
									URLString:urlString
									parameters:parameters
									error:nil];
	[request setTimeoutInterval:300];
	
	
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
		@try{
#ifdef DEBUG
            NSLog(@"success response: %@", responseObject);			// un dictionnaire déjà parsé
#endif
            
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                if([self isProcessResponseForBeanErrorOK:responseObject])
                {
                    succes();
                }
            }
            else {
                failure(nil);	// TODO: check that error = nil is handled correctly by the caller
            }
        }@catch(NSException* p_exception){
            
            //[self MessageErrorUser:@"GetReferentiel"];
            [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Exception saveBeanMobilitePegaseWithSucces" andExparams:nil];
            failure(nil);
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"failure error: %@", error);
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:nil andMessage:@"failure saveBeanMobilitePegaseWithSucces" andExparams:[NSString stringWithFormat:@"failure error: %@", error]];
		failure(error);
	}];
	
    [manager.operationQueue addOperation:operation];
}

- (void)GetBeanCommunicationByIDRequest:(NSNumber*)p_id succes:(void (^)(PEG_BeanCommunication* p_BeanCommunication))succes failure:(void (^)(NSError *error))failure
{
	// url du service
	PEGParametres* sharedPEGParametres = [PEGParametres sharedInstance];
	
    
    NSString* UrlWebservice =[sharedPEGParametres.URL stringForKey:@"WebServicesModuleCom"];
    
    NSString* renderUrl = [NSString stringWithFormat:@"%@/REST/getListBeanModulecommunicationForAllRest?App=Pegase&sequence=%@",UrlWebservice,p_id];
    
	NSLog(@"=> urlString: %@ ",renderUrl);
	
	AFHTTPRequestOperationManager *manager = [self requestManager];
	NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:renderUrl parameters:nil error:nil];
    [request setTimeoutInterval:600];
    
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try{
            NSString *responseString = [operation responseString];
            NSLog(@"success response: %@", responseObject);			// un dictionnaire déjà parsé
            NSLog(@"success responseString: %@", responseString);	// le JSON reçu sous forme texte
            
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                if([self isProcessResponseForBeanErrorOK:responseObject])
                {
                    PEG_BeanCommunication* v_PEG_BeanCommunication=[[PEG_BeanCommunication alloc]init];
                   
                        
                            //            NSArray* liste = [responseDictionary arrayForKeyPath:@"BeanModulecommunication"];
                            //            for (NSDictionary* v_BeanModulecommunication in liste)
                            //            {
                            //PEG_BeanCommunication* v_PEG_BeanCommunication=[[PEG_BeanCommunication alloc]init];
                            NSString* v_msg = [responseObject stringForKeyPath:@"Msg"];
                            NSString* v_Typemsg = [responseObject stringForKeyPath:@"typeMsg"];
                            v_PEG_BeanCommunication.Message=v_msg;
                            v_PEG_BeanCommunication.TypeMessage=v_Typemsg;
                            v_PEG_BeanCommunication.idsequence= [[responseObject stringForKeyPath:@"seq"] integerValue];
                    
                    succes(v_PEG_BeanCommunication);
                }
            }
           
        }@catch(NSException* p_exception){
            
            //[self MessageErrorUser:@"GetReferentiel"];
            [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Exception GetBeanCommunicationByIDRequest succes" andExparams:nil];
            failure(nil);
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"failure error: %@", error);
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:nil andMessage:@"failure GetBeanCommunicationByIDRequest" andExparams:[NSString stringWithFormat:@"failure error: %@", error]];
		failure(error);
	}];
	
    [manager.operationQueue addOperation:operation];
}


- (void)Login:(NSString*)p_Login andPassword:(NSString*) p_Password succes:(void (^)(bool p_IsAuthentified))succes failure:(void (^)(NSError *error))failure
{
	// url du service
	PEGParametres* sharedPEGParametres = [PEGParametres sharedInstance];
    

    
    NSString* UrlWebservice =[sharedPEGParametres.URL stringForKey:@"WebServicesCommun_Security"];
    NSLog(@"UrlWebservice : %@",UrlWebservice);
    if(UrlWebservice == nil || [UrlWebservice isEqualToString:@""])
    {
        [PEG_FTechnical traceErrorWithMessage:@"L'URL de WebServicesCommun_Security est null."];
    }
    NSString * v_Login=[NSString stringWithFormat:@"ADREXO_%@",p_Login ];
    
    //Dans le cas des tests, on utilise le compte de service qui ne debute pas par ADREXO
    if(![PEG_WS_ENVIRONNEMENT isEqualToString:@"PROD"])
    {
        v_Login=p_Login;
    }
    
    NSString* UrlService= [NSString stringWithFormat:@"/REST/GetInfoSecuritySGBDandConnect_Rest?paramUser=%@&paramPwd=%@",v_Login,p_Password];
    
    NSString* renderUrl=[NSString stringWithFormat:@"%@%@", UrlWebservice, UrlService];
    NSLog(@"renderUrl : %@",renderUrl);
	
	AFHTTPRequestOperationManager *manager = [self requestManager];
	NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:renderUrl parameters:nil error:nil];
    [request setTimeoutInterval:600];
    
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try{
            NSString *responseString = [operation responseString];
            NSLog(@"success response: %@", responseObject);			// un dictionnaire déjà parsé
            NSLog(@"success responseString: %@", responseString);	// le JSON reçu sous forme texte
            
            
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                if([self isProcessResponseForBeanErrorOK:responseObject])
                {
                
                    [PEGSession sharedPEGSession].IsAdmin=[responseObject boolForKeyPath:@"IsAdminIndiana"];
                    
                    succes([responseObject boolForKeyPath:@"IsAuthentif"]);
                }
            }
            
        }@catch(NSException* p_exception){
            
            //[self MessageErrorUser:@"GetReferentiel"];
            [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Exception GetBeanCommunicationByIDRequest succes" andExparams:nil];
            failure(nil);
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"failure error: %@", error);
        
        /****** Patch en attendant le format JSON de Security ******/
        NSString *responseString = [operation responseString];
        
        NSError *errorbis;
        NSDictionary *responseObject = nil;
        if (responseString) {       // pm0514 avoid crash in case responseString is nil.
            responseObject = [NSJSONSerialization
                         JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]
                         options:kNilOptions
                         error:&errorbis];
        }
        if (responseObject /*&& [responseObject isKindOfClass:[NSDictionary class]]*/) {
            if([self isProcessResponseForBeanErrorOK:responseObject])
            {
                
                [PEGSession sharedPEGSession].IsAdmin=[responseObject boolForKeyPath:@"IsAdminIndiana"];
                
                if([responseObject boolForKeyPath:@"IsAuthentif"] == true)
                {
                    succes([responseObject boolForKeyPath:@"IsAuthentif"]);
                }
                else{
                    [[PEGException sharedInstance] ManageExceptionWithoutThrow:nil andMessage:@"failure GetBeanCommunicationByIDRequest" andExparams:[NSString stringWithFormat:@"failure error: %@", error]];
                    failure(error);
                }
            }
            else{
                [[PEGException sharedInstance] ManageExceptionWithoutThrow:nil andMessage:@"failure GetBeanCommunicationByIDRequest" andExparams:[NSString stringWithFormat:@"failure error: %@", error]];
                failure(error);
            }
        }
        else{
            [[PEGException sharedInstance] ManageErrorWithoutThrow:error andMessage:@"failure GetBeanCommunicationByIDRequest" andExparams:[NSString stringWithFormat:@"failure error: %@", error]];
            failure(error);
        }
        /************/
        
        
//        [[PEGException sharedInstance] ManageExceptionWithoutThrow:nil andMessage:@"failure GetBeanCommunicationByIDRequest" andExparams:[NSString stringWithFormat:@"failure error: %@", error]];
//		failure();
	}];
	
    [manager.operationQueue addOperation:operation];
}

- (void)getBeanTourneeADXByMatricule:(NSString*)p_Matricule andDateDebut:(NSDate*)p_DateDebut andDateFin:(NSDate*)p_DateFin succes:(void (^)(void))succes failure:(void (^)(NSError *error))failure
{
	// url du service
	PEGParametres* sharedPEGParametres = [PEGParametres sharedInstance];
	
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString* dateDebut = [format stringFromDate:p_DateDebut];
    NSString* dateFin = [format stringFromDate:p_DateFin];
    
	NSString* urlWebservice =[sharedPEGParametres.URL stringForKey:@"WebServicesIndianaMerchandisingV2"];
    NSString* urlString = [NSString stringWithFormat:@"%@/REST/GetBeanTourneeADXByMatriculeDate?p_NoMatricule=%@&p_DateDebut=%@&p_DateFin=%@",urlWebservice,p_Matricule,dateDebut,dateFin];
    
	NSLog(@"=> urlString: %@ ",urlString);
	
	AFHTTPRequestOperationManager *manager = [self requestManager];
	NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:urlString parameters:nil error:nil];
    [request setTimeoutInterval:600];
    
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try{
            NSString *responseString = [operation responseString];
#ifdef DEBUG
            NSLog(@"success response: %@", responseObject);			// un dictionnaire déjà parsé
            NSLog(@"success responseString: %@", responseString);	// le JSON reçu sous forme texte
#endif
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                if([self isProcessResponseForBeanErrorOK:responseObject])
                {
                    /********* Debut ProcessResponse ***********/
                    //On persiste dans core Data à partir du JSON
                    PEGAppDelegate *app = (PEGAppDelegate *)[UIApplication sharedApplication].delegate;
                    NSArray* v_managedObjects =
                    [[PEG_FMobilitePegase CreateCoreData] managedObjectsFromJSONStructure:responseString withObjectName:@"BeanMobilitePegase" withManagedObjectContext:app.managedObjectContext];
                    
                    [[PEG_FMobilitePegase CreateCoreData] Save];
                    
                    NSString* v_st = [[PEG_FMobilitePegase CreateCoreData] GetContenuDebugCoreData];
                    DLog("Insertion des tournees ADX %@",v_st);
                    
                    /********* Fin ProcessResponse ***********/
                    
                    succes();
                }
            }
            else {
                [SPIRTechnicalException raise:@"EmptyResponseException" format:@"getBeanTourneeADXByMatricule : La réponse du serveur est vide."];
                failure(nil);
            }
        }@catch(NSException* p_exception){
            
            //[self MessageErrorUser:@"GetReferentiel"];
            [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Exception getBeanTourneeADXByMatriculeSuccess" andExparams:nil];
            failure(nil);
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"failure error: %@", error);
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:nil andMessage:@"failure getBeanTourneeADXByMatricule" andExparams:[NSString stringWithFormat:@"failure error: %@", error]];
		failure(error);
	}];
	
    [manager.operationQueue addOperation:operation];
}

- (void)getBeanimageByIdPointLivraison:(int)p_IdPointLivraison succes:(void (^)(UIImage* p_image))succes failure:(void (^)(NSError *error))failure
{
    // url du service
	PEGParametres* sharedPEGParametres = [PEGParametres sharedInstance];
    
    //http://adxnet.int.adrexo.fr/WS_MerchandisingV2/ServicesMerchandising.svc/REST/GetImageByteByIdPointLivraison?p_IdPointLivraison=64016
	NSString* urlWebservice =[sharedPEGParametres.URL stringForKey:@"WebServicesIndianaMerchandisingV2"];
    NSString* urlString = [NSString stringWithFormat:@"%@/REST/GetImageByteByIdPointLivraison?p_IdPointLivraison=%d",urlWebservice,p_IdPointLivraison ];
    
	NSLog(@"=> urlString: %@ ",urlString);
	
	AFHTTPRequestOperationManager *manager = [self requestManager];
	NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:urlString parameters:nil error:nil];
    //[request setTimeoutInterval:600];
    
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try{
            NSData *v_responseData = [operation responseData];
#ifdef DEBUG
            // NSString *responseString = [operation responseString];   // pm_06 not used, commented out as it takes time and memory to compute
            //NSLog(@"success response: %@", responseObject);			// un dictionnaire déjà parsé
            //NSLog(@"success responseString: %@", responseString);	// le JSON reçu sous forme texte
#endif
            if (v_responseData) {
                    //********* Debut ProcessResponse ***********
                    UIImage* v_retour;
                    
                    NSArray *strings = [NSJSONSerialization JSONObjectWithData:v_responseData options:kNilOptions error:NULL];
                    
                    unsigned c = strings.count;
                    uint8_t *bytes = malloc(sizeof(*bytes) * c);
                    
                    unsigned i;
                    for (i = 0; i < c; i++)
                    {
                        NSString *str = [strings objectAtIndex:i];
                        int byte = [str intValue];
                        bytes[i] = byte;
                    }
                    
                    NSData *imageData = [NSData dataWithBytesNoCopy:bytes length:c freeWhenDone:YES];
                    v_retour = [UIImage imageWithData:imageData];
     
                    //********* Fin ProcessResponse ***********
                    
                    succes(v_retour);
            }
            else {
                [SPIRTechnicalException raise:@"EmptyResponseException" format:@"getBeanimageByIdPointLivraison : La réponse du serveur est vide."];
                failure(nil);
            }
        }@catch(NSException* p_exception){
            
            //[self MessageErrorUser:@"GetReferentiel"];
            [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Exception getBeanimageByIdPointLivraisonSuccess" andExparams:nil];
            failure(nil);
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"failure error: %@", error);
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:nil andMessage:@"failure getBeanimageByIdPointLivraison" andExparams:[NSString stringWithFormat:@"failure error: %@", error]];
		failure(error);
	}];
	
    [manager.operationQueue addOperation:operation];
     
}

- (void)getImageStreamByIdPointLivraison:(int)p_IdPointLivraison succes:(void (^)(UIImage* p_image))succes failure:(void (^)(NSError *error))failure
{
    // url du service
	PEGParametres* sharedPEGParametres = [PEGParametres sharedInstance];
    
    //http://adxnet.int.adrexo.fr/WS_MerchandisingV2/ServicesMerchandising.svc/REST/GetImageByteByIdPointLivraison?p_IdPointLivraison=64016
	NSString* urlWebservice =[sharedPEGParametres.URL stringForKey:@"WebServicesIndianaMerchandisingV2"];
    NSString* urlString = [NSString stringWithFormat:@"%@/REST/GetImageStreamByIdPointLivraison?p_IdPointLivraison=%d",urlWebservice,p_IdPointLivraison ];
    
	NSLog(@"=> urlString: %@ ",urlString);
	
	AFHTTPRequestOperationManager *manager = [self requestManager];
	NSMutableURLRequest *request = [manager.requestSerializer requestWithMethod:@"GET" URLString:urlString parameters:nil error:nil];
    //[request setTimeoutInterval:600];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        succes(responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:nil andMessage:@"failure getImageStreamByIdPointLivraison" andExparams:[NSString stringWithFormat:@"failure error: %@", error]];
		failure(error);
    }];
    [requestOperation start];
    
}


- (void)saveBeanImage:(PEG_BeanImage*)p_BeanImage succes:(void (^)(void))succes failure:(void (^)(NSError *error))failure
{
	PEGParametres* sharedCEXParametres = [PEGParametres sharedInstance];
	NSString* urlWebservice =[sharedCEXParametres.URL stringForKey:@"WebServicesIndianaMerchandisingV2"];
	NSString* urlService=@"/REST/SaveImageBytePreImport_POST";
	NSString* urlString = [NSString stringWithFormat:@"%@%@", urlWebservice, urlService];
	
    DLog(@"saveBeanImage =>urlString: %@ ",urlString);

    NSMutableDictionary* parameters=[p_BeanImage objectToJson];

    if (! [NSJSONSerialization isValidJSONObject:parameters]) {	// serialisable ?
        NSLog(@"Image non serializable");
        failure(nil);	// que fait on dans ce cas ? (ne devrait pas se produire)
        return;
    }
    else{
        NSLog(@"Image : %@",[parameters stringForKey:@"nomImage"]);
    }
    
    AFHTTPRequestOperationManager *manager = [self requestManager];
	[manager.requestSerializer setAuthorizationHeaderFieldWithUsername:[SPIRSession username] password:[SPIRSession password]];
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer = requestSerializer;      // note pm_06 on est pas en train d'écraser setAuthorizationHeaderFieldWithUsername de 2 lignes au dessus ?

	NSMutableURLRequest *request = [manager.requestSerializer
									requestWithMethod:@"POST"
									URLString:urlString
									parameters:parameters
									error:nil];

    
	[request setTimeoutInterval:240];
	// NSLog(@"%@",[request allHTTPHeaderFields]);
	
    AFHTTPRequestOperation *operation = [manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
		@try{
#ifdef DEBUG
            NSLog(@"saveBeanImage success response: %@", responseObject);			// un dictionnaire déjà parsé
#endif
            
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                if([self isProcessResponseForBeanErrorOK:responseObject])
                {
                    succes();
                }
            }
            else {
                failure(nil);	// TODO: check that error = nil is handled correctly by the caller
            }
        }@catch(NSException* p_exception){
            
            //[self MessageErrorUser:@"GetReferentiel"];
            [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Exception saveBeanImage success" andExparams:nil];
            failure(nil);
        }
		
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"saveBeanImage failure error: %@", error);
        [[PEGException sharedInstance] ManageErrorWithoutThrow:error andMessage:@"failure saveBeanImage" andExparams:[NSString stringWithFormat:@"failure error: %@", error]];
		failure(error);
	}];
	
    [manager.operationQueue addOperation:operation];
 
}

@end



