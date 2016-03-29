//
//  OSPLockOperateView.h
//  GesUnlock
//
//  Created by xiao on 3/21/16.
//  Copyright © 2016 zhique. All rights reserved.
//
typedef enum {
    PureType = 0,
    TriangleType,
}Draw_Type;

@protocol OSPLockOperateViewDelegate;

#import "OSPGuestureItem.h"
#import <UIKit/UIKit.h>

typedef void(^CheckedBlock)(BOOL isSucceed);

@interface OSPLockOperateView : UIImageView

@property (nonatomic, assign) float remainTime;
@property (nonatomic) Draw_Type drawType;

- (OSPLockOperateView *)initWithFrame:(CGRect)frame withDelegate:(id<OSPLockOperateViewDelegate>)delegate;

- (void)preparePathViewerWithArray:(NSArray *)path wrongSign:(BOOL)isWrong;

@end
@protocol OSPLockOperateViewDelegate <NSObject>

@required
- (void)returnCurrentGesturesPassword:(NSArray *)password withCheckedBlock:(CheckedBlock)block;

@end