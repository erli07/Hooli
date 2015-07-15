//
//  PostItemViewController.m
//  Hooli
//
//  Created by Er Li on 7/12/15.
//  Copyright (c) 2015 ErLi. All rights reserved.
//

#import "PostItemViewController.h"
#import "HLTheme.h"
#import "GCPlaceholderTextView.h"
#import "HLTheme.h"
#import "ActivityLocationViewController.h"

@interface PostItemViewController ()<HLActivityLocationDelegate>
{
    NSArray *array1;
    NSArray *array3;
    NSArray *placeHolderArrray ;
    
}
@property (weak, nonatomic)  UIButton *submitButton;

@end



@implementation PostItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    array1 = [NSArray arrayWithObjects:@"Title",@"Price", nil];
    array3 = [NSArray arrayWithObjects:@"Condition",@"Category",@"Location", nil];
    placeHolderArrray = [NSArray arrayWithObjects:@"", @"",@"Input something...",@"",@"",@"",nil];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboards)];
    [self.detailTable addGestureRecognizer:tap];
    
    UIBarButtonItem *rightBarButton2 = [[UIBarButtonItem alloc]
                                        initWithTitle:@"Submit"
                                        style:UIBarButtonItemStyleDone
                                        target:self
                                        action:@selector(seeCategories)];
    self.navigationItem.rightBarButtonItem = rightBarButton2;
}

-(void)dismissKeyboards{
    
    
    
    for (UIView *view in [self.detailTable subviews]) {
        
        [view resignFirstResponder];
        
    }
    
}

#pragma mark tableview

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 2)
        return 132;
    else if(indexPath.section == 0)
        return 100;
        
    return 44;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(section == 0){
      return 1;
    }
    else if(section == 1){
      return [array1 count];
    }
    else if(section == 2){
      return 1;
    }
    else if(section == 3){
      return [array3 count];
    }
    else{
      return 1;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell.textLabel setFont:[UIFont fontWithName:[HLTheme mainFont] size:15.0f]];
    }
    if(indexPath.section == 0){
        
        cell.textLabel.text = @"Images";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    else if(indexPath.section == 1){
        
        cell.textLabel.text = [array1 objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        GCPlaceholderTextView *tf = [self makeTextField:@"" placeholder:@">>>" frame:CGRectMake(100, 2, 275, 40)];
        [cell addSubview:tf];

    }
    else if(indexPath.section == 2){
        
        cell.textLabel.text = @"Description";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        GCPlaceholderTextView *tf = [self makeTextField:@"" placeholder:@">>>" frame:CGRectMake(100, 0, 275, 132)];
        [cell addSubview:tf];
    }
    else if(indexPath.section == 3){
        
        cell.textLabel.text = [array3 objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    else{
        
        cell.textLabel.text = @"Submit";

    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
        if(indexPath.row == 0){
            
            UIStoryboard *detailSb = [UIStoryboard storyboardWithName:@"Post" bundle:nil];
            ActivityLocationViewController *vc = [detailSb instantiateViewControllerWithIdentifier:@"ActivityLocationViewController"];
            vc.title = @"Location";
            vc.showSearchBar = YES;
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
        else if(indexPath.row == 1){
            
            
        }
        else if(indexPath.row == 2){
            
            
        }
        
        
    
}

-(GCPlaceholderTextView*) makeTextField: (NSString*)text
                  placeholder: (NSString*)placeholder
                                  frame:(CGRect)frame{
    GCPlaceholderTextView *tf = [[GCPlaceholderTextView alloc] initWithFrame:frame];
    tf.placeholder = placeholder ;
    tf.text = text ;
    tf.autocorrectionType = UITextAutocorrectionTypeNo ;
    tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tf.textColor = [HLTheme textColor];
    return tf ;
}

-(void)didSelectLocation:(CLLocation *)location locationString:(NSString *)locationText{
    
    
}

@end
