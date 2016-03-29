//
//  OSPGuestureItem.m
//  GesUnLock
//
//  Created by xiao on 3/21/16.
//  Copyright © 2016 zhique. All rights reserved.
//

#import "OSPGuestureItem.h"

@implementation OSPGuestureItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isClicked=NO;
        self.normalColor = [UIColor whiteColor];
        self.selectedColor = [UIColor whiteColor];
        self.currentColor = self.normalColor;
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if(self.isClicked){
        self.currentColor = self.selectedColor;
    }else
        self.currentColor = self.normalColor;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.currentColor.CGColor);
    CGContextSetLineWidth(context, 1.5);
    CGContextAddArc(context, self.bounds.size.width/2, self.bounds.size.height/2, self.bounds.size.width/2-1.5, 0, M_PI*2, 0);
    CGContextDrawPath(context, kCGPathStroke);
    if(self.isClicked){
        CGContextSetFillColorWithColor(context, self.currentColor.CGColor);
        CGContextAddArc(context, self.bounds.size.width/2, self.bounds.size.height/2, (self.bounds.size.width-3)/4, 0, M_PI*2, 0);
        CGContextDrawPath(context, kCGPathFill);
        if (self.isPre) {
            CGFloat r = self.bounds.size.width;
            CGFloat l = (r-3)/5;
            
            CGPoint sPoint[3];
            
            CGFloat zero_x = r/2+r*3/8*cos(self.angle)+l*sin(M_PI/3)*cos(self.angle)/2.0;
            CGFloat zero_y = r/2+r*3/8*sin(self.angle)+l*sin(M_PI/3)*sin(self.angle)/2.0;
            
            sPoint[0] = CGPointMake(zero_x, zero_y);
            sPoint[1] = CGPointMake(zero_x-l*cos(M_PI/6+self.angle), zero_y-l*sin((M_PI/6+self.angle)));
            sPoint[2] = CGPointMake(zero_x-l*cos(self.angle-M_PI/6), zero_y-l*sin((self.angle-M_PI/6)));
            CGContextAddLines(context, sPoint, 3);
            CGContextClosePath(context);
            CGContextFillPath(context);
        }
    }
}

- (void)setIsClicked:(BOOL)isClicked
{
    _isClicked = isClicked;
    [self setNeedsDisplay];
}

@end
