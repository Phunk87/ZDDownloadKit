//
//  ZDDemoViewController.m
//  Demo
//
//  Created by Oneday on 13-1-22.
//  Copyright (c) 2013年 0day. All rights reserved.
//

#import "ZDDemoViewController.h"
#import "ZDDownloadKit.h"

#define kDemoFileURL    @"http://119.147.100.78/youku/6775DC42FC03D823E542785A0A/0300200100510215EF805A03CD680ED2B9F506-E194-CED0-F98D-D2E3DF605EE5.mp4"

@interface ZDDemoViewController ()

@end

@implementation ZDDemoViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addDownloadTask)];
    self.navigationItem.rightBarButtonItem = [addButton autorelease];
    
    self.title = @"ZDDownloadKit Demo";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)addDownloadTask {
    ZDSingleThreadDownloadTask *task = [ZDSingleThreadDownloadTask taskWithURL:[NSURL URLWithString:kDemoFileURL]];
    [task addObserver:self
           forKeyPath:@"state"
              options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
              context:nil];
    
    [task addObserver:self
           forKeyPath:@"progress"
              options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
              context:nil];
    
    [[ZDDownloadManager defaultManager] addTask:task
                               startImmediately:YES];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isKindOfClass:NSClassFromString(@"ZDDownloadTask")]) {
        NSUInteger index = [[ZDDownloadManager defaultManager] indexOfTask:object];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                                  withRowAnimation:UITableViewRowAnimationNone];
        });
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [ZDDownloadManager defaultManager].downloadTaskCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    ZDDownloadTask *task = [[ZDDownloadManager defaultManager] taskAtIndex:indexPath.row];
    
    switch (task.state) {
        case kZDDownloadTaskStateDownloaded:
            cell.textLabel.text = @"Downloaded";
            break;
        case kZDDownloadTaskStateDownloading:
            cell.textLabel.text = [NSString stringWithFormat:@"Downloading: %.3f", task.progress];
            break;
        case kZDDownloadTaskStateFailed:
            cell.textLabel.text = @"Failed";
            break;
        case kZDDownloadTaskStatePaused:
            cell.textLabel.text = @"Paused";
            break;
        case kZDDownloadTaskStateWaiting:
            cell.textLabel.text = @"Waiting";
            break;
        default:
            break;
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
