//
//  PEG_DtlLieuxViewController.m
//  Pegase
//
//  Created by HorsMedia1 on 30/05/13.
//  Copyright (c) 2013 HorsMedia1. All rights reserved.
//


#import "PEG_DtlLieuxViewController.h"
#import "PEG_DtlLieuCell.h"
#import "PEG_DtlAdresseCell.h"
#import "PEG_FMobilitePegase.h"
#import "BeanPresentoir.h"
#import "PEG_DtlPresentoirCell.h"
#import "PEG_PickerViewController.h"
#import "PEG_BeanImage.h"
#import "PEG_DtlAdresseLieuViewController.h"
#import "PEG_ActionMinuteViewController.h"
#import "PEG_ListRelationnelViewController.h"
#import "PEG_ConcurrentViewController.h"
#import "PEG_DtlQuantiteMaterielViewController.h"
#import "PEG_MapCartoViewController.h"
#import "PEGPresentoirTabbarViewController.h"
#import "PEG_ActionReplaceViewController.h"
#import "PEG_EnumFlagMAJ.h"
#import "MBProgressHUD.h"
#import "CustomBadge.h"
#import "PEG_BeanPresentoirParution.h"
#import "PEG_ImageViewController.h"
#import "PEG_BeanPresentoirParution.h"
#import "PEG_FTechnical.h"
#import "BeanEdition.h"

@interface PEG_DtlLieuxViewController ()

@property (strong, nonatomic) BeanLieu* BeanLieu;
@property (strong, nonatomic) NSMutableArray* ListPresentoirParution; //PEG_BeanPresentoirParution* BeanPresentoirParution;
@property (assign, nonatomic) int IndexPresentoirSelected;
@property (strong, nonatomic) IBOutlet UITableView *DtlLieuUITableView;
@property (strong, nonatomic) MBProgressHUD *hud ;
@property (assign, nonatomic) BOOL isFullScreen;
@property (assign, nonatomic) CGRect prevFrame;
@property (strong, nonatomic) UITapGestureRecognizer *tap;

@property (strong, nonatomic) PEG_BeanImage* ImageCourante;
@property (weak, nonatomic) CustomBadge *customBadgeActionMinute;
@property (weak, nonatomic) CustomBadge *customBadgeCadeau;
@property (weak, nonatomic) CustomBadge *customBadgeConcurrent;
@property (weak, nonatomic) CustomBadge *customBadgeAdresse;
@property (strong, nonatomic)  UIActivityIndicatorView *HudPhoto;
@end

@implementation PEG_DtlLieuxViewController

// pm201402 avec iOS7, les cellules occupent toute la largeur.
// Je pense que le +10 sur la position en x était là pour compenser le redimensionement des cellules / template.
#define BADGE_OFFET_X	0

#pragma mark - Init
// pm_06 initWithNibName not called with storyboard, use initWithCoder instead
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        self.IndexPresentoirSelected = 0;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = self.BeanLieu.liNomLieu;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.ImageCourante= [[PEG_BeanImage alloc]init];
    
    //Pour agrandir l'image
    self.isFullScreen = false;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self setDetailItem:self.BeanLieu.idLieu];
    //self.ListPresentoirParution = [[PEG_FMobilitePegase CreateLieu] GetListPresentoirParutionTourneeMerchByLieu:self.BeanLieu];
    
    //Deplacement du tag sur le premier presentoir valide, si l'existant ne l'est plus
    NSArray *array = [NSArray arrayWithArray:self.ListPresentoirParution];
    if(array.count > 0)
    {
        PEG_BeanPresentoirParution* v_PresentoirParution = ((PEG_BeanPresentoirParution*)[array objectAtIndex:self.IndexPresentoirSelected]);
        if(v_PresentoirParution != nil)
        {
            BeanPresentoir* v_Presentoir = v_PresentoirParution.Presentoir;
            if(![[PEG_FMobilitePegase CreatePresentoir] IsPresentoirActif:v_Presentoir])
            {
                self.IndexPresentoirSelected = 0;
                int v_numPres = 0;
                for (PEG_BeanPresentoirParution* v_item in array) {
                    v_PresentoirParution = ((PEG_BeanPresentoirParution*)[array objectAtIndex:v_numPres]);
                    if([[PEG_FMobilitePegase CreatePresentoir] IsPresentoirActif:v_PresentoirParution.Presentoir])
                    {
                        self.IndexPresentoirSelected = v_numPres;
                        break;
                    }
                    v_numPres++;
                }
            }
        }
    }
    
    [self.DtlLieuUITableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setDetailItem:(NSNumber*)p_IdLieu
{
    self.BeanLieu = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:p_IdLieu];
    self.ListPresentoirParution = [[PEG_FMobilitePegase CreateLieu] GetListPresentoirParutionTourneeMerchByLieu:self.BeanLieu];
}

#pragma mark - Table view data source
-(int) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @""; //@"Titre";
    }
    else if (section == 1)
    {
        return @""; //@"Présentoirs";
    }
    else if (section == 2)
    {
        return @"";//@"Admin";
    }
    else if (section == 3)
    {
        return @"";//@"Adresse";
    }
    return @"";
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return self.ListPresentoirParution.count;   // pm_06 was self.self.ListPresentoirParution.count;
    }
    else if (section == 2)
    {
        return 1;
    }
    else if (section == 3)
    {
        return 1;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 106.;
    }
    else if (indexPath.section == 1)
    {
        return 58.;
    }
    else if (indexPath.section == 2)
    {
        return 73.;
    }
    else if (indexPath.section == 3)
    {
        return 60.;
    }
    return 200.;
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try{
        UITableViewCell* cell = nil;
        if (indexPath.section==0)
        {
            PEG_DtlLieuCell* cellDtl = (PEG_DtlLieuCell *) [tableView dequeueReusableCellWithIdentifier:@"cellTitreLieu"];
            // with storyboard, dequeueReusableCellWithIdentifier allways returns a cell
            cellDtl.titreUILabel.text=self.BeanLieu.liNomLieu;
            
            //NSArray *array = [NSArray arrayWithArray:[self.BeanLieu.listPresentoir allObjects]];
            BeanPresentoir* v_Presentoir = nil;
            if(self.ListPresentoirParution.count >0)
            {
                NSArray *array = [NSArray arrayWithArray:self.ListPresentoirParution];
                
                ///BeanPresentoir* v_Presentoir = ((BeanPresentoir*)[array objectAtIndex:indexPath.item]);
                PEG_BeanPresentoirParution* v_PresentoirParution = ((PEG_BeanPresentoirParution*)[array objectAtIndex:self.IndexPresentoirSelected]);
                v_Presentoir = v_PresentoirParution.Presentoir;
                //BeanPresentoir* v_Presentoir = ((BeanPresentoir*)[array objectAtIndex:self.IndexPresentoirSelected ]);
                
                cellDtl.NbTacheUILabel.text = [NSString stringWithFormat:@"%i",[[PEG_FMobilitePegase CreateLieu] GetNbAllTacheForLieu:self.BeanLieu]];

                /* Desactivation */
                
                [self.HudPhoto removeFromSuperview];
                
                // Si l'Id et l'idPointDistribution sont different, il s'agit d'un nouveau présentoir
                // on ne doit pas reprendre l'ancienne photo alors en rentre dans le if
                if(self.ImageCourante.IdImage!=[v_Presentoir.idPointDistribution integerValue]
                   || [v_Presentoir.id intValue] != [v_Presentoir.idPointDistribution intValue]){
                    if(self.HudPhoto ==nil)
                    {
                        self.HudPhoto = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
                    }
                    self.HudPhoto.color =[UIColor blackColor];
                    //[self.HudPhoto setCenter:[[cellDtl] center]];
                    //[self setActivityIndicator: self.HudPhoto];
                    
                    [cellDtl addSubview:self.HudPhoto];
                    //self.HudPhoto;
                    [self.HudPhoto startAnimating];
                    
                    
                    self.ImageCourante.IdImage= [v_Presentoir.idPointDistribution integerValue];
                    if([[PEG_FMobilitePegase CreateActionPresentoir] IsPresentoirPhotoByIdPresentoir:v_Presentoir.id]){
                        UIImage * v_Image=[[PEG_FMobilitePegase CreateImage]GetPictureFromFileById:[v_Presentoir.id integerValue]];
                        if(v_Image !=nil){
                            self.ImageCourante.Image=nil;
                            self.ImageCourante.Image=v_Image;
                            [self.HudPhoto stopAnimating];
                        }
                    }else{
                        // Si l'Id et l'idPointDistribution sont different, il s'agit d'un nouveau présentoir,
                        // on ne doit pas reprendre l'ancienne photo, si on a déjà pris la photo, on va la chercher dans le fichier
                        // sinon pas de photo
                        if([v_Presentoir.id intValue] == [v_Presentoir.idPointDistribution intValue])
                        {
                            self.ImageCourante.Image = nil;
                            [self.ImageCourante GetBeanImageWithObserver:self];
                        }
                        else
                        {
                            //On laisse l'id setté pour pas tourner en rond
                            //self.ImageCourante.Image=nil;
                            
                            [self.HudPhoto stopAnimating];
                        }
                        //                            self.hud = [[MBProgressHUD alloc] initWithView:self.view];
                        //                            self.hud.removeFromSuperViewOnHide = YES;
                        //                            self.hud.labelText=@"Chargement de la photo";
                        //                            [self.view addSubview:self.hud];
                        //                            [self.hud show:YES];
                        //                            [self.hud release];
                        
                        
                    }
                }
                /**/
                if(self.ImageCourante.Image!=nil){
                    cellDtl.imgUIImageView.image =self.ImageCourante.Image;
                }else{
                    cellDtl.imgUIImageView.image = nil;
                    cellDtl.imgUIImageView.image = [UIImage imageNamed:@"NoPhoto.png"];
                }
                 
            }
            [cellDtl.AuditUIButton setEnabled:NO];
            
            cellDtl.imgUIImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgToFullScreen:)];
            tapper.numberOfTapsRequired = 1;
            [cellDtl.imgUIImageView addGestureRecognizer:tapper];

            if(![[PEG_FMobilitePegase CreateLieu] isLieuActif:_BeanLieu.idLieu]){
                cellDtl.backgroundColor=[[UIColor alloc ]initWithRed:0 green:0 blue:0 alpha:0.4];
                [cellDtl setUserInteractionEnabled:NO];
            }
            else
            {
                cellDtl.backgroundColor=[[UIColor alloc ]initWithRed:1 green:1 blue:1 alpha:1];
                [cellDtl setUserInteractionEnabled:YES];
            }
            
            ///// Badge
            
            [self.customBadgeActionMinute removeFromSuperview];
            self.customBadgeActionMinute = nil;
            if(v_Presentoir != nil &&
               ([[PEG_FMobilitePegase CreateActionPresentoir] IsPresentoirControleVisuelByIdPresentoir:v_Presentoir.id]
                || [[PEG_FMobilitePegase CreateActionPresentoir] IsPresentoirNettoyeByIdPresentoir:v_Presentoir.id]
                || [[PEG_FMobilitePegase CreateActionPresentoir] IsPresentoirReplaceByIdPresentoir:v_Presentoir.id]
                || [[PEG_FMobilitePegase CreateActionPresentoir] IsPresentoirDeplaceByIdPresentoir:v_Presentoir.id])
               )
            {
                self.customBadgeActionMinute = [CustomBadge customBadgeWithString:@"v"
                                                                  withStringColor:[UIColor whiteColor]
                                                                   withInsetColor:[UIColor colorWithRed:0.3 green:1 blue:0.3 alpha:0.7]
                                                                   withBadgeFrame:YES
                                                              withBadgeFrameColor:[UIColor whiteColor]
                                                                        withScale:0.75
                                                                      withShining:YES];
				// pm201402
                UIButton* button = cellDtl.actionsMinuteUIButton;
                [self.customBadgeActionMinute setFrame:CGRectMake(button.frame.origin.x+button.frame.size.width-self.customBadgeActionMinute.frame.size.width/2+BADGE_OFFET_X,
																  button.frame.origin.y-self.customBadgeActionMinute.frame.size.height/2+15,
																  self.customBadgeActionMinute.frame.size.width+3,
																  self.customBadgeActionMinute.frame.size.height+3)];

                [cellDtl addSubview:self.customBadgeActionMinute];
                
            }
            ///////
            
            return cellDtl;
        }
        else if (indexPath.section==1)
        {
            PEG_DtlPresentoirCell* cellPres = (PEG_DtlPresentoirCell *) [tableView dequeueReusableCellWithIdentifier:@"cellPresentoir"];
            NSArray *array = [NSArray arrayWithArray:self.ListPresentoirParution];
            
            ///BeanPresentoir* v_Presentoir = ((BeanPresentoir*)[array objectAtIndex:indexPath.item]);
            PEG_BeanPresentoirParution* v_PresentoirParution = ((PEG_BeanPresentoirParution*)[array objectAtIndex:indexPath.item]);
            BeanPresentoir* v_Presentoir = v_PresentoirParution.Presentoir;
            ///BeanParution* v_Parution = [[PEG_FMobilitePegase CreateParution] GetBeanParutionById:v_Presentoir.idParution];
            BeanParution* v_Parution = v_PresentoirParution.Parution;
            cellPres.NomPresentoirUILabel.text = [NSString stringWithFormat:@"%@",v_Parution.libelleEdition];
            
            if(v_PresentoirParution.IsFirstPres)
            {
                cellPres.EmplacementPresentoirUILabel.text = [NSString stringWithFormat:@"%@ - %@",v_Presentoir.emplacement,v_Presentoir.localisation];
                cellPres.TypePresentoirUILabel.text = v_Presentoir.tYPE;
                cellPres.DatePhotoUILabel.text = @"-";
                if([[PEG_FMobilitePegase CreatePresentoir] IsPhotoEnRougeOnPresentoir:v_Presentoir])
                {
                    cellPres.LabelDatePhotoUILabel.text = @"PHOTO";
                    cellPres.LabelDatePhotoUILabel.textColor = [UIColor redColor];
                    [cellPres.LabelDatePhotoUILabel setFont: [UIFont fontWithName:@"Helvetica-Bold" size:13.0f]];
                    cellPres.DatePhotoUILabel.textColor =[UIColor redColor];
                    [cellPres.DatePhotoUILabel setFont: [UIFont fontWithName:@"Helvetica Neue" size:13.0f]];
                }
                else{
                    cellPres.LabelDatePhotoUILabel.text = @"Photo";
                    cellPres.LabelDatePhotoUILabel.textColor = [UIColor blueColor];
                    [cellPres.LabelDatePhotoUILabel setFont: [UIFont fontWithName:@"Helvetica Neue" size:11.0f]];
                    cellPres.DatePhotoUILabel.textColor = [UIColor blackColor];
                    [cellPres.DatePhotoUILabel setFont: [UIFont fontWithName:@"Helvetica Neue" size:11.0f]];
                    if(v_Presentoir.dateDernierePhoto != nil)
                    {
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        [dateFormatter setDateFormat:@"dd/MM/yy"];
                        cellPres.DatePhotoUILabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:v_Presentoir.dateDernierePhoto ]];
                    }
                }
            }
            else
            {
                cellPres.EmplacementPresentoirUILabel.text =@"";
                cellPres.TypePresentoirUILabel.text = @"";
                cellPres.DatePhotoUILabel.text = @"";
                cellPres.LabelDatePhotoUILabel.text =@"";
            }
            
            //cellPres.textLabel.text=[NSString stringWithFormat:@"Presentoir - %d",indexPath.row ] ;
            
            cellPres.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cellPres.BtnCheckUIButton.tag = indexPath.item;//[v_Presentoir.IdPointDistribution integerValue];
            if(self.IndexPresentoirSelected == indexPath.item)
            {
                //NSString *thePath = [[NSBundle mainBundle] pathForResource:@"default" ofType:@"jpeg"];
                //UIImage *prodImg = [[UIImage alloc] initWithContentsOfFile:thePath];
                //cellPres.CheckUIImageView.image = [UIImage imageNamed:@"check-icon.jpg"];
                //[cellPres.BtnCheckUIButton setImage:[UIImage imageNamed:@"check-icon.jpg"] forState:UIControlStateNormal];
                //[cellPres.BtnCheckUIButton setImage:[UIImage imageNamed:@"TickBlue.png"] forState:UIControlStateNormal];
                cellPres.BtnCheckUIButton.imageView.image = [UIImage imageNamed:@"TickBlue.png"];
                //cellPres.CheckUIImageView.image = prodImg;
                //[prodImg release];
            }
            else
            {
                //cellPres.CheckUIImageView.image = nil;
                cellPres.BtnCheckUIButton.imageView.image = nil;
            }
            if(![[PEG_FMobilitePegase CreateLieu] isLieuActif:_BeanLieu.idLieu]){
                cellPres.backgroundColor=[[UIColor alloc ]initWithRed:0 green:0 blue:0 alpha:0.4];
                [cellPres setUserInteractionEnabled:NO];
            }
            else if(![[PEG_FMobilitePegase CreatePresentoir] IsPresentoirActif:v_Presentoir]){
                cellPres.backgroundColor=[[UIColor alloc ]initWithRed:1 green:0 blue:0 alpha:0.2];
                [cellPres setUserInteractionEnabled:NO];
            }            
            else
            {
                cellPres.backgroundColor=[[UIColor alloc ]initWithRed:1 green:1 blue:1 alpha:1];
                [cellPres setUserInteractionEnabled:YES];
            }
            return  cellPres;
        }
        else if (indexPath.section==2)
        {
            PEG_DtlLieuCell* cellAdmin = nil;       // pm_06 PEG_DtlLieuCell is used both for title and admin cell !
            cellAdmin = [tableView dequeueReusableCellWithIdentifier:@"cellAdminLieu"];
            //cellAdmin.textLabel.text=@"admin";
            
           
            NSArray *array = [[PEG_FMobilitePegase CreateConcurrent]GetBeanConcurentLieuByLieu:self.BeanLieu];
            NSInteger v_nbConcurrent=array.count;
            /*if((![self.BeanLieu.aucunConcurent boolValue]) && (v_nbConcurrent == 0)){
             [cellAdmin.ConcurrenceUIButton setImage:[UIImage imageNamed:@"ConcurenceRouge.png"] forState:UIControlStateNormal];
             }else{
             [cellAdmin.ConcurrenceUIButton setImage:[UIImage imageNamed:@"Concurence.png"] forState:UIControlStateNormal];
             }*/
            if(![[PEG_FMobilitePegase CreateLieu] isLieuActif:_BeanLieu.idLieu]){
                [cellAdmin.RelationnelUIButton setUserInteractionEnabled:NO];
                [cellAdmin.ConcurrenceUIButton setUserInteractionEnabled:NO];
            }
            else
            {
                [cellAdmin.RelationnelUIButton setUserInteractionEnabled:YES];
                [cellAdmin.ConcurrenceUIButton setUserInteractionEnabled:YES];
            }
            
            ///// Badge
            [self.customBadgeCadeau removeFromSuperview];
            self.customBadgeCadeau = nil;
            if([[PEG_FMobilitePegase CreateActionPresentoir] IsLieuRelationnelByIdLieu:self.BeanLieu.idLieu]
               || [[PEG_FMobilitePegase CreateActionPresentoir] GetBeanActionListCadeauByIdLieu:self.BeanLieu.idLieu].count>0)
            {
                self.customBadgeCadeau = [CustomBadge customBadgeWithString:@"v"
                                                            withStringColor:[UIColor whiteColor]
                                                             withInsetColor:[UIColor colorWithRed:0.3 green:1 blue:0.3 alpha:0.7]
                                                             withBadgeFrame:YES
                                                        withBadgeFrameColor:[UIColor whiteColor]
                                                                  withScale:0.75
                                                                withShining:YES];
                UIButton* button = cellAdmin.RelationnelUIButton;
                [self.customBadgeCadeau setFrame:CGRectMake(button.frame.origin.x+button.frame.size.width-self.customBadgeCadeau.frame.size.width/2+BADGE_OFFET_X, button.frame.origin.y-self.customBadgeCadeau.frame.size.height/2, self.customBadgeCadeau.frame.size.width, self.customBadgeCadeau.frame.size.height)];
                
                [cellAdmin addSubview:self.customBadgeCadeau];
            }
            
            [self.customBadgeConcurrent removeFromSuperview];
            self.customBadgeConcurrent = nil;
            if((![self.BeanLieu.aucunConcurent boolValue]) && (v_nbConcurrent == 0))
            {
                self.customBadgeConcurrent = [CustomBadge customBadgeWithString:@"!"
                                                                withStringColor:[UIColor whiteColor]
                                                                 withInsetColor:[UIColor redColor]
                                                                 withBadgeFrame:YES
                                                            withBadgeFrameColor:[UIColor whiteColor]
                                                                      withScale:0.75
                                                                    withShining:YES];
                UIButton* button = cellAdmin.ConcurrenceUIButton;
                [self.customBadgeConcurrent setFrame:CGRectMake(button.frame.origin.x+button.frame.size.width-self.customBadgeConcurrent.frame.size.width/2+5, button.frame.origin.y-self.customBadgeConcurrent.frame.size.height/2+5, self.customBadgeConcurrent.frame.size.width, self.customBadgeConcurrent.frame.size.height)];
                
                [cellAdmin addSubview:self.customBadgeConcurrent];
            }
            else
            {
                self.customBadgeConcurrent = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%i", v_nbConcurrent ]
                                                                withStringColor:[UIColor whiteColor]
                                                                 withInsetColor:[UIColor colorWithRed:0.3 green:1 blue:0.3 alpha:0.7]
                                                                 withBadgeFrame:YES
                                                            withBadgeFrameColor:[UIColor whiteColor]
                                                                      withScale:0.75
                                                                    withShining:YES];
                UIButton* button = cellAdmin.ConcurrenceUIButton;
                [self.customBadgeConcurrent setFrame:CGRectMake(button.frame.origin.x+button.frame.size.width-self.customBadgeConcurrent.frame.size.width/2+5, button.frame.origin.y-self.customBadgeConcurrent.frame.size.height/2+5, self.customBadgeConcurrent.frame.size.width, self.customBadgeConcurrent.frame.size.height)];
                
                [cellAdmin addSubview:self.customBadgeConcurrent];
            }
            
            /////
            return  cellAdmin;
            
        }
        else if (indexPath.section==3)
        {
            PEG_DtlAdresseCell* cellDtl = (PEG_DtlAdresseCell *) [tableView dequeueReusableCellWithIdentifier:@"cellAdresseLieu"];
            cellDtl.IdLieu = [self.BeanLieu.idLieu intValue];
            cellDtl.DtlLieuUITableView = self.DtlLieuUITableView;   // pm_06 there was a dead lock here as DtlLieuUITableView was strong !
            
            cellDtl.AdresseUILabel.text=[NSString stringWithFormat:@"%@",[[PEG_FMobilitePegase CreateLieu] GetAdresseComplete:self.BeanLieu]];
            if([self.BeanLieu.coordXpda intValue]==0 && [self.BeanLieu.coordYpda intValue]==0)
            {
                cellDtl.DistanceUILabel.text=@"? m";
            }
            else
            {
                PEG_BeanPoint* v_PointLieu = [[PEG_BeanPoint alloc] init];
                [v_PointLieu initWithLong:self.BeanLieu.coordXpda AndLat:self.BeanLieu.coordYpda];
                NSNumber* v_distance=[[PEG_FMobilitePegase CreateLieu] GetDistanceMetreEntreDeuxPoint1:v_PointLieu AndPoint2:[PEG_FTechnical GetCoordActuel]];
                if([v_distance intValue] < 9000)
                {
                    cellDtl.DistanceUILabel.text=[NSString stringWithFormat:@"%i m",[v_distance intValue]];
                }
                else
                {
                    cellDtl.DistanceUILabel.text=[NSString stringWithFormat:@"%i km",([v_distance intValue] / 1000)];
                }
            }
           
            /* [cellDtl.imgUIImageView setFrame:CGRectMake(0, 0, 24, 24)];
             
             [cellDtl.imgUIImageView setImage:[UIImage imageNamed:@"1369316723_pen_alt_stroke.png"]];
             */
            if(![[PEG_FMobilitePegase CreateLieu] isLieuActif:_BeanLieu.idLieu]){
                cellDtl.backgroundColor=[[UIColor alloc ]initWithRed:0 green:0 blue:0 alpha:0.4];
                [cellDtl setUserInteractionEnabled:NO];
            }
            else
            {
                cellDtl.backgroundColor=[[UIColor alloc ]initWithRed:1 green:1 blue:1 alpha:1];
                [cellDtl setUserInteractionEnabled:YES];
            }
            
            [self.customBadgeAdresse removeFromSuperview];
            self.customBadgeAdresse = nil;
            ///// Badge
            if([[PEG_FMobilitePegase CreateActionPresentoir] IsLieuCoordonneeByIdLieu:self.BeanLieu.idLieu] || ([self.BeanLieu.coordXpda intValue]!=0 && [self.BeanLieu.coordYpda intValue]!=0))
            {
                self.customBadgeAdresse = [CustomBadge customBadgeWithString:@"v"
                                                             withStringColor:[UIColor whiteColor]
                                                              withInsetColor:[UIColor colorWithRed:0.3 green:1 blue:0.3 alpha:0.7]
                                                              withBadgeFrame:YES
                                                         withBadgeFrameColor:[UIColor whiteColor]
                                                                   withScale:0.75
                                                                 withShining:YES];
                UIButton* button = cellDtl.CoordUIButton;
                [self.customBadgeAdresse setFrame:CGRectMake(button.frame.origin.x+button.frame.size.width-self.customBadgeAdresse.frame.size.width/2+BADGE_OFFET_X, button.frame.origin.y-self.customBadgeAdresse.frame.size.height/2, self.customBadgeAdresse.frame.size.width, self.customBadgeAdresse.frame.size.height)];
                
                [cellDtl addSubview:self.customBadgeAdresse];
                ////////
            }else{
                if([self.BeanLieu.coordXpda intValue]==0 && [self.BeanLieu.coordYpda intValue]==0){
                    self.customBadgeAdresse = [CustomBadge customBadgeWithString:@"!"
                                                                 withStringColor:[UIColor whiteColor]
                                                                  withInsetColor:[UIColor redColor]
                                                                  withBadgeFrame:YES
                                                             withBadgeFrameColor:[UIColor whiteColor]
                                                                       withScale:0.75
                                                                     withShining:YES];
                    UIButton* button = cellDtl.CoordUIButton;
                    [self.customBadgeAdresse setFrame:CGRectMake(button.frame.origin.x+button.frame.size.width-self.customBadgeAdresse.frame.size.width/2+BADGE_OFFET_X, button.frame.origin.y-self.customBadgeAdresse.frame.size.height/2, self.customBadgeAdresse.frame.size.width, self.customBadgeAdresse.frame.size.height)];
                    
                    [cellDtl addSubview:self.customBadgeAdresse];
                }
            }
            
            return cellDtl;
            
        }
        
        return cell;
    }
    @catch(NSException* p_exception){
        [[PEGException sharedInstance] ManageExceptionWithoutThrow:p_exception andMessage:@"Erreur dans PEG_DtlLieuxViewController tableView" andExparams:@""];
    }
    
}


#pragma mark Segue
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"pushDetailAdministratif"])
    {
        [[PEG_FMobilitePegase CreateGoogleAnalytics] sendEventWithCategory:@"DtlLieu" andAction:@"Administratif"];
        [((PEG_DtlAdresseLieuViewController*)[segue destinationViewController]) setDetailItem:self.BeanLieu.idLieu];
    }
    if([[segue identifier] isEqualToString:@"PushDetailPresentoir"])
    {
        [[PEG_FMobilitePegase CreateGoogleAnalytics] sendEventWithCategory:@"DtlLieu" andAction:@"DetailPresentoir"];
        ///NSArray *array = [NSArray arrayWithArray:[self.BeanLieu.listPresentoir allObjects]];
        NSArray *array = [NSArray arrayWithArray:self.ListPresentoirParution];
        // BeanPresentoir* v_Presentoir = ((BeanPresentoir*)[array objectAtIndex:self.IndexPresentoirSelected ]);
        //BeanPresentoir* v_Presentoir = ((BeanPresentoir*)[array objectAtIndex:[self.DtlLieuUITableView indexPathForSelectedRow].row]);
        PEG_BeanPresentoirParution* v_PresentoirParution = ((PEG_BeanPresentoirParution*)[array objectAtIndex:[self.DtlLieuUITableView indexPathForSelectedRow].row]);
        BeanPresentoir* v_Presentoir = v_PresentoirParution.Presentoir;
        
        //PEG_BeanPresentoir* v_Presentoir = ((PEG_BeanPresentoir*)[self.BeanLieu.listPresentoir objectAtIndex:self.IndexPresentoirSelected ]);
        PEGPresentoirTabbarViewController* v_PEG_DtlPresentoirViewController=((PEGPresentoirTabbarViewController*)[segue destinationViewController]);
        [v_PEG_DtlPresentoirViewController setDetailItem:v_Presentoir.id andIdParution:v_PresentoirParution.Parution.id];
        
        //On selectionne le presentoir sur lequel on va pour être correctement positionné au retour
        self.IndexPresentoirSelected = [self.DtlLieuUITableView indexPathForSelectedRow].row;
    }
    if([[segue identifier] isEqualToString:@"PushConcurrence"])
    {
        [[PEG_FMobilitePegase CreateGoogleAnalytics] sendEventWithCategory:@"DtlLieu" andAction:@"Concurence"];
        
        PEG_ConcurrentViewController* v_Concurrence =((PEG_ConcurrentViewController*)[segue destinationViewController]);
        [v_Concurrence setDetailItem:self.BeanLieu.idLieu];
    }
    
    if([[segue identifier] isEqualToString:@"PushMapItineraire"])
    {
        [[PEG_FMobilitePegase CreateGoogleAnalytics] sendEventWithCategory:@"DtlLieu" andAction:@"Itineraire"];
        
        PEG_MapCartoViewController* v_Map=((PEG_MapCartoViewController*)[segue destinationViewController]);
        [v_Map setDetailItem:self.BeanLieu.idLieu];
    }
}


- (void)showPickerNewPresentoir
{
    static BOOL presenting = NO;	// pm201402 eviter superposition picker sur double clic
	if (presenting) return;
	presenting = YES;
	
    PEG_PickerViewController *pickerController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"PEG_PickerViewController"];
    
    SPIROrderedDictionary *values2 = [[SPIROrderedDictionary alloc] init];
    NSArray* v_listeChoix=[[PEG_FMobilitePegase CreateListeChoix] GetListBeanChoixTypePresentoir];
    for (BeanChoix* v_RowChoix in  v_listeChoix){
        [values2 setValue:v_RowChoix.code forKey:v_RowChoix.code];
    }
    
    NSArray* v_array = [[NSArray alloc] initWithObjects:values2, nil];
    NSArray* v_arrayValueSelected = [[NSArray alloc]initWithObjects:[values2 keyAtIndex:0],nil];
    
    [pickerController initWithListValue:v_array andListValueSelected:v_arrayValueSelected andNbColonnesToSee:1];
    pickerController.listLargueurColonne = [[NSArray alloc] initWithObjects:[[NSNumber alloc] initWithInt: 250], nil];
    
    
    [pickerController setDelegate:self];
    
    [self addChildViewController:pickerController];
    
    CGRect frame = pickerController.view.frame;
    
    frame.origin = CGPointMake(.0, self.view.frame.size.height);
    
    pickerController.view.frame = frame;
    
    [self.view addSubview:pickerController.view];
    
    [pickerController didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear
     
                     animations:^{
                         pickerController.view.frame = CGRectMake(.0, .0, pickerController.view.frame.size.width, self.view.frame.size.height);
                     }
     
                     completion:^(BOOL finished) {
						 presenting = NO;
                         //                             [pickerController.view removeFromSuperview];
                         //
                         //                             [pickerController willMoveToParentViewController:self];
                         //
                         //                             [pickerController removeFromParentViewController];
                         
                         
                     }
     
     ];
    
    
}





-(void) formPicker:(PEG_PickerViewController *)_formPicker didChoose:(NSMutableArray *)value
{
    
    PEG_PickerViewController *pickerController = [self.childViewControllers objectAtIndex:0];
    [UIView animateWithDuration:.3
     
                          delay:.0
     
                        options:UIViewAnimationOptionCurveLinear
     
                     animations:^{
                         
                         pickerController.view.frame = CGRectMake(.0, self.view.frame.size.height, pickerController.view.frame.size.width, pickerController.view.frame.size.height);
                         
                     }
     
                     completion:^(BOOL finished) {
                         
                         [pickerController.view removeFromSuperview];
                         
                         [pickerController willMoveToParentViewController:self];
                         
                         [pickerController removeFromParentViewController];
                         
                         
                     }];
    if(value.count>0){
        
        SPIROrderedDictionary* v_dict = (SPIROrderedDictionary*)[pickerController.listAllValues objectAtIndex:0];
        NSNumber* v_indexSelected=((NSNumber*)[pickerController.listIndexSelectedRow objectAtIndex:0]);
        
        NSString* v_Code= (NSString*)[v_dict keyAtIndex:[v_indexSelected intValue]];
        
        BeanPresentoir* v_BeanPresentoir= [[PEG_FMobilitePegase CreatePresentoir] CreateBeanPresentoirOnLieu:self.BeanLieu andType:v_Code];

        [self.DtlLieuUITableView reloadData];
        
        //[[PEG_FMobilitePegase CreateActionPresentoir] AddLieuVisiteByIdLieu:self.BeanLieu.idLieu];

        
        PEG_ActionReplaceViewController *ActionReplaceViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"PEG_ActionReplaceViewController"];
        [ActionReplaceViewController setDetailItemForCreation:v_BeanPresentoir.idPointDistribution  IsFromVole:NO];
        
        [[PEG_FMobilitePegase CreateGoogleAnalytics] sendEventWithCategory:@"DtlLieu" andAction:@"CreationPresentoir"];
        
        [self.navigationController pushViewController:ActionReplaceViewController animated:YES];
        
    }
    
}

- (void)showPickerActionMinute
{
    static BOOL presenting = NO;	// pm201402 eviter superposition picker sur double clic
	if (presenting) return;
	presenting = YES;
	
    PEG_ActionMinuteViewController *pickerController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"PEG_ActionMinuteViewController"];
    
    NSArray *array = [NSArray arrayWithArray:self.ListPresentoirParution];
    pickerController._IdPresentoir=  ((PEG_BeanPresentoirParution*)[array objectAtIndex:self.IndexPresentoirSelected ]).Presentoir.id;
    //pickerController._IdPresentoir=  ((BeanPresentoir*)[self.BeanLieu.listPresentoir objectAtIndex:self.IndexPresentoirSelected ]).id;
    
    [self addChildViewController:pickerController];
    
    CGRect frame = pickerController.view.frame;
    
    frame.origin = CGPointMake(.0, self.view.frame.size.height);
    
    pickerController.view.frame = frame;
    
    [self.view addSubview:pickerController.view];
    
    [pickerController didMoveToParentViewController:self];
    
    [pickerController setDelegate:self];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear
     
                     animations:^{
                         pickerController.view.frame = CGRectMake(.0, .0, pickerController.view.frame.size.width, self.view.frame.size.height);
                     }
     
                     completion:^(BOOL finished) {
						 presenting = NO;
                       
                         //                             [pickerController.view removeFromSuperview];
                         //
                         //                             [pickerController willMoveToParentViewController:self];
                         //
                         //                             [pickerController removeFromParentViewController];
                         
                         
                     }
     
     ];
    
    
}

// pm201402 define delegate protocole to avoid warning
// pm140218 check that !
- (void)formActionMinuteFinished:(PEG_ActionMinuteViewController *)_formActionMinute{
    
    
    [UIView animateWithDuration:.3
     
                          delay:.0
     
                        options:UIViewAnimationOptionCurveLinear
     
                     animations:^{
                         
                         _formActionMinute.view.frame = CGRectMake(.0, self.view.frame.size.height, _formActionMinute.view.frame.size.width, _formActionMinute.view.frame.size.height);
                         
                     }
     
                     completion:^(BOOL finished) {
                         
                         [_formActionMinute.view removeFromSuperview];
                         
                         [_formActionMinute willMoveToParentViewController:self];
                         
                         [_formActionMinute removeFromParentViewController];
                         
                         
                     }];
    
    [self.DtlLieuUITableView reloadData];
}

#pragma mark - IBAction (User Event)


- (IBAction)ActionMinute_TouchUpInside:(id)sender
{
    if(self.ListPresentoirParution.count > 0)
    {
        [[PEG_FMobilitePegase CreateGoogleAnalytics] sendEventWithCategory:@"DtlLieu" andAction:@"ActionMinute"];
        [self showPickerActionMinute];
    }
}

- (IBAction)AjoutPresentoir_TouchUpInside:(id)sender {
    [self showPickerNewPresentoir];
}

- (IBAction)Audit_TouchUpInside:(id)sender {
}

- (IBAction)Relationnel_TouchUpInside:(id)sender {
    
    static BOOL presenting = NO;	// pm201402 eviter superposition picker sur double clic
	if (presenting) return;
	presenting = YES;

    [[PEG_FMobilitePegase CreateGoogleAnalytics] sendEventWithCategory:@"DtlLieu" andAction:@"Relationnel"];
    
    PEG_ListRelationnelViewController *pickerController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"PEG_ListRelationnelViewController"];
    
    pickerController.BeanLieu= self.BeanLieu;
    
    [self addChildViewController:pickerController];
    
    CGRect frame = pickerController.view.frame;
    
    frame.origin = CGPointMake(.0, self.view.frame.size.height);
    
    pickerController.view.frame = frame;
    
    [self.view addSubview:pickerController.view];
    
    [pickerController didMoveToParentViewController:self];
    
    [pickerController setDelegate:self];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear
     
                     animations:^{
                         pickerController.view.frame = CGRectMake(.0, .0, pickerController.view.frame.size.width, self.view.frame.size.height);
                     }
     
                     completion:^(BOOL finished) {
						 presenting = NO;

                         //                             [pickerController.view removeFromSuperview];
                         //
                         //                             [pickerController willMoveToParentViewController:self];
                         //
                         //                             [pickerController removeFromParentViewController];
                         
                         
                     }
     
     ];
    
    
}

- (IBAction)Concurence_TouchUpInside:(id)sender {
}


- (IBAction)CheckPresentoir_TouchUpInside:(id)sender
{
    UIButton* btn = (UIButton *) sender;
    self.IndexPresentoirSelected = btn.tag;
    //self.IndexPresentoirSelected = [self.TableView cellForRowAtIndexPath:[self.TableView indexPathForSelectedRow]].;
    [self.DtlLieuUITableView reloadData];
}


-(void) fillFinishedGetBeanImage
{
    //[self.hud hide:YES];
    //    PEG_DtlLieuCell* cell = (PEG_DtlLieuCell *) [self.DtlLieuUITableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //    [cell.HudPhoto stopAnimating];
    //    [cell.HudPhoto setHidden:YES];
    
    [self.DtlLieuUITableView reloadData];
    
    
}

-(void) finishedWithErrorGetBeanImage
{
    //[self.hud hide:YES];
    //    PEG_DtlLieuCell* cell = (PEG_DtlLieuCell *) [self.DtlLieuUITableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //    [cell.HudPhoto stopAnimating];
    //    [cell.HudPhoto setHidden:YES];
}

- (void)formListRelationnelFinished:(PEG_ListRelationnelViewController *)_formListRelationnel{
    
    [UIView animateWithDuration:.3
     
                          delay:.0
     
                        options:UIViewAnimationOptionCurveLinear
     
                     animations:^{
                         
                         _formListRelationnel.view.frame = CGRectMake(.0, self.view.frame.size.height, _formListRelationnel.view.frame.size.width, _formListRelationnel.view.frame.size.height);
                         
                     }
     
                     completion:^(BOOL finished) {
                         
                         [_formListRelationnel.view removeFromSuperview];
                         
                         [_formListRelationnel willMoveToParentViewController:self];
                         
                         [_formListRelationnel removeFromParentViewController];
                         
                         
                     }];
    
    [self.DtlLieuUITableView reloadData];
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;
{
    return YES;
}

#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
// pm_06 un peu simplifié pour trouver un leak mémoire…
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
   
    [self dismissViewControllerAnimated:YES completion:NULL];

    if (image) {
        
        PEG_BeanPresentoirParution* v_PresentoirParution = ((PEG_BeanPresentoirParution*)[self.ListPresentoirParution objectAtIndex:self.IndexPresentoirSelected]);
        BeanPresentoir* v_Presentoir = v_PresentoirParution.Presentoir;
        
        PEG_ImageServices * imageService = [PEG_FMobilitePegase CreateImage];
        [imageService SavePictureInfile:image ById:v_Presentoir.id ];
        
        //Id presentoir car photo sur le presentoir actif pas le point de distri supprimé
        NSString* nomImage=[NSString stringWithFormat:@"%@.jpg",v_Presentoir.id];
        [[PEG_FMobilitePegase CreateActionPresentoir] AddOrUpdatePresentoirPhoto:v_Presentoir.id andNomPhoto:nomImage andFait:YES];
        
        self.ImageCourante.Image = image;
        
        [[PEG_FMobilitePegase CreateGoogleAnalytics] sendEventWithCategory:@"DtlLieu" andAction:@"PrisePhoto"];
        
        [self.DtlLieuUITableView reloadData];
    }
}




- (IBAction)showImagePickerFromCamera:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])    // pm_06: commenter cette ligne pour test simulateur avec photo existantes
    {
        //On ne peut prendre une photo que s'il y a au moins un presentoir
        if(self.ListPresentoirParution.count > 0)
        {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.delegate = self;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  
                                  initWithTitle:@"Présentoir"
                                  message:@"Aucun présentoir pour la prise de photo."
                                  delegate:self
                                  cancelButtonTitle:@"Quitter"
                                  otherButtonTitles:nil];
            
            [alert show];
        }
    }
}



#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
{
    BOOL shouldReceiveTouch = YES;
    
    if (gestureRecognizer == self.tap) {
        PEG_DtlLieuCell* cell = (PEG_DtlLieuCell *) [self.DtlLieuUITableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        shouldReceiveTouch = (touch.view == cell.imgUIImageView);
    }
    
    return shouldReceiveTouch;
}

-(void)imgToFullScreen:(id)sender {
    
    if(self.ImageCourante.Image!=nil){
        PEG_ImageViewController *viewController = (PEG_ImageViewController*)[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"PEG_ImageViewController"];
        viewController.modalTransitionStyle= UIModalTransitionStyleCrossDissolve;
        [viewController SetDetailItem:self.ImageCourante];
        [[PEG_FMobilitePegase CreateGoogleAnalytics] sendEventWithCategory:@"DtlLieu" andAction:@"imgToFullScreen"];
        [self presentModalViewController:viewController animated:YES];
    }
    
    
    //
    //    PEG_DtlLieuCell* cell = (PEG_DtlLieuCell *) [self.DtlLieuUITableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //    if (!self.isFullScreen) {
    //        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
    //            //save previous frame
    //            self.prevFrame = cell.imgUIImageView.frame;
    //            [cell.imgUIImageView setFrame:[[UIScreen mainScreen] bounds]];
    //        }completion:^(BOOL finished){
    //            self.isFullScreen = true;
    //        }];
    //        return;
    //    }
    //    else{
    //        [UIView animateWithDuration:0.5 delay:0 options:0 animations:^{
    //            [cell.imgUIImageView setFrame:self.prevFrame];
    //        }completion:^(BOOL finished){
    //            self.isFullScreen = false;;
    //        }];
    //        return;
    //    }
}
@end
