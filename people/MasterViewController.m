#import "MasterViewController.h"
#import "Person.h"
#import "NSDate+Extra.h"
#import "AppDelegate.h"
#import "PersonView.h"
#import "Person.h"
#import <Twitter/Twitter.h>

@interface MasterViewController() 
@property (strong) UIView* headerView;
@property (strong) UIView* shadowView;
@property (strong, readonly) NSFetchedResultsController* fetchController;

- (void) doDelete:(id)sender;
- (void) doEdit:(id)sender;
- (void) doTweet:(id)sender;
- (void) doCalendar:(id)sender;
- (UIView*) getNewOptionView;
@end

@implementation MasterViewController

@synthesize headerView = _headerView;
@synthesize shadowView = _shadowView;
@synthesize currentActionCell = _currentActionCell;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSError* err;
    [self.fetchController performFetch:&err];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.157 green:0.157 blue:0.157 alpha:1.000];
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    self.headerView.backgroundColor = [UIColor colorWithRed:0.157 green:0.157 blue:0.157 alpha:1.000];
    UILabel* name = [[UILabel alloc] initWithFrame:CGRectMake(60, 3, 200, 44)];
    name.text = @"PEOPLE";
    name.font = [UIFont fontWithName:@"League Gothic" size:36];
    name.textAlignment = UITextAlignmentCenter;
    name.textColor = [UIColor whiteColor];
    name.backgroundColor = [UIColor clearColor];
    [self.headerView addSubview:name];
    
    UIImage* shadowImage = [UIImage imageNamed:@"shadowbar.png"];
    self.shadowView = [[UIImageView alloc] initWithImage:shadowImage];
    self.shadowView.frame = CGRectMake(0, 58, 320, 18);
    self.shadowView.hidden = YES;
    [[[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController].view addSubview:self.shadowView];
    [[[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController].view addSubview:self.headerView];

    self.tableView.delaysContentTouches = NO;
    
}

- (UIView*) getNewOptionView {
    UIImage* background = [UIImage imageNamed:@"background.jpg"];
    UIView* optionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 88)];
    optionView.backgroundColor = [UIColor colorWithPatternImage:background];
    
    UIButton* editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* editIcon = [UIImage imageNamed:@"edit.png"];
    [editButton setImage:editIcon forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(doEdit:) forControlEvents:UIControlEventTouchUpInside];
    editButton.frame = CGRectMake(0, 0, 44, 44);
    editButton.center = CGPointMake(123, 44);
    
    UIButton* deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* deleteIcon = [UIImage imageNamed:@"delete.png"];
    [deleteButton setImage:deleteIcon forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(doDelete:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.bounds = CGRectMake(0, 0, 44, 44);
    deleteButton.center = CGPointMake(70, 44);
    
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    if( delegate.canTweat ) {
        UIButton* tweetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage* tweetIcon = [UIImage imageNamed:@"twitter.png"];
        [tweetButton setImage:tweetIcon forState:UIControlStateNormal];
        [tweetButton addTarget:self action:@selector(doTweet:) forControlEvents:UIControlEventTouchUpInside];
        tweetButton.bounds = CGRectMake(0, 0, 44, 44);
        tweetButton.center = CGPointMake(250, 44);
        [optionView addSubview:tweetButton];
    }
    
    UIButton* calButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* calIcon = [UIImage imageNamed:@"cal.png"];
    [calButton setImage:calIcon forState:UIControlStateNormal];
    [calButton addTarget:self action:@selector(doCalendar:) forControlEvents:UIControlEventTouchUpInside];
    calButton.bounds = CGRectMake(0, 0, 44, 44);
    calButton.center = CGPointMake(187, 44);
    
    [optionView addSubview:editButton];
    [optionView addSubview:deleteButton];
    [optionView addSubview:calButton];
    
    return optionView;
}



- (NSFetchedResultsController*) fetchController {
    if (_fetchController != nil) {
        return _fetchController;
    }
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *ent = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:appDelegate.managedObjectContext];

    [fetchRequest setFetchBatchSize:20];
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = nil;
    sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    [fetchRequest setEntity:ent];
    
    _fetchController =  [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                        managedObjectContext:appDelegate.managedObjectContext 
                                                              sectionNameKeyPath:nil cacheName:nil];
    _fetchController.delegate = self;
    
    return _fetchController;    
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SlidyCell";
    SlidyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Person* person = [self.fetchController objectAtIndexPath:indexPath];
	
	if (cell == nil) {
		cell = [[SlidyTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier person:person];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.optionView = [self getNewOptionView];
        [(SlidyTableCell*)cell setActionDelegate:self];
	} else {
        [(SlidyTableCell*)cell personView].person = person;
    }
    
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"sections %d", [[self.fetchController sections] count] == 0 ? 1 : [[self.fetchController sections] count]);
    NSLog(@"%@", self.fetchController.fetchedObjects);
    return [[self.fetchController sections] count] == 0 ? 1 : [[self.fetchController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = nil;
    sectionInfo = [[self.fetchController sections] objectAtIndex:section];
    NSLog(@"rows in %d %d", section, [sectionInfo numberOfObjects]);
    return [sectionInfo numberOfObjects];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    headerView.backgroundColor = [UIColor colorWithRed:0.157 green:0.157 blue:0.157 alpha:1.000];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"BEGIN DRAGGING");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.contentOffset.y < 1) {
        self.shadowView.hidden = YES;
    } else {
        self.shadowView.hidden = NO;
    }
    [self.currentActionCell deactivateCell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected %d", indexPath.row);
}

- (SlidyTableCell*) clickedCell:(UIButton*)button{
    CGPoint point = [button convertPoint:button.bounds.origin toView:self.tableView];
    NSIndexPath* ip = [self.tableView indexPathForRowAtPoint:point];
    return (SlidyTableCell*)[self.tableView cellForRowAtIndexPath:ip];
}

- (void) doDelete:(id)sender {
    NSLog(@"clicked delete");
}

- (void) doTweet:(id)sender {
    NSLog(@"did tweet sucka'");
    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
    SlidyTableCell* selectedCell = [self clickedCell:sender];
    [tweetViewController setInitialText:[NSString stringWithFormat:@"@%@ ", selectedCell.personView.person.twitter]];
    
    [tweetViewController setCompletionHandler:^(TWTweetComposeViewControllerResult result) {
        switch (result) {
            case TWTweetComposeViewControllerResultCancelled:
                NSLog(@"Cancelled");
                break;
            case TWTweetComposeViewControllerResultDone:
                NSLog(@"tweeted playa!");
                break;
            default:
                break;
        }
        [self dismissModalViewControllerAnimated:YES];
    }];
    
    [self presentModalViewController:tweetViewController animated:YES];
    [self.currentActionCell deactivateCell];

}

- (void) doCalendar:(id)sender {
}

- (void) doEdit:(id)sender {
    NSLog(@"clicked edit");
}

- (void) becomeCurrentActionCell:(SlidyTableCell*)cell {
    NSLog(@"becomd active %@", self.currentActionCell);
    [self.currentActionCell deactivateCell];
    self.currentActionCell = cell;
}

- (void) resignActive:(SlidyTableCell*)cell {
    self.currentActionCell = nil;
}

@end



