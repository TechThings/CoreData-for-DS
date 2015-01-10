//
//  FouthViewController.m
//  CoreDataDemo
//
//  Created by mac on 15/1/10.
//  Copyright (c) 2015年 DS. All rights reserved.
//

#import "FouthViewController.h"

@interface FouthViewController ()

@end

@implementation FouthViewController

-(id)init
{
    if (self = [super init])
    {
        self.title = @"Sample three";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
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
