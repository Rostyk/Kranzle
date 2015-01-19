//
//  CustomerListViewController.m
//  KranzlePDF
//
//  Created by Ross on 1/15/15.
//  Copyright (c) 2015 Ross. All rights reserved.
//

#import "CustomerListViewController.h"
#import "DataProvider.h"
#import "CustomerCell.h"
#import "Customer.h"
#import "Constants.h"
#import "CollectDataViewController.h"
#import "NewCustomerViewController.h"
#import "AppDelegate.h"

@interface CustomerListViewController ()
@property (nonatomic) TABLE_MODE tableMode;
@property (nonatomic) BOOL newCustomerBeingAdded;
@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, strong) NSArray *manuallyAddedRows;
@property (nonatomic, strong) NSArray *parsedRows;
@property (nonatomic, weak) IBOutlet UITableView *customerTableView;
@end

@implementation CustomerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRightNavigationItem];
    
    self.rows = [DataProvider sharedProvider].fetchedRows;
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(self.newCustomerBeingAdded) {
        self.newCustomerBeingAdded = NO;
        __weak typeof(self) weakSelf = self;
        
        /*passing nil as customer number makes the data provider to use last used number*/
        [[DataProvider sharedProvider] fetchRecordsForSalesmenNumber:nil sucess:^(NSArray *records) {
            weakSelf.rows = records;
            [weakSelf reloadData];
        } failure:^(NSError *error) {
            if(error.code == INVALID_CUSTOMER_NUMBER_SPECIFIED) {
                /*Generally it means that we hase some iternal app workflow error.
                 To get to this screen we should have a proper customer number used,
                 if this number became invalid, most probably it was deallocated or set to nil
                 from somewhere*/
                [weakSelf alert:@"Invalid customer number"];
            }
        }];
    }
}

#pragma mark right navigation button

- (void)setupRightNavigationItem {
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCustomer)];
    self.navigationItem.rightBarButtonItem = anotherButton;
}

- (void)reloadData {
    NSArray *allCustomers = self.rows;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"manuallyCreated == YES"];
    self.manuallyAddedRows = [allCustomers filteredArrayUsingPredicate:pred];
    pred = [NSPredicate predicateWithFormat:@"manuallyCreated == NO"];
    self.parsedRows = [allCustomers filteredArrayUsingPredicate:pred];
    
    [self.customerTableView reloadData];

}

#pragma mark table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    /*divide tableview into 2 sections if there're any recored created by the app*/
    if(self.manuallyAddedRows.count > 0) {
        self.tableMode = DOUBLE_SECTION_TABLE_MODE;
        return 2;
    }
    self.tableMode = SINGLE_SECTION_TABLE_MODE;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.tableMode == DOUBLE_SECTION_TABLE_MODE) {
        if(section == MANUALLY_CREATED_CUSTOMERS_SECTION)
            return self.manuallyAddedRows.count;
        if(section == PARSED_CUSTOMERS_SECTION)
            return self.parsedRows.count;
    }
    if(self.tableMode == SINGLE_SECTION_TABLE_MODE) {
        return self.parsedRows.count;
    }
    
    /*should not get here*/
    NSLog(@"Wrong number of sections. Potential issues");
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *CellIdentifier = @"CustomerCellID";
    CustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath: indexPath];
    if(cell == nil) {
        cell = [[CustomerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Customer *customer = nil;
    if(self.tableMode == DOUBLE_SECTION_TABLE_MODE) {
        if(indexPath.section == MANUALLY_CREATED_CUSTOMERS_SECTION) {
            customer = self.manuallyAddedRows[indexPath.row];
        }
        if(indexPath.section == PARSED_CUSTOMERS_SECTION) {
            customer = self.parsedRows[indexPath.row];
        }
    }
    
    if(self.tableMode == SINGLE_SECTION_TABLE_MODE) {
        customer = self.parsedRows[indexPath.row];
    }
    
    cell.textLabel.text = [self combineStringFromCustomer:customer details: NO];
    cell.detailTextLabel.text = [self combineStringFromCustomer:customer details: YES];
    
    cell.nameLabel.text = @"";
    cell.streetLabel.text = @"";
    
    return cell;
}

- (NSString *)combineStringFromCustomer:(Customer *)customer details:(BOOL)details {
    NSMutableArray *strings = [[NSMutableArray alloc] init];
    
    if(details) {
        if(customer.street) [strings addObject:customer.street];
        if(customer.plz) [strings addObject:customer.plz];
        if(customer.ort) [strings addObject:customer.ort];
    }
    else {
        if(customer.number) [strings addObject:customer.number];
        if(customer.name) [strings addObject:customer.name];
        if(customer.name2) [strings addObject:customer.name2];
        if(customer.name3) [strings addObject:customer.name3];
    }
    
    NSString *result = @"";
    for (NSString *string in strings) {
        if([string length])
          result = [result stringByAppendingString: [NSString stringWithFormat:@"%@, ", string]];
    }
    
    //truncate @" ," in the end of the string
    if(result.length > 3)
       return [result substringToIndex:result.length - 2];
    
    return @"Invalid customer details";
}

#pragma mark table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CollectDataViewController *controller = (CollectDataViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"CollectDataViewControllerID"];
    
    Customer *customer = nil;
    
    if(self.tableMode == DOUBLE_SECTION_TABLE_MODE) {
        if(indexPath.section == MANUALLY_CREATED_CUSTOMERS_SECTION) {
            customer = self.manuallyAddedRows[indexPath.row];
        }
        if(indexPath.section == PARSED_CUSTOMERS_SECTION) {
            customer = self.parsedRows[indexPath.row];
        }
    }
    
    if(self.tableMode == SINGLE_SECTION_TABLE_MODE) {
        customer = self.parsedRows[indexPath.row];
    }
    
    controller.customer = customer;
    [self.navigationController pushViewController: controller animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(self.tableMode == DOUBLE_SECTION_TABLE_MODE) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 26)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.frame.size.width, 16)];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15]];
        
        if(section == MANUALLY_CREATED_CUSTOMERS_SECTION) {
           label.text = @"Your customers";
        }
        if(section == PARSED_CUSTOMERS_SECTION) {
            label.text = @"Customers";
        }
        [view addSubview:label];
        [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]];
        return view;
    }
    
    return nil;
}

#pragma mark searchbar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if(searchText.length > 0) {
        NSArray *allCustomers = [DataProvider sharedProvider].fetchedRows;
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(number contains[cd] %@) OR (street contains[cd] %@) OR (name contains[cd] %@) OR (name2 contains[cd] %@) OR (name3 contains[cd] %@) OR (plz contains[cd] %@) OR (ort contains[cd] %@)", searchText, searchText, searchText, searchText, searchText, searchText, searchText];
        NSArray *results = [allCustomers filteredArrayUsingPredicate:pred];
        
        if(results.count > 0) {
            self.rows = results;
            [self reloadData];
        }
        else {
            /*if we previously had some filtering matches, display all list again*/
            if(self.rows.count != [DataProvider sharedProvider].fetchedRows.count) {
                self.rows = [DataProvider sharedProvider].fetchedRows;
                [self reloadData];
            }
        }
    }
    else {
        self.rows = [DataProvider sharedProvider].fetchedRows;
        [self reloadData];
    }
    
}

#pragma mark adding new customer

- (void)addCustomer {
    self.newCustomerBeingAdded = NO;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    NewCustomerViewController *controller = (NewCustomerViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"NewCustomerViewControllerID"];
    self.newCustomerBeingAdded = YES;
    [self.navigationController pushViewController: controller animated:YES];
    
}

#pragma mark display alert

- (void)alert:(NSString *)text {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:text
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}



@end
