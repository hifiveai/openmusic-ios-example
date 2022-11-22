//
//  DVETextBaseStyleCell.h
//  TTVideoEditorDemo
//
//  Created by bytedance on 2020/12/20
//  Copyright © 2020 bytedance. All rights reserved.
//

#import "DVETextBaseCell.h"
#import "DVEVCContext.h"
NS_ASSUME_NONNULL_BEGIN

@interface DVETextBaseStyleCell : DVETextBaseCell

@property (nonatomic, copy) selectBaseStyleBlock selectStyleBlock;
@property (nonatomic, copy) selectAlignmentBlock alignMentBlock;
@property (nonatomic, weak) DVEVCContext *vcContext;

@end

NS_ASSUME_NONNULL_END
