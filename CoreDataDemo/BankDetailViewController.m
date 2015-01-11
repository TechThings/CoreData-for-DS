//
//  BankDetailViewController.m
//  CoreDataDemo
//
//  Created by mac on 15/1/11.
//  Copyright (c) 2015年 DS. All rights reserved.
//

#import "BankDetailViewController.h"

@interface BankDetailViewController ()

-(void)hidePicker;
-(void)showPicker;

@end

@implementation BankDetailViewController

@synthesize b_bankInfo;

-(id)initWithBnkInfo:(FailedBankInfo *)aInfo
{
    if (self = [super init])
    {
        self.title = @"Edit";
        
        b_bankInfo = aInfo;
    }
    
    return self;
}

-(void)saveBankInfo
{
    b_bankInfo.name = @"Hello - name";
    b_bankInfo.city = @"Hello - wuhan";
    b_bankInfo.state = @"Hello - state";
    b_bankInfo.detials.zip = [NSNumber numberWithInt:000];
    b_bankInfo.detials.updateDate = [NSDate date];
    b_bankInfo.detials.closeDate = [NSDate date];
    
    NSError *error = nil;
    if ([b_bankInfo.managedObjectContext hasChanges] && ![b_bankInfo.managedObjectContext save:&error])
    {
        NSLog(@"Failed");
        abort();
    }
    else
    {
        NSLog(@"保存成功");
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = b_bankInfo.name;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveBankInfo)];
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

@end
