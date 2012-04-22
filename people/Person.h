#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Person : NSManagedObject
@property (strong) NSString* name;
@property (strong) NSDate* startDate;
@property (strong) NSString* title;
@property (strong) NSDate* bday;
@property (strong) NSString* photoUrl;
@property (strong) NSString* twitter;

+ (Person*) createPersonWithName:(NSString*)aName startdate:(NSDate*)aSdate bday:(NSDate*)aBday 
                           title:(NSString*)aTitle twitter:(NSString*)aTwitter photo:(NSString*)aPhoto;
@end
