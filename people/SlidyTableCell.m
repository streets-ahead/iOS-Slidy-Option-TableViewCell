#import "SlidyTableCell.h"
#import "PersonView.h"
#import "Person.h"
#import "AppDelegate.h"
#import <Twitter/Twitter.h>

@interface SlidyTableCell()
@property (assign) CGPoint touchStart;
@property (assign) NSTimeInterval startTime;

- (void) animateToX:(CGFloat)x y:(CGFloat)y withDuration:(CGFloat)duration;
@end

@implementation SlidyTableCell

@synthesize actionDelegate = _actionDelegate;
@synthesize personView = _personView;
@synthesize touchStart = _touchStart;
@synthesize actionCell = _actionCell;
@synthesize startTime = _startTime;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier person:(Person*)person {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"creating cell");

            [self.contentView addSubview:self.optionView];

        self.personView = [[PersonView alloc] initWithFrame:CGRectMake(0, 0, 320, 88)];
        self.personView.person = person;
        [self.contentView addSubview:self.personView];
        
        self.actionCell = NO;
    }
    return self;
}

- (UIView*)optionView {
    return _optionView;
}

- (void)setOptionView:(UIView *)optionView {
    _optionView = optionView;
    [self.contentView addSubview:_optionView];
    [self.contentView bringSubviewToFront:self.personView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches began");
    [super touchesBegan:touches withEvent:event];
    self.touchStart = [[touches anyObject] locationInView:self.personView];
    self.startTime = [[NSDate date] timeIntervalSince1970] * 1000;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"canceled");
    [super touchesCancelled:touches withEvent:event];
    [self touchesDone:touches];
}

- (void) deactivateCell {
    if(self.actionCell) {
        self.actionCell = NO;
        [self animateToX:0 y:0 withDuration:.3];   
    }
}

- (void) animateToX:(CGFloat)x y:(CGFloat)y withDuration:(CGFloat)duration {
    CGSize size = self.personView.frame.size;
    CGRect newRect = CGRectMake(x, y, size.width, size.height);
    [UIView animateWithDuration:duration animations:^{
        self.personView.frame = newRect;    
    } completion:^(BOOL finished) {
        [self.personView printInfo];
    }];
}

- (void) touchesDone:(NSSet*)touches {
    self.personView.backgroundColor = [UIColor colorWithRed:0.157 green:0.157 blue:0.157 alpha:1.000];
    ((UITableView*)self.superview).scrollEnabled = YES;
    
    CGPoint current = [[touches anyObject] locationInView:self];
    CGFloat delta = current.x - self.touchStart.x;
    NSLog(@"touchstart %f, %f", self.touchStart.x, current.x);
    CGFloat xpoint = self.personView.center.x + delta;
    NSLog(@"delta %f", delta);
    
    NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970] * 1000;
    NSTimeInterval deltaTime = endTime - self.startTime;
    NSLog(@"delta time %f", deltaTime);
    
    if(!self.actionCell) {
        if(xpoint > 500 || (delta > 80 && deltaTime < 100)) {
            [self.actionDelegate becomeCurrentActionCell:self];
            [self animateToX:280 y:0 withDuration:.1];
            self.actionCell = YES;
        } else if(xpoint < -100 || (delta < -80 && deltaTime < 100)) {
            [self.actionDelegate becomeCurrentActionCell:self];
            [self animateToX:-280 y:0 withDuration:.1];
            self.actionCell = YES;
        }else {
            [self animateToX:0 y:0 withDuration:.3]; 
        }
    } else {
        [self deactivateCell];        
    }

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self touchesDone:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    CGPoint current = [[touches anyObject] locationInView:self.personView];
    
    CGPoint totalCurrent = [[touches anyObject] locationInView:self];
    CGFloat deltax = (totalCurrent.x - self.touchStart.x);
    NSLog(@"delta %f", deltax);
    if(abs(deltax) > 3) {
        NSLog(@"SCROLL DISABLE");
        ((UITableView*)self.superview).scrollEnabled = NO;
        self.personView.backgroundColor = [UIColor colorWithRed:0.087 green:0.087 blue:0.087 alpha:1.000];
        
        self.personView.center = CGPointMake( self.personView.center.x + (current.x - self.touchStart.x), 
                                             self.personView.center.y);   
    }
    


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
