//
//  PostFormViewController.h
//  Hooli
//
//  Created by Er Li on 1/11/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef enum{
    
    HL_ITEM_DETAIL_NAME = 1,
    HL_ITEM_DETAIL_DESCRIPTION,
    HL_ITEM_DETAIL_PRICE,
    HL_ITEM_DETAIL_CATEGORY,
    HL_ITEM_DETAIL_CONDITION,
    HL_ITEM_DETAIL_LOCATION
    
} DetailType;

@interface PostFormViewController : UITableViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *postFormTableView;
@property (nonatomic) NSMutableArray *detailsArray;
@property (nonatomic) NSMutableArray *conditionArray;
@property (nonatomic,assign) CLLocationCoordinate2D itemLocationCoordinate;
@property (nonatomic) NSString *itemName;
@property (nonatomic) NSString *itemDescription;
@property (nonatomic) NSString *itemPrice;
@property (nonatomic) NSString *itemCategory;
@property (nonatomic) NSString *itemCondition;
@property (nonatomic) NSString *itemLocation;

@property (nonatomic) UIPickerView *pickerView;
@property (nonatomic, assign) DetailType detailType;


@end
