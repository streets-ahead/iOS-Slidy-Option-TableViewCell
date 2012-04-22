//
//  PersonView.h
//  people
//
//  Created by sam mussell on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Person;

@interface PersonView : UIView {
    Person* _person;
}
@property (strong) Person* person;

- (void) printInfo;
@end
