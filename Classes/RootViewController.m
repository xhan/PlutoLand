//
//  RootViewController.m
//  PlutoLand
//
//  Created by xu xhan on 7/16/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import "RootViewController.h"

#import "ImageLoaderBasicVC.h"
#import "ImageLoaderSpecial.h"

@implementation RootViewController





#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Pluto Land";
	
	contents = [@"Normal^^Special" componentsSeparatedByString:@"^^"];
	klasses = [[NSArray arrayWithObjects:[ImageLoaderBasicVC class],[ImageLoaderSpecial class],nil] retain];
}





#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return @"Image Loader";
}
				
				

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = [contents objectAtIndex:indexPath.row];
    return cell;
}





#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	Class klass = [klasses objectAtIndex:indexPath.row];
	
	 UIViewController *detailViewController = [[klass alloc] init];
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];

}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

