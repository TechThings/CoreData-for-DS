//
//  DSModelDemo.h
//  CoreDataDemo
//
//  Created by mac on 15/1/10.
//  Copyright (c) 2015年 DS. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Person.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface DSModelDemo : NSObject

{
    NSManagedObjectContext *_dManagedObjectContext;
}

// 1 - Creating and saving Data Using CoreData
-(void)createAndSavePersonWithNewPerson:(Person *)onePerson;

// 2 - Reading Data from CoreData
-(NSArray *)readingDataFromCoreData;

// 3 - Delete Data from CoreData;
-(void)deleteDataWithPerson:(Person *)deletePerson;

// 4 - Sorting Data in CoreData;
-(void)sortingData;

// 5 -
+(instancetype)insertNewObjectInManagedObjectContext:(NSManagedObjectContext *)moc;


@end
