//
//  Event.h
//  CoredataTest
//
//  Created by Stephen on 4/7/12.
//  Copyright 2012 silicon valley. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Event :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSDate * creationDate;

@end



