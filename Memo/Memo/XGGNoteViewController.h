//
//  XGGNoteViewController.h
//  Memo
//
//  Created by Richard on 16/7/16.
//  Copyright © 2016年 Richard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGGPassValueDelegate.h"

@interface XGGNoteViewController : UIViewController

@property(nonatomic, weak) id<XGGPassValueDelegate> delegate;

@end
