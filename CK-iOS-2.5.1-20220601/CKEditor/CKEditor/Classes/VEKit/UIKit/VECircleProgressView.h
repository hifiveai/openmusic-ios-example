//
//  VECircleProgressView.h
//  TTVideoEditorDemo
//
//  Created by bytedance on 2020/12/20
//  Copyright © 2020 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VECircleProgressView : UIView

-(instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth;

@property (assign,nonatomic) float progress;

@property (assign,nonatomic) CGFloat lineWidth;

@end

NS_ASSUME_NONNULL_END
