//
//  Annotation.m
// My World for iPad version 1.2
//


#import "Annotation.h"


@implementation Annotation
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;


- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate_ addressDictionary:(NSDictionary *)addressDictionary {
	
	if ((self = [super initWithCoordinate:coordinate addressDictionary:addressDictionary])) {
		self.coordinate = coordinate_;
	}
	return self;
}

-(CLLocationCoordinate2D)coord
{
    return coordinate;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate;
}



@end
