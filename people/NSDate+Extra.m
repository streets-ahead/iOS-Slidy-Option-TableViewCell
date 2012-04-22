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
