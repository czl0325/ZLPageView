//
//  ZLPageView.h
//  yunkuang
//
//  Created by qipai on 2018/4/3.
//  Copyright © 2018年 ulink. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol ZLPageViewDelegate<NSObject>
//@optional
//
//- (NSInteger)numberOfChildCount;
//- (UIViewController*)childViewController:(NSInteger)index;
//
//@end

typedef enum  {
    Line,
    Block
}IndicatorStyle;

@interface ZLPageView : UIView

//@property(nonatomic,assign)id <ZLPageViewDelegate> delegate;

@property(nonatomic,assign)BOOL titleCanScorll;

@property(nonatomic,assign)CGFloat titleHeight;
@property(nonatomic,strong)UIColor* titleBackColor;
@property(nonatomic,strong)UIColor* titleNormalColor;
@property(nonatomic,strong)UIColor* titleHighlightColor;
@property(nonatomic,strong)UIColor* indicatorColor;
@property(nonatomic,assign)IndicatorStyle indicatorStyle;
@property(nonatomic,assign)NSInteger currentIndex;
@property(nonatomic,assign)CGFloat indicatorWidth;
@property(nonatomic,assign)CGFloat indicatorHeight;

- (void)setTitles:(NSArray<NSString*>*)titles viewcontrollers:(NSArray<UIViewController*>*)viewcontrollers;

@end
