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
    _number = record[COLUMN_NUMBER];
    _name = record[COLUMN_NAME];
    _name2 = record[COLUMN_NAME2];
    _name3 = record[COLUMN_NAME3];
    _street = record[COLUMN_STREET];
    _plz = record[COLUMN_PLZ];
    _ort = record[COLUMN_ORT];
    _email = record[COLUMN_EMAIL];
    _verband = record[COLUMN_VERBAND];
    _emailVertreter = record[COLUMN_EMAIL_VERTRETER];
    _verbandsNumber = record[COLUMN_VERBANDS_NUMBER];
    _vertreterCode = record[COLUMN_VERTRETER_CODE];
    return self;
}

@end
