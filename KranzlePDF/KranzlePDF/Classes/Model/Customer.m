//
//  Customer.m
//  KranzlePDF
//
//  Created by Ross on 1/13/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import "Customer.h"
#import "Constants.h"
@implementation Customer

#pragma mark lifecycle

-(id)initWithRecord:(NSArray*)record {
    self = [super init];
    _name = record[COLUMN_NAME];
    _street = record[COLUMN_STREET];
    return self;
}

@end
