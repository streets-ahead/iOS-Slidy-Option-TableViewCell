#import "Person.h"
#import "AppDelegate.h"

@implementation Person
@dynamic bday;
@dynamic name;
@dynamic startDate;
@dynamic title;
@dynamic photoUrl;
@dynamic twitter;

+ (Person*) createPersonWithName:(NSString*)aName startdate:(NSDate*)aSdate bday:(NSDate*)aBday 
                           title:(NSString*)aTitle twitter:(NSString*)aTwitter photo:(NSString*)aPhoto{
    
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    Person* person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:delegate.managedObjectContext];
    
    person.name = aName;
    person.startDate = aSdate;
    person.bday = aBday;
    person.title = aTitle;
    person.twitter = aTwitter;
    person.photoUrl = aPhoto;
    
    return person;
}
@end
