//
//  DetailViewController.m
//  CoreDataDemo
//
//  Created by mac on 15/1/10.
//  Copyright (c) 2015年 DS. All rights reserved.
//

#import "DetailViewController.h"

#import "Person.h"
#import <CoreData/CoreData.h>

#import "AppDelegate.h"

@interface DetailViewController () <UITextFieldDelegate>

{
    UITextField *_dFirstField;
    UITextField *_dSecondField;
    UITextField *_dAgeField;
    
    UIScrollView *_dScroller;
    
    NSInteger _dTextIndex;
}

@end

@implementation DetailViewController

-(id)init
{
    if (self = [super init])
    {
        self.title = @"Add";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backToRootVC)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePerson)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self customAddUIView];
}

-(void)backToRootVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)savePerson
{
    // 1 - 暂未完成
    
    if (_dFirstField.text.length == 0 || _dSecondField.text.length == 0 || _dAgeField.text.length == 0)
    {
        return;
    }
    
    [self createNewPersonWithFirstName:_dFirstField.text secondName:_dSecondField.text age:[_dAgeField.text integerValue]];
    
    // 2 - 返回
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createNewPersonWithFirstName:(NSString *)fName secondName:(NSString *)sName age:(NSInteger)aAge
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
    
    Person *newPerson = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:managedObjectContext];
    
    if (newPerson != nil)
    {
        newPerson.firstName = fName;
        newPerson.lastName = sName;
        newPerson.age = [NSNumber numberWithInteger:aAge];
        newPerson.icon = [UIImage imageNamed:@"152.png"];
        
        NSError *savingError = nil;
        if ([managedObjectContext save:&savingError])
        {
            NSLog(@"Save success");
        }
        else
        {
            NSLog(@"Save failed");
        }
    }
    else
    {
        NSLog(@"Failed to create the new person object");
    }
}

-(void)customAddUIView
{
    // 1 - icon
    // 2 - firstName
    // 3 - lastName
    // 4 - age
    // 5 - partemter
    UIImageView *tempImgView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 10, 120, 120)];
    tempImgView.image = [UIImage imageNamed:@"152.png"];
    [self.view addSubview:tempImgView];
    
    _dFirstField = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, 300, 40)];
    _dFirstField.borderStyle = UITextBorderStyleRoundedRect;
    _dFirstField.placeholder = @"First name";
    _dFirstField.delegate = self;
    [self.view addSubview:_dFirstField];
    
    _dSecondField = [[UITextField alloc] initWithFrame:CGRectMake(10, 250, 300, 40)];
    _dSecondField.borderStyle = UITextBorderStyleRoundedRect;
    _dSecondField.placeholder = @"Second name";
    _dSecondField.delegate = self;
    [self.view addSubview:_dSecondField];
    
    _dAgeField = [[UITextField alloc] initWithFrame:CGRectMake(10, 300, 300, 40)];
    _dAgeField.borderStyle = UITextBorderStyleRoundedRect;
    _dAgeField.placeholder = @"Age";
    _dAgeField.delegate = self;
    _dAgeField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_dAgeField];
    
    // 部门
    _dScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 140, 300, 50)];
    _dScroller.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _dScroller.layer.borderWidth = 1.0;
    _dScroller.layer.cornerRadius = 5.0;
    [self.view addSubview:_dScroller];
    
    _dTextIndex = 0;
    
    NSArray *arr = @[@"销售部",@"人事部",@"研发部",@"行政部",@"编辑部"];
    for (int nn=0; nn<arr.count; nn++)
    {
        CGFloat aPointX = 5+nn*60;
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(aPointX, 5, 50, 40)];
        lab.text = arr[nn];
        lab.font = [UIFont boldSystemFontOfSize:15.0];
        lab.tag = 100+nn;
        lab.userInteractionEnabled = YES;
        [self.view addSubview:lab];
        
        if (nn == 0)
        {
            lab.textColor = [UIColor redColor];
        }
        
        [_dScroller addSubview:lab];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapLab:)];
        [lab addGestureRecognizer:tapGesture];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    // 打开键盘，视图上移
    [self animateTextFiled:textField up:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    // 隐藏键盘， 视图下移
    [self animateTextFiled:textField up:NO];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_dFirstField resignFirstResponder];
    [_dSecondField resignFirstResponder];
    [_dAgeField resignFirstResponder];
}

-(void)animateTextFiled:(UITextField *)aTextFiled up:(BOOL)upOrDown
{
    int movementDistance = 80;
//    int movementDistance = aTextFiled.frame.origin.y-200;
    float movementDuration = 0.4;
    
    int movement = (upOrDown ? -movementDistance : movementDistance);
    
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(void)handleTapLab:(UITapGestureRecognizer *)gesture
{
    [self cancelTextColorWithIndex:_dTextIndex];
    
    UILabel *lab = (UILabel *)gesture.view;
    lab.textColor = [UIColor redColor];
    
    _dTextIndex = lab.tag-100;
}

-(void)cancelTextColorWithIndex:(NSInteger)aIndex
{
    UILabel *lab = (UILabel *)[_dScroller viewWithTag:aIndex+100];
    lab.textColor = [UIColor blackColor];
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
