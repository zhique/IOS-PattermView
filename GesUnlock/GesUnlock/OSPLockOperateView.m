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
typedef enum{
    NormalType = 0,
    ErrorType = 1,
}Result_Type;

#import "OSPLockOperateView.h"

@interface OSPLockOperateView ()

@property (nonatomic, strong) UIImage *pointImage;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSMutableArray *itemArray;

@property (nonatomic, assign) CGPoint lineStartPoint;
@property (nonatomic, assign) CGPoint lineEndPoint;

@property (nonatomic, weak) id<OSPLockOperateViewDelegate>delegate;

@end

@implementation OSPLockOperateView

- (OSPLockOperateView *)initWithFrame:(CGRect)frame withDelegate:(id<OSPLockOperateViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemArray=[NSMutableArray array];
        self.pointImage = [UIImage imageNamed:@"normal.png"];
        self.selectedImage = [UIImage imageNamed:@"point.png"];
        self.backgroundColor=[UIColor clearColor];
        self.userInteractionEnabled = YES;
        self.delegate = delegate;
        self.remainTime = 0.3;
        self.drawType = PureType;
        [self loadViews];
    }
    return self;
}

- (void)loadViews
{
    for (int i=0; i<9; i++) {
        int row=i/3;
        int col=i%3;
        CGFloat item_Width = self.bounds.size.width/2.0/3.0;
        CGFloat item_Padding = self.bounds.size.width/2.0/4.0;
        OSPGuestureItem *item=[[OSPGuestureItem alloc]initWithFrame:CGRectMake(item_Padding+(item_Width+item_Padding)*row, item_Padding+(item_Width+item_Padding)*col, item_Width, item_Width)];
        item.backgroundColor=[UIColor clearColor];
        item.userInteractionEnabled=NO;
        item.tag=i;
        [self addSubview:item];
        [self.itemArray addObject:item];
    }
}

- (void)preparePathViewerWithArray:(NSArray *)path wrongSign:(BOOL)isWrong
{
    for (int i=0;i<self.itemArray.count;i++) {
        OSPGuestureItem *item = self.itemArray[i];
        item.isClicked = NO;
        for (OSPGuestureItem *theitem in path) {
            if (theitem.tag == item.tag) {
                item.selectedColor = isWrong?[UIColor redColor]:item.normalColor;
                item.isClicked = YES;
            }
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.selectedArray=[[NSMutableArray alloc]initWithCapacity:9];
    
    UITouch *touch=[touches anyObject];
    if (touch) {
        for (OSPGuestureItem *item in self.itemArray) {
            CGPoint touchPoint = [touch locationInView:item];
            if ([item pointInside:touchPoint withEvent:nil]) {
                self.lineStartPoint = item.center;
                item.isClicked=YES;
                [self.selectedArray addObject:item];
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch) {
        self.lineEndPoint = [touch locationInView:self];
        
        for (OSPGuestureItem *item in self.itemArray) {
            CGPoint touchPoint = [touch locationInView:item];
            
            if ([item pointInside:touchPoint withEvent:nil]) {
                if (item.isClicked==YES) {
                    break;
                }
                else{
                    item.isClicked=YES;
                    if (self.lineStartPoint.x == 0 && self.lineStartPoint.y == 0) {
                        self.lineStartPoint = item.center;
                    }
                    [self.selectedArray addObject:item];
                }
            }
        }
        
        self.image=[self drawUnlockLineWithType:NormalType confirm:NO];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.image=[self drawUnlockLineWithType:NormalType confirm:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(returnCurrentGesturesPassword:withCheckedBlock:)]) {
        [self.delegate returnCurrentGesturesPassword:self.selectedArray withCheckedBlock:^(BOOL isSucceed) {
            if (!isSucceed) {
                self.image = [self drawUnlockLineWithType:ErrorType confirm:YES];
            }else
                self.image = [self drawUnlockLineWithType:NormalType confirm:YES];
        }];
    }
    self.userInteractionEnabled = NO;
    [self performSelector:@selector(delayToDisappear) withObject:nil afterDelay:self.remainTime];
}

- (void)delayToDisappear
{
    [self outputSelectedButtons];
    self.image = nil;
    self.selectedArray=nil;
    self.userInteractionEnabled = YES;
}

- (void)outputSelectedButtons
{
    self.lineStartPoint = CGPointMake(0, 0);
    for (OSPGuestureItem *item in self.itemArray) {
//        [item setImage:self.pointImage forState:UIControlStateNormal];
        item.selectedColor = [UIColor whiteColor];
        item.isClicked = NO;
        item.isPre = NO;
    }
}

#pragma mark - Draw Line

- (UIImage *)drawUnlockLineWithType:(Result_Type)type confirm:(BOOL)confirm
{
    if (self.lineStartPoint.x == 0 || self.lineStartPoint.y == 0) {
        return nil;
    }
    
    UIImage *image = nil;
    
    UIColor *color = [UIColor whiteColor];
    if (type == ErrorType) {
        color = [UIColor redColor];
    }
    
    CGFloat width = 3.0f;
    CGSize imageContextSize = self.frame.size;
    
    UIGraphicsBeginImageContext(imageContextSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    
    CGContextMoveToPoint(context, self.lineStartPoint.x, self.lineStartPoint.y);
    
    
    for (int i =0;i<self.selectedArray.count;i++) {
        OSPGuestureItem *selectedItem = self.selectedArray[i];
        CGPoint itemCenter = selectedItem.center;
        CGFloat x_b = itemCenter.x;
        CGFloat y_b = itemCenter.y;
        
        if (self.drawType == TriangleType || confirm) {
            if (i > 0) {
                OSPGuestureItem *preItem = self.selectedArray[i-1];
                CGPoint preItemCenter = preItem.center;
                CGFloat x_a = preItemCenter.x;
                CGFloat y_a = preItemCenter.y;
                CGFloat angle = atan((y_b-y_a)/(x_b-x_a));
                if (x_a>x_b) {
                    if (y_a<=y_b) {
                        angle = M_PI - fabs(angle);
                    }else
                        angle = M_PI + angle;
                }
                preItem.isPre = YES;
                preItem.angle = angle;
            }
        }
        
        selectedItem.selectedColor = color;
        selectedItem.isClicked = YES;
        
        CGContextAddLineToPoint(context, x_b, y_b);
        CGContextMoveToPoint(context,x_b,y_b);

    }

    if (confirm == NO) {
        CGContextAddLineToPoint(context, self.lineEndPoint.x, self.lineEndPoint.y);
    }
    
    CGContextStrokePath(context);
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
