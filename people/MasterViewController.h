//
//  MasterViewController.h
//  people
//
//  Created by sam mussell on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlidyTableCell.h"
#import <CoreData/CoreData.h>

@class NSFetchedResultsController;

@interface MasterViewController : UITableViewController <CellActionDelegate, NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController* _fetchController;
}
@property (strong) SlidyTableCell* currentActionCell;  
@end
