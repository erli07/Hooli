//
//  Annotation.h
// My World for iPad version 1.2
//


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface Annotation : MKPlacemark {
	CLLocationCoordinate2D coordinate;
}
@property (nonatomic, readwrite, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) 	NSString *title;
@property (nonatomic, assign) 	NSString *subtitle;


- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
