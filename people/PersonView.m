#import "PersonView.h"
#import "Person.h"
#import "NSDate+Extra.h"
#import "UIImageView+AFNetworking.h"

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

#define TEXT_TOP 8
#define TEXT_LEFT 76

#define BIG_FONT_SIZE 36
#define SMALL_FONT_SIZE 14

@interface PersonView() 
@property (strong) UIImage* ribbon;
@property (strong) UIImageView* photoView;
@property (strong) UIImage* bday;
- (void) updateImage;
@end

@implementation PersonView

@synthesize ribbon = _ribbon;
@synthesize photoView = _photoView;
@synthesize bday = _bday;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.157 green:0.157 blue:0.157 alpha:1.000];
        
        self.ribbon = [UIImage imageNamed:@"ribbon.png"];
        UIImage* image = [UIImage imageNamed:@"blank.png"];
        self.photoView = [[UIImageView alloc] initWithImage:image];
        self.photoView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoView.clipsToBounds = YES;
        [self updateImage];
        CGSize size = self.photoView.frame.size;
        self.photoView.frame = CGRectMake(9, 15, size.width, size.height);
        [self addSubview:self.photoView];
        
        self.bday = [UIImage imageNamed:@"birthday.png"];
    }
    return self;
}



- (void) printInfo {
    NSLog(@"%f, %f", self.photoView.bounds.origin.x, self.photoView.bounds.origin.y);
    NSLog(@"%f, %f", self.photoView.frame.origin.x, self.photoView.frame.origin.y);
}

- (Person *)person {
    return _person;
}

- (void) updateImage {
    if([self.person.photoUrl hasPrefix:@"http://"]) {
        UIImage* image = [UIImage imageNamed:@"blank.png"];
        [self.photoView setImageWithURL:[NSURL URLWithString:self.person.photoUrl] placeholderImage:image];
    } else {
        NSLog(@"%@", self.person.photoUrl);
        UIImage* image = [UIImage imageNamed:self.person.photoUrl];
        self.photoView.image = image;
    }
}

- (void)setPerson:(Person *)person {
    _person = person;
    [self updateImage];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[UIColor colorWithRed:0.671 green:0.792 blue:0.271 alpha:1.000] set];
    [[self.person.name uppercaseString] drawAtPoint:CGPointMake(TEXT_LEFT, TEXT_TOP) withFont:[UIFont fontWithName:@"League Gothic" size:BIG_FONT_SIZE]];
    
    [[UIColor whiteColor] set];
    UIFont* smallFont = [UIFont fontWithName:@"Museo Slab" size:SMALL_FONT_SIZE];
    [self.person.title drawAtPoint:CGPointMake(TEXT_LEFT, TEXT_TOP+BIG_FONT_SIZE) withFont: smallFont];

    [self.bday drawAtPoint:CGPointMake(TEXT_LEFT, TEXT_TOP+SMALL_FONT_SIZE+BIG_FONT_SIZE+3)];
    [[self.person.bday stringWithFormat:@"MMM dd, yyyy"] drawAtPoint:CGPointMake(TEXT_LEFT + 16, TEXT_TOP+SMALL_FONT_SIZE+BIG_FONT_SIZE+3) withFont:smallFont];
    
    [self.ribbon drawAtPoint:CGPointMake(256, 13)];
    NSString* dayString = [NSString stringWithFormat:@"%d", [self.person.startDate daysSince]*-1];
    CGFloat offset = [dayString sizeWithFont:smallFont].width / 2;
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, -1), 0, [UIColor colorWithWhite:.3 alpha:1].CGColor);
    [dayString drawAtPoint:CGPointMake(294 - offset, 18) withFont:smallFont];
    [@"days" drawAtPoint:CGPointMake(278, 31) withFont:smallFont];
    
    CGContextSetShadowWithColor(ctx, CGSizeMake(0.0, 0.0), 0.0, nil);
}


@end
