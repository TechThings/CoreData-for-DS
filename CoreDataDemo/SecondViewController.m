//
//  SecondViewController.m
//  CoreDataDemo
//
//  Created by mac on 15/1/10.
//  Copyright (c) 2015年 DS. All rights reserved.
//

#import "SecondViewController.h"

#import "AppDelegate.h"
#import "FailedBankDetails.h"
#import "FailedBankInfo.h"

@interface SecondViewController ()

{
    NSManagedObjectContext *_sManagedObjectContext;
    NSManagedObjectModel *_sManagedObjectModel;
    NSPersistentStoreCoordinator *_sPersistentStoreCoor;
}

@end

@implementation SecondViewController

-(id)init
{
    if (self = [super init])
    {
        self.title = @"Sample one";
    }
    return self;
}

-(void)shareManagedObjectContext
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    _sManagedObjectContext = appDelegate.managedObjectContext;
    _sManagedObjectModel = appDelegate.managedObjectModel;
    _sPersistentStoreCoor = appDelegate.persistentStoreCoordinator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 1 -
    [self shareManagedObjectContext];
    
    // 2 -
    // NSLog(@"Entities:%@",_sManagedObjectModel.entities);
    // NSLog(@"Attri : %@",_sManagedObjectModel.entitiesByName);
    
    // 3 -
    [self testingOurModel];
    
    [self testingFetch];
}

#pragma mark - 1
-(void)testingOurModel
{
    /*
     NSManagedObject *failedBankInfo = [NSEntityDescription insertNewObjectForEntityForName:@"FailedBankInfo" inManagedObjectContext:_sManagedObjectContext];
     [failedBankInfo setValue:@"Test Bank" forKey:@"name"];
     [failedBankInfo setValue:@"Test ville" forKey:@"city"];
     [failedBankInfo setValue:@"Test land" forKey:@"state"];
     
     NSManagedObject *failedBankDetails = [NSEntityDescription insertNewObjectForEntityForName:@"FailedBankDetails" inManagedObjectContext:_sManagedObjectContext];
     [failedBankDetails setValue:[NSDate date] forKey:@"closeDate"];
     [failedBankDetails setValue:[NSDate date] forKey:@"updateDate"];
     [failedBankDetails setValue:[NSNumber numberWithInt:1234] forKey:@"zip"];
     [failedBankDetails setValue:failedBankInfo forKey:@"info"];
     [failedBankInfo setValue:failedBankDetails forKey:@"detials"];
     
     NSError *error;
     if (![_sManagedObjectContext save:&error])
     {
     NSLog(@"Failed");
     }
     else
     {
     NSLog(@"Success");
     }
     */
    FailedBankInfo *failedBankInfo = [NSEntityDescription insertNewObjectForEntityForName:@"FailedBankInfo" inManagedObjectContext:_sManagedObjectContext];
    failedBankInfo.name = @"BankName1";
    failedBankInfo.city = @"ville1";
    failedBankInfo.state = @"land1";
    
    FailedBankDetails *failedBankDetails = [NSEntityDescription insertNewObjectForEntityForName:@"FailedBankDetails" inManagedObjectContext:_sManagedObjectContext];
    failedBankDetails.zip = [NSNumber numberWithInt:123];
    failedBankDetails.closeDate = [NSDate date];
    failedBankDetails.updateDate = [NSDate date];
    
    failedBankInfo.detials = failedBankDetails;
    failedBankDetails.info = failedBankInfo;
    
    NSError *error = nil;
    if ([_sManagedObjectContext save:&error])
    {
        NSLog(@"Success");
    }
    else
    {
        NSLog(@"Fail");
    }
}

#pragma mark - 2 fetch
-(void)testingFetch
{
    /*
     NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
     NSEntityDescription *entity = [NSEntityDescription entityForName:@"FailedBankInfo" inManagedObjectContext:_sManagedObjectContext];
     [fetchRequest setEntity:entity];
     
     NSError *fetchError = nil;
     NSArray *fetchedObjects = [_sManagedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
     
     for (NSManagedObject *info in fetchedObjects)
     {
     NSLog(@"Name = %@",[info valueForKey:@"name"]);
     
     NSManagedObject *details = [info valueForKey:@"details"];
     NSLog(@"Zip:%@ updateDate:%@",[details valueForKey:@"zip"],[details valueForKey:@"updateDate"]);
     }
     */
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"FailedBankInfo"];
    NSError *fetchError = nil;
    NSArray *fetchedObjects = [_sManagedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    for (FailedBankInfo *info in fetchedObjects)
    {
        NSLog(@"Name = %@",info.name);
        
        FailedBankDetails *detail = info.detials;
        NSLog(@"Zip:%@ -> updateDate:%@",detail.zip,detail.updateDate);
    }
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
