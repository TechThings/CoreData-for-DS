//
//  BankDetailViewController.h
//  CoreDataDemo
//
//  Created by mac on 15/1/11.
//  Copyright (c) 2015年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FailedBankDetails.h"
#import "FailedBankInfo.h"

@interface BankDetailViewController : UIViewController

@property (nonatomic, strong) FailedBankInfo *b_bankInfo;

-(id)initWithBnkInfo:(FailedBankInfo *)aInfo;

@end
