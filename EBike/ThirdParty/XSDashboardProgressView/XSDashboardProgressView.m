//
//  XSDashboardProgressView.m
//  XSDashboardProgressView
//
//  Created by 刘佳斌 on 2019/2/20.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import "XSDashboardProgressView.h"
#import "XSDashboardProgressLayer.h"

#define degreesToRadians(x) (M_PI*(x)/180.0)
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)  // 角度转弧度
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))    // 弧度转角度

@implementation XSDashboardProgressView

#pragma mark - 初始化

/** 初始化方法，用于从代码中创建的类实例 */
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self defaultInit];
    }
    return self;
}

/** 初始化方法，用于从代码中创建的类实例 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self defaultInit];
    }
    return self;
}

/** 初始化方法，用于从xib文件中载入的类实例 */
- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self)
    {
        [self defaultInit];
    }
    return self;
}

/** 默认的初始化方法 */
- (void)defaultInit
{
    CGFloat minRadius = MIN(self.bounds.size.width, self.bounds.size.height);
    
    self.outerRadius = MIN(minRadius, 221) / 2;
    self.innerRadius = MAX(self.outerRadius - 12, 0);
    self.beginAngle = 145;
    self.blockAngle = 8;
    self.gapAngle = 2;
    self.progressColor = [UIColor greenColor];
    self.trackColor = [UIColor grayColor];
    self.outlineColor = [UIColor clearColor];
    self.outlineWidth = 0;
    
    self.blockCount = 26;
    self.minValue = 0;
    self.maxValue = 100;
    self.currentValue = 50;
    self.autoAdjustAngle = YES;
    [self addLeftCurve];
    [self addRightCurve];
}

// 重设默认层
+ (Class)layerClass
{
    return [XSDashboardProgressLayer class];
}

// 重新布局视图
- (void)layoutSubviews
{
    XSDashboardProgressLayer *layer = (XSDashboardProgressLayer *)self.layer;
    [layer setNeedsDisplay];
}



#pragma mark - 属性

- (CGFloat)outerRadius
{
    XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
    
    return layer.outerRadius;
}

- (void)setOuterRadius:(CGFloat)outerRadius
{
    if (self.outerRadius != outerRadius)
    {
        XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
        layer.outerRadius = outerRadius;
        [layer setNeedsDisplay];
    }
}

- (CGFloat)innerRadius
{
    XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
    
    return layer.innerRadius;
}

- (void)setInnerRadius:(CGFloat)innerRadius
{
    if (self.innerRadius != innerRadius)
    {
        XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
        layer.innerRadius = innerRadius;
        [layer setNeedsDisplay];
    }
}

- (CGFloat)beginAngle
{
    XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
    
    return RADIANS_TO_DEGREES(layer.beginAngle);
}

- (void)setBeginAngle:(CGFloat)beginAngle
{
    CGFloat radians = DEGREES_TO_RADIANS(beginAngle);
    if (self.beginAngle != radians)
    {
        XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
        layer.beginAngle = radians;
        [layer setNeedsDisplay];
    }
}

- (CGFloat)blockAngle
{
    XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
    
    return RADIANS_TO_DEGREES(layer.blockAngle);
}

- (void)setBlockAngle:(CGFloat)blockAngle
{
    CGFloat radians = DEGREES_TO_RADIANS(blockAngle);
    if (self.blockAngle != blockAngle)
    {
        XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
        layer.blockAngle = radians;
        [layer setNeedsDisplay];
    }
}

- (CGFloat)gapAngle
{
    XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
    
    return RADIANS_TO_DEGREES(layer.gapAngle);
}

- (void)setGapAngle:(CGFloat)gapAngle
{
    CGFloat radians = DEGREES_TO_RADIANS(gapAngle);
    if (self.gapAngle != radians)
    {
        XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
        layer.gapAngle = radians;
        [layer setNeedsDisplay];
    }
}

- (UIColor *)progressColor
{
    XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
    
    return layer.progressColor;
}

- (void)setProgressColor:(UIColor *)progressColor
{
    if (![self.progressColor isEqual:progressColor])
    {
        XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
        layer.progressColor = progressColor;
        [layer setNeedsDisplay];
    }
}

- (UIColor *)trackColor
{
    XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
    
    return layer.trackColor;
}

- (void)setTrackColor:(UIColor *)trackColor
{
    if (![self.trackColor isEqual:trackColor])
    {
        XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
        layer.trackColor = trackColor;
        [layer setNeedsDisplay];
    }
}

- (UIColor *)outlineColor
{
    XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
    
    return layer.outlineColor;
}

- (void)setOutlineColor:(UIColor *)outlineColor
{
    if (![self.outlineColor isEqual:outlineColor])
    {
        XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
        layer.outlineColor = outlineColor;
        [layer setNeedsDisplay];
    }
}

- (CGFloat)outlineWidth
{
    XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
    
    return layer.outlineWidth;
}

- (void)setOutlineWidth:(CGFloat)outlineWidth
{
    if (self.outlineWidth != outlineWidth)
    {
        XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
        layer.outlineWidth = outlineWidth;
        [layer setNeedsDisplay];
    }
}

- (NSUInteger)blockCount
{
    XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
    
    return layer.blockCount;
}

- (void)setBlockCount:(NSUInteger)blockCount
{
    if (self.blockCount != blockCount)
    {
        XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
        layer.blockCount = blockCount;
        [layer setNeedsDisplay];
    }
}

- (CGFloat)minValue
{
    XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
    
    return layer.minValue;
}

- (void)setMinValue:(CGFloat)minValue
{
    if (self.minValue != minValue)
    {
        XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
        layer.minValue = minValue;
        [layer setNeedsDisplay];
    }
}

- (CGFloat)maxValue
{
    XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
    
    return layer.maxValue;
}

- (void)setMaxValue:(CGFloat)maxValue
{
    if (self.maxValue != maxValue)
    {
        XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
        layer.maxValue = maxValue;
        [layer setNeedsDisplay];
    }
}

- (CGFloat)currentValue
{
    XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
    
    return layer.currentValue;
}

- (void)setCurrentValue:(CGFloat)currentValue
{
    if (self.currentValue != currentValue)
    {
        XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
        layer.currentValue = currentValue;
        [layer setNeedsDisplay];
    }
}

- (BOOL)autoAdjustAngle
{
    XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
    
    return layer.autoAdjustAngle;
}

- (void)setAutoAdjustAngle:(BOOL)autoAdjustAngle
{
    if (self.autoAdjustAngle != autoAdjustAngle)
    {
        XSDashboardProgressView *layer = (XSDashboardProgressView *)self.layer;
        layer.autoAdjustAngle = autoAdjustAngle;
        [layer setNeedsDisplay];
    }
}


- (void)addLeftCurve{
    if (self.leftCurveLayer) {
        [self.leftCurveLayer removeFromSuperlayer];
        self.leftCurveLayer = nil;
    }
    [self.layer addSublayer:self.leftCurveLayer];
}

- (CAShapeLayer *)leftCurveLayer{
    if (!_leftCurveLayer) {
//        CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
//        CGPoint x = self.center.x;
//        CGPoint y = self.center.y;
//        CGPoint center = CGPointMake(x, y);
        
        CGPoint center = CGPointMake([EBTool handleCommonFit:150], [EBTool handleCommonFit:130]);
        
        
        _leftCurveLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:self.outerRadius+20 startAngle:degreesToRadians(150) endAngle:degreesToRadians(220) clockwise:YES];
        
        [self createItemPathOfPath:path Start:10 end:15 frameY:180];
        [self createItemPathOfPath:path Start:4 end:9 frameY:160];
        [self createItemPathOfPath:path Start:1 end:6 frameY:140];
        [self createItemPathOfPath:path Start:2 end:7 frameY:120];
        [self createItemPathOfPath:path Start:5 end:10 frameY:100];
        [self createItemPathOfPath:path Start:9 end:14 frameY:80];
        [self createItemPathOfPath:path Start:19 end:24 frameY:60];
        
        _leftCurveLayer.path = [path CGPath];
        _leftCurveLayer.lineWidth = 2;
        _leftCurveLayer.fillColor = [UIColor clearColor].CGColor;
        _leftCurveLayer.strokeColor = [EBTool colorWithHexString:@"46CAD7"].CGColor;
        
    }
    return _leftCurveLayer;
}

- (CAShapeLayer *)rightCurveLayer{
    if (!_rightCurveLayer) {
//        CGPoint center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
        CGPoint center = CGPointMake([EBTool handleCommonFit:150], [EBTool handleCommonFit:130]);
        _rightCurveLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:self.outerRadius+20 startAngle:degreesToRadians(320) endAngle:degreesToRadians(30) clockwise:YES];
        path = [UIBezierPath bezierPathWithArcCenter:center radius:self.outerRadius+20 startAngle:degreesToRadians(320) endAngle:degreesToRadians(30) clockwise:YES];

        [self createItemPathOfPath:path Start:290 end:285 frameY:180];
        [self createItemPathOfPath:path Start:297 end:292 frameY:160];
        [self createItemPathOfPath:path Start:299 end:294 frameY:140];
        [self createItemPathOfPath:path Start:299 end:294 frameY:120];
        [self createItemPathOfPath:path Start:296 end:291 frameY:100];
        [self createItemPathOfPath:path Start:290 end:285 frameY:80];
        [self createItemPathOfPath:path Start:282 end:277 frameY:60];
        
        _rightCurveLayer.path = [path CGPath];
        _rightCurveLayer.lineWidth = 2;
        _rightCurveLayer.fillColor = [UIColor clearColor].CGColor;
        _rightCurveLayer.strokeColor = [EBTool colorWithHexString:@"46CAD7"].CGColor;
    }
    return _rightCurveLayer;
}

- (void)addRightCurve{
    if (self.rightCurveLayer) {
        [self.rightCurveLayer removeFromSuperlayer];
        self.rightCurveLayer = nil;
    }
    [self.layer addSublayer:self.rightCurveLayer];
}

- (void)createItemPathOfPath:(UIBezierPath *)path Start:(CGFloat)start end:(CGFloat)end frameY:(CGFloat)frameY{
    UIBezierPath *itemPath = [UIBezierPath bezierPath];
    [itemPath moveToPoint:CGPointMake([EBTool handleCommonFit:start], [EBTool handleCommonFit:frameY])];
    [itemPath addLineToPoint:CGPointMake([EBTool handleCommonFit:end], [EBTool handleCommonFit:frameY])];
    itemPath.lineWidth = 2.0;
    [path appendPath:itemPath];
}


@end
