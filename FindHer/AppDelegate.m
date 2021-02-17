//
//  AppDelegate.m
//  FindHer
//
//  Created by tql on 2020/6/11.
//  Copyright © 2020 tqlLW. All rights reserved.
//

#import "AppDelegate.h"
#import <AMapFoundationKit/AMapFoundationKit.h>



NSString *ampkey = @"3b2b0049c153cc0516ef06a5f986b48e";



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [AMapServices sharedServices].apiKey = ampkey;

    
    [self createCustomRealmPath];

    return YES;
}


- (void)createCustomRealmPath
{
    DebugMethod();
    uint8_t buffer[64];

    __unused int result = SecRandomCopyBytes(kSecRandomDefault, 64, buffer);
    
    __unused NSData *keyData = [[NSData alloc] initWithBytes:buffer length:sizeof(buffer)];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths lastObject];
    NSString *directryPath = [path stringByAppendingPathComponent:@"Realm"];
    
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    int currentVersion = 1;
    config.schemaVersion = currentVersion;
    //config.encryptionKey = keyData;
    
    if ([fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil]) {
        config.fileURL = [[[config.fileURL URLByDeletingLastPathComponent]  URLByAppendingPathComponent:@"/Realm/find"] URLByAppendingPathExtension:@"realm"];
        //        logMessage(@"%@",config.fileURL);
        [RLMRealmConfiguration setDefaultConfiguration:config];
    }
    
    //数据迁移
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        // 我们目前还未执行过迁移，因此 oldSchemaVersion == 0
        //        if (oldSchemaVersion < currentVersion) {
        //            // enumerateObjects:block: 方法将会遍历
        //            // 所有存储在 Realm 文件当中的 `NoteTable` 对象
        //            [migration enumerateObjects:NoteTable.className
        //                                  block:^(RLMObject *oldObject, RLMObject *newObject) {
        //                                      if (oldSchemaVersion < 2) {
        //                                          newObject[@"noteBgId"] = @"";
        //                                      }
        //                                  }];
        //        }
        
    };
    [RLMRealmConfiguration setDefaultConfiguration:config];
    // 现在我们已经通知了 Realm 如何处理架构变化，
    // 打开文件将会自动执行迁移
    [RLMRealm defaultRealm];
    
    
    //                                          //处理v2.0的更新
    //                                          if (oldSchemaVersion < 2.0) {
    //                                              newObject[@"fullName"] = [NSString stringWithFormat:@"%@ %@", oldObject[@"firstName"], oldObject[@"lastName"]];
    //                                          }
    //                                          //处理v3.0的更新
    //                                          if(oldSchemaVersion < 3.0) {
    //                                              newObject[@"email"] = @"";
    //                                          }
}
#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
