//
//  ViewController.h
//  CoreDataDemo
//
//  Created by mac on 15/1/6.
//  Copyright (c) 2015年 DS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>

{
    UITableView *_vTableView;
    NSArray *_vGroups;
    
    NSFetchedResultsController *_vFrc;
    
    NSManagedObjectContext *_vManagedObjectContext;
}


@end

