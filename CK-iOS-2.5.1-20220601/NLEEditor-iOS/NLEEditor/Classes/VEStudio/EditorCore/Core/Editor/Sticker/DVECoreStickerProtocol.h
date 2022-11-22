//
//   DVECoreStickerProtocol.h
//   NLEEditor
//
//   Created  by bytedance on 2021/4/26.
//   Copyright © 2021 ByteDance Ltd. All rights reserved.
//
    
#import "DVECoreProtocol.h"

#if ENABLE_SUBTITLERECOGNIZE
#import "DVECaptionModel.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@class DVETextParm;
@class NLEVideoFrameModel_OC;
@class NLEStyleText_OC;

@protocol DVEStickerKeyFrameProtocol <NSObject>

- (void)stickerKeyFrameDidChangedWithSlot:(NLETrackSlot_OC *)slot;

@end

@protocol DVECoreStickerProtocol <DVECoreProtocol>

@property (nonatomic, weak) id<DVEStickerKeyFrameProtocol> keyFrameDelegate;

//添加一个随机位置的图片贴纸
- (NLETrackSlot_OC *)addNewRandomPositionImageSitckerWithPath:(NSString *)path;

/*
 在屏幕中心点位置添加贴纸
 */
- (NLETrackSlot_OC *)addStickerWithPath:(NSString *)path
                             identifier:(NSString *)identifier
                                iconURL:(NSString *)iconURL;

// 编辑一个贴纸transform
- (void)setSticker:(NSString *)segmentId
           offsetX:(CGFloat)x
           offsetY:(CGFloat)y
             angle:(CGFloat)angle
             scale:(CGFloat)scale
       isCommitNLE:(BOOL)iscommit;

- (void)setSticker:(NSString *)segmentId startTime:(CGFloat)startTime duration:(CGFloat)duration;

- (void)setStickerFilpX:(NSString *)segmentId;

-(NSArray<NLETrackSlot_OC *> *)stickerSlots;

-(NSArray<NLETrackSlot_OC *> *)textSlots;

- (NSString *)addNewRandomPositonTextSticker;

- (NSString *)addNewRandomPositionTextStickerForVideoCover:(NLEVideoFrameModel_OC *)coverModel
                                                 startTime:(CGFloat)startTime
                                                  duration:(CGFloat)duration;

// 横竖排
- (void)changeTextSitckerHorOrVer:(NSString *)segId;

// note(caishaowu):翻转气泡 未完成
- (void)changeTextBubbleHorOrVer:(NSString *)segId;

// 更新文字样式
- (void)updateTextStickerWithParm:(DVETextParm *)parm
                        segmentID:(NSString *)segId
                         isCommit:(BOOL)commit
                       isMainEdit:(BOOL)mainEdit;

- (NSDictionary *)convertTextParamToDic:(DVETextParm *)parm
                                   slot:(NLETrackSlot_OC *)slot;

//- (void)removeInfoSticker:(NSString * )segmentId
//                 isCommit:(BOOL)commit
//               isMainEdit:(BOOL)mainEdit;
//- (NSString *)copyInfoSticker:(NSString *)segmentId isCommit:(BOOL)commit;

/// 当前样式
- (NLEStyleText_OC *)currentStyle;

#if ENABLE_SUBTITLERECOGNIZE
/// 自动插入语音转字幕
/// @param subtitleQueryModel 字幕数据
/// @param coverOldSubtitle 是否覆盖已有字幕
- (void)insertAutoSubtitle:(DVESubtitleQueryModel *)subtitleQueryModel coverOldSubtitle:(BOOL)coverOldSubtitle;
#endif

@end

NS_ASSUME_NONNULL_END
