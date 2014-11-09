//
//  OfferFilterViewController.h
//  Hooli
//
//  Created by Er Li on 11/8/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferFilterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UISlider *distanceSlider;
- (IBAction)sliderValueChanged:(id)sender;

@end
