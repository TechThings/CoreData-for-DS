//
//  FailedBankInfo.h
//  CoreDataDemo
//
//  Created by mac on 15/1/11.
//  Copyright (c) 2015年 DS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/*
 * One to One relationship
 */

@class FailedBankDetails;

@interface FailedBankInfo : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) FailedBankDetails *detials;

@end
