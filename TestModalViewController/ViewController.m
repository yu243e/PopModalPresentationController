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
#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.showModalButton];
    [self.showModalButton addTarget:self action:@selector(showModalView) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.backgroundView.frame = CGRectMake(0, 0, 375, 667);
    self.showModalButton.frame = CGRectMake(100, 100, 200, 22);
}

#pragma mark - private methods
- (void)showModalView {
    //only support iOS8+
    ModalViewController * presentedModalViewController = [[ModalViewController alloc]init];
    presentedModalViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    presentedModalViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:presentedModalViewController animated:YES completion:nil];
}

#pragma mark - setter and getter
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
        [_showModalButton setTitle:@"show modal" forState:UIControlStateNormal];
        [_showModalButton setTitleColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"green"]] forState:UIControlStateNormal];
        _showModalButton.backgroundColor = [UIColor greenColor];
        
    }
    return _showModalButton;
}
@end

