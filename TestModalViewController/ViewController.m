//
//  ViewController.m
//  TestModalViewController
//
//  Created by yu243e on 16/8/15.
//  Copyright © 2016年 yu243e. All rights reserved.
//

#import "ViewController.h"
#import "ModalViewController.h"
#import "ModalPresentationController.h"

@interface ViewController() <ModalViewControllerDelegate>

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIButton *showModalButton;
@property (nonatomic, strong) UISegmentedControl *styleSegmentedControl;

@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.showModalButton];
    [self.view addSubview:self.styleSegmentedControl];
    [self.showModalButton addTarget:self action:@selector(showModalButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.backgroundView.frame = self.view.frame;
    
    CGFloat buttonWidth = CGRectGetWidth(self.view.frame) / 2;
    CGFloat buttonHeight = 80;
    CGFloat buttonLeft = CGRectGetWidth(self.view.frame) / 2 - buttonWidth / 2;
    CGFloat buttonTop = CGRectGetHeight(self.view.frame) / 2 - buttonHeight / 2;
    self.showModalButton.frame = CGRectMake(buttonLeft, buttonTop, buttonWidth, buttonHeight);
    
    self.styleSegmentedControl.frame = CGRectMake(self.view.frame.size.width * 0.1, buttonTop + buttonHeight * 1.5, self.view.frame.size.width * 0.8, 40);
}

#pragma mark - ModalViewControllerDelegate
- (void)modalViewControllerDismiss:(ModalViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - private methods
- (void)showModalButtonClicked {
    //only support iOS8+
    ModalViewController * presentedModalViewController = [[ModalViewController alloc] init];
    
    //因为没有被强持有，必须用NS_VALID_UNTIL_END_OF_SCOPE 保持其存在
    //参考 APPLE Custom View Controller Presentations and Transitions
    ModalPresentationController *presentationController NS_VALID_UNTIL_END_OF_SCOPE;
    presentationController = [[ModalPresentationController alloc] initWithPresentedViewController:presentedModalViewController presentingViewController:self];
    if (self.styleSegmentedControl.selectedSegmentIndex != UISegmentedControlNoSegment) {
        presentationController.modalStyle = self.styleSegmentedControl.selectedSegmentIndex;
    }
    presentedModalViewController.delegate = self;
    presentedModalViewController.transitioningDelegate = presentationController;
    
    presentedModalViewController.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:presentedModalViewController animated:YES completion:NULL];
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

- (UISegmentedControl *)styleSegmentedControl {
    if (!_styleSegmentedControl) {
        NSArray *items = @[@"center", @"top", @"down"];
        _styleSegmentedControl = [[UISegmentedControl alloc] initWithItems:items];
        _styleSegmentedControl.tintColor = [UIColor whiteColor];
//        _styleSegmentedControl.selectedSegmentIndex = 0;
    }
    return _styleSegmentedControl;
}
@end

