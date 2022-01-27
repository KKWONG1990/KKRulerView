//
//  KKRulerView.m
//  MyPratice
//
//  Created by BYMac on 2022/1/24.
//

#import "KKRulerView.h"

@interface KKRulerView()<UIScrollViewDelegate>

/// 背景图片视图
@property (nonatomic, strong) UIImageView * backgroundImageView;

/// 标尺滚动视图
@property (nonatomic, strong) UIScrollView * scrollView;

/// 总数
@property (nonatomic, assign) int total;

/// toast标签
@property (nonatomic, strong) UILabel * toastLabel;

/// 刻度线数组
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> * layers;

/// 标签数组
@property (nonatomic, strong) NSMutableArray<UILabel *> * labels;

/// 刻度间隔，默认10
@property (nonatomic) int interval;

@end
@implementation KKRulerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSetup];
        [self setupUI];
    }
    return self;
}

- (void)initSetup {
    _minimum = 0;
    _maximum = 200;
    _interval = 10;
    _selectValue = _minimum;
    
    _lineWidth = 1;
    _lineSpacing = 10;
    _smallLineHeight = 10;
    _mediumLineHeight = 15;
    _largeLineHeight = 20;
    
    _lineColor = UIColor.darkTextColor;
    _textFont = [UIFont systemFontOfSize:16];
    _textColor = UIColor.blackColor;
    
    _isNeedShowToast = YES;
    _textSpacingToLine = 10;
    _lineSpacingToScrollView = 10;
    _scrollViewEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)setupUI {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.scrollView];
    [self addSubview:self.toastLabel];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize scrollViewSize = [self scrollViewSize];
    self.backgroundImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    self.scrollView.frame = CGRectMake(self.scrollViewEdgeInsets.left, self.scrollViewEdgeInsets.top, scrollViewSize.width, scrollViewSize.height);
    self.scrollView.contentSize = CGSizeMake([self scrollViewContentWidth], 0);
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self removeAllDatas];
    [self createRuler];
}

#pragma mark - 创建尺子
- (void)createRuler {
    //从0开始遍历创建控件
    for (int idx = 0; idx <= self.total; idx++) {
        CGRect lineRect = [self calculateLineRectWithIdx:idx];
        CAShapeLayer * line = [self drawLineLayerWithRect:lineRect];
        if ([self isNeedCrateLabel:idx]) {
            UILabel * label = [self createLabelWithIdx:idx lineRect:lineRect];
            [self.scrollView addSubview:label];
            [self.labels addObject:label];
        }
        [self.scrollView.layer addSublayer:line];
        [self.layers addObject:line];
    }
    [self updateScrollViewContentOffsetWithAnimated:NO];
}

#pragma mark - 计算线条的rect
- (CGRect)calculateLineRectWithIdx:(int)idx {
    CGFloat x = idx * [self totalLineWidth] + [self startX];
    CGFloat h = [self calculateRealLineHeightWithIdx:idx];
    CGFloat y = 0;
    if (self.reversal) {
        y = self.lineSpacingToScrollView;
    } else {
        y = CGRectGetHeight(self.scrollView.frame) - h - self.lineSpacingToScrollView;
    }
    return CGRectMake(x, y, self.lineWidth, h);
}

#pragma mark - 创建线条
- (CAShapeLayer *)drawLineLayerWithRect:(CGRect)rect {
    UIBezierPath * path = [UIBezierPath bezierPathWithRect:rect];
    CAShapeLayer * layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.strokeColor = self.lineColor.CGColor;
    layer.lineWidth = self.lineWidth;
    return layer;
}

#pragma mark - 获取线条高度
- (CGFloat)calculateRealLineHeightWithIdx:(int)idx {

    //第一个或遇上10的刻度
    if (idx % self.interval == 0) {
        return self.largeLineHeight;
    }
    
    //遇到5的刻度
    if (idx % self.interval == 5) {
        return self.mediumLineHeight;
    }
    
    return self.smallLineHeight;
}

#pragma mark - 创建和设置文本标签, 文本标签frame依赖lineRect
- (UILabel *)createLabelWithIdx:(int)idx lineRect:(CGRect)lineRect {
    UILabel * label = [[UILabel alloc] init];
    int value = idx + self.minimum;
    if (self.delegate && [self.delegate respondsToSelector:@selector(rulerView:didCreateTextLabel:value:)]) {
        [self.delegate rulerView:self didCreateTextLabel:label value:value];
    } else {
        label.text = [NSString stringWithFormat:@"%ld",(long)value];
        label.font = self.textFont;
        label.textColor = self.textColor;
        label.textAlignment = NSTextAlignmentCenter;
    }
    CGSize size = [self calculateSizeOfLabel:label];
    label.frame = [self calculateLabelRectWithLineRect:lineRect size:size];
    return label;
}

#pragma mark - 计算文本的size
- (CGSize)calculateSizeOfLabel:(UILabel *)label {
    NSDictionary * attributes;
    NSString * string;
    if (label.attributedText) {
        attributes = [label.attributedText attributesAtIndex:0 effectiveRange:nil];
        string = label.attributedText.string;
    } else {
        attributes = @{NSFontAttributeName : label.font};
        string = label.text;
    }
    return [string boundingRectWithSize:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.scrollView.frame)) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
}

#pragma mark - 计算文本的rect
- (CGRect)calculateLabelRectWithLineRect:(CGRect)lineRect size:(CGSize)size {
    CGFloat x = CGRectGetMinX(lineRect) - size.width / 2;
    CGFloat y = 0;
    if (self.reversal) {
        y = CGRectGetHeight(lineRect) + self.textSpacingToLine + self.lineSpacingToScrollView;
    } else {
        y = CGRectGetHeight(self.scrollView.frame) - CGRectGetHeight(lineRect) - size.height - self.textSpacingToLine - self.lineSpacingToScrollView;
    }
    return CGRectMake(x, y, size.width, size.height);
}

#pragma mark - 是否需要创建文本
- (BOOL)isNeedCrateLabel:(int)idx {
    
    //第一个或遇上10的刻度
    if (idx % self.interval == 0) {
        return YES;
    }

    return NO;
}

- (void)updateScrollViewContentOffsetWithAnimated:(BOOL)animated {
    CGFloat width = (self.selectValue - self.minimum) * [self totalLineWidth];
    [self.scrollView setContentOffset:CGPointMake(width, 0) animated:animated];
}

#pragma mark - 移除数据
- (void)removeAllDatas {
    [self.layers enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.scrollView.layer.sublayers containsObject:obj]) {
            [obj removeFromSuperlayer];
        }
    }];
    [self.labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.scrollView.subviews containsObject:obj]) {
            [obj removeFromSuperview];
        }
    }];
    [self.layers removeAllObjects];
    [self.labels removeAllObjects];
}

#pragma mark - 滑动更新选中的值
- (void)updateWillBeSelectValueWithScrollView:(UIScrollView *)scrollView {
    //计算下标
    int index = scrollView.contentOffset.x / [self totalLineWidth];
    //判断是否与当前选中的值相等
    if (self.selectValue == (index + self.minimum)) {
        return;
    }
    //设置新的值
    self.selectValue = index + self.minimum;
    if (self.isNeedShowToast) {
        [self showToastWithIdx:self.selectValue];
    }
}

- (void)showToastWithIdx:(int)idx {
    self.toastLabel.text = [NSString stringWithFormat:@"%d",idx];
    CGSize size = [self.toastLabel sizeThatFits:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.scrollView.frame))];
    self.toastLabel.frame = CGRectMake(CGRectGetWidth(self.frame) / 2 - (size.width + 10) / 2, CGRectGetMinY(self.scrollView.frame), size.width + 10, size.height);
    self.toastLabel.hidden = NO;
    self.toastLabel.alpha = 1.0;
}

- (void)hideToast {
    [UIView animateWithDuration:0.5 animations:^{
        self.toastLabel.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.toastLabel.hidden = YES;
    }];
}

#pragma mark - 刻度渲染的起点
- (CGFloat)startX {
    return CGRectGetWidth(self.scrollView.frame) / 2;
}

#pragma mark - 滚动视图的大小
- (CGSize)scrollViewSize {
    CGFloat width = CGRectGetWidth(self.frame) - self.scrollViewEdgeInsets.left - self.scrollViewEdgeInsets.right;
    CGFloat height = CGRectGetHeight(self.frame) - self.scrollViewEdgeInsets.top - self.scrollViewEdgeInsets.bottom;
    return CGSizeMake(width, height);
}

#pragma mark - 滚动视图可滚动的宽度
- (CGFloat)scrollViewContentWidth {
    /*
     因为是滑动到视图中间才进行选择，所以加上scrollview的宽度增大可滑动距离
    */
    return self.total * [self totalLineWidth] + CGRectGetWidth(self.scrollView.frame);
}

#pragma mark - 刻度与刻度间距加起来相当于一个刻度
- (CGFloat)totalLineWidth {
    return self.lineWidth + self.lineSpacing;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateWillBeSelectValueWithScrollView:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    BOOL stop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (stop) {
        [self updateScrollViewContentOffsetWithAnimated:YES];
        [self hideToast];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        BOOL stop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
        if (stop) {
            [self updateScrollViewContentOffsetWithAnimated:YES];
            [self hideToast];
        }
    }
}

- (void)setMinimum:(int)minimum {
    _minimum = minimum;
    self.selectValue = minimum;
}

- (void)setMaximum:(int)maximum {
    _maximum = maximum;
}

- (void)setInterval:(int)interval {
    _interval = interval;
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    _lineSpacing = lineSpacing;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
}

- (void)setSelectValue:(int)selectValue {
    _selectValue = selectValue;
    if (self.delegate && [self.delegate respondsToSelector:@selector(rulerViwe:didUpdateSelectValue:)]) {
        [self.delegate rulerViwe:self didUpdateSelectValue:selectValue];
    }
}

- (void)setScrollViewEdgeInsets:(UIEdgeInsets)scrollViewEdgeInsets {
    _scrollViewEdgeInsets = scrollViewEdgeInsets;
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
}

- (void)setTextSpacingToLine:(CGFloat)textSpacingToLine {
    _textSpacingToLine = textSpacingToLine;
}

- (void)setSmallLineHeight:(CGFloat)smallLineHeight {
    _smallLineHeight = smallLineHeight;
}

- (void)setMediumLineHeight:(CGFloat)mediumLineHeight {
    _mediumLineHeight = mediumLineHeight;
}

- (void)setLargeLineHeight:(CGFloat)largeLineHeight {
    _largeLineHeight = largeLineHeight;
}
     
- (void)setLineSpacingToScrollView:(CGFloat)lineSpacingToScrollView {
    _lineSpacingToScrollView = lineSpacingToScrollView;
}
     
- (int)total {
    return self.maximum - self.minimum;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = UIColor.clearColor;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (NSMutableArray<UILabel *> *)labels {
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}

- (NSMutableArray<CAShapeLayer *> *)layers {
    if (!_layers) {
        _layers = [NSMutableArray array];
    }
    return _layers;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
    }
    return _backgroundImageView;
}

- (UILabel *)toastLabel {
    if (!_toastLabel) {
        _toastLabel = [[UILabel alloc] init];
        _toastLabel.textColor = UIColor.whiteColor;
        _toastLabel.textAlignment = NSTextAlignmentCenter;
        _toastLabel.font = [UIFont systemFontOfSize:16];
        _toastLabel.hidden = YES;
        _toastLabel.layer.cornerRadius = 10;
        _toastLabel.layer.masksToBounds = YES;
        _toastLabel.backgroundColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.5];
    }
    return _toastLabel;
}
@end
