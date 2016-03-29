//
//  ViewController.m
//  GesUnlock
//
//  Created by Xiao on 3/21/16.
//  Copyright © 2016 Perkinelmer. All rights reserved.
//

#import "ViewController.h"
#import "GesturesUnLock.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (IBAction)btnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 10:
        {   //set
            GesturesUnLock *vc = [[GesturesUnLock alloc]initWithExpectedMode:SetMode];
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        case 20:
        {   //change
            GesturesUnLock *vc = [[GesturesUnLock alloc]initWithExpectedMode:EditMode];
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        case 30:
        {   //unlock
            GesturesUnLock *vc = [[GesturesUnLock alloc]initWithExpectedMode:UnlockMode];
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
