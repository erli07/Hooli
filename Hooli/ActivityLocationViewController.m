//
//  ActivityLocationViewController.m
//  Hooli
//
//  Created by Er Li on 3/13/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "ActivityLocationViewController.h"
#import "LocationManager.h"
#import "LocationPinAnnotation.h"
#import "MBProgressHUD.h"
@interface ActivityLocationViewController ()<MKMapViewDelegate>
@property (nonatomic, assign) MKCoordinateRegion boundingRegion;
@property (nonatomic) CLLocationCoordinate2D userLocation;
@property (nonatomic) LocationPinAnnotation *annotation;
@property (nonatomic) CLLocation *eventLocation;



@end

@implementation ActivityLocationViewController
@synthesize mapView = _mapView;
@synthesize boundingRegion = _boundingRegion;
@synthesize userLocation = _userLocation;
@synthesize searchBar = _searchBar;
@synthesize annotation = _annotation;
@synthesize eventLocation = _eventLocation;
@synthesize eventLocationText = _eventLocationText;
@synthesize showSearchBar = _showSearchBar;
@synthesize eventGeopoint = _eventGeopoint;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    _mapView.delegate = self;
    
    _searchBar.delegate = self;
    
    [self updateMapViewWithCoordinate:[[LocationManager sharedInstance]currentLocation]];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEventOccured:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    if(!_showSearchBar){
        
        _searchBar.hidden = YES;
    }
    else{
        
        _searchBar.hidden = NO;
        
    }
    
    if(_eventGeopoint){
                
        [self dropPinOnMap: CLLocationCoordinate2DMake(_eventGeopoint.latitude, _eventGeopoint.longitude)];
        
    }
    
    if(_eventLocationText){
        
        _searchBar.text = _eventLocationText;
    }

}

-(void)viewWillDisappear:(BOOL)animated{
    
   
    
}

-(void)tapEventOccured:(id)sender{
    
    [_searchBar resignFirstResponder];
    
}

-(void)updateMapViewWithCoordinate:(CLLocationCoordinate2D)location{
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = location.latitude;
    newRegion.center.longitude = location.longitude;
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    [self.mapView setRegion:newRegion];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
    
    [_searchBar resignFirstResponder];

    [self convertAddressToCoordinate:searchBar.text block:^(CLLocationCoordinate2D coordinate, NSError *error) {
        
        if(!error){
            
            _eventLocationText = searchBar.text;
            
            [self.delegate didSelectEventLocation:_eventLocation locationString:_eventLocationText];

            [self dropPinOnMap:coordinate];
            
            _eventLocation = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
            
        }
        else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can not load location" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        
    }];
    
}


-(void)dropPinOnMap:(CLLocationCoordinate2D)coordinate{
    
    [self updateMapViewWithCoordinate:coordinate];
    
    _annotation = [[LocationPinAnnotation alloc]initWithCoords:coordinate];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.mapView addAnnotations:@[_annotation]];
        
        [self.mapView selectAnnotation:_annotation animated:YES];
        
    });
    
    
}
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *kAnnotationIdentifier = @"kAnnotationIdentifier";
    
    LocationPinAnnotation *pView = (LocationPinAnnotation *)
    [self.mapView dequeueReusableAnnotationViewWithIdentifier:kAnnotationIdentifier];
    
    if (pView)
    {
        
        [self.mapView removeAnnotation:pView];
        // if an existing pin view was not available, create one
        LocationPinAnnotation *cPinView = [[LocationPinAnnotation alloc]
                                           initWithAnnotation:annotation reuseIdentifier:kAnnotationIdentifier];
        cPinView.pinColor = MKPinAnnotationColorRed;
        cPinView.animatesDrop = YES;
        [cPinView setTitle:_searchBar.text];
        
        return cPinView;
    }
    else{
        
        LocationPinAnnotation *cPinView = [[LocationPinAnnotation alloc]
                                           initWithAnnotation:annotation reuseIdentifier:kAnnotationIdentifier];
        cPinView.pinColor = MKPinAnnotationColorRed;
        cPinView.animatesDrop = YES;
        [cPinView setTitle:_searchBar.text];

        return cPinView;
    }
    
    return pView;
    
}
- (void) convertAddressToCoordinate:(NSString *)address block:(void (^)(CLLocationCoordinate2D coordinate, NSError *error))completionBlock
{
    CLLocationCoordinate2D center;
    
    double latitude = 0;
    double longitude = 0;
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    // NSLog(@"%@",req);
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    // NSLog(@"result %@",result);
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    center.latitude = latitude;
    center.longitude = longitude;
    
    completionBlock(center,nil);
    
    [MBProgressHUD hideHUDForView:self.view.superview animated:YES];

        
    
}

@end
