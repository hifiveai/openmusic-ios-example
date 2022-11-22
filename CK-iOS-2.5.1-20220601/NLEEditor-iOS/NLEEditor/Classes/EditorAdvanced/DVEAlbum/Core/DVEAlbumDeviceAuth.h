//
//  DVEAlbumDeviceAuth.h
//  Pods
//
//  Created by bytedance on 2019/9/11.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface DVEAlbumDeviceAuth : NSObject

+ (BOOL)isCameraAuth;

+ (BOOL)isCameraDenied;

+ (BOOL)isCameraNotDetermined;

+ (BOOL)isMicroPhoneAuth;

+ (BOOL)isMicroPhoneDenied;

+ (BOOL)isMicroPhoneNotDetermined;

+ (BOOL)isiOS14PhotoNotDetermined;

+ (BOOL)isiOS14PhotoLimited;

+ (void)requestPhotoLibraryPermission:(void(^)(BOOL success))completion;

+ (PHAuthorizationStatus)acc_authorizationStatusForPhoto;

+ (AVAuthorizationStatus)acc_authorizationStatusForVideo;

+ (AVAuthorizationStatus)acc_authorizationStatusForAudio;

+ (BOOL)hasCameraAndMicroPhoneAuth;

@end

NS_ASSUME_NONNULL_END
