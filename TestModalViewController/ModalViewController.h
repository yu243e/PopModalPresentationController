//
//  ModalViewController.h
//  TestModalViewController
//
//  Created by yu243e on 16/8/15.
//  Copyright © 2016年 yu243e. All rights reserved.
//
#import <UIKit/UIKit.h>
@class ModalViewController;
@protocol ModalViewControllerDelegate <NSObject>

- (void)modalViewControllerDismiss:(ModalViewController *)viewController;

@end

@interface ModalViewController : UIViewController

@property (nonatomic, weak) id<ModalViewControllerDelegate> delegate;

@end
