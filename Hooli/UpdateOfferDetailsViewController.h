//
//  UpdateOfferDetailsViewController.h
//  Hooli
//
//  Created by Er Li on 1/8/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateOfferDetailsViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTextFiled;

@property (nonatomic,strong) NSString *updatedName;
@property (nonatomic,strong) NSString *updatedPrice;
@property (nonatomic,strong) NSString *updatedDescription;

@property (nonatomic,strong) NSString *oldName;
@property (nonatomic,strong) NSString *oldPrice;
@property (nonatomic,strong) NSString *oldDescription;

@property (nonatomic,strong) NSString *offerId;
@end
