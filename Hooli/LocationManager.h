//
//  LocationManager.h
//  Hooli
//
//  Created by Er Li on 10/27/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>
@interface LocationManager : NSObject<CLLocationManagerDelegate>
@property (nonatomic) CLLocationCoordinate2D currentLocation;
@property (nonatomic) NSString *convertedAddress;
+(LocationManager *)sharedInstance;
-(void)startLocationUpdate;
-(void)stopLocationUpdate;
-(PFGeoPoint *)getCurrentLocationGeoPoint;
-(NSString *)getApproximateDistance:(CLLocationCoordinate2D)offerLocation;
- (void)convertGeopointToAddress;
@end
