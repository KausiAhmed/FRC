//
//  FRCTableVC.m
//  FRC
//
//  Copyright (c) 2014 SampleFRC. All rights reserved.
//

#import "FRCTableVC.h"
#import "AppDelegate.h"
#import "Meeting.h"

@interface FRCTableVC () <NSFetchedResultsControllerDelegate>

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation FRCTableVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.managedObjectContext) [self getManagedObjectContext];
    [self fetchedResultsController];
    [self.fetchedResultsController performFetch:nil];

}

-(NSManagedObjectContext *)getManagedObjectContext
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = appDelegate.managedObjectContext;
    return self.managedObjectContext;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   	NSInteger count = [[self.fetchedResultsController sections] count];
    NSLog (@"section count %i", count);
	return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> secInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    NSLog (@"secInfo numberOfObjects %i", [secInfo numberOfObjects]);
    return [secInfo numberOfObjects];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:CellIdentifier];
    }
    
    Meeting *meeting = (Meeting *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = meeting.title;
    
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

	id <NSFetchedResultsSectionInfo> theSection = [[self.fetchedResultsController sections] objectAtIndex:section];
    NSLog(@"****Number of section %@", [theSection name]);
    
    return  [theSection name];
}



- (NSFetchedResultsController *)fetchedResultsController
{
    if(_fetchedResultsController!=nil)
    {
        return  _fetchedResultsController;
    }
    
    if (!self.managedObjectContext)
    {
        self.managedObjectContext = [self getManagedObjectContext];
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Meeting"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *firstSort = [[NSSortDescriptor alloc] initWithKey:@"sortKey"
                                                              ascending:YES];
    
    
    [fetchRequest setSortDescriptors:@[firstSort]];
    
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest
                                                                       managedObjectContext:self.managedObjectContext
                                                                         sectionNameKeyPath:@"sectionIdentifier"
                                                                                  cacheName:nil];
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}


@end
