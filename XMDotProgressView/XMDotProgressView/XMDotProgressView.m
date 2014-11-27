//
//  XMDotProgressView.m
//  XMDotProgressView
//
//  Created by xiaoming on 14/11/27.
//  Copyright (c) 2014年 XiaoMing. All rights reserved.
//

#import "XMDotProgressView.h"

#define kDotViewBaseTag 1000
#define kLabelViewBaseTag 2000
#define kDotBackgroundViewBaseTag 3000
#define kProgressLineBackgroundView 4000
#define kProgressLineView 5000

#define kShadowColor [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0]


#import "XMDotProgressView.h"

@interface XMDotProgressView()

//内部自己用的变量
@property (nonatomic, strong) UIView *progressLineBackgroundView;
@property (nonatomic, strong) UIView *progressLineView;
@property (nonatomic, assign) NSInteger totalDotCount;
@property (nonatomic, assign) CGFloat dotInterval;
@property (nonatomic, assign) NSInteger targetDotViewIndex;//将要选中的dotView的位置，默认是0，
@property (nonatomic, strong, readwrite) NSArray *dotItemArray;

@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign, readwrite) NSInteger seletedCount; // default is 0

@property (nonatomic, strong) NSArray *dotArray;
@property (nonatomic, strong) NSArray *descriptionLabelArray;

@end


@implementation XMDotProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.dotDiameter = 10;
        self.paddingLeft = 10;
        self.progressLineHeight = 2;
        self.dotSelectedColor = [UIColor orangeColor];
        self.dotUnseletedColor = [UIColor lightGrayColor];
        self.targetDotViewIndex = 0;
    }
    return self;
}


#pragma mark -
#pragma mark - publicMethod

- (void)setupWithTotalDotCount:(NSInteger)argTotalDotCount {
    [self createDotViewsWithTotalCount:argTotalDotCount andShouldShowDescriptionLabel:NO];
}

- (void)setupWithDotItem:(NSArray *)argArray {
    self.dotItemArray = argArray;
    [self createDotViewsWithTotalCount:argArray.count andShouldShowDescriptionLabel:YES];
}


- (void)setSeletedCount:(NSInteger)seletedCount {
    [self setSeletedCount:seletedCount animated:NO];
}

- (void)setSeletedCount:(NSInteger)seletedCount animated:(BOOL)animated {
    if (self.isAnimating) {
        return;
    }
    _seletedCount = seletedCount;
    if (seletedCount - 1 < self.targetDotViewIndex) {
        [self resetDotViews];
    }
    if (seletedCount == 0) {
        [self resetDotViews];
    }
    else {
        [self setupSeletedDotViewWithIndex:seletedCount animated:animated];
    }
    
    
}

#pragma mark -
#pragma mark - privateMethod

- (void)resetDotViews {
    for (UIImageView *dotView in self.dotArray) {
        dotView.backgroundColor = self.dotUnseletedColor;
    }
    for (UILabel *label in self.descriptionLabelArray) {
        label.textColor = self.dotUnseletedColor;
    }
    CGRect progressLineViewFrame = self.progressLineView.frame;
    progressLineViewFrame.size.width = 0;
    self.progressLineView.frame = progressLineViewFrame;
    self.targetDotViewIndex = 0;
}


- (UIImageView *)createDotViewWithDotDiameter:(CGFloat)argDiameter {
    UIImageView *dotView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, argDiameter, argDiameter)];
    dotView.layer.cornerRadius = argDiameter / 2;
    dotView.layer.masksToBounds = YES;
    dotView.backgroundColor = self.dotUnseletedColor;
    return dotView;
}

- (UILabel *)createLabelWithFrame:(CGRect)argFrame {
    UILabel *label = [[UILabel alloc] initWithFrame:argFrame];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = self.dotUnseletedColor;
    return label;
}

- (void)createDotViewsWithTotalCount:(NSInteger)argTotalDotCount andShouldShowDescriptionLabel:(BOOL)argShowDescriptionLabel {
    for (UIView *subView in self.subviews) {
        if (subView.tag >= kDotViewBaseTag) {
            [subView removeFromSuperview];//必须这么remove掉，否则重新调用这个方法的时候会在原位置重新add一遍。
        }
    }
    self.targetDotViewIndex = 0;
    if (argTotalDotCount > 0) {
        self.dotInterval = (CGRectGetWidth(self.bounds) - (self.paddingLeft + self.dotDiameter / 2) * 2) / (argTotalDotCount - 1);
        CGFloat currentCenterX = self.paddingLeft + self.dotDiameter / 2;
        CGFloat currentBackgroundCenterX = currentCenterX;
        
        NSMutableArray *dotBackgroundArray = [NSMutableArray arrayWithCapacity:argTotalDotCount];
        for (int i = 0; i < argTotalDotCount; i++) {
            UIImageView *dotView = [self createDotViewWithDotDiameter:self.dotDiameter];
            dotView.backgroundColor = kShadowColor;
            dotView.center = CGPointMake(currentBackgroundCenterX, CGRectGetHeight(self.bounds) / 2);
            currentBackgroundCenterX += self.dotInterval;
            dotView.tag = kDotBackgroundViewBaseTag + i;
            [self addSubview:dotView];
            [dotBackgroundArray addObject:dotView];
        }
        
        
        UIView *progressLineBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(currentCenterX, 0, CGRectGetWidth(self.bounds) - currentCenterX * 2, self.progressLineHeight + 4)];
        progressLineBackgroundView.center = CGPointMake(progressLineBackgroundView.center.x, CGRectGetHeight(self.bounds) / 2);
        progressLineBackgroundView.backgroundColor = self.dotUnseletedColor;
        progressLineBackgroundView.layer.borderWidth = 2;
        progressLineBackgroundView.layer.borderColor = [kShadowColor CGColor];
        progressLineBackgroundView.tag = kProgressLineBackgroundView;
        [self addSubview:progressLineBackgroundView];
        self.progressLineBackgroundView = progressLineBackgroundView;
        
        NSMutableArray *dotArray = [NSMutableArray arrayWithCapacity:argTotalDotCount];
        NSMutableArray *labelArray = [NSMutableArray arrayWithCapacity:argTotalDotCount];
        for (int i = 0; i < argTotalDotCount; i++) {
            UIImageView *dotView = [self createDotViewWithDotDiameter:self.dotDiameter - 4];
            dotView.center = CGPointMake(currentCenterX, CGRectGetHeight(self.bounds) / 2);
            currentCenterX += self.dotInterval;
            dotView.tag = kDotViewBaseTag + i;
            [self addSubview:dotView];
            [dotArray addObject:dotView];
            
            if (argShowDescriptionLabel) {
                XMDotItem *item = self.dotItemArray[i];
                UILabel *descriptionLabel = [self createLabelWithFrame:CGRectMake(0, CGRectGetMaxY(dotView.frame) + 6, 60, 14)];
                descriptionLabel.center = CGPointMake(CGRectGetMidX(dotView.frame), descriptionLabel.center.y);
                descriptionLabel.tag = kLabelViewBaseTag + i;
                descriptionLabel.text = item.dotDescription;
                [self addSubview:descriptionLabel];
                [labelArray addObject:descriptionLabel];
            }
        }
        self.dotArray = dotArray;
        if (argShowDescriptionLabel) {
            self.descriptionLabelArray = labelArray;
        }
        else {
            self.descriptionLabelArray = nil;
        }
        
        UIView *progressLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.progressLineBackgroundView.frame),
                                                                            CGRectGetHeight(self.bounds) / 2 - self.progressLineHeight / 2,
                                                                            0,
                                                                            self.progressLineHeight)];
        progressLineView.backgroundColor = self.dotSelectedColor;
        [self addSubview:progressLineView];
        self.progressLineView = progressLineView;
    }
    else {
        return;
    }
    if (argTotalDotCount == 1) {
        UIView *dotView = [self viewWithTag:kDotViewBaseTag];
        dotView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
        
        UIView *dotBackgroundView = [self viewWithTag:kDotBackgroundViewBaseTag];
        dotBackgroundView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
        
        UILabel *label = (UILabel *)[self viewWithTag:kLabelViewBaseTag];
        label.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, label.center.y);
        
        self.progressLineBackgroundView.hidden = YES;
        self.progressLineView.hidden = YES;
        
    }
}

- (CAKeyframeAnimation *)setupKeyframeAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.1),@(1.0),@(1.6), @(1.0)];
    animation.keyTimes = @[@(0.0),@(0.3),@(0.5),@(1.0)];
    animation.calculationMode = kCAAnimationLinear;
    return animation;
}

- (void)setupSeletedDotViewWithIndex:(NSInteger)argIndex animated:(BOOL)animated {
    if (self.targetDotViewIndex >= argIndex) {
        self.targetDotViewIndex = argIndex;
        return;
    }
    
    if (animated) {
        self.isAnimating = YES;
        UIView *dotView = [self viewWithTag:kDotViewBaseTag + self.targetDotViewIndex];
        UILabel *label = (UILabel *)[self viewWithTag:kLabelViewBaseTag + self.targetDotViewIndex];
        CGFloat lineWidth = dotView.center.x - (self.paddingLeft + self.dotDiameter / 2);
        CGRect progressLineViewFrame = self.progressLineView.frame;
        progressLineViewFrame.size.width = lineWidth;
        CGFloat animationDuration = 0;
        if (argIndex != 0) {
            animationDuration = 0.75;
        }
        [UIView animateWithDuration:animationDuration animations:^{
            self.progressLineView.frame = progressLineViewFrame;
        } completion:^(BOOL finished) {
            if (finished) {
                [dotView.layer addAnimation:[self setupKeyframeAnimation] forKey:@"showDotView"];
                dotView.backgroundColor = self.dotSelectedColor;
                [label.layer addAnimation:[self setupKeyframeAnimation] forKey:@"showLabel"];
                label.textColor = self.dotSelectedColor;
                self.targetDotViewIndex++;
                [self setupSeletedDotViewWithIndex:argIndex animated:animated];
                self.isAnimating = NO;
            }
        }];
    }
    else {
        UIView *LastDotView = [self viewWithTag:kDotViewBaseTag + argIndex - 1];
        CGFloat lineWidth = LastDotView.center.x - (self.paddingLeft + self.dotDiameter / 2);
        CGRect progressLineViewFrame = self.progressLineView.frame;
        progressLineViewFrame.size.width = lineWidth;
        self.progressLineView.frame = progressLineViewFrame;
        for (int i = 0; i < argIndex; i++) {
            UIView *dotView = self.dotArray[i];
            dotView.backgroundColor = self.dotSelectedColor;
            UILabel *label = self.descriptionLabelArray[i];
            label.textColor = self.dotSelectedColor;
        }
        self.targetDotViewIndex = argIndex;
    }
    
    
    
}


@end

@implementation XMDotItem

@end

