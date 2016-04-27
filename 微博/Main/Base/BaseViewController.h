//
//  BaseViewController.h
//  微博
//
//  Created by mac on 15/10/8.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperation.h"
@interface BaseViewController : UIViewController

-(void)showHUD:(NSString *)title ;
-(void)hiddenHUD ;
-(void)completeHUD:(NSString *)title;

-(void)isLoading:(BOOL)show;

- (void)showStatusTipWithTitle:(NSString *)title
                          show:(BOOL)show
                     operation:(AFHTTPRequestOperation *)operation;

@end
