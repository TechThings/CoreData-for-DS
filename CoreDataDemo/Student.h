//
//  Student.h
//  CoreDataDemo
//
//  Created by mac on 15/1/11.
//  Copyright (c) 2015年 DS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Teacher;

@interface Student : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSSet *teacher;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Student (CoreDataGeneratedAccessors)

- (void)addTeacherObject:(Teacher *)value;
- (void)removeTeacherObject:(Teacher *)value;
- (void)addTeacher:(NSSet *)values;
- (void)removeTeacher:(NSSet *)values;

- (void)addTagsObject:(NSManagedObject *)value;
- (void)removeTagsObject:(NSManagedObject *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
