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
};

@interface ModalPresentationController : UIPresentationController <UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) CHYCModalPresentationStyle modalStyle;

@end
