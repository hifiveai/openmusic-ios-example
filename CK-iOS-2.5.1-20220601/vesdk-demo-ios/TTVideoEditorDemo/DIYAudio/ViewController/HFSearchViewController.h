//
//  DIYSearchViewController.h
//  TTVideoEditorDemo
//
//  Created by ly on 2022/7/13.
//  Copyright © 2022 bytedance. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFSearchViewController : UIViewController

@property (nonatomic ,copy) void(^chooseBlock)(NSURL *filePath,NSString *name);

@end

NS_ASSUME_NONNULL_END
