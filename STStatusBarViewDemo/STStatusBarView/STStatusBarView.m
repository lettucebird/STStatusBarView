/*
 Copyright (c) 2015 Bill Wang
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "STStatusBarView.h"

@interface STStatusBarView () <UIGestureRecognizerDelegate>
@property (nonatomic) BOOL isOriginalStatusBarLight;

@end

#define GREEN_COLOR [UIColor colorWithRed:76.f/255.f green:213.f/255.f blue:100.f/255.f alpha:1]
#define RED_COLOR [UIColor colorWithRed:253.f/255.f green:75.f/255.f blue:66.f/255.f alpha:1]

#define OFF_SCREEN_FRAME CGRectMake(0, -42, [UIScreen mainScreen].bounds.size.width, 42)
#define ON_SCREEN_FRAME  CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 42)
#define LABEL_FRAME CGRectMake(0, 6, [UIScreen mainScreen].bounds.size.width, 42)

@implementation STStatusBarView

- (instancetype)initWithText:(NSString *)text
{

    self = [self initWithFrame:OFF_SCREEN_FRAME];
    if (self) {
        _contentLabel = [[UILabel alloc] initWithFrame: LABEL_FRAME];
        [_contentLabel setText:text];
        [_contentLabel setTextColor:[UIColor whiteColor]];
        [_contentLabel setTextAlignment:NSTextAlignmentCenter];
        [_contentLabel setFont:[UIFont systemFontOfSize:13]];
        [_contentLabel setNumberOfLines:0];
        [self addSubview:_contentLabel];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = GREEN_COLOR;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
        [self addGestureRecognizer:tapGesture];
    }
    
    
    return self;
}

- (void)show
{
    UIViewController *top = [UIApplication sharedApplication].keyWindow.rootViewController;
    [top.view addSubview:self];
    
    if ([top isKindOfClass:[UINavigationController class]]) {
        if (((UINavigationController *)top).navigationBar.barStyle == UIBarStyleBlack) {
            _isOriginalStatusBarLight = YES;
        } else _isOriginalStatusBarLight = NO;
        
        ((UINavigationController *)top).navigationBar.barStyle = UIBarStyleBlack;
    } else {
        if ([UIApplication sharedApplication].statusBarStyle == UIStatusBarStyleLightContent) {
            _isOriginalStatusBarLight = YES;
        } else _isOriginalStatusBarLight = NO;
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    if (_style == STStatusBarStyleGreen) {
        self.backgroundColor = GREEN_COLOR;
    } else if (_style == STStatusBarStyleRed) {
        self.backgroundColor = RED_COLOR;
    }
    
    _contentLabel.alpha = 1;
    
    [UIView animateWithDuration:0.2f animations:^{
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 42);
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:1.f delay:0.f options:UIViewAnimationOptionCurveEaseOut |UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
                [_contentLabel setAlpha:0];
                [_contentLabel setAlpha:1];
            } completion:nil];
        }
    }];
}

- (void)hide
{
    UIViewController *top = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([top isKindOfClass:[UINavigationController class]]) {
        if (!_isOriginalStatusBarLight) {
            ((UINavigationController *)top).navigationBar.barStyle = UIBarStyleDefault;
        }
    } else {
        if (!_isOriginalStatusBarLight) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.frame = OFF_SCREEN_FRAME;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)tapGestureRecognized:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateRecognized) {
        [self hide];
    }
}

- (void)setStyle:(STStatusBarStyle)style
{
    if (style == _style) {
        return;
    }
    
    if (self.superview) {
        [UIView animateWithDuration:0.5f animations:^{
            if (style == STStatusBarStyleRed) {
                self.backgroundColor = RED_COLOR;
            } else if (style == STStatusBarStyleGreen) {
                self.backgroundColor = GREEN_COLOR;
            }
        }];
    }
    
    _style = style;
}

@end
