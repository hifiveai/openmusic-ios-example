//
//  UIDevice+ACCHardware.m
//  Pods
//
//  Created by bytedance on 2019/8/6.
//

#import "UIDevice+DVEAlbumHardware.h"
#include <sys/sysctl.h>
#import "DVEAlbumMacros.h"

typedef NS_ENUM(NSUInteger, DVEAlbumDeviceModelType) {
    DVEAlbumDeviceModelTypeUnknown,
    DVEAlbumDeviceModelTypeiPhone,
    DVEAlbumDeviceModelTypeiPad,
    DVEAlbumDeviceModelTypeiPodTouch,
};

@interface DVEAlbumDeviceModelInfo: NSObject

@property (nonatomic, assign) DVEAlbumDeviceModelType type;
@property (nonatomic, assign) NSInteger generation;
@property (nonatomic, assign) NSInteger serial;
@property (nonatomic, assign) BOOL isAChip;
@property (nonatomic, assign) NSInteger chipGeneration;
@property (nonatomic, assign) BOOL graphicsPowerChip;

@end


@implementation DVEAlbumDeviceModelInfo

@end



@implementation UIDevice (DVEAlbumHardware)

+ (NSString *)acc_btd_machineModel
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *machineModel = [NSString stringWithUTF8String:machine];
    free(machine);
    return machineModel;
}

+ (DVEAlbumDeviceModelInfo *)acc_deviceModel
{
    static DVEAlbumDeviceModelInfo *modelInfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        modelInfo = [[DVEAlbumDeviceModelInfo alloc] init];
        NSString *platformStr = [UIDevice acc_btd_machineModel];
        NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:@"^([a-zA-Z]+)(\\d+),(\\d+)" options:0 error:nil];
        NSTextCheckingResult *result = [reg firstMatchInString:platformStr options:0 range:NSMakeRange(0, platformStr.length)];
        if (result) {
            NSString *device = [platformStr substringWithRange:[result rangeAtIndex:1]];
            NSInteger generation = [platformStr substringWithRange:[result rangeAtIndex:2]].integerValue;
            NSInteger tag = [platformStr substringWithRange:[result rangeAtIndex:3]].integerValue;
            if ([device isEqualToString:@"iPhone"]) {
                modelInfo.type = DVEAlbumDeviceModelTypeiPhone;
                // iPhone 4 (iPhone3,1) 以前用的不是 A 系列芯片
                if (generation >= 3) {
                    modelInfo.isAChip = YES;
                    modelInfo.chipGeneration = generation + 1;
                    modelInfo.graphicsPowerChip = NO;
                } else {
                    modelInfo.isAChip = NO;
                }
            } else if ([device isEqualToString:@"iPad"]) {
                modelInfo.type = DVEAlbumDeviceModelTypeiPad;
                modelInfo.isAChip = YES;
                if (generation == 3) {
                    modelInfo.graphicsPowerChip = YES;
                    if (tag <= 3) {
                        // iPad 3 (iPad3,1-3) A5X
                        modelInfo.chipGeneration = 5;
                    } else {
                        // iPad 4 (iPad3,4-6) A6X
                        modelInfo.chipGeneration = 6;
                    }
                } else {
                    modelInfo.chipGeneration = generation + 3;
                    modelInfo.graphicsPowerChip = NO;
                    
                    if (generation <= 2) {
                        modelInfo.graphicsPowerChip = NO;
                    } else if (generation == 4) {
                        modelInfo.graphicsPowerChip = NO;
                    } else if (generation == 5) {
                        if (tag <= 2) {
                            // iPad mini 4 - A8
                            modelInfo.graphicsPowerChip = NO;
                        } else {
                            // iPad Air 2 - A8X
                            modelInfo.graphicsPowerChip = YES;
                        }
                    } else if (generation == 6) {
                        if (tag >= 11) {
                            // iPad (2017) - A9
                            modelInfo.graphicsPowerChip = NO;
                        } else {
                            // iPad Pro 12.9 inch (2016), iPad Pro 9.7 inch - A9X
                            modelInfo.graphicsPowerChip = YES;
                        }
                    } else {
                        // iPad Pro 12.9 inch (2017), iPad Pro 10.5 inch - A10X
                        // 未来的 iPad 默认猜测是带 X 的
                        modelInfo.graphicsPowerChip = YES;
                    }
                }
            } else if ([device isEqualToString:@"iPod"]) {
                modelInfo.type = DVEAlbumDeviceModelTypeiPodTouch;
                modelInfo.graphicsPowerChip = NO;
                if (generation < 4) {
                    modelInfo.isAChip = NO;
                } else if (generation < 6) {
                    modelInfo.isAChip = YES;
                    modelInfo.chipGeneration = generation;
                } else {
                    // iPod Touch 6 (iPod7,1) - A8
                    modelInfo.isAChip = YES;
                    modelInfo.chipGeneration = generation + 1;
                }
            }
            modelInfo.generation = generation;
            modelInfo.serial = tag;
        }
    });
    return modelInfo;
}

+ (BOOL)acc_isBetterThanIPhone7
{
    DVEAlbumDeviceModelInfo *info = [self acc_deviceModel];
    return info.chipGeneration >= 10;
}

+ (BOOL)acc_isIPhone7Plus
{
    DVEAlbumDeviceModelInfo *info = [self acc_deviceModel];
    return info.type == DVEAlbumDeviceModelTypeiPhone && info.generation == 9 && (info.serial == 2 || info.serial == 4);
}

+ (BOOL)acc_isIPhone {
    DVEAlbumDeviceModelInfo *info = [self acc_deviceModel];
    return info.type == DVEAlbumDeviceModelTypeiPhone;
}

+ (BOOL)acc_isIPad
{
    DVEAlbumDeviceModelInfo *info = [self acc_deviceModel];
    return info.type == DVEAlbumDeviceModelTypeiPad;
}

+ (BOOL)acc_isPoorThanIPhone6S
{
    DVEAlbumDeviceModelInfo *info = [self acc_deviceModel];
    return info.chipGeneration < 9;
}

// iPhone6(iPhone7,2/A8)
+ (BOOL)acc_isPoorThanIPhone6
{
    DVEAlbumDeviceModelInfo *info = [self acc_deviceModel];
    return info.chipGeneration < 8;
}

+ (BOOL)acc_isPoorThanIPhone5s
{
    DVEAlbumDeviceModelInfo *info = [self acc_deviceModel];
    return info.chipGeneration < 7;
}

+ (BOOL)acc_isPoorThanIPhone5
{
    DVEAlbumDeviceModelInfo *info = [self acc_deviceModel];
    return info.chipGeneration < 6;
}

+ (SCIFScreenWidthCategory)acc_screenWidthCategory
{
    CGFloat width = MIN([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    if (!TOC_FLOAT_GREATER_THAN(width, 320.f)) {
        return SCIFScreenWidthCategoryiPhone5;
    } else if (!TOC_FLOAT_GREATER_THAN(width, 375.f)) {
        return SCIFScreenWidthCategoryiPhone6;
    } else if (!TOC_FLOAT_GREATER_THAN(width, 414.f)) {
        return SCIFScreenWidthCategoryiPhone6Plus;
    } else if (!TOC_FLOAT_GREATER_THAN(width, 768.f)) {
        return SCIFScreenWidthCategoryiPad9_7;
    } else if (!TOC_FLOAT_GREATER_THAN(width, 834.f)) {
        return SCIFScreenWidthCategoryiPad10_5;
    } else {
        return SCIFScreenWidthCategoryiPad12_9;
    }
}

+ (SCIFScreenHeightCategory)acc_screenHeightCategory
{
    CGFloat height = MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    if (!TOC_FLOAT_GREATER_THAN(height, 480.f)) {
        return SCIFScreenHeightCategoryiPhone4s;
    } else if (!TOC_FLOAT_GREATER_THAN(height, 568.f)) {
        return SCIFScreenHeightCategoryiPhone5;
    } else if (!TOC_FLOAT_GREATER_THAN(height, 667.f)) {
        return SCIFScreenHeightCategoryiPhone6;
    } else if (!TOC_FLOAT_GREATER_THAN(height, 736.f)) {
        return SCIFScreenHeightCategoryiPhone6Plus;
    } else if (!TOC_FLOAT_GREATER_THAN(height, 812.f)) {
        return SCIFScreenHeightCategoryiPhoneX;
    } else if (!TOC_FLOAT_GREATER_THAN(height, 896.f)) {
        return SCIFScreenHeightCategoryiPhoneXSMax;
    } else if (!TOC_FLOAT_GREATER_THAN(height, 1024.f)) {
        return SCIFScreenHeightCategoryiPad9_7;
    } else if (!TOC_FLOAT_GREATER_THAN(height, 1122.f)) {
        return SCIFScreenHeightCategoryiPad10_5;
    } else {
        return SCIFScreenHeightCategoryiPad12_9;
    }
}

+ (SCIFScreenRatoCategory)acc_screenRatoCategory
{
    CGFloat width = MIN([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    CGFloat height = MAX([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    CGFloat rato = width / height;
    CGFloat distant4_3 = fabs((3.0f / 4.0f) - rato);
    CGFloat distant16_9 = fabs((9.0f / 16.0f) - rato);
    CGFloat distantX = fabs((375.0f / 812.0f) - rato);
    if (distant4_3 < distant16_9 && distant4_3 < distantX) {
        return SCIFScreenRatoCategoryiPhone4_3;
    } else if (distant16_9 < distantX) {
        return SCIFScreenRatoCategoryiPhone16_9;
    } else {
        return SCIFScreenRatoCategoryiPhoneX;
    }
}

static NSInteger isNotchedScreen = -1;
+ (BOOL)acc_isIPhoneX
{
    if (isNotchedScreen < 0) {
        if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone || UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            if (@available(iOS 11.0, *)) {
                UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] firstObject];
                BOOL shouldRemoveWindow = NO;
                if (!mainWindow) {
                    mainWindow = [[UIWindow alloc] init];
                    mainWindow.backgroundColor = [UIColor clearColor];
                    shouldRemoveWindow = YES;
                }
                isNotchedScreen = mainWindow.safeAreaInsets.bottom > 0.0 ? 1 : 0;
                if (shouldRemoveWindow) {
                    [mainWindow removeFromSuperview];
                    mainWindow = nil;
                }
            } else {
                isNotchedScreen = 0;
            }
        } else {
            isNotchedScreen = 0;
        }
    }
    return isNotchedScreen > 0;
}

+ (BOOL)acc_isIPhoneXsMax
{
    static BOOL isIPhoneXsMax = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isIPhoneXsMax = [self acc_screenHeightCategory] == SCIFScreenHeightCategoryiPhoneXSMax;
    });
    return isIPhoneXsMax;
}

@end
