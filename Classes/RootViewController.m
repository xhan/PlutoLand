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

#import "SegmentDemoViewController.h"
#import "TabBarVCDemoViewController.h"
#import "WebViewCombineController.h"

@interface SectionItem : NSObject
{
	NSString* title;
	NSArray* contents;
	NSArray* classes;
}

@property (nonatomic, copy) NSArray *classes;
@property (nonatomic, copy) NSArray *contents;
@property (nonatomic, copy) NSString *title;

+ (id)section;
@end

@implementation SectionItem

@synthesize classes;
@synthesize contents;
@synthesize title;


+ (id)section
{
	return [[SectionItem new] autorelease];
}

- (void)dealloc
{
	[title release], title = nil;
	[classes release], classes = nil;
	[contents release], contents = nil;
	[super dealloc];
}


@end

/////////////////////////////////////////////////////////////////////////////////////


@implementation RootViewController



#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Pluto Land";
	

	
	SectionItem* ImageLoaderSection = [SectionItem section];
	ImageLoaderSection.title = @"Image Loader";
	ImageLoaderSection.contents = [@"Normal^^Special" componentsSeparatedByString:@"^^"];
	ImageLoaderSection.classes = [NSArray arrayWithObjects:[ImageLoaderBasicVC class],[ImageLoaderSpecial class],nil];  
	
	SectionItem* SegmentSection = [SectionItem section];
	SegmentSection.title = @"Segement Demo";
	SegmentSection.contents = [@"Segment View||PLTabBarController" componentsSeparatedByString:@"||"];
	SegmentSection.classes = [NSArray arrayWithObjects:[SegmentDemoViewController class],[TabBarVCDemoViewController class],nil];

	
	SectionItem* webViewSection = [SectionItem section];
	webViewSection.title = @"WebView Combined";
	webViewSection.contents = [NSArray arrayWithObject:@"Demo1"];
	webViewSection.classes = [NSArray arrayWithObject:[WebViewCombineController class]];
	
	sections = [[NSArray arrayWithObjects:ImageLoaderSection,SegmentSection,webViewSection,nil] retain];
}





#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sections count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[(SectionItem*)[sections objectAtIndex:section] contents] count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return [(SectionItem*)[sections objectAtIndex:section] title];
}
				
				

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = [[(SectionItem*)[sections objectAtIndex:indexPath.section] contents] objectAtIndex:indexPath.row];

    return cell;
}





#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	Class klass = [[(SectionItem*)[sections objectAtIndex:indexPath.section] classes] objectAtIndex:indexPath.row];

	
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




