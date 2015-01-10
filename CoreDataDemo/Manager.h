//
//  Manager.h
//  CoreDataDemo
//
//  Created by mac on 15/1/10.
//  Copyright (c) 2015年 DS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/*
 * One to many relationship
 */

@class Employee;

@interface Manager : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) Employee *employees;

@end

@interface Manager (CoreDataGeneratedAccessors)

-(void)addEmployeesObject:(Employee *)value;
-(void)removeEmployeesObject:(Employee *)value;
-(void)addEmployees:(NSSet *)values;
-(void)removeEmployees:(NSSet *)values;

@end
