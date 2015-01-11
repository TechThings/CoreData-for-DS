//
//  FouthViewController.m
//  CoreDataDemo
//
//  Created by mac on 15/1/10.
//  Copyright (c) 2015年 DS. All rights reserved.
//

#import "FouthViewController.h"

#import "AppDelegate.h"

#import "FailedBankDetails.h"
#import "FailedBankInfo.h"

#import "BankDetailViewController.h"

@interface FouthViewController () <UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>

{
    NSManagedObjectContext *_fManagedObjectContext;
    
    UITableView *_fTableView;
    
    NSFetchedResultsController *_fFetchedResultController;
}

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

-(void)addBank
{
    FailedBankInfo *bankInfo = (FailedBankInfo *)[NSEntityDescription insertNewObjectForEntityForName:@"FailedBankInfo" inManagedObjectContext:_fManagedObjectContext];
    bankInfo.name = @"Fouth bank name";
    bankInfo.city = @"Wuhan";
    bankInfo.state = @"Activity";
    
    FailedBankDetails *bankDetails = (FailedBankDetails *)[NSEntityDescription insertNewObjectForEntityForName:@"FailedBankDetails" inManagedObjectContext:_fManagedObjectContext];
    bankDetails.closeDate = [NSDate date];
    bankDetails.updateDate = [NSDate date];
    bankDetails.zip = [NSNumber numberWithInteger:123];
    
    bankInfo.detials = bankDetails;
    bankDetails.info = bankInfo;
    
    NSError *error = nil;
    
    if ([_fManagedObjectContext save:&error])
    {
        NSLog(@"Success");
    }
    else
    {
        NSLog(@"Fail");
        abort();
    }
}

-(void)showSearch
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self testCoreData];
    
    _fTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _fTableView.delegate = self;
    _fTableView.dataSource = self;
    [self.view addSubview:_fTableView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBank)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearch)];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return 1;
    return _fFetchedResultController.sections.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 10.0;
    id <NSFetchedResultsSectionInfo> sectionInfo = _fFetchedResultController.sections[section];
    
    return sectionInfo.numberOfObjects;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [_fManagedObjectContext deleteObject:[_fFetchedResultController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        
        if (![_fManagedObjectContext save:&error])
        {
            NSLog(@"Error happened");
            
            abort();
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FouthCell";
    UITableViewCell *result = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!result)
    {
        result = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    FailedBankInfo *info = [_fFetchedResultController objectAtIndexPath:indexPath];
    
//    result.textLabel.text = @"Hell0, world!";
    
    result.textLabel.text = info.name;
    
    return result;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FailedBankInfo *bankInfo = [_fFetchedResultController objectAtIndexPath:indexPath];
    BankDetailViewController *detailVC = [[BankDetailViewController alloc] initWithBnkInfo:bankInfo];
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [_fTableView beginUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if (type == NSFetchedResultsChangeDelete)
    {
        [_fTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (type == NSFetchedResultsChangeInsert)
    {
        [_fTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }
    else if (type == NSFetchedResultsChangeUpdate)
    {
        
    }
    else if (type == NSFetchedResultsChangeMove)
    {
        [_fTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_fTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [_fTableView endUpdates];
}

-(void)testCoreData
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    _fManagedObjectContext = appDelegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"FailedBankInfo"];
    
    NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    fetchRequest.sortDescriptors = @[nameSort];
    
    _fFetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_fManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fFetchedResultController.delegate = self;
    NSError *fetchError = nil;
    
    if ([_fFetchedResultController performFetch:&fetchError])
    {
        NSLog(@"Fetch yes");
    }
    else
    {
        NSLog(@"Fetch no");
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
