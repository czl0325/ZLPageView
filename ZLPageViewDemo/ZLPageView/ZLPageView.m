//
//  ZLPageView.m
//  yunkuang
//
//  Created by qipai on 2018/4/3.
//  Copyright © 2018年 ulink. All rights reserved.
//

#import "ZLPageView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface ZLPageView()
<UIScrollViewDelegate>
{
    NSInteger laseIndex;
}

@property(nonatomic,strong)UIScrollView* scrollViewTitle;
@property(nonatomic,strong)UIScrollView* scrollViewController;
@property(nonatomic,strong)UIView* indicatorView;

@property(nonatomic,copy)NSArray<NSString*>* titles;
@property(nonatomic,copy)NSArray<NSString*>* normalImages;
@property(nonatomic,copy)NSArray<NSString*>* highlightedImages;
@property(nonatomic,copy)NSArray<UIViewController*>* viewcontrollers;

@property(nonatomic,strong)NSMutableArray* arrayTitleViews;
@property(nonatomic,strong)NSMutableArray* arrayLabels;
@property(nonatomic,strong)NSMutableArray* arrayImageViews;
@property(nonatomic,strong)NSMutableArray* arrayViewcontrollers;
@property(nonatomic,strong)NSMutableArray* arrayBedges;

@property(nonatomic,assign)BOOL isTouch;
@property(nonatomic,assign)CGFloat oldX;

@end

@implementation ZLPageView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray<NSString*>*)titles viewcontrollers:(NSArray<UIViewController*>*)viewcontrollers {
    if (self = [self init]) {
        [self setTitles:titles viewcontrollers:viewcontrollers];
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray<NSString*>*)titles normalImages:(NSArray<NSString*>*)normalImages highlightedImages:(NSArray<NSString*>*)highlightedImages viewcontrollers:(NSArray<UIViewController*>*)viewcontrollers {
    if (self = [self init]) {
        [self setTitles:titles normalImages:normalImages highlightedImages:highlightedImages viewcontrollers:viewcontrollers];
    }
    return self;
}

- (void)initData {
    self.titleCanScorll = NO;
    self.titleHeight = 80;
    self.titleBackColor = [UIColor whiteColor];
    self.titleNormalColor = [UIColor blackColor];
    self.titleHighlightColor = [UIColor redColor];
    self.titleFont = [UIFont systemFontOfSize:12];
    self.indicatorColor = [UIColor orangeColor];
    self.currentIndex = 0;
    self.indicatorWidth = -1;
    self.indicatorHeight = 1.5;
    self.indicatorStyle = Line;
    self.tablayoutStyle = PlainText;
    
    self.oldX = 0;
    self.isTouch = NO;
    
    laseIndex = self.currentIndex;
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

- (void)setTitles:(NSArray<NSString*>*)titles normalImages:(NSArray<NSString*>*)normalImages highlightedImages:(NSArray<NSString*>*)highlightedImages viewcontrollers:(NSArray<UIViewController*>*)viewcontrollers {
    self.titles = titles;
    self.normalImages = normalImages;
    self.highlightedImages = highlightedImages;
    self.viewcontrollers = viewcontrollers;
    [self setupUI];
}

- (void)setBedgeForIndex:(NSInteger)index bedge:(NSString*)bedge {
    if (index >= self.titles.count) {
        return;
    }
    UILabel* label = self.arrayBedges[index];
    if (bedge == nil || bedge.length < 1 || [bedge isEqualToString:@"0"]) {
        label.hidden = YES;
    } else {
        label.hidden = NO;
    }
    label.text = bedge;
}

- (void)setupUI {
    [self.arrayLabels removeAllObjects];
    [self.arrayImageViews removeAllObjects];
    [self.arrayTitleViews removeAllObjects];
    [self.arrayViewcontrollers removeAllObjects];
    [self.arrayBedges removeAllObjects];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (self.titles.count == 0) {
        return;
    }
    
    [self addSubview:self.scrollViewTitle];
    self.scrollViewTitle.backgroundColor = self.titleBackColor;
    [self.scrollViewTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.mas_equalTo(self);
        make.height.mas_equalTo(self.titleHeight);
    }];
    
    UIView* contentTitle = [UIView new];
    contentTitle.backgroundColor = self.titleBackColor;
//    contentTitle.layer.borderColor = [UIColor blackColor].CGColor;
//    contentTitle.layer.shadowColor = [UIColor blackColor].CGColor;
//    contentTitle.layer.shadowOffset = CGSizeMake(0, 10);
//    contentTitle.layer.shadowOpacity = 0.4;
//    contentTitle.layer.shadowRadius = 0.5;
//    contentTitle.layer.shouldRasterize = YES;
    [self.scrollViewTitle addSubview:contentTitle];
    [contentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollViewTitle);
        make.height.mas_equalTo(self.scrollViewTitle);
    }];
    
    [contentTitle addSubview:self.indicatorView];
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (self.tablayoutStyle != SwitchText && self.tablayoutStyle != SwitchTextNotScroll) {
            make.bottom.mas_equalTo(contentTitle);
        }
    }];
    
    if (self.tablayoutStyle == SwitchText || self.tablayoutStyle == SwitchTextNotScroll) {
        [contentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.scrollViewTitle);
        }];
        
        UIView* switchView = [UIView new];
        [contentTitle addSubview:switchView];
        [switchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80*self.titles.count);
            make.height.mas_equalTo(contentTitle.mas_height).offset(-20);
            make.center.mas_equalTo(contentTitle);
        }];
        
        UILabel* temp = nil;
        for (int i=0; i<self.titles.count; i++) {
            UILabel* label = [UILabel new];
            label.layer.borderColor = [UIColor blackColor].CGColor;
            label.layer.borderWidth = 0.5;
            label.tag = i;
            label.font = self.titleFont;
            label.text = self.titles[i];
            label.textAlignment = NSTextAlignmentCenter;
            if (i==self.currentIndex) {
                label.textColor = self.titleHighlightColor;
            } else {
                label.textColor = self.titleNormalColor;
            }
            label.userInteractionEnabled = YES;
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTouchTitle:)];
            [label addGestureRecognizer:tap];
            [switchView addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(80);
                make.top.bottom.mas_equalTo(switchView);
                if (temp == nil) {
                    make.left.mas_equalTo(0);
                } else {
                    make.left.mas_equalTo(temp.mas_right);
                }
            }];
            
            temp = label;
            
            [self.arrayLabels addObject:label];
            [self.arrayTitleViews addObject:label];
        }
    } else {
        UIView* temp = nil;
        for (int i=0; i<self.titles.count; i++) {
            UIView* view = [UIView new];
            view.tag = i;
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTouchTitle:)];
            [view addGestureRecognizer:tap];
            [contentTitle addSubview:view];
            
            if (self.titleCanScorll) {
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(contentTitle);
                    if (self.tablayoutStyle > 2) {
                        make.width.mas_equalTo([self getMaxWidth]);
                    } else {
                        make.width.mas_equalTo([self getItemWidth:i]);
                    }
                    make.top.mas_equalTo(0);
                    if (temp == nil) {
                        make.left.mas_equalTo(0);
                    } else {
                        make.left.mas_equalTo(temp.mas_right);
                    }
                }];
            } else {
                [view mas_makeConstraints:^(MASConstraintMaker *make) {
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
            
            [self.arrayTitleViews addObject:view];
            
            UIImageView* imgV = [UIImageView new];
            imgV.contentMode = UIViewContentModeScaleAspectFit;
            [view addSubview:imgV];
            if (self.tablayoutStyle == PlainText) {
                imgV.hidden = YES;
            } else {
                imgV.hidden = NO;
                if (i==self.currentIndex) {
                    if (self.highlightedImages.count > i) {
                        NSString* str = self.highlightedImages[i];
                        if ([str hasPrefix:@"http"]) {
                            [imgV sd_setImageWithURL:[NSURL URLWithString:str]];
                        } else {
                            imgV.image = [UIImage imageNamed:str];
                        }
                    }
                } else {
                    if (self.normalImages.count > i) {
                        NSString* str = self.normalImages[i];
                        if ([str hasPrefix:@"http"]) {
                            [imgV sd_setImageWithURL:[NSURL URLWithString:str]];
                        } else {
                            imgV.image = [UIImage imageNamed:str];
                        }
                    }
                }
            }
            if (self.tablayoutStyle > 0) {
                [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (self.tablayoutStyle <= ImageRightTextLeft) {
                        make.centerY.mas_equalTo(view);
                        if (self.tablayoutStyle == ImageRightTextLeft) {
                            make.right.mas_equalTo(-10);
                        } else {
                            make.left.mas_equalTo(10);
                        }
                    } else {
                        make.centerX.mas_equalTo(view);
                        if (self.tablayoutStyle == ImageTopTextBottom) {
                            make.top.mas_equalTo(5);
                        } else {
                            make.bottom.mas_equalTo(-5);
                        }
                    }
                    make.size.mas_equalTo(self.titleHeight/2);
                }];
            }
            [self.arrayImageViews addObject:imgV];
            
            UILabel* label = [UILabel new];
            label.textColor = self.titleNormalColor;
            label.backgroundColor = [UIColor clearColor];
            label.font = self.titleFont;
            label.text = self.titles[i];
            if (i==self.currentIndex) {
                label.textColor = self.titleHighlightColor;
            } else {
                label.textColor = self.titleNormalColor;
            }
            if (self.tablayoutStyle == ImageLeftTextRight) {
                label.textAlignment = NSTextAlignmentLeft;
            } else if (self.tablayoutStyle == ImageRightTextLeft) {
                label.textAlignment = NSTextAlignmentRight;
            } else {
                label.textAlignment = NSTextAlignmentCenter;
            }
            [view addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                if (self.tablayoutStyle == PlainText) {
                    make.edges.mas_equalTo(view);
                } else if (self.tablayoutStyle == ImageLeftTextRight) {
                    make.centerY.mas_equalTo(view);
                    make.left.mas_equalTo(imgV.mas_right).offset(5);
                    make.right.mas_equalTo(-10);
                } else if (self.tablayoutStyle == ImageRightTextLeft) {
                    make.centerY.mas_equalTo(view);
                    make.left.mas_equalTo(10);
                    make.right.mas_equalTo(imgV.mas_left).offset(-5);
                } else if (self.tablayoutStyle == ImageTopTextBottom) {
                    make.centerX.mas_equalTo(view);
                    make.top.mas_equalTo(imgV.mas_bottom).offset(5);
                    make.bottom.mas_equalTo(-5);
                } else if (self.tablayoutStyle == ImageBottomTextTop) {
                    make.centerX.mas_equalTo(view);
                    make.top.mas_equalTo(5);
                    make.bottom.mas_equalTo(imgV.mas_top).offset(-5);
                }
            }];
            [self.arrayLabels addObject:label];
            
            UILabel* bedge = [UILabel new];
            bedge.backgroundColor = [UIColor redColor];
            bedge.layer.cornerRadius = 6;
            bedge.layer.masksToBounds = YES;
            bedge.font = [UIFont systemFontOfSize:8];
            bedge.textAlignment = NSTextAlignmentCenter;
            bedge.hidden = YES;
            bedge.textColor = [UIColor whiteColor];
            [view addSubview:bedge];
            [bedge mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(12);
                make.right.mas_equalTo(-5);
                make.top.mas_equalTo(5);
                make.width.mas_equalTo(20);
            }];
            
            [self.arrayBedges addObject:bedge];
            
            if (i==self.titles.count-1) {
                [contentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(view.mas_right);
                }];
            }
            
            temp = view;
        }
    }
    
    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        UILabel* label = self.arrayTitleViews[self.currentIndex];
        make.centerX.mas_equalTo(label);
        if (self.indicatorStyle == Line && self.tablayoutStyle != SwitchText && self.tablayoutStyle != SwitchTextNotScroll) {
            make.height.mas_equalTo(self.indicatorHeight);
        } else {
            make.height.mas_equalTo(label);
        }
        if (self.indicatorWidth <= 0) {
            make.width.mas_equalTo(label);
        } else {
            make.width.mas_equalTo(self.indicatorWidth);
        }
        if (self.tablayoutStyle == SwitchText  || self.tablayoutStyle == SwitchTextNotScroll) {
            make.bottom.mas_equalTo(label);
        }
    }];
    
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
    UIView* view = self.arrayTitleViews[sender.view.tag];
    for (int i=0; i<self.arrayLabels.count; i++) {
        UILabel* l = self.arrayLabels[i];
        if (i==sender.view.tag) {
            l.textColor = self.titleHighlightColor;
        } else {
            l.textColor = self.titleNormalColor;
        }
    }
    for (int i=0; i<self.arrayImageViews.count; i++) {
        UIImageView* imgV = self.arrayImageViews[i];
        if (imgV.isHidden) {
            continue;
        }
        if (i==self.currentIndex) {
            if (self.highlightedImages.count > i) {
                NSString* str = self.highlightedImages[i];
                if ([str hasPrefix:@"http"]) {
                    [imgV sd_setImageWithURL:[NSURL URLWithString:str]];
                } else {
                    imgV.image = [UIImage imageNamed:str];
                }
            }
        } else {
            if (self.normalImages.count > i) {
                NSString* str = self.normalImages[i];
                if ([str hasPrefix:@"http"]) {
                    [imgV sd_setImageWithURL:[NSURL URLWithString:str]];
                } else {
                    imgV.image = [UIImage imageNamed:str];
                }
            }
        }
    }
    [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view);
        if (self.indicatorStyle == Line && self.tablayoutStyle != SwitchText && self.tablayoutStyle != SwitchTextNotScroll) {
            make.height.mas_equalTo(self.indicatorHeight);
        } else {
            make.height.mas_equalTo(view);
        }
        make.bottom.mas_equalTo(view);
        if (self.indicatorWidth <= 0) {
            make.width.mas_equalTo(view);
        } else {
            make.width.mas_equalTo(self.indicatorWidth);
        }
    }];
    [self.scrollViewController setContentOffset:CGPointMake(sender.view.tag*self.scrollViewController.frame.size.width, 0) animated:YES];
    __weak typeof(ZLPageView*) weakSelf = self;
    [UIView animateWithDuration:(self.tablayoutStyle==SwitchTextNotScroll?0.0f:0.2f) animations:^{
        [weakSelf layoutIfNeeded];
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
    UILabel* view = self.arrayTitleViews[self.currentIndex];
    CGFloat move = (view.frame.size.width / self.scrollViewController.frame.size.width) * offsetX;
    if (offsetX < 0 && self.currentIndex > 0) {//向左滑动
        UIView* leftView = self.arrayTitleViews[self.currentIndex-1];
        move = (leftView.frame.size.width / self.scrollViewController.frame.size.width) * offsetX;
    }
    CGFloat newLeft = self.indicatorView.frame.origin.x + move;
    CGFloat newWidth = self.indicatorView.frame.size.width;
    [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(newLeft);
        if (self.indicatorStyle == Line && self.tablayoutStyle != SwitchText && self.tablayoutStyle != SwitchTextNotScroll) {
            make.height.mas_equalTo(self.indicatorHeight);
        } else {
            make.height.mas_equalTo(view);
        }
        make.bottom.mas_equalTo(view);
        if (self.indicatorWidth <= 0) {
            if (offsetX < 0 && self.currentIndex > 0) {//向左滑动
                UIView* leftView = self.arrayTitleViews[self.currentIndex-1];
                CGFloat w = newWidth+((leftView.frame.size.width-view.frame.size.width)*fabs(offsetX/self.scrollViewController.frame.size.width));
                make.width.mas_equalTo(w);
            } else if (offsetX > 0 && self.currentIndex < self.titles.count-1) {
                UIView* rightView = self.arrayTitleViews[self.currentIndex+1];
                CGFloat w = newWidth+((rightView.frame.size.width-view.frame.size.width) * offsetX/self.scrollViewController.frame.size.width);
                make.width.mas_equalTo(w);
            } else {
                make.width.mas_equalTo(view);
            }
        } else {
            make.width.mas_equalTo(self.indicatorWidth);
        }
    }];
    [self.indicatorView setNeedsLayout];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.oldX = scrollView.contentOffset.x;
    self.isTouch = NO;
    [self adjustTitleAndImage];
    [self adjustScrollTitle];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.oldX = scrollView.contentOffset.x;
    self.isTouch = NO;
    [self adjustTitleAndImage];
    [self adjustScrollTitle];
    
    static UIViewController *lastController = nil;
    if (lastController != nil) {
        if ([lastController respondsToSelector:@selector(viewWillDisappear:)]) {
            [lastController viewWillDisappear:YES];
        }
    }
    lastController = self.arrayViewcontrollers[self.currentIndex];
    [self.arrayViewcontrollers[self.currentIndex] viewWillAppear:YES];
}

- (void)setTitleHeight:(CGFloat)titleHeight {
    _titleHeight = titleHeight;
    [self.scrollViewTitle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.titleHeight);
    }];
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    for (UILabel* l in self.arrayLabels) {
        l.font = titleFont;
    }
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
    if (self.arrayTitleViews.count > 0 && self.currentIndex < self.arrayTitleViews.count) {
        [self.indicatorView mas_updateConstraints:^(MASConstraintMaker *make) {
            UIView* view = self.arrayTitleViews[self.currentIndex];
            if (self.indicatorStyle == Line && self.tablayoutStyle != SwitchText && self.tablayoutStyle != SwitchTextNotScroll) {
                make.height.mas_equalTo(self.indicatorHeight);
            } else {
                make.height.mas_equalTo(view);
            }
        }];
    }
}

- (void)setTablayoutStyle:(TablayoutStyle)tablayoutStyle {
    _tablayoutStyle = tablayoutStyle;
    [self setupUI];
}

- (void)setTitleHighlightColor:(UIColor *)titleHighlightColor {
    _titleHighlightColor = titleHighlightColor;
    
    if (self.currentIndex < self.arrayLabels.count) {
        UILabel* l = self.arrayLabels[self.currentIndex];
        l.textColor = titleHighlightColor;
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (_currentIndex != currentIndex) {
        laseIndex = _currentIndex;
        _currentIndex = currentIndex;
        self.isTouch = YES;
        [self adjustTitleAndImage];
        [self performSelector:@selector(scrollToPosition) withObject:nil afterDelay:0.01f];
    }
}

- (void)setScrollEnable:(BOOL)enable {
    self.scrollViewController.scrollEnabled = enable;
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

- (NSMutableArray*)arrayTitleViews {
    if (!_arrayTitleViews) {
        _arrayTitleViews = [NSMutableArray new];
    }
    return _arrayTitleViews;
}
                               
- (NSMutableArray*)arrayLabels {
    if (!_arrayLabels) {
        _arrayLabels = [NSMutableArray new];
    }
    return _arrayLabels;
}

- (NSMutableArray*)arrayImageViews {
    if (!_arrayImageViews) {
        _arrayImageViews = [NSMutableArray new];
    }
    return _arrayImageViews;
}

- (NSMutableArray*)arrayViewcontrollers {
    if (!_arrayViewcontrollers) {
        _arrayViewcontrollers = [NSMutableArray new];
    }
    return _arrayViewcontrollers;
}

- (NSMutableArray*)arrayBedges {
    if (!_arrayBedges) {
        _arrayBedges = [NSMutableArray new];
    }
    return _arrayBedges;
}

- (CGFloat)getMaxWidth {
    if (self.titles.count < 1) {
        return 0;
    }
    CGFloat max = 0;
    for (int i=0; i<self.titles.count; i++) {
        NSString* str = self.titles[i];
        CGFloat width = [str boundingRectWithSize:CGSizeMake(1000000, self.titleHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.titleFont} context:nil].size.width;
        if (width > max) {
            max = width;
        }
    }
    return max + 30;
}

- (CGFloat)getItemWidth:(NSInteger)index {
    NSString* str = self.titles[index];
    CGFloat width = [str boundingRectWithSize:CGSizeMake(1000000, self.titleHeight) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.titleFont} context:nil].size.width;
    return width + 15 + 15 + self.titleHeight/2;
}

- (void)adjustTitleAndImage {
    UIView* view = self.arrayTitleViews[self.currentIndex];
    for (int i=0; i<self.arrayLabels.count; i++) {
        UILabel* l = self.arrayLabels[i];
        if (i==self.currentIndex) {
            l.textColor = self.titleHighlightColor;
        } else {
            l.textColor = self.titleNormalColor;
        }
    }
    for (int i=0; i<self.arrayImageViews.count; i++) {
        UIImageView* imgV = self.arrayImageViews[i];
        if (imgV.isHidden) {
            continue;
        }
        if (i==self.currentIndex) {
            if (self.highlightedImages.count > i) {
                NSString* str = self.highlightedImages[i];
                if ([str hasPrefix:@"http"]) {
                    [imgV sd_setImageWithURL:[NSURL URLWithString:str]];
                } else {
                    imgV.image = [UIImage imageNamed:str];
                }
            }
        } else {
            if (self.normalImages.count > i) {
                NSString* str = self.normalImages[i];
                if ([str hasPrefix:@"http"]) {
                    [imgV sd_setImageWithURL:[NSURL URLWithString:str]];
                } else {
                    imgV.image = [UIImage imageNamed:str];
                }
            }
        }
    }
    [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view);
        if (self.indicatorStyle == Line && self.tablayoutStyle != SwitchText && self.tablayoutStyle != SwitchTextNotScroll) {
            make.height.mas_equalTo(self.indicatorHeight);
        } else {
            make.height.mas_equalTo(view);
        }
        make.bottom.mas_equalTo(view);
        if (self.indicatorWidth <= 0) {
            make.width.mas_equalTo(view);
        } else {
            make.width.mas_equalTo(self.indicatorWidth);
        }
    }];
    __weak typeof(ZLPageView*) weakSelf = self;
    [UIView animateWithDuration:0.05f animations:^{
        [weakSelf.indicatorView setNeedsLayout];
    }];
}

- (void)adjustScrollTitle {
    if (self.titleCanScorll) {
        if (self.currentIndex > laseIndex) {
            if (self.indicatorView.center.x > self.scrollViewTitle.contentOffset.x + self.scrollViewTitle.frame.size.width/2 && self.scrollViewTitle.contentSize.width > self.scrollViewTitle.frame.size.width) {
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
