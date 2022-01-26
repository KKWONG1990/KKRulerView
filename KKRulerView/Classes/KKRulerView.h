//
//  KKRulerView.h
//  MyPratice
//
//  Created by BYMac on 2022/1/24.
//

#import <UIKit/UIKit.h>
@class KKRulerView;
NS_ASSUME_NONNULL_BEGIN

@protocol KKRulerViewDelegate <NSObject>

/// 更新了选中数值
/// @param rulerView KKRulerView
/// @param value 数值
- (void)rulerViwe:(KKRulerView *)rulerView didUpdateSelectValue:(int)value;

/// 数值标签已创建，实现该方法后需要自行设置标签样式
/// @param rulerView KKRulerView
/// @param textLabel 标签label
/// @param value 值
- (void)rulerView:(KKRulerView *)rulerView didCreateTextLabel:(UILabel *)textLabel value:(int)value;

@end

#pragma TODO:添加选中的指针图片


@interface KKRulerView : UIView

@property (nonatomic, strong, readonly) UIScrollView * scrollView;

/// 代理
@property (nonatomic, weak) id<KKRulerViewDelegate>delegate;

/// 背景图片
@property (nonatomic, strong, readonly) UIImageView * backgroundImageView;

/// 最小刻度单位，默认0
@property (nonatomic) int minimum;

/// 最大刻度单位，默认200
@property (nonatomic) int maximum;

/// 当前选中的数值 - 默认是minimum
@property (nonatomic) int selectValue;

/// 刻度线之间的宽度，默认10
@property (nonatomic) CGFloat lineSpacing;

/// 刻度线的宽度，默认1
@property (nonatomic) CGFloat lineWidth;

/// 小刻度线高度 - 默认10
@property (nonatomic) CGFloat smallLineHeight;

/// 中刻度线高度 - 默认15
@property (nonatomic) CGFloat mediumLineHeight;

/// 大刻度线高度 - 默认20
@property (nonatomic) CGFloat largeLineHeight;

/// 线条颜色
@property (nonatomic, strong) UIColor * lineColor;

/// 文本字体
@property (nonatomic, strong) UIFont * textFont;

/// 文本颜色 - 默认黑色
@property (nonatomic, strong) UIColor * textColor;

/// scrollView在父视图的UIEdgeInsets，默认是UIEdgeInsetsMake(10, 10, 10, 10) ，ps 请都设置整数
@property (nonatomic) UIEdgeInsets scrollViewEdgeInsets;

/// 文本到刻度线的间距 - 默认10
@property (nonatomic) CGFloat textSpacingToLine;

/// 刻度线和scrollview的间隔 - 默认10
@property (nonatomic) CGFloat lineSpacingToScrollView;

/// 是否显示Toast
@property (nonatomic) BOOL isNeedShowToast;

/// 是否反转，默认为NO，上文下尺，Yes上尺下文
@property (nonatomic) BOOL reversal;

@end

NS_ASSUME_NONNULL_END
