/*
 * Copyright (C) 2016 zhique
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
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