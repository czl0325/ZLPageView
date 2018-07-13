//
//  ZLPageView.m
//  yunkuang
//
//  Created by qipai on 2018/4/3.
//  Copyright © 2018年 ulink. All rights reserved.
//

#import "ZLPageView.h"
#import "Masonry.h"

@interface ZLPageView()
<UIScrollViewDelegate>
{
    NSInteger laseIndex;
}

@property(nonatomic,strong)UIScrollView* scrollViewTitle;
@property(nonatomic,strong)UIScrollView* scrollViewController;
@property(nonatomic,strong)UIView* indicatorView;

@property(nonatomic,copy)NSArray<NSString*>* titles;
@property(nonatomic,strong)NSMutableArray* arrayLabels;
@property(nonatomic,copy)NSArray<UIViewController*>* viewcontrollers;
@property(nonatomic,strong)NSMutableArray* arrayViewcontrollers;

@property(nonatomic,assign)BOOL isTouch;
@property(nonatomic,assign)CGFloat oldX;

@end

@implementation ZLPageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleCanScorll = NO;
        self.titleHeight = 80;
        self.titleBackColor = [UIColor whiteColor];
        self.titleNormalColor = [UIColor blackColor];
        self.titleHighlightColor = [UIColor redColor];
        self.indicatorColor = [UIColor orangeColor];
        self.currentIndex = 0;
        self.indicatorWidth = -1;
        self.indicatorHeight = 1.5;
        self.indicatorStyle = Line;
        
        self.oldX = 0;
        self.isTouch = NO;
        
        laseIndex = self.currentIndex;
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray<NSString*>*)titles viewcontrollers:(NSArray<UIViewController*>*)viewcontrollers {
    if (self = [self initWithFrame:CGRectZero]) {
        self.titles = titles;
        self.viewcontrollers = viewcontrollers;
        [self setupUI];
    }
    return self;
}

- (void)setTitles:(NSArray<NSString*>*)titles viewcontrollers:(NSArray<UIViewController*>*)viewcontrollers {
    self.titles = titles;
    self.viewcontrollers = viewcontrollers;
    [self setupUI];
}

- (void)setTitleCanScorll:(BOOL)titleCanScorll {
    _titleCanScorll = titleCanScorll;
    [self setupUI];
}

- (void)setupUI {
    [self.arrayLabels removeAllObjects];
    [self.arrayViewcontrollers removeAllObjects];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (self.titles.count == 0) {
        return;
    }
    
    [self addSubview:self.scrollViewTitle];
    [self.scrollViewTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(self);
        make.height.mas_equalTo(self.titleHeight);
    }];
    
    UIView* contentTitle = [UIView new];
    contentTitle.backgroundColor = self.titleBackColor;
    contentTitle.layer.borderColor = [UIColor blackColor].CGColor;
    contentTitle.layer.shadowColor = [UIColor blackColor].CGColor;
    contentTitle.layer.shadowOffset = CGSizeMake(0, 10);
    contentTitle.layer.shadowOpacity = 0.4;
    contentTitle.layer.shadowRadius = 0.5;
    contentTitle.layer.shouldRasterize = YES;
    [self.scrollViewTitle addSubview:contentTitle];
    [contentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollViewTitle);
        make.height.mas_equalTo(self.scrollViewTitle);
    }];
    
    [contentTitle addSubview:self.indicatorView];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(contentTitle);
    }];
    
    UILabel* temp = nil;
    for (int i=0; i<self.titles.count; i++) {
        UILabel* label = [UILabel new];
        label.textColor = self.titleNormalColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.text = self.titles[i];
        label.tag = i;
        label.userInteractionEnabled = YES;
        if (i==self.currentIndex) {
            label.textColor = self.titleHighlightColor;
        } else {
            label.textColor = self.titleNormalColor;
        }
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTouchTitle:)];
        [label addGestureRecognizer:tap];
        [contentTitle addSubview:label];
        if (self.titleCanScorll) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentTitle);
                make.width.mas_equalTo([self getMaxWidth]);
                make.top.mas_equalTo(0);
                if (temp == nil) {
                    make.left.mas_equalTo(0);
                } else {
                    make.left.mas_equalTo(temp.mas_right);
                }
            }];
        } else {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(contentTitle);
                make.width.mas_equalTo(self.scrollViewTitle.mas_width).dividedBy(self.titles.count*1.0);
                make.top.mas_equalTo(0);
                if (temp == nil) {
                    make.left.mas_equalTo(0);
                } else {
                    make.left.mas_equalTo(temp.mas_right);
                }
            }];
        }
        temp = label;
        [self.arrayLabels addObject:label];
        if (i==self.titles.count-1) {
            [contentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(label.mas_right);
            }];
        }
    }
    
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        UILabel* label = self.arrayLabels[self.currentIndex];
        make.centerX.mas_equalTo(label);
        if (self.indicatorStyle == Line) {
            make.height.mas_equalTo(self.indicatorHeight);
        } else {
            make.height.mas_equalTo(label);
        }
        if (self.indicatorWidth <= 0) {
            make.width.mas_equalTo(label);
        } else {
            make.width.mas_equalTo(self.indicatorWidth);
        }
    }];
    //[self sendSubviewToBack:self.indicatorView];
    
    [self addSubview:self.scrollViewController];
    [self.scrollViewController mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.mas_equalTo(self);
        make.top.mas_equalTo(self.scrollViewTitle.mas_bottom);
    }];
    
    UIView* contentController = [UIView new];
    contentController.backgroundColor = [UIColor redColor];
    [self.scrollViewController addSubview:contentController];
    [contentController mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollViewController);
        make.height.mas_equalTo(self.scrollViewController);
    }];
    
    if (self.viewcontrollers.count == 0) {
        return;
    }
    
    UIViewController* tempVC = nil;
    for (int i=0; i<self.viewcontrollers.count; i++) {
        UIViewController* vc = self.viewcontrollers[i];
        //[self.viewController addChildViewController:vc];
        [contentController addSubview:vc.view];
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.mas_equalTo(contentController);
            make.width.mas_equalTo(self.scrollViewController);
            if (tempVC == nil) {
                make.left.mas_equalTo(0);
            } else {
                make.left.mas_equalTo(tempVC.view.mas_right);
            }
        }];
        tempVC = vc;
        if (i==self.viewcontrollers.count-1) {
            [contentController mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(vc.view.mas_right);
            }];
        }
        [self.arrayViewcontrollers addObject:vc];
    }
}

- (void)onTouchTitle:(UIGestureRecognizer*)sender {
    if (self.currentIndex == sender.view.tag) {
        return ;
    }
    self.isTouch = YES;
    UILabel* label = self.arrayLabels[sender.view.tag];
    for (int i=0; i<self.arrayLabels.count; i++) {
        UILabel* l = self.arrayLabels[i];
        if (i==sender.view.tag) {
            l.textColor = self.titleHighlightColor;
        } else {
            l.textColor = self.titleNormalColor;
        }
    }
    [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(label);
        if (self.indicatorStyle == Line) {
            make.height.mas_equalTo(self.indicatorHeight);
        } else {
            make.height.mas_equalTo(label);
        }
        make.bottom.mas_equalTo(self.scrollViewTitle);
        if (self.indicatorWidth <= 0) {
            make.width.mas_equalTo(label);
        } else {
            make.width.mas_equalTo(self.indicatorWidth);
        }
    }];
    [self.scrollViewController setContentOffset:CGPointMake(sender.view.tag*self.scrollViewController.frame.size.width, 0) animated:YES];
    [UIView animateWithDuration:0.2f animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    } ];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    laseIndex = self.currentIndex;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isTouch) {
        return ;
    }
    CGFloat offsetX = scrollView.contentOffset.x - self.oldX;
    self.oldX = scrollView.contentOffset.x;
    UILabel* label = self.arrayLabels[self.currentIndex];
    CGFloat move = (label.frame.size.width / self.scrollViewController.frame.size.width) * offsetX;
    //CGFloat newX = self.indicatorView.centerX + move;
    //self.indicatorView.left += move;
    CGFloat newLeft = self.indicatorView.frame.origin.x + move;
    [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(newLeft);
        if (self.indicatorStyle == Line) {
            make.height.mas_equalTo(self.indicatorHeight);
        } else {
            make.height.mas_equalTo(label);
        }
        make.bottom.mas_equalTo(self.scrollViewTitle);
        if (self.indicatorWidth <= 0) {
            make.width.mas_equalTo(label);
        } else {
            make.width.mas_equalTo(self.indicatorWidth);
        }
    }];
    [self.indicatorView setNeedsLayout];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.oldX = scrollView.contentOffset.x;
    UILabel* label = self.arrayLabels[self.currentIndex];
    for (int i=0; i<self.arrayLabels.count; i++) {
        UILabel* l = self.arrayLabels[i];
        if (i==self.currentIndex) {
            l.textColor = self.titleHighlightColor;
        } else {
            l.textColor = self.titleNormalColor;
        }
    }
    [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(label);
        if (self.indicatorStyle == Line) {
            make.height.mas_equalTo(self.indicatorHeight);
        } else {
            make.height.mas_equalTo(label);
        }
        make.bottom.mas_equalTo(self.scrollViewTitle);
        if (self.indicatorWidth <= 0) {
            make.width.mas_equalTo(label);
        } else {
            make.width.mas_equalTo(self.indicatorWidth);
        }
    }];
    [self adjustScrollTitle];
    //NSLog(@"当前的index = %zd", self.currentIndex);
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.oldX = scrollView.contentOffset.x;
    self.isTouch = NO;
    UILabel* label = self.arrayLabels[self.currentIndex];
    for (int i=0; i<self.arrayLabels.count; i++) {
        UILabel* l = self.arrayLabels[i];
        if (i==self.currentIndex) {
            l.textColor = self.titleHighlightColor;
        } else {
            l.textColor = self.titleNormalColor;
        }
    }
    [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(label);
        if (self.indicatorStyle == Line) {
            make.height.mas_equalTo(self.indicatorHeight);
        } else {
            make.height.mas_equalTo(label);
        }
        make.bottom.mas_equalTo(self.scrollViewTitle);
        if (self.indicatorWidth <= 0) {
            make.width.mas_equalTo(label);
        } else {
            make.width.mas_equalTo(self.indicatorWidth);
        }
    }];
    [self adjustScrollTitle];
    //NSLog(@"当前的index = %zd", self.currentIndex);
}

- (void)setTitleHeight:(CGFloat)titleHeight {
    _titleHeight = titleHeight;
    [self.scrollViewTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.titleHeight);
    }];
}

- (void)setIndicatorColor:(UIColor *)indicatorColor {
    _indicatorColor = indicatorColor;
    self.indicatorView.backgroundColor = indicatorColor;
}

- (void)setIndicatorWidth:(CGFloat)indicatorWidth {
    if (indicatorWidth <= 0) {
        return ;
    }
    _indicatorWidth = indicatorWidth;
    [self.indicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(indicatorWidth);
    }];
}

- (void)setIndicatorStyle:(IndicatorStyle)indicatorStyle {
    _indicatorStyle = indicatorStyle;
    if (self.arrayLabels.count > 0 && self.currentIndex < self.arrayLabels.count) {
        [self.indicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
            UILabel* label = self.arrayLabels[self.currentIndex];
            if (self.indicatorStyle == Line) {
                make.height.mas_equalTo(self.indicatorHeight);
            } else {
                make.height.mas_equalTo(label);
            }
        }];
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (_currentIndex != currentIndex) {
        laseIndex = _currentIndex;
        _currentIndex = currentIndex;
        self.isTouch = YES;
        UILabel* label = self.arrayLabels[currentIndex];
        for (int i=0; i<self.arrayLabels.count; i++) {
            UILabel* l = self.arrayLabels[i];
            if (i==currentIndex) {
                l.textColor = self.titleHighlightColor;
            } else {
                l.textColor = self.titleNormalColor;
            }
        }
        [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(label);
            if (self.indicatorStyle == Line) {
                make.height.mas_equalTo(self.indicatorHeight);
            } else {
                make.height.mas_equalTo(label);
            }
            make.bottom.mas_equalTo(self.scrollViewTitle);
            if (self.indicatorWidth <= 0) {
                make.width.mas_equalTo(label);
            } else {
                make.width.mas_equalTo(self.indicatorWidth);
            }
        }];
        [self performSelector:@selector(scrollToPosition) withObject:nil afterDelay:0.01f];
    }
}

- (void)scrollToPosition {
    [self.scrollViewController setContentOffset:CGPointMake(self.currentIndex*self.scrollViewController.frame.size.width, 0) animated:NO];
    self.isTouch = NO;
}

- (UIScrollView*)scrollViewTitle {
    if (!_scrollViewTitle) {
        _scrollViewTitle = [[UIScrollView alloc]initWithFrame:CGRectZero];
    }
    return _scrollViewTitle;
}

- (UIScrollView*)scrollViewController {
    if (!_scrollViewController) {
        _scrollViewController = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _scrollViewController.pagingEnabled = YES;
        _scrollViewController.delegate = self;
    }
    return _scrollViewController;
}

- (UIView*)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [UIView new];
        _indicatorView.backgroundColor = self.indicatorColor;
    }
    return _indicatorView;
}
                               
- (NSMutableArray*)arrayLabels {
    if (!_arrayLabels) {
        _arrayLabels = [NSMutableArray new];
    }
    return _arrayLabels;
}

- (NSMutableArray*)arrayViewcontrollers {
    if (!_arrayViewcontrollers) {
        _arrayViewcontrollers = [NSMutableArray new];
    }
    return _arrayViewcontrollers;
}

- (CGFloat)getMaxWidth {
    if (self.titles.count < 1) {
        return 0;
    }
    CGFloat max = 0;
    for (int i=0; i<self.titles.count; i++) {
        NSString* str = self.titles[i];
        CGFloat width = [str boundingRectWithSize:CGSizeMake(1000000, self.titleHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil].size.width;
        if (width > max) {
            max = width;
        }
    }
    return max + 30;
}

- (void)adjustScrollTitle {
    if (self.titleCanScorll) {
        if (self.currentIndex > laseIndex) {
            if (self.indicatorView.center.x > self.scrollViewTitle.contentOffset.x + self.scrollViewTitle.frame.size.width/2) {
                if (self.indicatorView.center.x+self.scrollViewTitle.frame.size.width/2>self.scrollViewTitle.contentSize.width) {
                    [self.scrollViewTitle setContentOffset:CGPointMake(self.scrollViewTitle.contentSize.width-self.scrollViewTitle.frame.size.width,0) animated:YES];
                } else {
                    [self.scrollViewTitle setContentOffset:CGPointMake(self.indicatorView.center.x-self.scrollViewTitle.frame.size.width/2,0) animated:YES];
                }
            }
        } else if (self.currentIndex < laseIndex) {
            if (self.indicatorView.center.x < self.scrollViewTitle.contentSize.width - self.scrollViewTitle.frame.size.width/2) {
                if (self.indicatorView.center.x-self.scrollViewTitle.frame.size.width/2<0) {
                    [self.scrollViewTitle setContentOffset:CGPointMake(0,0) animated:YES];
                } else {
                    [self.scrollViewTitle setContentOffset:CGPointMake(self.indicatorView.center.x-self.scrollViewTitle.frame.size.width/2,0) animated:YES];
                }
            }
        }
    }
}

@end
