//
//  PageViewController.m
//  ZLPageViewDemo
//
//  Created by zhaoliang chen on 2018/7/13.
//  Copyright © 2018年 zhaoliang chen. All rights reserved.
//

#import "PageViewController.h"
#import "Masonry.h"

@interface PageViewController ()

@property(nonatomic,strong)UILabel* label;

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setIndexLabel:(NSString *)str {
    self.label.text = str;
}

- (UILabel*)label {
    if (!_label) {
        _label = [UILabel new];
        _label.font = [UIFont systemFontOfSize:30];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.textColor = [UIColor whiteColor];
    }
    return _label;
}

@end
