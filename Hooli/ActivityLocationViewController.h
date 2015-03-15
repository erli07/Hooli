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


@interface ActivityLocationViewController : UIViewController<UISearchBarDelegate>

@property (nonatomic) IBOutlet  MKMapItem *mapItem;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
