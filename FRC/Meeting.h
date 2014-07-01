//
//  Meeting.h
//  FRC
//
//  Copyright (c) 2014 SampleFRC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

static NSString *const kSectionIDPast = @"  Past";
static NSString *const kSectionIDToday = @"  Today";
static NSString *const kSectionIDUpcoming = @"  Upcoming";


@interface Meeting : NSManagedObject

@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSNumber * sortKey;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * sectionIdentifier;

@end
