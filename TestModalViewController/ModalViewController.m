//
//  ModalViewController.m
//  testModalViewC
//
//  Created by yu243e on 16/8/11.
//  Copyright © 2016年 yu243e. All rights reserved.
//
#import "ModalViewController.h"

@interface ModalViewController ()

@property (nonatomic, strong) UIButton *backgroundButton;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *dismissModalButton;

@end

@implementation ModalViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.backgroundButton];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.dismissModalButton];
    
    [self.backgroundButton addTarget:self action:@selector(backgroundButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.dismissModalButton addTarget:self action:@selector(dismissModalButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutPageSubviews {
    //masonry constraints
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.backgroundButton.frame = self.view.frame;
    
    CGFloat contentViewWidth = CGRectGetWidth(self.view.frame) * 0.8;
    CGFloat contentViewHeight = contentViewWidth;
    CGFloat contentViewLeft = CGRectGetWidth(self.view.frame) / 2 - contentViewWidth / 2;
    CGFloat contentViewTop = CGRectGetHeight(self.view.frame) / 2 - contentViewHeight / 2;
    self.contentView.frame = CGRectMake(contentViewLeft , contentViewTop, contentViewWidth, contentViewHeight);
    
    CGFloat buttonWidth = CGRectGetWidth(self.view.frame) * 0.4;
    CGFloat buttonHeight = 60;
    CGFloat buttonLeft = contentViewWidth - buttonWidth;
    CGFloat buttonTop = 0;
    self.dismissModalButton.frame = CGRectMake(buttonLeft, buttonTop, buttonWidth, buttonHeight);
}

#pragma mark - event response
- (void)backgroundButtonClicked {
    [self dismissModalView];
}

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
- (UIView *)backgroundButton {
    if (!_backgroundButton) {
        _backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backgroundButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return _backgroundButton;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"green"]];
    }
    return _contentView;
}

- (UIButton *)dismissModalButton {
    if (!_dismissModalButton) {
        _dismissModalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dismissModalButton setTitle:@"dismiss modal" forState:UIControlStateNormal];
        [_dismissModalButton setBackgroundImage:[UIImage imageNamed:@"blue"] forState:UIControlStateNormal];
    }
    return _dismissModalButton;
}
@end

