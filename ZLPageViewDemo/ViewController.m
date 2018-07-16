//
//  ViewController.m
//  ZLPageViewDemo
//
//  Created by zhaoliang chen on 2018/7/13.
//  Copyright © 2018年 zhaoliang chen. All rights reserved.
//

#import "ViewController.h"
#import "ZLPageView.h"
#import "PageViewController.h"
#import "Masonry.h"

@interface ViewController ()

@property(nonatomic,strong)ZLPageView* pageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray* array1 = @[@"新闻",@"世界杯",@"今日头条",@"搞笑文章",@"体育",@"军事",@"新闻",@"娱乐",@"国际",@"国内",@"本地"];
    NSArray* colors = @[[UIColor redColor],[UIColor greenColor],[UIColor blueColor],[UIColor yellowColor],[UIColor purpleColor],[UIColor grayColor],[UIColor cyanColor],[UIColor brownColor],[UIColor orangeColor],[UIColor lightGrayColor],[UIColor lightTextColor]];
    NSArray* normal = @[@"tabBar_icon_01",@"tabBar_icon_02",@"tabBar_icon_03",@"tabBar_icon_04",@"tabBar_icon_01",@"tabBar_icon_02",@"tabBar_icon_03",@"tabBar_icon_04",@"tabBar_icon_01",@"tabBar_icon_02"];
    NSArray* selected = @[@"tabBar_icon_01_select",@"tabBar_icon_02_select",@"tabBar_icon_03_select",@"tabBar_icon_04_select",@"tabBar_icon_01_select",@"tabBar_icon_02_select",@"tabBar_icon_03_select",@"tabBar_icon_04_select",@"tabBar_icon_01_select",@"tabBar_icon_02_select"];
    NSMutableArray* vcs = [NSMutableArray new];
    for (int i=0; i<array1.count; i++) {
        PageViewController* vc = [[PageViewController alloc]init];
        vc.view.backgroundColor = colors[i];
        [vc setIndexLabel:array1[i]];
        [vcs addObject:vc];
    }
    
    [self.view addSubview:self.pageView];
    [self.pageView setTitles:array1 normalImages:normal highlightedImages:selected viewcontrollers:vcs];
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.pageView setBedgeForIndex:3 bedge:@"1"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ZLPageView*)pageView {
    if (!_pageView) {
        _pageView = [[ZLPageView alloc]initWithFrame:CGRectZero];
        _pageView.titleHeight = 50;
        _pageView.indicatorColor = [UIColor colorWithWhite:0.4  alpha:1.0];
        _pageView.titleHighlightColor = [UIColor redColor];
        _pageView.titleCanScorll = YES;
        _pageView.indicatorStyle = Block;
        _pageView.tablayoutStyle = ImageRightTextLeft;
    }
    return _pageView;
}


@end
