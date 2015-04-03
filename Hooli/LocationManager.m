//
//  LocationManager.m
//  Hooli
//
//  Created by Er Li on 10/27/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "LocationManager.h"
#import <Parse/Parse.h>
@interface LocationManager ()
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geoCoder;
@end

@implementation LocationManager
@synthesize currentLocation,geoCoder,convertedAddress;
+(LocationManager *)sharedInstance{
    
    static LocationManager *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LocationManager alloc] init];
    });
    return _sharedInstance;

    
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

-(void)stopLocationUpdate{
    
    if(self.locationManager){
        
        [self.locationManager stopUpdatingLocation];
        
    }
    
}

-(NSString *)getApproximateDistance:(CLLocationCoordinate2D)offerLocation{
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:self.currentLocation.latitude longitude:self.currentLocation.longitude];
    
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:offerLocation.latitude longitude:offerLocation.longitude];
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    
    if(distance > 50000)
        return @"> 50 mi.";
    else if(distance > 10000)
        return @"< 50 mi.";
    else if(distance > 5000)
        return @"< 10 mi.";
    else if(distance > 2000)
        return @"< 5 mi.";
    else if(distance > 1000)
        return @"< 2 mi.";
    else
        return @"< 1 mi.";
}

-(NSString *)getApproximateDistanceInKm:(CLLocationCoordinate2D)offerLocation{
    
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:self.currentLocation.latitude longitude:self.currentLocation.longitude];
    
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:offerLocation.latitude longitude:offerLocation.longitude];
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
        
    NSString *distanceStr = [NSString stringWithFormat:@"%.2f km", distance/1000];

    return distanceStr;
}

-(PFGeoPoint *)getCurrentLocationGeoPoint{
    
    PFGeoPoint *geoPoint = [[PFGeoPoint alloc]init];
    geoPoint.latitude = self.currentLocation.latitude;
    geoPoint.longitude = self.currentLocation.longitude;
    
    return geoPoint;
}

- (void)convertGeopointToAddress
{
   // __block NSString *returnAddress = @"";
    
    self.geoCoder = [[CLGeocoder alloc]init];

    [self.geoCoder reverseGeocodeLocation:self.locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(error){
            
            NSLog(@"%@", [error localizedDescription]);
            
        }
        CLPlacemark *placemark = [placemarks lastObject];
        
//        NSString *startAddressString = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
//                              placemark.subThoroughfare, placemark.thoroughfare,
//                              placemark.postalCode, placemark.locality,
//                              placemark.administrativeArea,
//                              placemark.country];
        
        NSString *startAddressString = [NSString stringWithFormat:@"%@ %@ %@",
                                        placemark.locality, placemark.administrativeArea,
                                        placemark.postalCode];
        
        self.convertedAddress = startAddressString;
        
        //NSLog(@"Get address %@",startAddressString);
        
        // call a method to execute the rest of the logic
    }];
}

-(void)convertGeopointToAddressWithGeoPoint:(CLLocationCoordinate2D)locationCoord
                                      block:(void (^)(NSString *, NSError *))completionBlock{
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:locationCoord.latitude longitude:locationCoord.longitude];
    
    self.geoCoder = [[CLGeocoder alloc]init];
    
    [self.geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(error){
            
            NSLog(@"%@", [error localizedDescription]);
            
        }
        
        CLPlacemark *placemark = [placemarks lastObject];

        NSString *startAddressString = [NSString stringWithFormat:@"%@ %@",
                                        placemark.locality, placemark.administrativeArea];
        
        if(!placemark.locality || !placemark.administrativeArea){
            
            startAddressString = nil;
            
        }
        
        
        if(completionBlock){
            
            completionBlock(startAddressString, nil);

        }
        
    }];

    
    
}

#pragma mark - CLLocationManagerDelegate methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *newLocation = [locations lastObject];
    
    self.currentLocation = newLocation.coordinate;
    
    [self convertGeopointToAddress];
    
   // [self stopLocationUpdate];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // report any errors returned back from Location Services
}

@end
