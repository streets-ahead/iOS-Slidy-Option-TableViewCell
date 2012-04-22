#import "AppDelegate.h"
#import "Person.h"
#import "NSDate+Extra.h"
#import <CoreData/CoreData.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface AppDelegate()
- (void)updateCanTweet;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize canTweat = _canTweat;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Person createPersonWithName:@"Sam Mussell" 
                     startdate:[NSDate dateWithMonth:3 day:20 year:2007] 
                          bday:[NSDate dateWithMonth:5 day:12 year:1984] 
                         title:@"Under Secretary of OK" 
                       twitter:@"smussell"
                           photo:@"http://sammussell.com/sam.png"];
    [Person createPersonWithName:@"Terry Keeney" 
                       startdate:[NSDate dateWithMonth:5 day:30 year:2007] 
                            bday:[NSDate dateWithMonth:3 day:9 year:1985] title:@"Ambassador of Awesome" 
                         twitter:@"tkeeney2"
                           photo:@"http://sammussell.com/terry.png"];
    [Person createPersonWithName:@"Dana Reynolds" 
                       startdate:[NSDate dateWithMonth:1 day:5 year:2007] 
                            bday:[NSDate dateWithMonth:2 day:8 year:1984] title:@"Queen of Operations" 
                         twitter:@"dreynolds"
                           photo:@"danadroid.png"];
    [Person createPersonWithName:@"Ron Swanson" 
                       startdate:[NSDate dateWithMonth:1 day:5 year:2007] 
                            bday:[NSDate dateWithMonth:2 day:8 year:1984] title:@"Director" 
                         twitter:@"dreynolds"
                           photo:@"http://sammussell.com/ron.jpg"];
    [Person createPersonWithName:@"Leslie Knope" 
                       startdate:[NSDate dateWithMonth:1 day:5 year:2001] 
                            bday:[NSDate dateWithMonth:2 day:8 year:1984] title:@"Assistant Director" 
                         twitter:@"dreynolds"
                           photo:@"http://cdn.smallscreenscoop.com/wp-content/uploads/2011/12/best-leslie-knope-quotes-480x304.jpg"];
    [Person createPersonWithName:@"Jim Halpert" 
                       startdate:[NSDate dateWithMonth:1 day:5 year:2007] 
                            bday:[NSDate dateWithMonth:2 day:8 year:1984] title:@"Salesman" 
                         twitter:@"dreynolds"
                           photo:@"http://sammussell.com/jim.jpg"];
    
    [self saveContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCanTweet) name:ACAccountStoreDidChangeNotification object:nil];
    [self updateCanTweet];
    return YES;
}

- (void)updateCanTweet {
    self.canTweat = [TWTweetComposeViewController canSendTweet];
    if(!self.canTweat) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Unable to send Tweet"
                                                        message:@"Your device is not setup with a Twitter account, please go to the iOS Settings app and add your Twitter account" 
                                                        delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
    }

}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *ctx = self.managedObjectContext;
    if (ctx != nil) {
        if ([ctx hasChanges] && ![ctx save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"PeopleModel.sqlite"]];
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:storeUrl.path error:&error];

    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil URL:storeUrl options:nil error:&error]) {
        NSLog(@"err %@", error);
    }
    
    return persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
