//
//  XMDotProgressView.h
//  XMDotProgressView
//
//  Created by xiaoming on 14/11/27.
//  Copyright (c) 2014年 XiaoMing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMDotProgressView : UIView

@property (nonatomic, strong) UIColor *dotSelectedColor;
@property (nonatomic, strong) UIColor *dotUnseletedColor;
@property (nonatomic, assign) CGFloat dotDiameter; //default is 10
@property (nonatomic, assign) CGFloat paddingLeft; //default is 10 第一个点与view左边距，注意从圆的最左边算起
@property (nonatomic, assign) CGFloat progressLineHeight; //default is 2;
@property (nonatomic, assign, readonly) NSInteger seletedCount; // default is 0
@property (nonatomic, strong, readonly) NSArray *dotItemArray;  //里面是 YBSDotItem

/**
 *  设置方法，必须在设置完属性之后调用，否则设置的属性无效,这个初始化方法没有dotView下面的描述label
 *
 *  @param argTotalDotCount <#argTotalDotCount description#>
 */
- (void)setupWithTotalDotCount:(NSInteger)argTotalDotCount;

/**
 *  初始化设置方法，注意array的item是YBSDotItem，这个初始化方法有描述label
 *
 *  @param argArray <#argArray description#>
 */
- (void)setupWithDotItem:(NSArray *)argArray;


- (void)setSeletedCount:(NSInteger)seletedCount;

- (void)setSeletedCount:(NSInteger)seletedCount animated:(BOOL)animated;



@end


@interface XMDotItem : NSObject

@property (nonatomic, copy) NSString *dotDescription;
@property (nonatomic, assign) NSInteger dotStatus;

@end
