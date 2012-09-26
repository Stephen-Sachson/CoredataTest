//
//  RootViewController.h
//  CoredataTest
//
//  Created by Stephen on 4/6/12.
//  Copyright 2012 silicon valley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface RootViewController : UITableViewController <CLLocationManagerDelegate> {
	NSMutableArray *eventsArray;
	NSManagedObjectContext *managedObjectContext;
	CLLocationManager *locationManager;
	UIBarButtonItem *addButton;
}
@property (nonatomic, retain) NSMutableArray *eventsArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) UIBarButtonItem *addButton;

- (void)addEvent;
@end
