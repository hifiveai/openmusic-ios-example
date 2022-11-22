//
//  UIImage+Rotation.h
//  TTVideoEditorDemo
//
//  Created by bytedance on 2020/12/20
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Rotation)

- (UIImage *)fixOrientation;
- (UIImage *)RotationOrientationLeft;
- (UIImage *)RotationOrientationRight;
- (UIImage *)RotationOrientationUpDown;

@end

NS_ASSUME_NONNULL_END
