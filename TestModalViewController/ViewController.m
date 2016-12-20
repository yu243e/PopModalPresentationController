//
//  ViewController.m
//  TestModalViewController
//
//  Created by yu243e on 16/8/15.
//  Copyright © 2016年 yu243e. All rights reserved.
//

#import "ViewController.h"
#import "ModalViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIButton *showModalButton;@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.showModalButton];
    [self.showModalButton addTarget:self action:@selector(showModalView) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.backgroundView.frame = self.view.frame;
    CGFloat buttonWidth = CGRectGetWidth(self.view.frame) / 2;
    CGFloat buttonHeight = 80;
    CGFloat buttonLeft = CGRectGetWidth(self.view.frame) / 2 - buttonWidth / 2;
    CGFloat buttonTop = CGRectGetHeight(self.view.frame) / 2 - buttonHeight / 2;
    self.showModalButton.frame = CGRectMake(buttonLeft, buttonTop, buttonWidth, buttonHeight);
}

#pragma mark - private methods
- (void)showModalView {
    //only support iOS8+
    ModalViewController * presentedModalViewController = [[ModalViewController alloc]init];
    presentedModalViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    presentedModalViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:presentedModalViewController animated:YES completion:nil];
}

#pragma mark - getters and setters
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]init];
        _backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blue"]];
    }
    return _backgroundView;
}

- (UIButton *)showModalButton {
    if (!_showModalButton) {
        _showModalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showModalButton setTitle:@"show" forState:UIControlStateNormal];
        [_showModalButton.titleLabel setFont:[UIFont systemFontOfSize:25]];
        [_showModalButton setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue"]] forState:UIControlStateNormal];
        [_showModalButton setBackgroundImage:[UIImage imageNamed:@"green"] forState:UIControlStateNormal];
    }
    return _showModalButton;
}
@end

