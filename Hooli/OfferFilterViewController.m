//
//  OfferFilterViewController.m
//  Hooli
//
//  Created by Er Li on 11/8/14.
//  Copyright (c) 2014 ErLi. All rights reserved.
//

#import "OfferFilterViewController.h"
#import "HLTheme.h"
#import "HLSettings.h"
#import "HLConstant.h"
@interface OfferFilterViewController ()

@end

@implementation OfferFilterViewController
@synthesize distanceLabel,distanceSlider;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIFont* labelFont = [UIFont fontWithName:[HLTheme boldFont] size:17.0f];
    self.distanceLabel.font = labelFont;
    
    UIColor* labelColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    self.distanceLabel.textColor = labelColor;
    
   self.distanceSlider = [UISlider appearance];
    
    UIImage* sliderMinTrackImage = [[UIImage imageNamed:@"sliderMinTrack"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25.0, 0.0, 25.0)];
    
    UIImage* sliderMaxTrackImage = [[UIImage imageNamed:@"sliderMaxTrack"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25.0, 0.0, 25.0)];
    
//    UIImage* sliderThumbImage = [[UIImage imageNamed:@"sliderThumb"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 25.0, 0.0, 25.0)];
//    
//    [self.distanceSlider setThumbImage:sliderThumbImage forState:UIControlStateNormal];
    [self.distanceSlider setMinimumTrackImage:sliderMinTrackImage forState:UIControlStateNormal];
    [self.distanceSlider setMaximumTrackImage:sliderMaxTrackImage forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sliderValueChanged:(id)sender {
    
    if([sender isKindOfClass:[UISlider class]]) {
        UISlider *s = (UISlider*)sender;
        if(s.value >= 0.0 && s.value <= 1.0) {
            
            [[HLSettings sharedInstance]setPreferredDistance:s.value * kHLMaxSearchDistance];
            
        }
    }

}
@end
