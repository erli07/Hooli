//
//  LocationManager.m
//  Hooli
//
//  Created by Er Li on 10/27/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager ()
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation LocationManager
@synthesize currentLocation;
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

#pragma mark - CLLocationManagerDelegate methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    CLLocation *newLocation = [locations lastObject];
    
    self.currentLocation = newLocation.coordinate;
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // report any errors returned back from Location Services
}

@end
