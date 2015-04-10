//
//  ActivityLocationViewController.h
//  Hooli
//
//  Created by Er Li on 3/13/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@protocol HLActivityLocationDelegate <NSObject>

//- (void)didSelectEventLocation:(CLLocation *)eventLocation;
- (void)didSelectLocation:(CLLocation *)location locationString:(NSString *)locationText;

@end

@interface ActivityLocationViewController : UIViewController<UISearchBarDelegate>

@property (nonatomic) IBOutlet  MKMapItem *mapItem;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) id<HLActivityLocationDelegate> delegate;
@property (nonatomic, assign) BOOL showSearchBar;
@property (nonatomic) NSString *eventLocationText;
@property (nonatomic) PFGeoPoint *eventGeopoint;

@end

