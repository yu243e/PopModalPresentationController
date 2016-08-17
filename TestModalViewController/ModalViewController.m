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
@property (nonatomic, strong) UIView *aView;
@property (nonatomic, strong) UIButton *dismissModalButton;
@end

@implementation ModalViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.backgroundButton];
    [self.view addSubview:self.aView];
    [self.view addSubview:self.dismissModalButton];
    
    [self.backgroundButton addTarget:self action:@selector(backgroundButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.dismissModalButton addTarget:self action:@selector(dismissModalButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self layoutPageSubviews];
}

- (void)layoutPageSubviews {
    //masonry constraints
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.backgroundButton.frame = self.view.frame;
    ;
    self.aView.frame = CGRectMake(75/2. , 150, 300, 300);
    self.dismissModalButton.frame = CGRectMake(100, 150, 120, 44);
}

#pragma mark - event response
- (void)backgroundButtonClick {
    [self dismissModalView];
}

- (void)dismissModalButtonClick {
    [self dismissModalView];
}

#pragma mark - private methods
- (void)dismissModalView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getters and setters
- (UIView *)backgroundButton {
    if (!_backgroundButton) {
        _backgroundButton = [[UIButton alloc]init];
        _backgroundButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return _backgroundButton;
}

- (UIView *)aView {
    if (!_aView) {
        _aView = [[UIView alloc]init];
        _aView.backgroundColor = [UIColor greenColor];
    }
    return _aView;
}

- (UIButton *)dismissModalButton {
    if (!_dismissModalButton) {
        _dismissModalButton = [[UIButton alloc]init];
        [_dismissModalButton setTitle:@"dismiss modal" forState:UIControlStateNormal];
        _dismissModalButton.backgroundColor = [UIColor redColor];
    }
    return _dismissModalButton;
}
@end

