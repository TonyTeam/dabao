//
//  LoginAndRegisterController.m
//  beautyContest
//
//  Created by Tony on 2017/4/23.
//  Copyright © 2017年 iMac. All rights reserved.
//

#import "LoginAndRegisterController.h"
#import "HeLoginVC.h"
#import "HeEnrollVC.h"
#import "HeForGetPasswordVC.h"
#import "Masonry.h"

@interface LoginAndRegisterController ()
@property(nonatomic,strong)UIPageViewController *pageViewController;
@property (nonatomic, strong) HeLoginVC *loginViewController;
@property (nonatomic, strong) HeEnrollVC *registerController;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIView *registerBtnIndicator;
@property (weak, nonatomic) IBOutlet UIView *loginBtnIndicator;

@end

@implementation LoginAndRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [self initializaiton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)initializaiton
{
    [super initializaiton];
}

- (void)initView
{
    [super initView];
    [self setupView];
}

- (void)setupView {
    
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.cornerRadius = 10.0;
    self.containerView.autoresizesSubviews = YES;
    
    self.pageViewController = [[UIPageViewController alloc]
                               initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                               options:@{UIPageViewControllerOptionSpineLocationKey:@10}];//初始化一个PageViewController
    self.pageViewController.view.backgroundColor = [UIColor whiteColor];
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    [self.containerView addSubview:self.pageViewController.view];
    [self addChildViewController:self.pageViewController];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView).insets(UIEdgeInsetsMake(50, 0, 0, 0));
    }];
    
    //    self.pageViewController.view.frame = CGRectMake(0,30,kScreenWidth - 60,self.containerView.bounds.size.height - 30);
    
    
    self.loginViewController = [[HeLoginVC alloc] initWithNibName:@"HeLoginVC" bundle:[NSBundle mainBundle]];
//    self.loginViewController.view.frame = self.containerView.bounds;
    
    [self.pageViewController addChildViewController:self.loginViewController];
    
    self.registerController = [[HeEnrollVC alloc] initWithNibName:@"HeEnrollVC" bundle:[NSBundle mainBundle]];
    [self.pageViewController addChildViewController:self.registerController];
    
    [self.pageViewController setViewControllers:@[self.loginViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.loginBtn.selected = YES;
    self.registerBtnIndicator.backgroundColor = [UIColor clearColor];
}

/*点击注册与登录按钮,分别切换至对应的控制器*/
- (IBAction)onRegister:(UIButton *)sender {
    __weak LoginAndRegisterController *weakSelf = self;
    
    [self.pageViewController setViewControllers:@[self.registerController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finish){
        weakSelf.registerController.navigationController.navigationBarHidden = YES;
        weakSelf.loginViewController.navigationController.navigationBarHidden = YES;
    }];
    //被选中的颜色FF5B65
    //未被选中的颜色E7B3B7
    self.loginBtn.selected = NO;
    self.registerBtn.selected = YES;
    
    self.registerBtnIndicator.backgroundColor = APPDEFAULTORANGE;
    self.loginBtnIndicator.backgroundColor = [UIColor clearColor];
    
}



- (IBAction)onLogin:(UIButton *)sender {
    [self.pageViewController setViewControllers:@[self.loginViewController] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    self.loginBtn.selected = YES;
    self.registerBtn.selected = NO;
    
    self.registerBtnIndicator.backgroundColor = [UIColor clearColor];
    self.loginBtnIndicator.backgroundColor = APPDEFAULTORANGE;
}

- (IBAction)forgetPassword:(id)sender
{
    HeForGetPasswordVC *forgetPaswordVC = [[HeForGetPasswordVC alloc] init];
    forgetPaswordVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:forgetPaswordVC animated:YES];
}

#pragma mark :- UIPageViewController DataSource
- (NSInteger)indexOfViewController:(UIViewController *)vc {
    if (vc == self.loginViewController) {
        return 0;
    } else if (vc == self.registerController){
        return 1;
    }
    return -1;
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index {
    if (index == 0) {
        return self.loginViewController;
    } else if (index == 1) {
        return self.registerController;
    }
    return nil;
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self indexOfViewController:viewController];
    if (index == 0){
        return [self viewControllerAtIndex:++ index];
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSInteger index = [self indexOfViewController:viewController];
    if (index == 1){
        return [self viewControllerAtIndex:-- index];
    }
    return nil;
}


- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers
       transitionCompleted:(BOOL)completed {
    if (completed) {
        if ([self.pageViewController.viewControllers firstObject] == self.loginViewController) {
            [self onLogin:self.loginBtn];
        } else {
            [self onRegister:self.registerBtn];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
