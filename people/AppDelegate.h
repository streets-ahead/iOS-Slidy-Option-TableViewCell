//
//  AppDelegate.h
//  people
//
//  Created by sam mussell on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, readonly, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, readonly, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, readonly, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (assign) BOOL canTweat;

- (void)saveContext;

@end
