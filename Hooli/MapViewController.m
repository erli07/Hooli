//
//  MapViewController.m
//  Hooli
//
//  Created by Er Li on 10/26/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "MapViewController.h"
#import "MBProgressHUD.h"
#import "LocationManager.h"

#define circleDistance 1000
@interface MapViewController ()<MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D userLocation;
@property (nonatomic, assign) MKCoordinateRegion boundingRegion;
@end

@implementation MapViewController


@synthesize boundingRegion,mapView,offerLocation;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
//    [[LocationManager sharedInstance]startLocationUpdate];
  //  self.userLocation = [[LocationManager sharedInstance]currentLocation];
    [self updateMapView];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
     [self.navigationController setNavigationBarHidden:NO];
//    
//    HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    HUD.delegate = self;
//   [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];//    self.view.alpha = 0.2;
//    [self startLocationUpdate];
//    [self updateMapView];
    
}

-(void)drawLocationCircle{
    
    CLLocationDistance fenceDistance = circleDistance;
    CLLocationCoordinate2D circleMiddlePoint = CLLocationCoordinate2DMake(self.offerLocation.latitude, self.offerLocation.longitude);
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:circleMiddlePoint radius:fenceDistance];
    [self.mapView addOverlay: circle];
}

-(void)configureRegionAndMapItemList{
    
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = self.offerLocation.latitude;
    newRegion.center.longitude = self.offerLocation.longitude;
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    MKMapItem *mapItem = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:self.offerLocation addressDictionary:nil]];
    mapItem.name = @"Test";
    
    self.boundingRegion = newRegion;
    
    [self drawLocationCircle];
    
}

-(void)updateMapView{
    
    
    [self configureRegionAndMapItemList];
    
    [self.mapView setRegion:self.boundingRegion];
    
    
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay

{
    MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:(MKCircle *)overlay] ;
    circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    return circleView;
}
@end
