//
//  ImageLoaderSpecial.m
//  PlutoLand
//
//  Created by xu xhan on 7/16/10.
//  Copyright 2010 xu han. All rights reserved.
//

#import "ImageLoaderSpecial.h"
#import "UIImageView+Http.h"
#import "AppRecord.h"
#import "ParseOperation.h"
#import "PLHttpClient.h"
#import "PLImageLoader.h"


static NSString *const TopPaidAppsFeed =
@"http://phobos.apple.com/WebObjects/MZStoreServices.woa/ws/RSS/toppaidapplications/limit=75/xml";

@implementation ImageLoaderSpecial

@synthesize entries;
@synthesize queue;

#pragma mark -
#pragma mark NSNotificationCenter observer

- (void)onGetNotificationImageSucceeded:(NSNotification*)notify
{
	NSDictionary* info = [notify userInfo];
	NSIndexPath* indexpath = [info objectForKey:@"indexPath"];
	NSLog(@"at index %d",indexpath.row);
	
//	int row 
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	NSLog(@"loading top list ...");	
	NSData* appListData = [PLHttpClient simpleSyncGet:TopPaidAppsFeed];
	
	NSLog(@"- top list loaded");
	self.title = @"Top Paied Apps";
	
	ParseOperation *parser = [[ParseOperation alloc] initWithData:appListData delegate:self];	
	queue = [[NSOperationQueue alloc] init];
	[queue addOperation:parser];
	[parser release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.entries = [NSMutableArray array];
	self.title = @"loading top list";
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onGetNotificationImageSucceeded:) name:NOTICE_IMAGE_LOADER_SUCCEEDED object:nil];
}


- (void)handleLoadedApps:(NSArray *)loadedApps
{
	//NSLog(@"finished load :%d",[loadedApps count]);	
	self.entries = [NSMutableArray arrayWithArray:loadedApps];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark ParseOperation delegate

- (void)didFinishParsing:(NSArray *)appList
{
    [self performSelectorOnMainThread:@selector(handleLoadedApps:) withObject:appList waitUntilDone:NO];
    
    self.queue = nil;   // we are finished with the queue and our ParseOperation
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [entries count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    AppRecord *appRecord = [self.entries objectAtIndex:indexPath.row];
	cell.textLabel.text = appRecord.appName;
	cell.detailTextLabel.text = appRecord.artist;
	NSDictionary* dic = [NSDictionary dictionaryWithObject:indexPath forKey:@"indexPath"];
	[cell.imageView fetchImageFromURL:appRecord.imageURLString userInfo:dic];
    return cell;
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
    [entries release], entries = nil;
    [queue release], queue = nil;
    [super dealloc];
}


@end

