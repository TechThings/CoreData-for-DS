//
//  ThirdViewController.m
//  CoreDataDemo
//
//  Created by mac on 15/1/10.
//  Copyright (c) 2015年 DS. All rights reserved.
//

#import "ThirdViewController.h"

#import "AppDelegate.h"

#import "FailedBankDetails.h"
#import "FailedBankInfo.h"

@interface ThirdViewController ()

{
    NSManagedObjectContext *_tManagedObjectContext;
}

@end

@implementation ThirdViewController

-(id)init
{
    if (self = [super init])
    {
        self.title = @"Sample two";
    }
    return self;
}

-(void)shareManagedObjectContext
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    _tManagedObjectContext = appDelegate.managedObjectContext;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self shareManagedObjectContext];
    
    [self testFetchJSON];
}

-(void)testFetchJSON
{
    NSError *err = nil;
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Banks" ofType:@"json"];
    NSArray *Banks = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:kNilOptions error:&err];
    
//    NSLog(@"Imported Banks:%@",Banks);
    
    [Banks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        FailedBankInfo *failedBankInfo = [NSEntityDescription insertNewObjectForEntityForName:@"FailedBankInfo" inManagedObjectContext:_tManagedObjectContext];
        
        failedBankInfo.name = [obj objectForKey:@"name"];
        failedBankInfo.city = [obj objectForKey:@"city"];
        failedBankInfo.state = [obj objectForKey:@"state"];
        
        FailedBankDetails *failedBankDetails = [NSEntityDescription insertNewObjectForEntityForName:@"FailedBankDetails" inManagedObjectContext:_tManagedObjectContext];
//        failedBankDetails.closeDate = [obj objectForKey:@"closeDate"];
        failedBankDetails.closeDate = [NSDate date];
        failedBankDetails.zip = [obj objectForKey:@"zip"];
        
        failedBankInfo.detials = failedBankDetails;
        failedBankDetails.info = failedBankInfo;
        
        NSError *error = nil;
        
        if (![_tManagedObjectContext save:&error])
        {
            NSLog(@"Error");
        }
        else
        {
            NSLog(@"YES");
        }
    }];
    
    // Test listing all
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"FailedBankInfo"];
    NSError *fetchError = nil;
    NSArray *fetchedObjects = [_tManagedObjectContext executeFetchRequest:fetchRequest error:&fetchError];
    for (FailedBankInfo *info in fetchedObjects)
    {
        NSLog(@"Name = %@",info.name);
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
