//
//  PermissionCompnent.m
//
//  Created by zhongyang on 6/10/15.
//  Copyright (c) 2015 zhongyang. All rights reserved.
//

#import "PermissionCompnent.h"

@implementation PermissionCompnent

+ (void)havePhotoPermission:(PermissionBlock)permissionBlock {
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status == ALAuthorizationStatusNotDetermined) {
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
            *stop = YES;
            permissionBlock(YES);
        };

        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
            permissionBlock(NO);
        };

        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:listGroupBlock failureBlock:failureBlock];
    } else if (status == ALAuthorizationStatusDenied || status == ALAuthorizationStatusRestricted) {
        permissionBlock(NO);
    } else {
        permissionBlock(YES);
    }
}

+ (void)havePhotoPermissionWithoutDetermined:(PermissionBlock)permissionBlock {
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status == ALAuthorizationStatusNotDetermined) {
        permissionBlock(YES);
    } else if (status == ALAuthorizationStatusDenied || status == ALAuthorizationStatusRestricted) {
        permissionBlock(NO);
    } else {
        permissionBlock(YES);
    }
}

+ (void)haveCameraPermission:(PermissionBlock)permissionBlock {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == ALAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            ThrowToMain(permissionBlock(granted););
        }];
    } else if (status == ALAuthorizationStatusDenied || status == ALAuthorizationStatusRestricted) {
        permissionBlock(NO);
    } else {
        permissionBlock(YES);
    }
}

+ (void)haveCameraPermissionWithoutDetermined:(PermissionBlock)permissionBlock {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == ALAuthorizationStatusNotDetermined) {
        permissionBlock(YES);
    } else if (status == ALAuthorizationStatusDenied || status == ALAuthorizationStatusRestricted) {
        permissionBlock(NO);
    } else {
        permissionBlock(YES);
    }
}


+ (BOOL)haveMicrophonePermission {
    __block BOOL canVisit = YES;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [session performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            canVisit = granted;
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    return canVisit;
}

@end
