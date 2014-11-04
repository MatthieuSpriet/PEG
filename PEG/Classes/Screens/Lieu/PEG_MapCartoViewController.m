//
//  PEG_MapCartoViewController.m
//  PEG
//
//  Created by 10_200_11_120 on 29/10/13.
//  Copyright (c) 2013 spir. All rights reserved.
//

#import "PEG_MapCartoViewController.h"
#import "PEG_MapAnnotation.h"
#import "BeanLieu.h"
#import "PEG_FMobilitePegase.h"
#import "BeanPresentoir.h"

@interface PEG_MapCartoViewController ()
@property (nonatomic,strong) BeanLieu* BeanLieu;
@end

@implementation PEG_MapCartoViewController



@synthesize mapView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) setDetailItem:(NSNumber*)p_IdLieu
{
    self.BeanLieu = [[PEG_FMobilitePegase CreateLieu] GetBeanLieuById:p_IdLieu];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    CLLocationCoordinate2D location;
    
	location.latitude = [self.BeanLieu.coordYpda floatValue];
	location.longitude = [self.BeanLieu.coordXpda floatValue];
    
    NSString* v_List=@"";
    int i=0;
    for(BeanPresentoir* v_beanpresentoir in self.BeanLieu.listPresentoir) {
        if(i==0){
            v_List=v_beanpresentoir.tYPE;
        }else{
			v_List=[NSString stringWithFormat:@"%@, %@",v_List,v_beanpresentoir.tYPE];
        }
		i++;
    }
    
	// Add the annotation to our map view
	PEG_MapAnnotation *newAnnotation = [[PEG_MapAnnotation alloc] initWithTitle:self.BeanLieu.liNomLieu andSubtitle:[NSString stringWithFormat:@"%@  -  %@",self.BeanLieu.ville,v_List] andCoordinate:location];
	[self.mapView addAnnotation:newAnnotation];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([newAnnotation coordinate], 1000, 1000);
    [self.mapView setRegion:region animated:YES];
	[self.mapView selectAnnotation:newAnnotation animated:YES];
	
	[self.mapView setShowsUserLocation:YES];
}


// When a map annotation point is added, zoom to it (1500 range)
// pm201402 here we can have pin annotations: MKPinAnnotationView (that's ok), but also user location (MKModernUserLocationView)
#pragma mark - MKMapViewDelegate protocol
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
	// pm201402 ce code n'était pas appelé (delegate pas en place dans le storyboard)
	// attention, on a 2 annotations sur la carte, celle qu'on a crée et la position de l'utilisateur.
	// [views objectAtIndex:0] est donc aléatoire !
	return;
		
// 	MKAnnotationView *annotationView = [views objectAtIndex:0];
// 	id <MKAnnotation> mp = [annotationView annotation];
// 	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 1000, 1000);
// 	[mv setRegion:region animated:YES];
// 	[mv selectAnnotation:mp animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)itineraireClick:(id)sender {
    CLLocationCoordinate2D location;
    
	location.latitude = [self.BeanLieu.coordYpda floatValue];
	location.longitude = [self.BeanLieu.coordXpda floatValue];
    MKPlacemark* place = [[MKPlacemark alloc] initWithCoordinate: location addressDictionary: nil];
    MKMapItem* destination = [[MKMapItem alloc] initWithPlacemark: place];
    destination.name = self.BeanLieu.liNomLieu;
    NSArray* items = [[NSArray alloc] initWithObjects: destination, nil];
    NSDictionary* options = [[NSDictionary alloc] initWithObjectsAndKeys:
                             MKLaunchOptionsDirectionsModeDriving,
                             MKLaunchOptionsDirectionsModeKey, nil];
    [MKMapItem openMapsWithItems: items launchOptions: options];
}


@end
