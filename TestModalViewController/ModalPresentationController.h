//
//  ModalPresentationController.h
//  TestModalViewController
//
//  Created by yu243e on 16/12/22.
//  Copyright © 2016年 yu243e. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CHYCModalPresentationStyle) {
    CHYCModalPresentationStyleCenter = 0,
    CHYCModalPresentationStyleFromTop,
    CHYCModalPresentationStyleFromBottom,
    CHYCModalPresentationStyleFromPoint
};

@interface ModalPresentationFromPointConfig: NSObject
@property (nonatomic, assign) CGPoint anchorPoint;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGFloat initAlpha;
//不要为0.0f，否则无动画
@property (nonatomic, assign) CGFloat initSizeRatio;
@end


@interface ModalPresentationController : UIPresentationController <UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) CHYCModalPresentationStyle modalStyle;
@property (nonatomic, strong) ModalPresentationFromPointConfig *config;

@end
