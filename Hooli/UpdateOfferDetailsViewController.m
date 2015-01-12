//
//  UpdateOfferDetailsViewController.m
//  Hooli
//
//  Created by Er Li on 1/8/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "UpdateOfferDetailsViewController.h"
#import "OffersManager.h"
#import "ItemDetailViewController.h"
@interface UpdateOfferDetailsViewController ()

@end

@implementation UpdateOfferDetailsViewController
@synthesize updatedDescription = _updatedDescription;
@synthesize updatedName = _updatedName;
@synthesize updatedPrice = _updatedPrice;
@synthesize offerId = _offerId;
@synthesize oldName = _oldName;
@synthesize oldDescription = _oldDescription;
@synthesize oldPrice = _oldPrice;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameTextField.text = _oldName;
    self.priceTextField.text = _oldPrice;
    self.descriptionTextFiled.text = _oldDescription;
    
    // Do any additional setup after loading the view.
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    

    
}

-(void)updateOfferModelValue{
    
    if(self.nameTextField.text != _oldName){
        
        _updatedName = self.nameTextField.text;
        
    }
    else{
        
        _updatedName = nil;
        
    }
    
    if(self.priceTextField.text != _oldPrice){
        
        _updatedPrice = self.priceTextField.text;
        
    }
    else{
        
        _updatedPrice = nil;
        
    }
    
    if(self.descriptionTextFiled.text != _oldDescription){
        
        _updatedDescription = self.descriptionTextFiled.text;
        
    }
    else{
        
        _updatedDescription = nil;
        
    }
}

- (IBAction)submitNewOfferDetails:(id)sender {

    
    [self.nameTextField resignFirstResponder];
    [self.priceTextField resignFirstResponder];
    [self.descriptionTextFiled resignFirstResponder];
    
    [self updateOfferModelValue];
    
    if(_offerId){
        
        OfferModel *updatedOfferModel = [[OfferModel alloc]init];
        
        updatedOfferModel.offerDescription = _updatedDescription;
        updatedOfferModel.offerPrice = _updatedPrice;
        updatedOfferModel.offerName = _updatedName;
        
        [[OffersManager sharedInstance]updateOfferModelWithOfferId:_offerId newOfferModel:updatedOfferModel block:^(BOOL succeeded, NSError *error) {
            
            if(succeeded){
            
                [[self.navigationController.viewControllers objectAtIndex:2] viewWillAppear:YES];
                [self.navigationController popViewControllerAnimated:YES];
                
                UIAlertView *deleteAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"Update success!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [deleteAlert show];

            }
            
            
        }];
        
    }
}

@end
