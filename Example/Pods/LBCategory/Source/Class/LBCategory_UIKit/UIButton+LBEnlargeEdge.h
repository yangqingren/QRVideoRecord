//
//  UIButton+LBEnlargeEdge.h
//  app
//
//  Created by 刘文扬 on 17/6/12.
//  Copyright © 2017年 Duke_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (LBEnlargeEdge)

- (void)setEnlargeEdge:(CGFloat) size;

- (void)setEnlargeEdgeWithTop:(CGFloat) top right:(CGFloat) right bottom:(CGFloat) bottom left:(CGFloat) left;

@end
