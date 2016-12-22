//
//  BounceTransitionAnimator.m
//  TestModalViewController
//
//  Created by yu243e on 16/12/20.
//  Copyright © 2016年 yu243e. All rights reserved.
//

#import "BounceTransitionAnimator.h"

@implementation BounceTransitionAnimator
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.8;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
//    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    //only support iOS8+
//    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
//    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.frame = CGRectOffset(finalFrame, 0, screenBounds.size.height);
    
    [containerView addSubview:toViewController.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         toViewController.view.frame = finalFrame;
                     } completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}
@end
