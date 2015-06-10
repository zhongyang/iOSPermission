//
//  PermissionCompnent.h
//
//  Created by zhongyang on 6/10/15.
//  Copyright (c) 2015 zhongyang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PermissionBlock)(BOOL canVisit);

@interface PermissionCompnent : NSObject

//Check visit ablum permission. If permission is ALAuthorizationStatusNotDetermined,
//permissionBlock will return until user make choice.
+ (void)havePhotoPermission:(PermissionBlock)permissionBlock;

//Check visit ablum permission. If permission is ALAuthorizationStatusNotDetermined, return YES
+ (void)havePhotoPermissionWithoutDetermined:(PermissionBlock)permissionBlock;

//Check visit camera permission. If permission is ALAuthorizationStatusNotDetermined,
//permissionBlock will return until user make choice.
+ (void)haveCameraPermission:(PermissionBlock)permissionBlock;

//Check visit camera permission. If permission is ALAuthorizationStatusNotDetermined, return YES
+ (void)haveCameraPermissionWithoutDetermined:(PermissionBlock)permissionBlock;

//Check have microphone permission
+ (BOOL)haveMicrophonePermission;

@end
