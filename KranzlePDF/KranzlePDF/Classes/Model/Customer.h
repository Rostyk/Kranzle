//
//  Customer.h
//  KranzlePDF
//
//  Created by Ross on 1/13/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Customer : NSObject
@property (nonatomic, strong, readonly) NSString *number;
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *name2;
@property (nonatomic, strong, readonly) NSString *name3;
@property (nonatomic, strong, readonly) NSString *street;
@property (nonatomic, strong, readonly) NSString *plz;
@property (nonatomic, strong, readonly) NSString *ort;
@property (nonatomic, strong, readonly) NSString *email;
@property (nonatomic, strong, readonly) NSString *verband;
@property (nonatomic, strong, readonly) NSString *emailVertreter;
@property (nonatomic, strong, readonly) NSString *verbandsNumber;
@property (nonatomic, strong, readonly) NSString *vertreterCode;

-(id)initWithRecord:(NSArray*)record;
@end
