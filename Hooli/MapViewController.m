//
//  MapViewController.m
//  Hooli
//
//  Created by Er Li on 10/26/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "MapViewController.h"
#import "MBProgressHUD.h"
@interface MapViewController ()<MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D userLocation;
@property (nonatomic, assign) MKCoordinateRegion boundingRegion;
@property (nonatomic, strong) NSArray *mapItemList;
@end

@implementation MapViewController


@synthesize boundingRegion,mapView,mapItemList;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView.delegate = self;
  

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
     [self.navigationController setNavigationBarHidden:YES];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    self.view.alpha = 0.2;
    [self startLocationUpdate];
    [self UpdateMapView];
    
}

-(void)startLocationUpdate{
    
    if (nil == self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
        
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    //    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    //    self.locationManager.distanceFilter = 500; // meters
    
    [self.locationManager startUpdatingLocation];
}

-(void)configureRegionAndMapItemList{
    
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = self.userLocation.latitude;
    newRegion.center.longitude = self.userLocation.longitude;
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    MKMapItem *mapItem = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:self.userLocation addressDictionary:nil]];
    mapItem.name = @"Test";
    
    self.mapItemList = [[NSArray alloc]initWithObjects:mapItem, nil];
    self.boundingRegion = newRegion;
    
}

-(void)UpdateMapView{
    
    
    [self configureRegionAndMapItemList];
    
    [self.mapView setRegion:self.boundingRegion];
    
    
}
#pragma mark - CLLocationManagerDelegate methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *newLocation = [locations lastObject];
    
    self.userLocation = newLocation.coordinate;
    
    [self UpdateMapView];
    
    [manager stopUpdatingLocation]; // we only want one update
    
    manager.delegate = nil;
    [HUD hide:YES];
    self.view.alpha = 1.0;
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // report any errors returned back from Location Services
}

@end
