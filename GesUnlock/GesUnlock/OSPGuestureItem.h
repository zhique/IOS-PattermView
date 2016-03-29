//
//  OSPGuestureItem.h
//  GesUnLock
//
//  Created by xiao on 3/21/16.
//  Copyright © 2016 zhique. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface OSPGuestureItem : UIView

@property (nonatomic) UIColor *normalColor;
@property (nonatomic) UIColor *selectedColor;
@property (nonatomic) UIColor *currentColor;
@property (nonatomic) BOOL isClicked;
@property (nonatomic) BOOL isPre;

@property (nonatomic) CGFloat angle;

@end
