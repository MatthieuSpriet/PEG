//
//  PEG_BeanLieu.m
//  PEG
//
//  Created by 10_200_11_120 on 20/06/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_BeanLieu.h"
#import "PEG_FTechnical.h"
#import "PEG_BeanPresentoir.h"
#import "PEG_BeanHoraire.h"
#import "PEG_BeanConcurentLieu.h"
#import "PEGException.h"
#import "PEG_EnumFlagMAJ.h"

@implementation PEG_BeanLieu

-(NSString*) description
{
	return [NSString stringWithFormat:@"<%@ %p> {IdLieu :%@,GUIDLieu :%@,LiNomLieu :%@,LiInfoSupp :%@,NoVoie :%@,NoVoieComplement :%@,PrefixDirectionVoie :%@,TypeVoie :%@,LiaisonVoie :%@,NomVoie :%@,NomDirecteurVoie :%@,SuffixDirectionVoie :%@,CodePostal :%@,CodePostalComplement :%@,Ville :%@,Intersection :%@,NomBatiment :%@,Service :%@,Complement :%@,Etat :%@,CodePays :%@,CodeEtatLieu :%@,CodeProchainEtatLieu :%@, DateProchainEtatLieu :%@, CoordX :%@,CoordY :%@,CoordXpda :%@,CoordYpda :%@,Proprietaire :%i,DateCreation :%@,DateDerniereVisite :%@,VfClientMag :%i,VfExclusif :%i, FlagMAJ : %@, ListePresentoir %@, ListHoraire %@ , ListConcurentLieu %@, ProchEtatCode %@, %@ }",
            NSStringFromClass([self class]),
            self,
            self.IdLieu,
            self.GUIDLieu,
            self.LiNomLieu,
            self.LiInfoSupp,
            self.NoVoie,
            self.NoVoieComplement,
            self.PrefixDirectionVoie,
            self.TypeVoie,
            self.LiaisonVoie,
            self.NomVoie,
            self.NomDirecteurVoie,
            self.SuffixDirectionVoie,
            self.CodePostal,
            self.CodePostalComplement,
            self.Ville,
            self.Intersection,
            self.NomBatiment,
            self.Service,
            self.Complement,
            self.Etat,
            self.CodePays,
            self.CodeEtatLieu,
            self.CodeProchainEtatLieu,
            self.DateProchainEtatLieu,
            self.CoordX,
            self.CoordY,
            self.CoordXpda,
            self.CoordYpda,
            self.Proprietaire,
            self.DateCreation,
            self.DateDerniereVisite,
            self.VfClientMag,
            self.VfExclusif,
            self.FlagMAJ,
            self.ListPresentoir,
            self.ListHoraire,
            self.ListConcurentLieu,
            self.ProchEtatCode,
            self.ProchEtatDate];
}

-(id) initBeanWithJson :(NSDictionary*)p_json
{
    @try
    {
        self = [self init];
        if (self)
        {
            self.IdLieu = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"IdLieu"]];
            //if([p_json stringForKeyPath:@"GUIDLieu"] != nil)
            self.GUIDLieu = [p_json stringForKeyPath:@"GUIDLieu"];
            if([self.GUIDLieu isEqualToString:@""]) self.GUIDLieu = @"00000000-0000-0000-0000-000000000000";
            //if([p_json stringForKeyPath:@"LiNomLieu"] != nil)
            self.LiNomLieu = [p_json stringForKeyPath:@"LiNomLieu"];
            //if([p_json stringForKeyPath:@"LiInfoSupp"] != nil)
            self.LiInfoSupp = [p_json stringForKeyPath:@"LiInfoSupp"];
            //if([p_json stringForKeyPath:@"NoVoie"] != nil)
            self.NoVoie = [[NSNumber alloc]initWithInt:[p_json integerForKeyPath:@"NoVoie"]];
            //if([p_json stringForKeyPath:@"NoVoieComplement"] != nil)
            self.NoVoieComplement = [p_json stringForKeyPath:@"NoVoieComplement"];
            //if([p_json stringForKeyPath:@"PrefixDirectionVoie"] != nil)
            self.PrefixDirectionVoie = [p_json stringForKeyPath:@"PrefixDirectionVoie"];
            //if([p_json stringForKeyPath:@"TypeVoie"] != nil)
            self.TypeVoie = [p_json stringForKeyPath:@"TypeVoie"];
            //if([p_json stringForKeyPath:@"LiaisonVoie"] != nil)
            self.LiaisonVoie = [p_json stringForKeyPath:@"LiaisonVoie"];
            //if([p_json stringForKeyPath:@"NomVoie"] != nil)
            self.NomVoie = [p_json stringForKeyPath:@"NomVoie"];
            //if([p_json stringForKeyPath:@"NomDirecteurVoie"] != nil)
            self.NomDirecteurVoie = [p_json stringForKeyPath:@"NomDirecteurVoie"];
            //if([p_json stringForKeyPath:@"SuffixDirectionVoie"] != nil)
            self.SuffixDirectionVoie = [p_json stringForKeyPath:@"SuffixDirectionVoie"];
            //if([p_json stringForKeyPath:@"CodePostal"] != nil)
            self.CodePostal = [p_json stringForKeyPath:@"CodePostal"];
            //if([p_json stringForKeyPath:@"CodePostalComplement"] != nil)
            self.CodePostalComplement = [p_json stringForKeyPath:@"CodePostalComplement"];
            //if([p_json stringForKeyPath:@"Ville"] != nil)
            self.Ville = [p_json stringForKeyPath:@"Ville"];
            //if([p_json stringForKeyPath:@"Intersection"] != nil)
            self.Intersection = [p_json stringForKeyPath:@"Intersection"];
            //if([p_json stringForKeyPath:@"NomBatiment"] != nil)
            self.NomBatiment = [p_json stringForKeyPath:@"NomBatiment"];
            // if([p_json stringForKeyPath:@"Service"] != nil)
            self.Service = [p_json stringForKeyPath:@"Service"];
            //if([p_json stringForKeyPath:@"Complement"] != nil)
            self.Complement = [p_json stringForKeyPath:@"Complement"];
            //if([p_json stringForKeyPath:@"Etat"] != nil)
            self.Etat = [p_json stringForKeyPath:@"Etat"];
            //if([p_json stringForKeyPath:@"CodePays"] != nil)
            self.CodePays = [p_json stringForKeyPath:@"CodePays"];
            //if([p_json stringForKeyPath:@"CodeEtatLieu"] != nil)
            self.CodeEtatLieu = [p_json stringForKeyPath:@"CodeEtatLieu"];
            self.CodeProchainEtatLieu = [p_json stringForKeyPath:@"CodeProchainEtatLieu"];
            self.DateProchainEtatLieu = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"DateProchainEtatLieu"]];
            //if([p_json stringForKeyPath:@"CoordX"] != nil)
            self.CoordX = [[NSNumber alloc]initWithFloat:[p_json floatForKeyPath:@"CoordX"]];
            //if([p_json stringForKeyPath:@"CoordY"] != nil)
            self.CoordY = [[NSNumber alloc]initWithFloat:[p_json floatForKeyPath:@"CoordY"]];
            //if([p_json stringForKeyPath:@"CoordXpda"] != nil)
            self.CoordXpda = [[NSNumber alloc]initWithFloat:[p_json floatForKeyPath:@"CoordXpda"]];
            //if([p_json stringForKeyPath:@"CoordYpda"] != nil)
            self.CoordYpda = [[NSNumber alloc]initWithFloat:[p_json floatForKeyPath:@"CoordYpda"]];
            //if([p_json stringForKeyPath:@"Proprietaire"] != nil)
            self.Proprietaire = [p_json boolForKeyPath:@"Proprietaire"];
            //if([p_json stringForKeyPath:@"DateCreation"] != nil)
            self.DateCreation = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"DateCreation"]];
            //if(![[p_json stringForKeyPath:@"DateDerniereVisite"] isEqualToString:@""])
            self.DateDerniereVisite = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"DateDerniereVisite"]];
            //if([p_json stringForKeyPath:@"VfClientMag"] != nil) self.VfClientMag = [p_json boolForKeyPath:@"VfClientMag"];
            //if([p_json stringForKeyPath:@"VfExclusif"] != nil)
            self.VfExclusif = [p_json boolForKeyPath:@"VfExclusif"];
            //if([p_json stringForKeyPath:@"FlagMAJ"] != nil)
            self.FlagMAJ = [p_json stringForKeyPath:@"FlagMAJ"];
            
            self.RespCivilite = [p_json stringForKeyPath:@"RespCivilite"];
            self.RespNom = [p_json stringForKeyPath:@"RespNom"];
            self.RespTel = [p_json stringForKeyPath:@"RespTel"];
            self.CodeActivite = [p_json stringForKeyPath:@"CodeActivite"];
            self.Ouvert247 = [p_json boolForKeyPath:@"Ouvert247"];
            self.Commentaire = [p_json stringForKeyPath:@"Commentaire"];
            self.DateIntention = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"DateIntention"]];
            self.Dist = [[NSNumber alloc]initWithFloat:[p_json floatForKeyPath:@"Dist"]];
            self.AucunConcurent = [p_json boolForKeyPath:@"AucunConcurent"];
            
            self.ProchEtatCode = [p_json stringForKeyPath:@"ProchEtatCode"];
            self.ProchEtatDate = [PEG_FTechnical getDateFromJson:[p_json stringForKeyPath:@"ProchEtatDate"]];
            
            
            NSArray* v_ListPresentoir = [p_json arrayForKeyPath:@"ListPresentoir"];
            if(v_ListPresentoir != nil)
            {
                self.ListPresentoir =[[NSMutableArray alloc] init];
                for (NSDictionary* v_ItemListPresentoir in v_ListPresentoir)
                {
                    PEG_BeanPresentoir* v_BeanPresentoir = [[PEG_BeanPresentoir alloc] initBeanWithJson:v_ItemListPresentoir];
                    [self.ListPresentoir addObject:v_BeanPresentoir];
                    [v_BeanPresentoir release];
                }
            }
            
            NSArray* v_ListConcurentLieu = [p_json arrayForKeyPath:@"ListConcurentLieu"];
            if(v_ListConcurentLieu != nil)
            {
                self.ListConcurentLieu =[[NSMutableArray alloc] init];
                for (NSDictionary* v_ItemListConcurentLieu in v_ListConcurentLieu)
                {
                    PEG_BeanConcurentLieu* v_BeanConcurentLieu = [[PEG_BeanConcurentLieu alloc] initBeanWithJson:v_ItemListConcurentLieu];
                    [self.ListConcurentLieu addObject:v_BeanConcurentLieu];
                    [v_BeanConcurentLieu release];
                }
            }
            
            
            NSArray* v_ListHoraire = [p_json arrayForKeyPath:@"ListHoraire"];
            if(v_ListHoraire != nil)
            {
                self.ListHoraire =[[NSMutableArray alloc] init];
                for (NSDictionary* v_ItemListHoraire in v_ListHoraire)
                {
                    PEG_BeanHoraire* v_BeanHoraire = [[PEG_BeanHoraire alloc] initBeanWithJson:v_ItemListHoraire];
                    [self.ListHoraire addObject:v_BeanHoraire];
                    [v_BeanHoraire release];
                }
            }
        }
    }
    @catch(NSException* p_exception){
        
        [[PEGException sharedInstance] ManageExceptionWithThrow:p_exception andMessage:[NSString stringWithFormat:@"PEG_BeanLieu.initBeanWithJson Lieu: %@",self.description] andExparams:nil];
    }
    return self;
}

-(NSString*) GetAdresseComplete
{
    NSString* v_Adresse = @"";
    if(self.NoVoie != nil)
        v_Adresse = [NSString stringWithFormat:@"%@ %@",v_Adresse,self.NoVoie];
    if(self.NoVoieComplement != nil)
        v_Adresse = [NSString stringWithFormat:@"%@ %@",v_Adresse,self.NoVoieComplement];
    if(self.PrefixDirectionVoie != nil)
        v_Adresse = [NSString stringWithFormat:@"%@ %@",v_Adresse,self.PrefixDirectionVoie];
    if(self.TypeVoie != nil)
        v_Adresse = [NSString stringWithFormat:@"%@ %@",v_Adresse,self.TypeVoie];
    if(self.LiaisonVoie != nil)
        v_Adresse = [NSString stringWithFormat:@"%@ %@",v_Adresse,self.LiaisonVoie];
    if(self.NomVoie != nil)
        v_Adresse = [NSString stringWithFormat:@"%@ %@",v_Adresse,self.NomVoie];
    if(self.SuffixDirectionVoie != nil)
        v_Adresse = [NSString stringWithFormat:@"%@ %@",v_Adresse,self.SuffixDirectionVoie];
    if(self.CodePostal != nil)
        v_Adresse = [NSString stringWithFormat:@"%@ %@",v_Adresse,self.CodePostal];
    if(self.CodePostalComplement != nil)
        v_Adresse = [NSString stringWithFormat:@"%@ %@",v_Adresse,self.CodePostalComplement];
    if(self.Ville != nil)
        v_Adresse = [NSString stringWithFormat:@"%@ %@",v_Adresse,self.Ville];
    return v_Adresse;
}

-(BOOL) IsLivrable247
{
    BOOL v_isLivrable = false;
    for (PEG_BeanHoraire* v_ItemHoraire in self.ListHoraire)
    {
        if(v_ItemHoraire.Livre24)
        {
            v_isLivrable = true;
        }
    }
    return v_isLivrable;
}

-(NSString*) GetLibelleJour:(NSNumber*)p_NumJour
{
    NSString* v_Jour = @"";
    
    switch ([p_NumJour intValue]) {
        case 1:
            v_Jour =@"Lundi";
            break;
        case 2:
            v_Jour =@"Mardi";
            break;
        case 3:
            v_Jour =@"Mercredi";
            break;
        case 4:
            v_Jour =@"Jeudi";
            break;
        case 5:
            v_Jour =@"Vendredi";
            break;
        case 6:
            v_Jour =@"Samedi";
            break;
        case 7:
            v_Jour =@"Dimanche";
            break;
        default:
            v_Jour =@"Inconnu";
            break;
    }
    return v_Jour;
}

-(NSMutableArray*) GetHorairesComplet
{
    NSMutableArray* v_ListHoraire= [[NSMutableArray alloc] init];
    //    NSString* v_Horaire = @"";
    
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"H:mm"];
    NSString* v_AM = @"";
    NSString* v_PM = @"";
    [self.ListHoraire sortUsingSelector:@selector(compare:)];
    for (PEG_BeanHoraire* v_ItemHoraire in self.ListHoraire)
    {
        NSString* v_Horaire = @"";
        v_Horaire = [NSString stringWithFormat:@"%@%@ : ",
                     v_Horaire,
                     [self GetLibelleJour:v_ItemHoraire.Jour]];
        
        v_AM = @"";
        if(v_ItemHoraire.AMDebut != nil && v_ItemHoraire.AMFin != nil)
        {
            v_AM = [NSString stringWithFormat:@"%@-%@",
                    [formatter stringFromDate:v_ItemHoraire.AMDebut], [formatter stringFromDate:v_ItemHoraire.AMFin]];
        }
        v_PM = @"";
        if(v_ItemHoraire.PMDebut != nil && v_ItemHoraire.PMFin != nil)
        {
            v_PM = [NSString stringWithFormat:@"%@-%@",[formatter stringFromDate:v_ItemHoraire.PMDebut], [formatter stringFromDate:v_ItemHoraire.PMFin]];
        }
        
        if(v_AM.length > 1 && v_PM.length > 1)
        {
            v_Horaire = [NSString stringWithFormat:@"%@%@ / %@\n",
                         v_Horaire,
                         v_AM,v_PM];
        }
        else if (v_AM.length > 1)
        {
            v_Horaire = [NSString stringWithFormat:@"%@%@\n",
                         v_Horaire,
                         v_AM];
        }
        else if(v_PM.length > 1)
        {
            v_Horaire = [NSString stringWithFormat:@"%@%@\n",
                         v_Horaire,
                         v_PM];
        }
        [v_ListHoraire addObject:v_Horaire];
    }
    
    return v_ListHoraire;
}


-(PEG_BeanHoraire*) GetBeanHoraireByIndex:(NSUInteger) v_Index
{
    PEG_BeanHoraire* v_beanHoraire=nil;
    [self.ListHoraire sortUsingSelector:@selector(compareHoraire:)];
    v_beanHoraire=[self.ListHoraire objectAtIndex:v_Index];
    return v_beanHoraire;
}

-(void) AddOrReplaceHoraire:(PEG_BeanHoraire*) v_BeanHoraire
{
    [self.ListHoraire sortUsingSelector:@selector(compare:)];
    BOOL v_trouve=NO;
    for (PEG_BeanHoraire* v_ItemHoraire in self.ListHoraire)
    {
        if([v_ItemHoraire.Jour isEqualToNumber:v_BeanHoraire.Jour]){
            v_ItemHoraire=v_BeanHoraire;
            v_trouve=YES;
            break;
        }
    }
    if(!v_trouve){
        [self.ListHoraire addObject:v_BeanHoraire];
    }
}

-(NSMutableDictionary* ) objectToJson
{
    //on constitue la liste des qte
    NSMutableArray* v_listPresentoir = [NSMutableArray array];
    for(PEG_BeanPresentoir* v_BeanPresentoir in self.ListPresentoir)
    {
        [v_listPresentoir addObject:[v_BeanPresentoir objectToJson]];
    }
    
    NSMutableArray* v_listHoraire = [NSMutableArray array];
    for(PEG_BeanHoraire* v_BeanHoraire in self.ListHoraire)
    {
        [v_listHoraire addObject:[v_BeanHoraire objectToJson]];
    }
    
    NSMutableArray* v_listConcurrentLieu = [NSMutableArray array];
    for(PEG_BeanConcurentLieu* v_BeanConcurrentLieu in self.ListConcurentLieu)
    {
        [v_listConcurrentLieu addObject:[v_BeanConcurrentLieu objectToJson]];
    }
    
    NSMutableDictionary* v_Return2 =[[NSMutableDictionary alloc] init];
    if (self.IdLieu != nil)[v_Return2 setObject:self.IdLieu forKey:@"IdLieu"];
    if (self.GUIDLieu != nil)[v_Return2 setObject:self.GUIDLieu forKey:@"GUIDLieu"];
    if (self.LiNomLieu != nil)[v_Return2 setObject:self.LiNomLieu forKey:@"LiNomLieu"];
    if (self.LiInfoSupp != nil)[v_Return2 setObject:self.LiInfoSupp forKey:@"LiInfoSupp"];
    if (self.NoVoie != nil)[v_Return2 setObject:self.NoVoie forKey:@"NoVoie"];
    if (self.NoVoieComplement != nil)[v_Return2 setObject:self.NoVoieComplement forKey:@"NoVoieComplement"];
    if (self.PrefixDirectionVoie != nil)[v_Return2 setObject:self.PrefixDirectionVoie forKey:@"PrefixDirectionVoie"];
    if (self.TypeVoie != nil)[v_Return2 setObject:self.TypeVoie forKey:@"TypeVoie"];
    if (self.LiaisonVoie != nil)[v_Return2 setObject:self.LiaisonVoie forKey:@"LiaisonVoie"];
    if (self.NomVoie != nil)[v_Return2 setObject:self.NomVoie forKey:@"NomVoie"];
    if (self.NomDirecteurVoie != nil)[v_Return2 setObject:self.NomDirecteurVoie forKey:@"NomDirecteurVoie"];
    if (self.SuffixDirectionVoie != nil)[v_Return2 setObject:self.SuffixDirectionVoie forKey:@"SuffixDirectionVoie"];
    if (self.CodePostal != nil)[v_Return2 setObject:self.CodePostal forKey:@"CodePostal"];
    if (self.CodePostalComplement != nil)[v_Return2 setObject:self.CodePostalComplement forKey:@"CodePostalComplement"];
    if (self.Ville != nil)[v_Return2 setObject:self.Ville forKey:@"Ville"];
    if (self.Intersection != nil)[v_Return2 setObject:self.Intersection forKey:@"Intersection"];
    if (self.NomBatiment != nil)[v_Return2 setObject:self.NomBatiment forKey:@"NomBatiment"];
    if (self.Service != nil)[v_Return2 setObject:self.Service forKey:@"Service"];
    if (self.Complement != nil)[v_Return2 setObject:self.Complement forKey:@"Complement"];
    if (self.Etat != nil)[v_Return2 setObject:self.Etat forKey:@"Etat"];
    if (self.CodePays != nil)[v_Return2 setObject:self.CodePays forKey:@"CodePays"];
    if (self.CodeEtatLieu != nil)[v_Return2 setObject:self.CodeEtatLieu forKey:@"CodeEtatLieu"];
    if (self.CodeProchainEtatLieu != nil)[v_Return2 setObject:self.CodeProchainEtatLieu forKey:@"CodeProchainEtatLieu"];
    if ([PEG_FTechnical getJsonFromDate:self.DateProchainEtatLieu] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.DateProchainEtatLieu] forKey:@"DateProchainEtatLieu"];
    if (self.CoordX != nil)[v_Return2 setObject:self.CoordX forKey:@"CoordX"];
    if (self.CoordY != nil)[v_Return2 setObject:self.CoordY forKey:@"CoordY"];
    if (self.CoordXpda != nil)[v_Return2 setObject:self.CoordXpda forKey:@"CoordXpda"];
    if (self.CoordYpda != nil)[v_Return2 setObject:self.CoordYpda forKey:@"CoordYpda"];
    if ([[NSNumber alloc ] initWithBool:self.Proprietaire] != nil)[v_Return2 setObject:[[NSNumber alloc ] initWithBool:self.Proprietaire] forKey:@"Proprietaire"];
    if ([PEG_FTechnical getJsonFromDate:self.DateCreation] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.DateCreation] forKey:@"DateCreation"];
    if ([PEG_FTechnical getJsonFromDate:self.DateDerniereVisite] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.DateDerniereVisite] forKey:@"DateDerniereVisite"];
    if ([[NSNumber alloc ] initWithBool:self.VfClientMag] != nil)[v_Return2 setObject:[[NSNumber alloc ] initWithBool:self.VfClientMag] forKey:@"VfClientMag"];
    if ([[NSNumber alloc ] initWithBool:self.VfExclusif] != nil)[v_Return2 setObject:[[NSNumber alloc ] initWithBool:self.VfExclusif] forKey:@"VfExclusif"];
    if (self.FlagMAJ != nil)[v_Return2 setObject:self.FlagMAJ forKey:@"FlagMAJ"];
    if (self.RespCivilite != nil)[v_Return2 setObject:self.RespCivilite forKey:@"RespCivilite"];
    if (self.RespNom != nil)[v_Return2 setObject:self.RespNom forKey:@"RespNom"];
    if (self.RespTel != nil)[v_Return2 setObject:self.RespTel forKey:@"RespTel"];
    if (self.CodeActivite != nil)[v_Return2 setObject:self.CodeActivite forKey:@"CodeActivite"];
    if ([[NSNumber alloc ] initWithBool:self.Ouvert247] != nil)[v_Return2 setObject:[[NSNumber alloc ] initWithBool:self.Ouvert247] forKey:@"Ouvert247"];
    if (self.Commentaire != nil)[v_Return2 setObject:self.Commentaire forKey:@"Commentaire"];
    if ([PEG_FTechnical getJsonFromDate:self.DateIntention] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.DateIntention] forKey:@"DateIntention"];
    if (self.Dist != nil)[v_Return2 setObject:self.Dist forKey:@"Dist"];
    if ([[NSNumber alloc ] initWithBool:self.AucunConcurent] != nil)[v_Return2 setObject:[[NSNumber alloc ] initWithBool:self.AucunConcurent] forKey:@"AucunConcurent"];
    if (self.ProchEtatCode != nil)[v_Return2 setObject:self.ProchEtatCode forKey:@"ProchEtatCode"];
    if ([PEG_FTechnical getJsonFromDate:self.ProchEtatDate] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.ProchEtatDate] forKey:@"ProchEtatDate"];
    if (v_listPresentoir != nil)[v_Return2 setObject:v_listPresentoir forKey:@"ListPresentoir"];
    if (v_listHoraire != nil)[v_Return2 setObject:v_listHoraire forKey:@"ListHoraire"];
    if (v_listConcurrentLieu != nil)[v_Return2 setObject:v_listConcurrentLieu forKey:@"ListConcurentLieu"];
    
    return v_Return2;
    
}

-(NSMutableDictionary* ) objectModifiedToJson
{
    //on constitue la liste des qte
    NSMutableArray* v_listPresentoir = [NSMutableArray array];
    for(PEG_BeanPresentoir* v_BeanPresentoir in self.ListPresentoir)
    {
        NSMutableDictionary* v_JsonTmp = [v_BeanPresentoir objectModifiedToJson];
        if(v_JsonTmp != nil)
        {
        [v_listPresentoir addObject:v_JsonTmp];
        }
    }
    
    NSMutableArray* v_listHoraire = [NSMutableArray array];
    for(PEG_BeanHoraire* v_BeanHoraire in self.ListHoraire)
    {
        if(![v_BeanHoraire.FlagMAJ isEqualToString:PEG_EnumFlagMAJ_Unchanged])
        {
            [v_listHoraire addObject:[v_BeanHoraire objectToJson]];
        }
    }
    
    NSMutableArray* v_listConcurrentLieu = [NSMutableArray array];
    for(PEG_BeanConcurentLieu* v_BeanConcurrentLieu in self.ListConcurentLieu)
    {
        if(![v_BeanConcurrentLieu.FlagMAJ isEqualToString:PEG_EnumFlagMAJ_Unchanged])
        {
            [v_listConcurrentLieu addObject:[v_BeanConcurrentLieu objectToJson]];
        }
    }
    
    NSMutableDictionary* v_Return2 =nil;
    
    if(v_listPresentoir.count != 0 || v_listHoraire.count != 0 || v_listConcurrentLieu.count != 0 || ![self.FlagMAJ isEqualToString:PEG_EnumFlagMAJ_Unchanged])
    {
        v_Return2 =[[NSMutableDictionary alloc] init];
        if (self.IdLieu != nil)[v_Return2 setObject:self.IdLieu forKey:@"IdLieu"];
        if (self.GUIDLieu != nil)[v_Return2 setObject:self.GUIDLieu forKey:@"GUIDLieu"];
        if (self.LiNomLieu != nil)[v_Return2 setObject:self.LiNomLieu forKey:@"LiNomLieu"];
        if (self.LiInfoSupp != nil)[v_Return2 setObject:self.LiInfoSupp forKey:@"LiInfoSupp"];
        if (self.NoVoie != nil)[v_Return2 setObject:self.NoVoie forKey:@"NoVoie"];
        if (self.NoVoieComplement != nil)[v_Return2 setObject:self.NoVoieComplement forKey:@"NoVoieComplement"];
        if (self.PrefixDirectionVoie != nil)[v_Return2 setObject:self.PrefixDirectionVoie forKey:@"PrefixDirectionVoie"];
        if (self.TypeVoie != nil)[v_Return2 setObject:self.TypeVoie forKey:@"TypeVoie"];
        if (self.LiaisonVoie != nil)[v_Return2 setObject:self.LiaisonVoie forKey:@"LiaisonVoie"];
        if (self.NomVoie != nil)[v_Return2 setObject:self.NomVoie forKey:@"NomVoie"];
        if (self.NomDirecteurVoie != nil)[v_Return2 setObject:self.NomDirecteurVoie forKey:@"NomDirecteurVoie"];
        if (self.SuffixDirectionVoie != nil)[v_Return2 setObject:self.SuffixDirectionVoie forKey:@"SuffixDirectionVoie"];
        if (self.CodePostal != nil)[v_Return2 setObject:self.CodePostal forKey:@"CodePostal"];
        if (self.CodePostalComplement != nil)[v_Return2 setObject:self.CodePostalComplement forKey:@"CodePostalComplement"];
        if (self.Ville != nil)[v_Return2 setObject:self.Ville forKey:@"Ville"];
        if (self.Intersection != nil)[v_Return2 setObject:self.Intersection forKey:@"Intersection"];
        if (self.NomBatiment != nil)[v_Return2 setObject:self.NomBatiment forKey:@"NomBatiment"];
        if (self.Service != nil)[v_Return2 setObject:self.Service forKey:@"Service"];
        if (self.Complement != nil)[v_Return2 setObject:self.Complement forKey:@"Complement"];
        if (self.Etat != nil)[v_Return2 setObject:self.Etat forKey:@"Etat"];
        if (self.CodePays != nil)[v_Return2 setObject:self.CodePays forKey:@"CodePays"];
        if (self.CodeEtatLieu != nil)[v_Return2 setObject:self.CodeEtatLieu forKey:@"CodeEtatLieu"];
        if (self.CodeProchainEtatLieu != nil)[v_Return2 setObject:self.CodeProchainEtatLieu forKey:@"CodeProchainEtatLieu"];
        if ([PEG_FTechnical getJsonFromDate:self.DateProchainEtatLieu] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.DateProchainEtatLieu] forKey:@"DateProchainEtatLieu"];
        if (self.CoordX != nil)[v_Return2 setObject:self.CoordX forKey:@"CoordX"];
        if (self.CoordY != nil)[v_Return2 setObject:self.CoordY forKey:@"CoordY"];
        if (self.CoordXpda != nil)[v_Return2 setObject:self.CoordXpda forKey:@"CoordXpda"];
        if (self.CoordYpda != nil)[v_Return2 setObject:self.CoordYpda forKey:@"CoordYpda"];
        if ([[NSNumber alloc ] initWithBool:self.Proprietaire] != nil)[v_Return2 setObject:[[NSNumber alloc ] initWithBool:self.Proprietaire] forKey:@"Proprietaire"];
        if ([PEG_FTechnical getJsonFromDate:self.DateCreation] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.DateCreation] forKey:@"DateCreation"];
        if ([PEG_FTechnical getJsonFromDate:self.DateDerniereVisite] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.DateDerniereVisite] forKey:@"DateDerniereVisite"];
        if ([[NSNumber alloc ] initWithBool:self.VfClientMag] != nil)[v_Return2 setObject:[[NSNumber alloc ] initWithBool:self.VfClientMag] forKey:@"VfClientMag"];
        if ([[NSNumber alloc ] initWithBool:self.VfExclusif] != nil)[v_Return2 setObject:[[NSNumber alloc ] initWithBool:self.VfExclusif] forKey:@"VfExclusif"];
        if (self.FlagMAJ != nil)[v_Return2 setObject:self.FlagMAJ forKey:@"FlagMAJ"];
        if (self.RespCivilite != nil)[v_Return2 setObject:self.RespCivilite forKey:@"RespCivilite"];
        if (self.RespNom != nil)[v_Return2 setObject:self.RespNom forKey:@"RespNom"];
        if (self.RespTel != nil)[v_Return2 setObject:self.RespTel forKey:@"RespTel"];
        if (self.CodeActivite != nil)[v_Return2 setObject:self.CodeActivite forKey:@"CodeActivite"];
        if ([[NSNumber alloc ] initWithBool:self.Ouvert247] != nil)[v_Return2 setObject:[[NSNumber alloc ] initWithBool:self.Ouvert247] forKey:@"Ouvert247"];
        if (self.Commentaire != nil)[v_Return2 setObject:self.Commentaire forKey:@"Commentaire"];
        if ([PEG_FTechnical getJsonFromDate:self.DateIntention] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.DateIntention] forKey:@"DateIntention"];
        if (self.Dist != nil)[v_Return2 setObject:self.Dist forKey:@"Dist"];
        if ([[NSNumber alloc ] initWithBool:self.AucunConcurent] != nil)[v_Return2 setObject:[[NSNumber alloc ] initWithBool:self.AucunConcurent] forKey:@"AucunConcurent"];
        if (self.ProchEtatCode != nil)[v_Return2 setObject:self.ProchEtatCode forKey:@"ProchEtatCode"];
        if ([PEG_FTechnical getJsonFromDate:self.ProchEtatDate] != nil)[v_Return2 setObject:[PEG_FTechnical getJsonFromDate:self.ProchEtatDate] forKey:@"ProchEtatDate"];
        if (v_listPresentoir != nil)[v_Return2 setObject:v_listPresentoir forKey:@"ListPresentoir"];
        if (v_listHoraire != nil)[v_Return2 setObject:v_listHoraire forKey:@"ListHoraire"];
        if (v_listConcurrentLieu != nil)[v_Return2 setObject:v_listConcurrentLieu forKey:@"ListConcurentLieu"];
    }
    
    return v_Return2;
    
}

@end
