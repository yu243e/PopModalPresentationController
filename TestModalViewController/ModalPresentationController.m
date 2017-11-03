//
//  ModalPresentationController.m
//  TestModalViewController
//
//  Created by yu243e on 16/12/22.
//  Copyright © 2016年 yu243e. All rights reserved.
//

#import "ModalPresentationController.h"

@implementation ModalPresentationFromPointConfig
@end

static const CGFloat modalDimmingViewAlpha = 0.5f;
static const NSTimeInterval modalTransitionDuration = 0.3f;
static const NSTimeInterval modalDismissTransitionDuration = 0.3f;
//初始动画和结束动画(centerStyle) view长宽各为
static const CGFloat modalCenterInitialViewSizeRatio = 0.1f;
static const CGFloat modalCenterInitialViewAlpha = 0.5f;

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
    [self.dimmingView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmingViewTapped:)]];
    
    //获取转场协调器
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    //渐变的 dimmingView，使该动画和转场动画并行
    self.dimmingView.alpha = 0.f;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.dimmingView.alpha = modalDimmingViewAlpha;
    } completion: NULL];
}

- (void)dismissalTransitionWillBegin
{
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dimmingView.alpha = 0.f;
    } completion:NULL];
}

#pragma mark - about layout
- (CGSize)sizeForChildContentContainer:(id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    if (container == self.presentedViewController) {
        return ((UIViewController *)container).preferredContentSize;
    } else {
        return [super sizeForChildContentContainer:container withParentContainerSize:parentSize];
    }
}

- (CGRect)frameOfPresentedViewInContainerView
{
    CGRect containerViewBounds = self.containerView.bounds;
    CGSize presentedViewContentSize = [self sizeForChildContentContainer:self.presentedViewController withParentContainerSize:containerViewBounds.size];
    
    CGRect presentedViewControllerFrame;
    presentedViewControllerFrame.size.width = presentedViewContentSize.width;
    presentedViewControllerFrame.size.height = presentedViewContentSize.height;
    
    switch (self.modalStyle) {
        case CHYCModalPresentationStyleFromTop:
            presentedViewControllerFrame.origin.y = 0;
            presentedViewControllerFrame.origin.x = (CGRectGetMaxX(containerViewBounds) - presentedViewContentSize.width) / 2;
            break;
        case CHYCModalPresentationStyleFromBottom:
            presentedViewControllerFrame.origin.y = CGRectGetMaxY(containerViewBounds) - presentedViewContentSize.height;
            presentedViewControllerFrame.origin.x = (CGRectGetMaxX(containerViewBounds) - presentedViewContentSize.width) / 2;
            break;
        case CHYCModalPresentationStyleCenter:
            presentedViewControllerFrame.origin.y = (CGRectGetMaxY(containerViewBounds) - presentedViewContentSize.height) / 2;
            presentedViewControllerFrame.origin.x = (CGRectGetMaxX(containerViewBounds) - presentedViewContentSize.width) / 2;
            break;
        case CHYCModalPresentationStyleFromPoint:
            presentedViewControllerFrame.origin.y = self.config.frame.origin.y;
            presentedViewControllerFrame.origin.x = self.config.frame.origin.x;
            break;
    }
    
    return presentedViewControllerFrame;
}

//出现动画的 presentedView 的初始状态
- (CGRect)toViewInitialFrameForStyle:(CHYCModalPresentationStyle)modalStyle containterViewBounds:(CGRect)bounds finalSize:(CGSize)finalSize {
    CGRect toViewInitialFrame;
    
    //置中偏移量
    CGFloat XOffset = CGRectGetMidX(bounds) - finalSize.width / 2;
    CGFloat YOffset = CGRectGetMidY(bounds) - finalSize.height / 2;
    switch (modalStyle) {
        case CHYCModalPresentationStyleFromTop:
            toViewInitialFrame.origin = CGPointMake(XOffset, - CGRectGetMaxY(bounds));
            toViewInitialFrame.size = finalSize;
            break;
        case CHYCModalPresentationStyleFromBottom:
            toViewInitialFrame.origin = CGPointMake(XOffset, CGRectGetMaxY(bounds));
            toViewInitialFrame.size = finalSize;
            break;
        case CHYCModalPresentationStyleCenter:
            toViewInitialFrame.origin = CGPointMake(XOffset, YOffset);
            toViewInitialFrame.size = finalSize;
            break;
        case CHYCModalPresentationStyleFromPoint:
            toViewInitialFrame.origin = self.config.frame.origin;
//            toViewInitialFrame.origin = CGPointMake(self.config.frame.origin.x + 0.5 * self.config.frame.size.width, self.config.frame.origin.y + 0.5 * self.config.frame.size.height);
            toViewInitialFrame.size = finalSize;
            break;
    }
    return toViewInitialFrame;
}

//结束动画的 presentedView 的最终状态
- (CGRect)fromViewFinalFrameForStyle:(CHYCModalPresentationStyle)modalStyle fromViewFrame:(CGRect)fromViewFrame {
    CGRect fromViewFinalFrame = CGRectZero;
    
    switch (modalStyle) {
        case CHYCModalPresentationStyleFromTop:
            fromViewFinalFrame = CGRectOffset(fromViewFrame, 0, - CGRectGetHeight(fromViewFrame));
            break;
        case CHYCModalPresentationStyleFromBottom:
            fromViewFinalFrame = CGRectOffset(fromViewFrame, 0, CGRectGetHeight(fromViewFrame));
            break;
        case CHYCModalPresentationStyleCenter:
            //do nothing
            break;
        case CHYCModalPresentationStyleFromPoint:
            break;
    }
    return fromViewFinalFrame;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    //点开的展现动画，或 dismiss 动画
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    BOOL isPresenting = (fromViewController == self.presentingViewController);
    
    //返回设定的时间
    if ([transitionContext isAnimated]) {
        if (isPresenting) {
            return modalTransitionDuration;
        } else {
            return modalDismissTransitionDuration;
        }
    } else {
        return 0;
    }
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    // For a Presentation:
    //      fromView = The presenting view.
    //      toView   = The presented view.
    // For a Dismissal:
    //      fromView = The presented view.
    //      toView   = The presenting view.
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
        //出现动画
        toViewInitialFrame = [self toViewInitialFrameForStyle:self.modalStyle containterViewBounds:containerView.bounds finalSize:toViewFinalFrame.size];;
        toView.frame = toViewInitialFrame;
        
        if (self.modalStyle == CHYCModalPresentationStyleCenter) {
            //缩小并半透明化
            toView.alpha = modalCenterInitialViewAlpha;
            toView.transform = CGAffineTransformMakeScale(modalCenterInitialViewSizeRatio, modalCenterInitialViewSizeRatio);
        }
        if (self.modalStyle == CHYCModalPresentationStyleFromPoint) {
            toView.alpha = self.config.initAlpha;
            //anchorPoint改变时frame会改变
            toView.layer.anchorPoint = self.config.anchorPoint;
            toView.frame = toViewInitialFrame;
            toView.transform = CGAffineTransformMakeScale(self.config.initSizeRatio, self.config.initSizeRatio);
        }
    } else {
        //结束动画
        fromViewFinalFrame = [self fromViewFinalFrameForStyle:self.modalStyle fromViewFrame:fromView.frame];
    }
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    if (self.modalStyle == CHYCModalPresentationStyleCenter) {
        [UIView animateWithDuration:transitionDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (isPresenting) {
                //恢复正常态
                toView.alpha = 1.0f;
                toView.transform = CGAffineTransformIdentity;
            } else {
                fromView.alpha = 0.0f;
                fromView.transform = CGAffineTransformMakeScale(modalCenterInitialViewSizeRatio, modalCenterInitialViewSizeRatio);
            }
        } completion:^(BOOL finished) {
            toView.frame = toViewFinalFrame;
            [transitionContext completeTransition:YES];
        }];
    } else if (self.modalStyle == CHYCModalPresentationStyleFromPoint) {
        fromView.layer.anchorPoint = self.config.anchorPoint;
        [UIView animateWithDuration:transitionDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (isPresenting) {
                //恢复正常态
                toView.alpha = 1.0f;
                toView.transform = CGAffineTransformIdentity;
            } else {
                fromView.alpha = 0.0f;
                fromView.transform = CGAffineTransformMakeScale(self.config.initSizeRatio, self.config.initSizeRatio);
            }
        } completion:^(BOOL finished) {
            toView.frame = toViewFinalFrame;
            [transitionContext completeTransition:YES];
        }];
    } else {
        [UIView animateWithDuration:transitionDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (isPresenting) {
                toView.frame = toViewFinalFrame;
            } else {
                fromView.frame = fromViewFinalFrame;
            }
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
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

#pragma mark - event response
- (void)dimmingViewTapped:(UITapGestureRecognizer*)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    
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
