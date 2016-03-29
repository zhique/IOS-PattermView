//
//  GesturesUnLock.h
//  GesUnLock
//
//  Created by xiao on 3/21/16.
//  Copyright © 2016 zhique. All rights reserved.
//
typedef enum {
    UnlockMode = 0,
    EditMode = 1,
    SetMode = 2,
}OperationMode;

#import "OSPGuestureItem.h"
#import <UIKit/UIKit.h>

@interface GesturesUnLock : UIViewController<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lblHint;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *unLockContentView;
@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (nonatomic, strong) NSMutableArray *rightPassword;
@property (nonatomic, strong) NSMutableArray *waitSure;

@property (nonatomic) BOOL reSet;
@property (nonatomic) BOOL setFlag;// if setFlag is Yes, now you can set a new gestures password
@property (nonatomic) BOOL sureFlag; 
@property (nonatomic) BOOL isHomePage;
@property (nonatomic) BOOL passwordWrong;

@property (nonatomic, assign) OperationMode mode;

- (id)initWithExpectedMode:(OperationMode)mode;

@end
