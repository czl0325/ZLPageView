# ZLPageView
GitHub上唯一支持autolayout的tablayout。

支持cocoapods。
```
 pod 'ZLPageView'
```

![](https://github.com/czl0325/ZLPageView/blob/master/demo.gif?raw=true)

## 使用方法

```
	- (ZLPageView*)pageView {
    if (!_pageView) {
        _pageView = [[ZLPageView alloc]initWithFrame:CGRectZero];
        _pageView.titleHeight = 50;
        _pageView.indicatorColor = [UIColor colorWithWhite:0.4  alpha:1.0];
        _pageView.titleHighlightColor = [UIColor redColor];
        _pageView.titleCanScorll = YES;
        _pageView.indicatorStyle = Block;
    }
    return _pageView;
}
```


### 调用

```
    [self.view addSubview:self.pageView];
    [self.pageView setTitles:array1 viewcontrollers:vcs];
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
```