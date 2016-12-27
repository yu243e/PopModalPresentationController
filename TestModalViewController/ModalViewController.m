//
//  ModalViewController.m
//  testModalViewC
//
//  Created by yu243e on 16/8/11.
//  Copyright © 2016年 yu243e. All rights reserved.
//
#import "ModalViewController.h"

#define kSCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT	[UIScreen mainScreen].bounds.size.height

@interface ModalViewController ()

@property (nonatomic, strong) UIButton *dismissModalButton;

@end

@implementation ModalViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updatePreferredContentSize];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"green"]];
    [self.view addSubview:self.dismissModalButton];
    
    [self.dismissModalButton addTarget:self action:@selector(dismissModalButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)updatePreferredContentSize {
    CGFloat contentSizeWidth = kSCREEN_WIDTH * 0.8;
    CGFloat contentSizeHeight = contentSizeWidth;
    
    self.preferredContentSize = CGSizeMake(contentSizeWidth, contentSizeHeight);
}

//self.view.frame 在这里取，能取得正确值
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat buttonWidth = CGRectGetWidth(self.view.frame) * 0.5;
    CGFloat buttonHeight = 60;
    CGFloat buttonLeft = CGRectGetWidth(self.view.frame) * 0.5;
    CGFloat buttonTop = 0;
    self.dismissModalButton.frame = CGRectMake(buttonLeft, buttonTop, buttonWidth, buttonHeight);
}

#pragma mark - event response
- (void)dismissModalButtonClicked {
    [self dismissModalView];
}

#pragma mark - private methods
- (void)dismissModalView {
    if (self.delegate) {
        [self.delegate modalViewControllerDismiss:self];
    }
}

#pragma mark - getters and setters
- (UIButton *)dismissModalButton {
    if (!_dismissModalButton) {
        _dismissModalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dismissModalButton setTitle:@"dismiss modal" forState:UIControlStateNormal];
        [_dismissModalButton setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
    }
    return _dismissModalButton;
}
@end

