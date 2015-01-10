//
//  ViewController.m
//  CoreDataDemo
//
//  Created by mac on 15/1/6.
//  Copyright (c) 2015年 DS. All rights reserved.
//

#import "ViewController.h"

#import "AppDelegate.h"

#import "DetailViewController.h"
#import "InfoViewController.h"

#import "Person.h"
#import "DSModelDemo.h"

@interface ViewController ()

@end

@implementation ViewController

-(id)init
{
    if (self = [super init])
    {
        self.title = @"List";
    }
    return self;
}

-(void)handleTest
{
    for (NSUInteger counter=0; counter<10; counter++)
    {
        Person *person = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Person class]) inManagedObjectContext:_vManagedObjectContext];
        
        person.firstName = [NSString stringWithFormat:@"Name_%lu",(unsigned long)counter];
        person.lastName = [NSString stringWithFormat:@"LastName_%lu",(unsigned long)counter];
        person.age = [NSNumber numberWithInteger:counter];
    }
    
    NSError *error = nil;
    if ([_vManagedObjectContext save:&error])
    {
        NSLog(@"Managed to populate the database");
    }
    else
    {
        NSLog(@"Failed to populate the database");
    }
}

-(NSFetchRequest *)newFetchRequest
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Person class])];
    request.fetchBatchSize = 5;
    request.predicate = [NSPredicate predicateWithFormat:@"(age > 5) AND (age < 8)"];
    request.resultType = NSManagedObjectResultType;
    
    return request;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPerson)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"Test" style:UIBarButtonItemStyleDone target:self action:@selector(handleTest)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    /*
     * 部门 (销售、人事、研发、行政、编辑)
     */
    _vGroups = @[@"销售部",@"人事部",@"研发部",@"行政部",@"编辑部"];
    
    _vTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _vTableView.delegate = self;
    _vTableView.dataSource = self;
    [self.view addSubview:_vTableView];
    
    // 读取数据
    [self readPersonInfo];
    
    // test
    [self testCoreData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - UITableView delegate methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _vFrc.sections.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return _vPersonsArr.count;
    id <NSFetchedResultsSectionInfo> sectionInfo = _vFrc.sections[section];
    
    return sectionInfo.numberOfObjects;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _vGroups[section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GroupCell";
    UITableViewCell *result = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!result)
    {
        result = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Person *onePerson = [_vFrc objectAtIndexPath:indexPath];
    
    result.textLabel.text = [NSString stringWithFormat:@"Name:%@",onePerson.firstName];
    result.detailTextLabel.text = [NSString stringWithFormat:@"Age:%@",onePerson.age];
    
    return result;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Person *personToDelete = [_vFrc objectAtIndexPath:indexPath];
        
        [_vManagedObjectContext deleteObject:personToDelete];
        
        if ([personToDelete isDeleted])
        {
            NSError *savingError = nil;
            if ([_vManagedObjectContext save:&savingError])
            {
                NSLog(@"Save success");
            }
            else
            {
                NSLog(@"Save failed");
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    [self scanPersonInfoWithIndex:indexPath.row];
}

-(void)scanPersonInfoWithIndex:(NSInteger)aIndex
{
    InfoViewController *infoVC = [[InfoViewController alloc] init];
    [self.navigationController pushViewController:infoVC animated:YES];
}

-(void)addPerson
{
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:detailVC];
    
    [self presentViewController:detailNav animated:YES completion:nil];
}

-(void)readPersonInfo
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    
    _vManagedObjectContext = managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    
    // 查找指定数据...
//    NSFetchRequest *fetchRequest = [self newFetchRequest];
    
    NSSortDescriptor *ageSort = [[NSSortDescriptor alloc] initWithKey:@"age" ascending:YES];
    NSSortDescriptor *firstNameSort = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    
    fetchRequest.sortDescriptors = @[ageSort,firstNameSort];
    
    _vFrc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _vFrc.delegate = self;
    NSError *fetchError = nil;
    if ([_vFrc performFetch:&fetchError])
    {
        NSLog(@"Successfully fetch");
    }
    else
    {
        NSLog(@"Failed to fetch");
    }
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [_vTableView beginUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if (type == NSFetchedResultsChangeDelete)
    {
        [_vTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if (type == NSFetchedResultsChangeInsert)
    {
        [_vTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [_vTableView endUpdates];
}

-(void)testCoreData
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
