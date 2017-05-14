//
//  HeInstructionView.m
//  com.mant.iosClient
//
//  Created by 何 栋明 on 13-11-13.
//  Copyright (c) 2013年 何栋明. All rights reserved.
//

#import "HeInstructionView.h"
#import "AppDelegate.h"

#define DefaultTabBarImageHilightedTintColor             [UIColor colorWithRed:120.0f/255.0f green:202.0f/255.0f blue:255.0f/255.0f alpha:1.0]
#define DefaultTabBarTitleHilightedTintColor             [UIColor orangeColor]

@interface HeInstructionView ()
@property(strong,nonatomic)NSArray *launchArray;

@end

@implementation HeInstructionView
@synthesize loadSucceedFlag;
@synthesize launchArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        self.navigationItem.titleView = label;
        label.text = @"大寶";
        [label sizeToFit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    myscrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGH)];
    myscrollView.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:230.0f/255.0f];
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREENHEIGH - 40, SCREENWIDTH, 30)];
    images = [NSMutableArray arrayWithObjects:@"ios_guide_step_1.jpg",@"ios_guide_step_2.jpg", nil];
    
    [self.view addSubview:myscrollView];
    [self setupPage];
    [self.view addSubview:pageControl];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self hideHud];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    self.loadSucceedFlag = 1;
}


-(void)setupPage
{
    myscrollView.delegate = self;
    [myscrollView setBackgroundColor:[UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:230.0f/255.0f]];
    [myscrollView setCanCancelContentTouches:NO];
    myscrollView.clipsToBounds = YES;
    myscrollView.scrollEnabled = YES;
    myscrollView.pagingEnabled = YES;
    myscrollView.directionalLockEnabled = NO;
    myscrollView.alwaysBounceHorizontal = NO;
    myscrollView.alwaysBounceVertical = NO;
    myscrollView.showsHorizontalScrollIndicator = NO;
    myscrollView.showsVerticalScrollIndicator = NO;
    
    NSInteger nimages = 0;
    CGFloat cx = 0;
    for (NSString *imagepath in images) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imagepath]];
        imageView.frame = CGRectZero;
        CGRect rect = myscrollView.frame;
        rect.size.height = SCREENHEIGH;
        rect.size.width = SCREENWIDTH;
        rect.origin.x = cx;
        rect.origin.y = 0;
        imageView.frame = rect;
        
        [myscrollView addSubview:imageView];
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        if (nimages == [images count] - 1) {
            enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [enterButton setTitle:@"马上体验" forState:UIControlStateNormal];
            [enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [enterButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
            UIScreen *mainScreen = [UIScreen mainScreen];
            
            CGFloat buttonW = 150;
            CGFloat buttonH = 40;
            CGFloat buttonX = (SCREENWIDTH - buttonW)/2.0;
            CGFloat buttonY = SCREENHEIGH - 75;
            
            enterButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
            [enterButton setBackgroundImage:[Tool buttonImageFromColor:APPDEFAULTORANGE withImageSize:enterButton.frame.size] forState:UIControlStateNormal];
            //            enterButton.layer.borderWidth = 0;
            //            enterButton.layer.borderColor = [UIColor clearColor].CGColor;
            myscrollView.userInteractionEnabled = YES;
            imageView.userInteractionEnabled = YES;
            [enterButton addTarget:self action:@selector(enterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [enterButton setAlpha:0.8];
            
            [imageView addSubview:enterButton];
            enterButton.hidden = self.hideEnterButton;
        }
        
        cx += myscrollView.frame.size.width;
        nimages++;
    }
    pageControl.numberOfPages = nimages;
    pageControl.currentPage = 0;
    [myscrollView setContentSize:CGSizeMake(cx, [myscrollView bounds].size.height)];
    
}

-(void)enterButtonClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:nil];
    //此处应该做判断
//    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
//    TabBarController *mainViewController = (TabBarController*)[storyboard instantiateInitialViewController];
//    
//    //    TabBarController *tabBarVC = [[TabBarController alloc] init];
//    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    //    appDelegate.viewController = tabBarVC;
//    [appDelegate.window setRootViewController:mainViewController];
//    [appDelegate.window makeKeyAndVisible];
}


-(void)initUser
{
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (pageControlIsChangingPage) {
        
        return;
    }
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    pageControl.currentPage = page;
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlIsChangingPage = NO;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
