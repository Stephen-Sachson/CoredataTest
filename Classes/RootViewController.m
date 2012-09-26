//
//  RootViewController.m
//  CoredataTest
//
//  Created by Stephen on 4/6/12.
//  Copyright 2012 silicon valley. All rights reserved.
//

#import "RootViewController.h"
#import "Event.h"

@implementation RootViewController
@synthesize eventsArray;
@synthesize managedObjectContext;
@synthesize locationManager;
@synthesize addButton;
/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"Locations";
	self.navigationItem.leftBarButtonItem=self.editButtonItem;
	addButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent)];
	addButton.enabled=NO;
	self.navigationItem.rightBarButtonItem=addButton;
	[[self locationManager] startUpdatingLocation];
    //eventsArray=[[NSMutableArray alloc] init];
	
	NSFetchRequest *request=[[NSFetchRequest alloc] init];
	NSEntityDescription *entity=[NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	NSSortDescriptor *sortDescriptor=[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
	NSArray *sortDescriptors=[[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	[sortDescriptor release];
	[sortDescriptors release];
	NSError *error=nil;
	NSMutableArray *mutableFetchResults=[[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults==nil) {
		
	}
	[self setEventsArray:mutableFetchResults];
	[mutableFetchResults release];
	[request release];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (CLLocationManager *)locationManager {
	if (locationManager!=nil) {
		return locationManager;
	}
	locationManager=[[CLLocationManager alloc] init];
	locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
	locationManager.delegate=self;
	
	return locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	addButton.enabled=YES;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	addButton.enabled=NO;
}

- (void)addEvent {
	CLLocation *location=[locationManager location];
	if (!location) {
		return;
	}
	Event *event=(Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event" 
														inManagedObjectContext:managedObjectContext];
	CLLocationCoordinate2D coordinate=[location coordinate];
	[event setLatitude:[NSNumber numberWithDouble:coordinate.latitude]];
	[event setLongitude:[NSNumber numberWithDouble:coordinate.longitude]];
	[event setCreationDate:[NSDate date]];
	
	NSError *error=nil;
	if (![managedObjectContext save:&error]) {
	}
	
	[eventsArray insertObject:event atIndex:0];
	NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] 
	                      atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.eventsArray=nil;
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [eventsArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSDateFormatter *dateFormatter=nil;
	
	if (dateFormatter==nil) {
		dateFormatter=[[NSDateFormatter alloc] init];
		[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	}
	
	static NSNumberFormatter *numberFormatter=nil;
	
	if (numberFormatter==nil) {
		numberFormatter=[[NSNumberFormatter alloc] init];
		[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[numberFormatter setMaximumFractionDigits:3];
	}
	
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		Event *event=(Event *)[eventsArray objectAtIndex:indexPath.row];
		cell.textLabel.text=[dateFormatter stringFromDate:[event creationDate]];
		NSString *string=[NSString stringWithFormat:@"%@, %@",
						  [numberFormatter stringFromNumber:[event latitude]],
						  [numberFormatter stringFromNumber:[event longitude]]];
		cell.detailTextLabel.text=string;
    }
    
    // Set up the cell...
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
		//int i;
		//for (i=0; i<[eventsArray count]; i++) {
		NSManagedObject *eventToDelete=[eventsArray objectAtIndex:indexPath.row];
		[managedObjectContext deleteObject:eventToDelete];
		
        NSError *error=nil;
		if (![managedObjectContext save:&error]) {
			
		}
			//NSLog(@"done");	
		//}
		[eventsArray removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}  
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	[managedObjectContext release];
	[eventsArray release];
	[locationManager release];
	[addButton release];
    [super dealloc];
}


@end

