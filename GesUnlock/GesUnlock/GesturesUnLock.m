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
#define MIN_NUM 3

#import "GesturesUnLock.h"
#import "OSPLockOperateView.h"

@interface GesturesUnLock ()<OSPLockOperateViewDelegate>
{
    OSPLockOperateView *_lockView;
    OSPLockOperateView *lockViewer;
}

@end

@implementation GesturesUnLock

- (id)initWithExpectedMode:(OperationMode)mode
{
    self = [super init];
    if (self) {
        self.mode = mode;
        switch (mode) {
            case SetMode:
            {
                //
                self.setFlag = YES;
                NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:@"YES",@"isLock",nil,@"password", nil];
                NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
                [userDefaults setObject:dic forKey:@"gesturesLock"];
                [userDefaults synchronize];
            }
                break;
            case EditMode:
            {
                self.reSet = YES;
            }
                break;
            case UnlockMode:
            {
                //
            }
                break;
            default:
                break;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rightPassword=[NSMutableArray array];
    self.waitSure=[NSMutableArray array];
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[userDefaults objectForKey:@"gesturesLock"];
    self.rightPassword=[NSMutableArray arrayWithArray:[dic objectForKey:@"password"]];
    NSLog(@"-----right password:%@",self.rightPassword);
    self.setFlag = self.rightPassword.count>0?NO:YES;
    if (self.rightPassword.count<=0){
        self.reSet = NO;
    }
    self.view.backgroundColor = [UIColor blackColor];
    
    [self initView];
    if (self.mode == EditMode || self.mode == SetMode) {
        [self showPathGraphicsOnViewWithPassword:nil];
    }else{
        self.imageView.image = [UIImage imageNamed:@"user.png"];
    }
}

-(void)initView
{
    _lockView=[[OSPLockOperateView alloc]initWithFrame:self.unLockContentView.bounds withDelegate:self];
    _lockView.remainTime = 0.3;
    _lockView.drawType = TriangleType;
    if (self.mode == UnlockMode) {
        _lockView.drawType = PureType;
    }
    NSLog(@"%@",[[UIApplication sharedApplication].windows.firstObject description]);
    [self.unLockContentView addSubview:_lockView];
    
    if (self.reSet==YES) {
        if (self.rightPassword!=nil) {
            self.lblHint.text=@"请绘制原始密码";
        }
        else{
            self.lblHint.text=@"您从未设置过手势密码，直接绘制";
            self.reSet = NO;
            self.setFlag = YES;
        }
    }
    else if (self.setFlag==YES) {
        self.lblHint.text=@"请设置密码";
    }
    else
        self.lblHint.text=@"请滑动手势解锁";
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark OSPLockOperateViewDelegate
- (void)returnCurrentGesturesPassword:(NSArray *)password withCheckedBlock:(CheckedBlock)block
{
    self.lblHint.textColor = [UIColor whiteColor];
    self.passwordWrong = NO;
    BOOL isRight = YES;
    if (password.count<1) {
        NSLog(@"未选择，退出");
        //        return;
    }
    else if (password.count<MIN_NUM) {
        self.lblHint.text=[NSString stringWithFormat:@"At least %d points required",MIN_NUM];
        self.lblHint.textColor = [UIColor redColor];
        for (int i=0; i<password.count; i++) {
            OSPGuestureItem *btn=[password objectAtIndex:i];
            btn.isClicked=NO;
        }
        isRight = NO;
        self.passwordWrong = YES;
    }
    else if (self.setFlag==NO&&self.reSet==YES) {
        NSMutableArray *currentNumbers=[NSMutableArray array];
        for (int i=0; i<password.count; i++) {
            OSPGuestureItem *btn=[password objectAtIndex:i];
            NSNumber *num=[NSNumber numberWithInt:(int)btn.tag];
            [currentNumbers addObject:num];
            btn.isClicked=NO;
        }
        if ([currentNumbers isEqualToArray:self.rightPassword]) {
            self.lblHint.text=@"密码正确，现在请输入新密码";
            NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
            [userDefaults removeObjectForKey:@"gesturesLock"];
            self.reSet=NO;
            self.setFlag = YES;
            //            return;
        }
        else{
            self.lblHint.text=@"原密码错误";
            self.lblHint.textColor = [UIColor redColor];
            isRight = NO;
            self.passwordWrong = YES;
        }
    }
    else if (self.setFlag==YES&&self.reSet==NO){
        if (self.sureFlag==NO) {
            for (int i=0; i<password.count; i++) {
                OSPGuestureItem *btn=[password objectAtIndex:i];
                NSNumber *num=[NSNumber numberWithInt:(int)btn.tag];
                [self.waitSure addObject:num];
                btn.isClicked=NO;
            }
            self.lblHint.text=@"重复上一次的密码";
            self.sureFlag=YES;
            //            return;
        }
        else if (self.sureFlag==YES){
            NSMutableArray *currentNumbers=[NSMutableArray array];
            for (int i=0; i<password.count; i++) {
                OSPGuestureItem *btn=[password objectAtIndex:i];
                NSNumber *num=[NSNumber numberWithInt:(int)btn.tag];
                [currentNumbers addObject:num];
                btn.isClicked=NO;
            }
            if ([currentNumbers isEqualToArray:self.waitSure]) {
                NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:@"YES",@"isLock",currentNumbers,@"password", nil];
                NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
                [userDefaults setObject:dic forKey:@"gesturesLock"];
                [userDefaults synchronize];
                self.lblHint.text=@"密码设置成功";
                self.setFlag=NO;
                NSString *switchOn=@"YES";
                [self performSelector:@selector(popToPreVC:) withObject:switchOn afterDelay:1];
                //                return;
            }
            else{
                self.lblHint.text=@"重复密码错误，请重新设置";
                self.lblHint.textColor = [UIColor redColor];
                [self.waitSure removeAllObjects];
                self.sureFlag=NO;
                isRight = NO;
                self.passwordWrong = YES;
                //                return;
            }
        }
    }
    else if (self.setFlag==NO)
    {
        NSMutableArray *checkArray=[NSMutableArray array];
        NSLog(@"解锁");
        NSLog(@"selectedButtons.count:%lu:正确密码:%@",(unsigned long)password.count,self.rightPassword);
        for (int i=0; i<password.count; i++) {
            OSPGuestureItem *btn=[password objectAtIndex:i];
            NSNumber *num=[NSNumber numberWithInt:(int)btn.tag];
            [checkArray addObject:num];
            btn.isClicked=NO;
        }
        if ([checkArray isEqualToArray:self.rightPassword]) {
            self.lblHint.text=@"解密成功";
            [self popToPreVC:nil];
        }
        else{
            self.lblHint.text=@"密码错误，请重试";
            self.lblHint.textColor = [UIColor redColor];
            
            isRight = NO;
            self.passwordWrong = YES;
            NSLog(@"密码错误，请重试");
        }
    }
    if (block) {
        block(isRight);
    }
    [self showPathGraphicsOnViewWithPassword:password];
}

- (void)showPathGraphicsOnViewWithPassword:(NSArray *)password
{
    if (self.mode == EditMode) {
        if (!lockViewer) {
            lockViewer = [[OSPLockOperateView alloc]initWithFrame:self.imageView.bounds withDelegate:nil];
            [self.imageView addSubview:lockViewer];
        }
        [lockViewer preparePathViewerWithArray:password wrongSign:self.passwordWrong];
    }
}

- (IBAction)back:(id)sender {
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    NSDictionary *dic=[userDefaults objectForKey:@"gesturesLock"];
    if (dic==nil) {
        UIAlertView *lockAlert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"您尚未设置手势密码,仍然要退出吗?" delegate:self cancelButtonTitle:@"继续设置" otherButtonTitles:@"退出", nil];
        [lockAlert show];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma -mark     UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        return;
    }
}

-(void)popToPreVC:(NSString *)switchOn
{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"popToPreVC");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
