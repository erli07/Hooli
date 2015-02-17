//
//  FormDetailViewController.m
//  Hooli
//
//  Created by Er Li on 1/11/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "FormDetailViewController.h"
#import "FormManager.h"
@interface FormDetailViewController ()

@end

@implementation FormDetailViewController
@synthesize detailFormFiled,itemCategory,itemCondition,itemDescription,itemLocation,itemName,itemPrice;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = NO;
    
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView sizeToFit];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleBordered target:self
                                                                  action:@selector(doneClicked:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    self.detailFormFiled.inputAccessoryView = keyboardDoneButtonView;
    
    self.detailFormFiled.delegate =self;
//    switch (self.detailType) {
//        case HL_ITEM_DETAIL_NAME:
//            self.title = @"Name";
//            break;
//        case HL_ITEM_DETAIL_CATEGORY:
//            self.title = @"Category";
//            break;
//        case HL_ITEM_DETAIL_CONDITION:
//            self.title = @"Condition";
//            break;
//        case HL_ITEM_DETAIL_DESCRIPTION:
//            self.title = @"Description";
//            break;
//        case HL_ITEM_DETAIL_LOCATION:
//            self.title = @"Location";
//            break;
//        case HL_ITEM_DETAIL_PRICE:
//            self.title = @"Price";
//            break;
//            
//        default:
//            break;
//    }

    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
    
    if (self.detailType == HL_ITEM_DETAIL_NAME ) {
        
        self.detailFormFiled.borderStyle = UITextBorderStyleBezel;
        self.detailFormFiled.font = [UIFont systemFontOfSize:20.0f];
        self.detailFormFiled.text = self.itemName;
        [self.detailFormFiled setKeyboardType:UIKeyboardTypeDefault];

        
    }
    if (self.detailType == HL_ITEM_DETAIL_DESCRIPTION ) {
        
        self.detailFormFiled.borderStyle = UITextBorderStyleBezel;
        self.detailFormFiled.font = [UIFont systemFontOfSize:20.0f];
        self.detailFormFiled.text = self.itemDescription;
        [self.detailFormFiled setKeyboardType:UIKeyboardTypeDefault];
        
    }
    
    else if(self.detailType == HL_ITEM_DETAIL_PRICE){
        
        self.detailFormFiled.borderStyle = UITextBorderStyleNone;
        
        self.detailFormFiled.text = @"$";
        
        self.detailFormFiled.font = [UIFont systemFontOfSize:50.0f];
        
        [self.detailFormFiled setKeyboardType:UIKeyboardTypeDecimalPad];
        
        
    }
    
    
    [self.detailFormFiled becomeFirstResponder];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if(self.detailType == HL_ITEM_DETAIL_PRICE){
        
        textField.text = @"$";
        
    }
    
}


-(void)doneClicked:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
        switch (self.detailType) {
                
            case HL_ITEM_DETAIL_NAME:
                [[FormManager sharedInstance]setDetailType:HL_ITEM_DETAIL_NAME];
                [[FormManager sharedInstance]setItemName:self.detailFormFiled.text];
                break;
            case HL_ITEM_DETAIL_CATEGORY:
                [[FormManager sharedInstance]setDetailType:HL_ITEM_DETAIL_CATEGORY];
                [[FormManager sharedInstance]setItemCategory:self.detailFormFiled.text];
                break;
            case HL_ITEM_DETAIL_DESCRIPTION:
                [[FormManager sharedInstance]setDetailType:HL_ITEM_DETAIL_DESCRIPTION];
                [[FormManager sharedInstance]setItemDescription:self.detailFormFiled.text];
                break;
            case HL_ITEM_DETAIL_LOCATION:
                [[FormManager sharedInstance]setDetailType:HL_ITEM_DETAIL_LOCATION];
                [[FormManager sharedInstance]setItemLocation:self.detailFormFiled.text];
                break;
            case HL_ITEM_DETAIL_PRICE:
                [[FormManager sharedInstance]setDetailType:HL_ITEM_DETAIL_PRICE];
                [[FormManager sharedInstance]setItemPrice:self.detailFormFiled.text];
                break;
                
            default:
                break;
        }
    
}

@end
