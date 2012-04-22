#import <Foundation/Foundation.h>

@interface NSDate (Extra)

- (NSString*) stringWithFormat:(NSString*)format;
- (NSInteger) daysSince;

+ (NSDate*) dateWithMonth:(NSInteger)month day:(NSInteger)day year:(NSInteger)year;

@end
