//
//  Customer.h
//  KranzlePDF
//
//  Created by Ross on 1/18/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Customer : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * emailVertreter;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * name2;
@property (nonatomic, retain) NSString * name3;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * ort;
@property (nonatomic, retain) NSString * plz;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * verband;
@property (nonatomic, retain) NSString * verbandsNumber;
@property (nonatomic, retain) NSString * vertreterCode;
@property (nonatomic, retain) NSNumber * manuallyCreated;

@end
