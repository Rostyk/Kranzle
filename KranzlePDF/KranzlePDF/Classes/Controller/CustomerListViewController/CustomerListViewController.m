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
#import "CollectDataViewController.h"

@interface CustomerListViewController ()
@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, weak) IBOutlet UITableView *customerTableView;
@end

@implementation CustomerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.rows = [DataProvider sharedProvider].rows;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger number = self.rows.count;
    return number;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    static NSString *CellIdentifier = @"CustomerCellID";
    CustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath: indexPath];
    if(cell == nil) {
        cell = [[CustomerCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Customer *customer = self.rows[indexPath.row];
    cell.textLabel.text = [self combineStringFromArray:@[customer.number, customer.name, customer.name2, customer.name3]];
    cell.detailTextLabel.text = [self combineStringFromArray:@[customer.street, customer.plz, customer.ort]];
    
    cell.nameLabel.text = @"";
    cell.streetLabel.text = @"";
    
    return cell;
}

- (NSString *)combineStringFromArray: (NSArray *)strings {
    NSString *result = @"";
    for (NSString *string in strings) {
        if([string length])
          result = [result stringByAppendingString: [NSString stringWithFormat:@"%@, ", string]];
    }
    
    //truncate @" ," in the end of the string
    return [result substringToIndex:result.length - 2];
}

#pragma mark table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CollectDataViewController *controller = (CollectDataViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"CollectDataViewControllerID"];
    
    Customer *customer = self.rows[indexPath.row];
    controller.customer = customer;
    [self.navigationController pushViewController: controller animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
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
    NSArray *allCustomers = [DataProvider sharedProvider].rows;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(number ==[c] %@) OR (street ==[c] %@) OR (name ==[c] %@) OR (name2 ==[c] %@) OR (name3 ==[c] %@) OR (plz ==[c] %@) OR (ort ==[c] %@)", searchText, searchText, searchText, searchText, searchText, searchText, searchText];
    NSArray *results = [allCustomers filteredArrayUsingPredicate:pred];
    
    if(results.count > 0) {
        self.rows = results;
        [self.customerTableView reloadData];
    }
    else {
        /*if we previously had some filtering matches, display all list again*/
        if(self.rows.count != [DataProvider sharedProvider].rows.count) {
            self.rows = [DataProvider sharedProvider].rows;
            [self.customerTableView reloadData];
        }
    }
}



@end
