//
//  XSDashboardProgressView.h
//  XSDashboardProgressView
//
//  Created by 刘佳斌 on 2019/2/20.
//  Copyright © 2019 xiaosi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface XSDashboardProgressView : UIView

/** 外圈半径，默认为视图短边边长的一半 */
@property (nonatomic, assign) CGFloat  outerRadius;
/** 内圈半径，默认为（外圈半径-12） */
@property (nonatomic, assign) CGFloat  innerRadius;

/** 起始角度，单位是角度，3点钟方向为0度，顺时针旋转，默认值145度 */
@property (nonatomic, assign) CGFloat  beginAngle;
/** 每个进度块的角度范围，单位是角度，默认值8度 */
@property (nonatomic, assign) CGFloat  blockAngle;
/** 两个进度块的间隙的角度，单位是角度，默认值2度 */
@property (nonatomic, assign) CGFloat  gapAngle;

/** 进度条填充色，默认为绿色 */
@property (nonatomic, strong) UIColor *progressColor;
/** 进度条痕迹填充色，默认为灰色 */
@property (nonatomic, strong) UIColor *trackColor;
/** 进度条边框颜色，默认为无色 */
@property (nonatomic, strong) UIColor *outlineColor;
/** 进度条边框线宽，默认为0 */
@property (nonatomic, assign) CGFloat  outlineWidth;

/** 进度块的数量，默认为26 */
@property (nonatomic, assign) NSUInteger blockCount;
/** 进度条最小数值，默认为0 */
@property (nonatomic, assign) CGFloat    minValue;
/** 进度条最大数值，默认为100 */
@property (nonatomic, assign) CGFloat    maxValue;
/** 进度条当前数值 */
@property (nonatomic, assign) CGFloat    currentValue;


/** 自动调整角度，使进度条开口向下并且左右对称，默认为YES */
@property (nonatomic, assign) BOOL     autoAdjustAngle;

@property(nonatomic, strong)CAShapeLayer *leftCurveLayer;
@property(nonatomic, strong)CAShapeLayer *rightCurveLayer;


- (void)addLeftCurve;
- (void)addRightCurve;
@end

NS_ASSUME_NONNULL_END
