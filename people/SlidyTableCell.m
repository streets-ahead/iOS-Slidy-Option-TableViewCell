//
// Copyright (c) 2012 Streets Ahead LLC.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal 
// in the Software without restriction, including without limitation the rights to use, 
// copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the 
// Software, and to permit persons to whom the Software is furnished to do so, subject 
// to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all 
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR 
// A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER 
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "SlidyTableCell.h"
#import "PersonView.h"
#import "Person.h"
#import "AppDelegate.h"
#import <Twitter/Twitter.h>

@interface SlidyTableCell()
- (void) animateToX:(CGFloat)x y:(CGFloat)y withDuration:(CGFloat)duration;
@end

@implementation SlidyTableCell {
    CGPoint _touchStart;
    NSTimeInterval _startTime;
    UIView* _optionView;
}

@synthesize actionDelegate = _actionDelegate;
@synthesize personView = _personView;
@synthesize actionCell = _actionCell;

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
    _touchStart = [[touches anyObject] locationInView:self.personView];
    _startTime = [[NSDate date] timeIntervalSince1970] * 1000;
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
    CGFloat delta = current.x - _touchStart.x;
    NSLog(@"touchstart %f, %f", _touchStart.x, current.x);
    CGFloat xpoint = self.personView.center.x + delta;
    NSLog(@"delta %f", delta);
    
    NSTimeInterval endTime = [[NSDate date] timeIntervalSince1970] * 1000;
    NSTimeInterval deltaTime = endTime - _startTime;
    NSLog(@"delta time %f", deltaTime);
    
    if(!self.actionCell) {
        if(xpoint > 500 || (delta > 80 && deltaTime < 200)) {
            [self.actionDelegate becomeCurrentActionCell:self];
            [self animateToX:280 y:0 withDuration:.1];
            self.actionCell = YES;
        } else if(xpoint < -100 || (delta < -80 && deltaTime < 200)) {
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
    CGFloat deltax = (totalCurrent.x - _touchStart.x);
    NSLog(@"delta %f", deltax);
    if(abs(deltax) > 10) {
        NSLog(@"SCROLL DISABLE");
        ((UITableView*)self.superview).scrollEnabled = NO;
        self.personView.backgroundColor = [UIColor colorWithRed:0.087 green:0.087 blue:0.087 alpha:1.000];
        
        self.personView.center = CGPointMake( self.personView.center.x + (current.x - _touchStart.x), 
                                             self.personView.center.y);   
    }
    


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
