//
//  Constants.h
//  KranzlePDF
//
//  Created by Ross on 1/13/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#ifndef KranzlePDF_Constants_h
#define KranzlePDF_Constants_h

#define COLUMN_NUMBER            0
#define COLUMN_NAME              1
#define COLUMN_NAME2             2
#define COLUMN_NAME3             3
#define COLUMN_STREET            4
#define COLUMN_PLZ               5
#define COLUMN_ORT               6
#define COLUMN_EMAIL             10
#define COLUMN_EMAIL_VERTRETER   12
#define COLUMN_VERBAND           13
#define COLUMN_VERTRETER_CODE    14
#define COLUMN_VERBANDS_NUMBER   18

#define FORM_VALUES             @[@(20), @(23), @(3), @(6), @(3), @(2), @(4), @(2), @(6)]

typedef enum {
    PARSER_ERROR = 0,
    EMPTY_FETCH_RESULT_ERROR,
    INVALID_CUSTOMER_NUMBER_SPECIFIED
} ERROR_TYPE;

#endif
