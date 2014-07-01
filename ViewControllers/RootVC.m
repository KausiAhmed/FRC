//
//  RootVC.m
//  FRC
//
//  Copyright (c) 2014 SampleFRC. All rights reserved.
//

#import "RootVC.h"
#import "AppDelegate.h"
#import "Meeting.h"

@interface RootVC ()
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation RootVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.managedObjectContext) [self getManagedObjectContext];
}

- (IBAction)buttonGeneateData:(UIButton *)sender
{
    [self generateDataToStore];

}

- (NSManagedObjectContext *)getManagedObjectContext
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    return self.managedObjectContext;
}


- (void)generateDataToStore
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDate *date = [NSDate date];
    NSDateComponents *comps = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                     fromDate:date];
    NSDate *today = [cal dateFromComponents:comps];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    NSDate *startDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
   

    for (int i = -30; i<20; i++)
    {
        Meeting *meeting = [NSEntityDescription
                            insertNewObjectForEntityForName:@"Meeting"
                            inManagedObjectContext:self.managedObjectContext];
        
        [components setDay:-i];
        startDate = [cal dateByAddingComponents:components toDate:today options:0];
        meeting.startDate = startDate;
        meeting.title = [formatter stringFromDate:startDate];
        NSLog(@"Meeting.StartDate: %@", meeting.startDate);
        NSLog(@"Meeting.Title: %@", meeting.title);
    }
    BOOL save = [self.managedObjectContext save:nil];
    if (!save) NSLog(@"There was an Error saving to Core Data in RootVC");
}


@end
