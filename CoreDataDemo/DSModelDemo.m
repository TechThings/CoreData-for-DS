//
//  DSModelDemo.m
//  CoreDataDemo
//
//  Created by mac on 15/1/10.
//  Copyright (c) 2015年 DS. All rights reserved.
//

#import "DSModelDemo.h"

@implementation DSModelDemo

-(id)init
{
    if (self = [super init])
    {
        
    }
    
    return self;
}

#pragma mark - Creating person
-(void)createAndSavePersonWithNewPerson:(Person *)onePerson
{
    // 1 -
    Person *newPerson = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:_dManagedObjectContext];
    
    // 2 -
    newPerson = onePerson;
    
    // 3 -
    NSError *saveError = nil;
    if ([_dManagedObjectContext save:&saveError])
    {
        NSLog(@"Successfully to create a new person");
    }
    else
    {
        NSLog(@"Failed to save the new person");
    }
}

#pragma mark - Reading person
-(NSArray *)readingDataFromCoreData
{
    // 1 - Tell the request that we want to read the contents of the Person entity
    // Create the fetch request first
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    // 2 -
    NSError *requestError = nil;
    // 3 - And execute the fetch request on the context
    NSArray *persons = [_dManagedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    // 4 - Make sure we get the array
    if (persons.count > 0)
    {
        NSLog(@"Reading success");
    }
    else
    {
        NSLog(@"Could not find any Person entity in the context");
    }
    
    return persons;
}

#pragma mark - Delete person
-(void)deleteDataWithPerson:(Person *)deletePerson
{
    [_dManagedObjectContext deleteObject:deletePerson];
    
    NSError *savingError = nil;
    if ([_dManagedObjectContext save:&savingError])
    {
        NSLog(@"Successfully deleted the person");
    }
    else
    {
        NSLog(@"Failed to delete the person");
    }
}

#pragma mark - Sorting Data
-(void)sortingData
{
    // 1 - Create the fetch request first
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    // 2 -
    NSSortDescriptor *ageSort = [[NSSortDescriptor alloc] initWithKey:@"age" ascending:YES];
    NSSortDescriptor *firstNameSort = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    fetchRequest.sortDescriptors = @[ageSort,firstNameSort];
    NSError *requestError = nil;
    // And execute the fetch request on the context
    NSArray *persons = [_dManagedObjectContext executeFetchRequest:fetchRequest error:&requestError];
    
    for (Person *onePerson in persons)
    {
        NSLog(@"FirstName = %@",onePerson.firstName);
    }
}

@end
