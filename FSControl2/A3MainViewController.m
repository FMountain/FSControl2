//
//  A3MainViewController.m
//  FSControl2
//
//  Created by mac on 15/11/23.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "A3MainViewController.h"
#import "A3OneViewController.h"
#import "A3TwoViewController.h"
#import "A3ThreeViewController.h"
#import "A3FourViewController.h"
#import "UIView+A3Extension.h"

@interface A3MainViewController ()<UIScrollViewDelegate>
/** 存放所有的标题按钮 */
@property (nonatomic,strong)NSMutableArray *titleButtons;

/** 当前被选中的按钮 */
@property (nonatomic, weak) UIButton *selectedTitleButton;

/** 存放所有的子控制器的 scrollView */
@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation A3MainViewController
#pragma mark - titleButtons
- (NSMutableArray *)titleButtons
{
    if (!_titleButtons) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    //1. 添加子控制器
    [self setupChildVcs];
    //2.设置导航栏
    [self setupNav];
    //3.添加scrollView
    [self setupScrollView];
    //4.添加scrollView内的每个View的标题栏
    [self setupTitlesView];
    //5.根据scrollView的偏移量添加子控制器的view
    [self addchildVcView];
    
}

/**
 *  1.添加子控制器
 */
- (void)setupChildVcs
{
    A3OneViewController *one     = [[A3OneViewController alloc] init];
    one.title                    = @"one";
    [self addChildViewController:one];
    
    A3TwoViewController *two     = [[A3TwoViewController alloc] init];
    two.title                    = @"two";
    [self addChildViewController:two];
    
    A3ThreeViewController *three = [[A3ThreeViewController alloc] init];
    three.title                  = @"three";
    [self addChildViewController:three];
    
    A3FourViewController *four   = [[A3FourViewController alloc] init];
    four.title                   = @"four";
    [self addChildViewController:four];
}

/**
 *  2.设置导航
 */
- (void)setupNav
{
    UILabel *titleText = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 120, 40)];
    
    // NavigationBar 背景颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20/255.0 green:155/255.0 blue:150/255.0 alpha:1.0]];
    titleText.textColor = [UIColor whiteColor];
    [titleText setFont:[UIFont systemFontOfSize:17.0]];
    [titleText setText:@"父子控制器进阶版"];
    //设置导航栏标题
    self.navigationItem.titleView = titleText;
}

/**
 *  3.添加scrollView
 */
- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame         = self.view.bounds;
    scrollView.pagingEnabled = YES;
    scrollView.delegate      = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    //禁止掉 自动设置scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置内容大小
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count * scrollView.width, 0);
    
}

/**
 *  4.添加标题栏
 */
- (void)setupTitlesView
{
    UIView *titlesView = [[UIView alloc] init];
  
    titlesView.frame = CGRectMake(0, 60, self.view.width, 40);
    titlesView.backgroundColor = [UIColor yellowColor];
    //添加到view
    [self.view addSubview:titlesView];
    //添加标题
    NSUInteger count  = self.childViewControllers.count;

    //size
    CGFloat titleBtnW = titlesView.width / count;
    CGFloat titleBtnH = titlesView.height;

    //遍历标题按钮
    for (int i = 0 ; i < count; i++) {
        //创建
        UIButton *titleBtn = [[UIButton alloc] init];
        titleBtn.tag       = i;
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:titleBtn];
        [self.titleButtons addObject:titleBtn];
        
        //frame
        titleBtn.frame = CGRectMake(i * titleBtnW, 0, titleBtnW, titleBtnH);
        
        //设置
        [titleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        //font
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        //数据
        [titleBtn setTitle:self.childViewControllers[i].title forState:UIControlStateNormal];
       
        //默认点击第一个.
        UIButton *firstBtn = titlesView.subviews.firstObject;
        firstBtn.selected = YES;
        self.selectedTitleButton = firstBtn;
        [firstBtn.titleLabel sizeToFit];
    }
}

- (void)titleBtnClick:(UIButton *)titleButton
{
    //让当前被选中的按钮取消选中
    self.selectedTitleButton.selected = NO;

    //让被点击的按钮变成选中状态
    titleButton.selected              = YES;

    //让被点击的按钮变成当前选中的标题按钮
    self.selectedTitleButton          = titleButton;
    
    //滚动scrollView
    CGPoint offset = self.scrollView.contentOffset;
    offset.x       = titleButton.tag * self.scrollView.width;
    [self.scrollView setContentOffset:offset animated:YES];
}

/**
 *     5.根据scrollView的偏移量添加子控制器的view
 */
- (void)addchildVcView
{
    UIScrollView *scrollView = self.scrollView;
    
    //计算按钮索引
    int index = scrollView.contentOffset.x / scrollView.width;
    //添加对应的子控制器view
    UIViewController *willShowVc = self.childViewControllers[index];
    
    if (willShowVc.isViewLoaded) {
        return;
    }
    
    [scrollView addSubview:willShowVc.view];
    willShowVc.view.frame = scrollView.bounds;
}

#pragma mark - delegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //根据scrollView的偏移量添加子控制器的view
    [self addchildVcView];
}

/**
 * 当scrollView停上滚动的时候 会调用一次(人为拖拽)
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //计算按钮索引
    int index = scrollView.contentOffset.x / scrollView.width;
    UIButton *titleBtn = self.titleButtons[index];
    
    //点击按钮
    [self titleBtnClick:titleBtn];
    
    //根据scrollView的偏移量添加子控制器的view
    [self addchildVcView];

}
@end
