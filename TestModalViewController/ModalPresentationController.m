//
//  ModalPresentationController.m
//  TestModalViewController
//
//  Created by yu243e on 16/12/22.
//  Copyright © 2016年 yu243e. All rights reserved.
//

#import "ModalPresentationController.h"

static const CGFloat modalDimmingViewAlpha = 0.5f;
static const NSTimeInterval modalTransitionDuration = 0.8;

@interface ModalPresentationController () <UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong) UIView *dimmingView;
@end

@implementation ModalPresentationController
#pragma mark - life cycle
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController {
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if (self) {
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    return self;
}

- (void)presentationTransitionWillBegin {
    //加入 dimmingView
    [self.containerView addSubview:self.dimmingView];
    self.dimmingView.userInteractionEnabled = YES;
    
    //获取转场协调器
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    //渐变的 dimmingView，使该动画和转场动画并行
    self.dimmingView.alpha = 0.f;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.dimmingView.alpha = modalDimmingViewAlpha;
    } completion: nil];
}

- (void)dismissalTransitionWillBegin
{
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0.f;
    } completion:nil];
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return [transitionContext isAnimated] ? modalTransitionDuration : 0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    //点开的展现动画，或 dismiss 动画
    BOOL isPresenting = (fromViewController == self.presentingViewController);
    
    CGRect __unused fromViewInitialFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect fromViewFinalFrame = [transitionContext finalFrameForViewController:fromViewController];
    CGRect toViewInitialFrame = [transitionContext initialFrameForViewController:toViewController];
    CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toViewController];
    
    [containerView addSubview:toView];
    
    if (isPresenting) {
        //toView 出现点在最下方，大小等同最终大小
        toViewInitialFrame.origin = CGPointMake(CGRectGetMinX(containerView.bounds), CGRectGetMaxY(containerView.bounds));
        toViewInitialFrame.size = toViewFinalFrame.size;
        toView.frame = toViewInitialFrame;
    } else {
        //fromView 的出现点在
        fromViewFinalFrame = CGRectOffset(fromView.frame, 0, CGRectGetHeight(fromView.frame));
    }
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:transitionDuration animations:^{
        if (isPresenting) {
            toView.frame = toViewFinalFrame;
        } else {
            fromView.frame = fromViewFinalFrame;
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    NSAssert(self.presentedViewController == presented, @"You didn't initialize %@ with the correct presentedViewController.  Expected %@, got %@.",
             self, presented, self.presentedViewController);
    return self;
}

//返回 self 作为 animator
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self;
}

//返回 self  作为 animator
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self;
}

#pragma mark - getters and setters
- (UIView *)dimmingView {
    if (!_dimmingView) {
        _dimmingView = [[UIView alloc] initWithFrame:self.containerView.bounds];
        _dimmingView.backgroundColor = [UIColor blackColor];
        _dimmingView.opaque = NO;
    }
    return _dimmingView;
}
@end
