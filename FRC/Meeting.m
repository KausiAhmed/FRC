//
//  Meeting.m
//  FRC
//
//  Copyright (c) 2014 SampleFRC. All rights reserved.
//

#import "Meeting.h"
#import "AppDelegate.h"



@interface Meeting ()
@property (nonatomic) NSDate *primitiveStartDate;
@property (nonatomic) NSString *primitiveSectionIdentifier;
@property (nonatomic) NSNumber *primitiveSortKey;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation Meeting

@dynamic startDate;
@dynamic sortKey;
@dynamic title;
@dynamic sectionIdentifier;

@dynamic primitiveSectionIdentifier;
@dynamic primitiveSortKey;
@dynamic primitiveStartDate;
@dynamic managedObjectContext;

#pragma mark - Transient properties

- (NSString *)sectionIdentifier
{
    // Create and cache the section identifier on demand.
    
    [self willAccessValueForKey:@"sectionIdentifier"];
    NSString *tmp = [self primitiveSectionIdentifier];
    [self didAccessValueForKey:@"sectionIdentifier"];
    
    [self willAccessValueForKey:@"sortKey"];
    NSNumber *tempSort = [self primitiveSortKey];
    [self didAccessValueForKey:@"sortKey"];
    
    [self willAccessValueForKey:@"startDate"];
    NSDate *dateToCompare = [self getDateWithLocalTimeZone:[self primitiveStartDate]];
    dateToCompare = [self dateWithoutTime:dateToCompare];
    [self didAccessValueForKey:@"startDate"];
    
    NSDate *now = [self getDateWithLocalTimeZone:[NSDate date]];
    now = [self dateWithoutTime:now];
    
    NSInteger differenceInDays = [self differenceInDays:now andDateToCompare:dateToCompare];
    
    NSString *sectionString;
    NSInteger sortNumber = 0;
    
    
    if (differenceInDays == 0)
    {
        sectionString = kSectionIDToday;
        sortNumber = 0;
        
    }
    else if (differenceInDays < 0)
    {
        sectionString = kSectionIDPast;
        sortNumber = 2;
    }
    else if (differenceInDays > 0)
    {
        sectionString = kSectionIDUpcoming;
        sortNumber = 1;
    }
    
    if ((sortNumber != [tempSort integerValue]) || (!tempSort))
    {
        tmp = sectionString;
        NSLog(@"sectionString %@", sectionString);
        tempSort = [NSNumber numberWithInt:sortNumber];
        [self setPrimitiveSectionIdentifier:tmp];
        [self setPrimitiveSortKey:tempSort];
        
        if (!self.managedObjectContext) [self getManagedObjectContext];
        self.sortKey = tempSort;
        BOOL save = [self.managedObjectContext save:nil];
        if (!save) NSLog(@"There was an Error saving to Core Data");
        if (save) NSLog(@"Date Saved in Core Data from Meeting.m");

    }
    return tmp;
}

-(NSDate *)getDateWithLocalTimeZone:(NSDate*)date
{
    NSDate *sourceDate = date;
    
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate *dateWithCurrentTimeZone = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    return dateWithCurrentTimeZone;
}

-(NSDate *)dateWithoutTime:(NSDate *)now
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"dd-MM-yyyy";
    format.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSString *stringDate = [format stringFromDate:now];
    NSDate *todaysDate = [format dateFromString:stringDate];
    return todaysDate;
    
}

-(NSInteger)differenceInDays:(NSDate *)todaysDate andDateToCompare:(NSDate *)dateToCompare
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSInteger differenceInDays =
    [calendar ordinalityOfUnit:NSDayCalendarUnit
                        inUnit:NSEraCalendarUnit
                       forDate:dateToCompare] -
    [calendar ordinalityOfUnit:NSDayCalendarUnit
                        inUnit:NSEraCalendarUnit
                       forDate:todaysDate];
    NSLog(@"differenceInDays %i", differenceInDays);
    return differenceInDays;
    
}

-(NSManagedObjectContext *)getManagedObjectContext
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    return self.managedObjectContext;
}

#pragma mark - Time stamp setter

- (void)setStartDate:(NSDate *)newDate
{
    // If the startDate changes, the section identifier become invalid.

    [self willChangeValueForKey:@"startDate"];
    [self setPrimitiveStartDate:newDate];
    [self didChangeValueForKey:@"startDate"];
    
    [self setPrimitiveSectionIdentifier:nil];
}

- (void)setSortKey:(NSNumber *)sortKey
{
    [self willChangeValueForKey:@"sortKey"];
    [self setPrimitiveSortKey:sortKey];
    [self didChangeValueForKey:@"sortKey"];
    
}


#pragma mark - Key path dependencies


+ (NSSet *)keyPathsForValuesAffectingSectionIdentifier
{
    // If the value of startDate changes, the section identifier may change as well.
    return [NSSet setWithObject:@"startDate"];
}

+ (NSSet *)keyPathsForValuesAffectingSortKey
{
    // If the value of stateDate changes, the section identifier may change as well.
    return [NSSet setWithObject:@"startDate"];
}

@end
