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
    NSString *subtitletext;
    NSString *titletext;
    
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSString *titletext;
@property (nonatomic) NSString *subtitletext;

- (id) initWithCoords:(CLLocationCoordinate2D) coords;
- (NSString *)subtitle;
- (NSString *)title;
-(void)setTitle:(NSString*)strTitle;
-(void)setSubTitle:(NSString*)strSubTitle;

@end
