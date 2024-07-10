//
//  UIView+frameChanges.h
//  HomeRepairs
//
//  Created by Kevin Baldha on 29/07/20.
//  Copyright © 2020 Eugeniuses. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (frameChanges)

- (void) frameAddX:(CGFloat)x;
- (void) frameAddY:(CGFloat)y;
- (void) frameAddWidth:(CGFloat)width;
- (void) frameAddHeight:(CGFloat)height;
- (void) frameSetX:(CGFloat)x y:(CGFloat)y;
- (void) frameSetX:(CGFloat)x;
- (void) frameSetY:(CGFloat)y;
- (void) frameSetX:(CGFloat)x width:(CGFloat)width;
- (void) frameSetY:(CGFloat)y height:(CGFloat)height;
- (void) frameSetWidth:(CGFloat)width;
- (void) frameSetHeight:(CGFloat)height;
- (void) frameSetWidth:(CGFloat)width height:(CGFloat)height;

- (void) frameSetOrigin:(CGPoint)origin;
- (void) frameSetSize:(CGSize)size;
- (void) frameSetOrigin:(CGPoint)origin size:(CGSize)size;

@end
