//
//  ZLPageView.h
//  yunkuang
//
//  Created by qipai on 2018/4/3.
//  Copyright © 2018年 ulink. All rights reserved.
//

#import <UIKit/UIKit.h>

//版本2.2

@class ZLPageView;
@protocol ZLPageViewDelegate<NSObject>
@optional

- (void)pageView:(ZLPageView *)pageView didScrollToIndex:(NSInteger)index ;

@end

typedef enum  {
    Line,
    Block
}IndicatorStyle;

typedef enum  {
    PlainText = 0,          //纯文本类型
    ImageLeftTextRight,     //图片在左文本在右
    ImageRightTextLeft,     //图片在右文本在左
    ImageTopTextBottom,     //图片在上文本在下
    ImageBottomTextTop,     //图片在下文本在上
    SwitchText,             //UISwitch
    SwitchTextNotScroll
}TablayoutStyle;

@interface ZLPageView : UIView

@property(nonatomic,weak)id <ZLPageViewDelegate> delegate;

//上层tablayout是否可以滚动，如果设置NO则平分每个title
@property(nonatomic,assign)BOOL titleCanScorll;

@property(nonatomic,assign)CGFloat titleHeight;         //上层tablayout占用的空间
@property(nonatomic,strong)UIColor* titleBackColor;     //背景色
@property(nonatomic,strong)UIColor* titleNormalColor;   //文字未选中的颜色
@property(nonatomic,strong)UIColor* titleHighlightColor;//文字选中的高亮颜色
@property(nonatomic,strong)UIFont* titleFont;           //文字的字体
@property(nonatomic,strong)UIColor* indicatorColor;     //指示器颜色
@property(nonatomic,assign)IndicatorStyle indicatorStyle;//指示器类型
@property(nonatomic,assign)TablayoutStyle tablayoutStyle;//tablayout的类型
@property(nonatomic,assign)NSInteger currentIndex;      //当前的index
@property(nonatomic,assign)CGFloat indicatorWidth;      //指示器的宽度
@property(nonatomic,assign)CGFloat indicatorHeight;     //指示器的高度
@property(nonatomic,assign)BOOL showsHorizontalScrollIndicator;//显示滚动条

- (instancetype)initWithTitles:(NSArray<NSString*>*)titles viewcontrollers:(NSArray<UIViewController*>*)viewcontrollers;

- (void)setTitles:(NSArray<NSString*>*)titles viewcontrollers:(NSArray<UIViewController*>*)viewcontrollers;

- (instancetype)initWithTitles:(NSArray<NSString*>*)titles normalImages:(NSArray<NSString*>*)normalImages highlightedImages:(NSArray<NSString*>*)highlightedImages viewcontrollers:(NSArray<UIViewController*>*)viewcontrollers;

- (void)setTitles:(NSArray<NSString*>*)titles normalImages:(NSArray<NSString*>*)normalImages highlightedImages:(NSArray<NSString*>*)highlightedImages viewcontrollers:(NSArray<UIViewController*>*)viewcontrollers;

//设置每个tablayout的bedge，为0则自动隐藏
- (void)setBedgeForIndex:(NSInteger)index bedge:(NSString*)bedge;
//设置scrollview不滚动
- (void)setScrollEnable:(BOOL)enable;

@end
