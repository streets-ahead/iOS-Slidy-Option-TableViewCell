#import <UIKit/UIKit.h>

@class PersonView;
@class Person;
@class SlidyTableCell;

@protocol CellActionDelegate <NSObject>
- (void) becomeCurrentActionCell:(SlidyTableCell*)cell;
- (void) resignActive:(SlidyTableCell*)cell;
@end

@interface SlidyTableCell : UITableViewCell {
    UIView* _optionView;
}
@property (strong) UIView* optionView;
@property (strong) PersonView* personView;
@property (weak) id<CellActionDelegate> actionDelegate;
@property (assign) BOOL actionCell;

- (void) deactivateCell;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier person:(Person*)person;
- (void) touchesDone:(NSSet*)touches;
@end
