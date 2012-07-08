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

#import "NSDate+Extra.h"

@implementation NSDate (Extra)
- (NSString*) stringWithFormat:(NSString*)format {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setCalendar:cal];
    [formatter setLocale:[NSLocale currentLocale]];
    NSString *ret = [formatter stringFromDate:self];
    return ret;
}

- (NSInteger) daysSince {
    return [self timeIntervalSinceNow] / 60 / 60 / 24;
}

+ (NSDate*) dateWithMonth:(NSInteger)month day:(NSInteger)day year:(NSInteger)year {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* components = [[NSDateComponents alloc] init];
    [components setDay:day];
    [components setMonth:month];
    [components setYear:year];
    return [cal dateFromComponents:components];
}
@end
