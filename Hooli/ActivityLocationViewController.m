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
#import "HLTheme.h"
#import "Annotation.h"
#import "AnnotationView.h"

@interface ActivityLocationViewController ()<MKMapViewDelegate>
@property (nonatomic, assign) MKCoordinateRegion boundingRegion;
@property (nonatomic) CLLocationCoordinate2D userLocation;
@property (nonatomic) Annotation *annotation;
@property (nonatomic) CLLocation *eventLocation;
@property (nonatomic) CLGeocoder *geoCoder;
@property (nonatomic) NSString *address;
@property (nonatomic) AnnotationView *annotationView;
@property (assign) BOOL isPinned;

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
@synthesize geoCoder = _geoCoder;
@synthesize address = _address;
@synthesize annotationView  = _annotationView;
@synthesize isPinned = _isPinned;

static NSString * const kPinAnnotationIdentifier = @"PinIdentifier";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    self.title = @"Location";
    
    _mapView.delegate = self;
    
    _searchBar.delegate = self;
    
    _geoCoder = [[CLGeocoder alloc]init];
    
    _userLocation = [[LocationManager sharedInstance]currentLocation];
    
    [self updateMapViewWithCoordinate:self.userLocation];
    
    [self reverseCoordinateToAddress:_userLocation];
    
    if(_eventLocationText){
        
        _searchBar.text = _eventLocationText;
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    if(_eventGeopoint){
        
        CLLocationCoordinate2D eventLocation = CLLocationCoordinate2DMake(_eventGeopoint.latitude, _eventGeopoint.longitude);
        [self.mapView setCenterCoordinate:eventLocation animated:YES];
        if(!_isPinned){
            [self dropPinOnMap: eventLocation];
            [self reverseCoordinateToAddress:eventLocation];
        }
        
    }
    else {
        
        [self.mapView setCenterCoordinate:_userLocation animated:YES];
        if(!_isPinned){
            [self dropPinOnMap: _userLocation];
            [self reverseCoordinateToAddress:_userLocation];
        }
    }
    
    [self.mapView selectAnnotation:[[self.mapView annotations] lastObject] animated:YES];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [self.delegate didSelectLocation:_eventLocation locationString:_address];
    
    _isPinned = NO;
    
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
            
            [self dropPinOnMap:coordinate];
            
            _eventLocation = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
            
            [self.delegate didSelectLocation:_eventLocation locationString:_eventLocationText];
            
        }
        else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can not load location" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
        
    }];
    
}


-(void)dropPinOnMap:(CLLocationCoordinate2D)coordinate{
    
    [self updateMapViewWithCoordinate:coordinate];
    
    //  _annotation = [[LocationPinAnnotation alloc]initWithCoords:coordinate];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _annotation= [[Annotation alloc]initWithCoordinate:coordinate addressDictionary:nil];
        _annotation.title = @"Drag me to move";
        [self.mapView addAnnotation:_annotation];
        _isPinned = YES;
    });
    
    
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    // NSLog(@"Did change location");
    
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    
    //NSLog(@"Will change location");
    
}

#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    AnnotationView *pinView = (AnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
    
    if (pinView) {
        pinView.annotation = annotation;
    } else {
        pinView = [[AnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier];
    }
    
    if(!_eventGeopoint)
    pinView.draggable = YES;
    
    return pinView;
    
}


-(void)mapView:(MKMapView *)_mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
    if (newState == MKAnnotationViewDragStateEnding)
    {
        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
        [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
        [self reverseCoordinateToAddress:droppedAt];
    }
    
}


//- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    if ([annotation isKindOfClass:[MKUserLocation class]])
//        return nil;
//
//    static NSString *kAnnotationIdentifier = @"kAnnotationIdentifier";
//
//    LocationPinAnnotation *pView = (LocationPinAnnotation *)
//    [self.mapView dequeueReusableAnnotationViewWithIdentifier:kAnnotationIdentifier];
//
//    if (pView)
//    {
//
//        [self.mapView removeAnnotation:pView];
//        // if an existing pin view was not available, create one
//        LocationPinAnnotation *cPinView = [[LocationPinAnnotation alloc]
//                                           initWithAnnotation:annotation reuseIdentifier:kAnnotationIdentifier];
//        cPinView.pinColor = MKPinAnnotationColorRed;
//        cPinView.animatesDrop = YES;
//        cPinView.draggable = YES;
//
//       // [cPinView setTitle:_searchBar.text];
//
//        return cPinView;
//    }
//    else{
//
//        LocationPinAnnotation *cPinView = [[LocationPinAnnotation alloc]
//                                           initWithAnnotation:annotation reuseIdentifier:kAnnotationIdentifier];
//        cPinView.pinColor = MKPinAnnotationColorRed;
//        cPinView.animatesDrop = YES;
//        cPinView.draggable = YES;
//       // [cPinView setTitle:_searchBar.text];
//
//        return cPinView;
//    }
//
//    return pView;
//
//}
//
- (void)reverseCoordinateToAddress:(CLLocationCoordinate2D)coordinate
{
    __block NSString *returnAddress = @"";
    _eventLocation = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    [self.geoCoder reverseGeocodeLocation:_eventLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error){
            NSLog(@"%@", [error localizedDescription]);
        }
        
        CLPlacemark *placemark = [placemarks lastObject];
        
        NSString *startAddressString = [NSString stringWithFormat:@"%@ %@, %@, %@ %@",
                                        placemark.subThoroughfare,
                                        placemark.thoroughfare,
                                        placemark.locality,
                                        placemark.administrativeArea,
                                        placemark.postalCode];
        returnAddress = startAddressString;
        _address = returnAddress;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view.superview animated:YES];
            [self.infoTableView reloadData];
        });
        
    }];
    
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

#pragma mark UITableview delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kCellIdentifier = @"mapCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if(cell == nil){
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        
    }
    
    cell.textLabel.text = _address;
    [cell.textLabel setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
    cell.textLabel.textColor = [HLTheme mainColor];
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return  1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44;
}

@end
