//
//  LocationPinAnnotation.h
//  Hooli
//
//  Created by Er Li on 3/14/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface LocationPinAnnotation : MKPinAnnotationView<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *subtitle;
    NSString *title;
    
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id) initWithCoords:(CLLocationCoordinate2D) coords;

@end
