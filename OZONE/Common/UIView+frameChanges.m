//
//  UIView+frameChanges.m
//  HomeRepairs
//
//  Created by Kevin Baldha on 29/07/20.
//  Copyright © 2020 Eugeniuses. All rights reserved.
//

#import "UIView+frameChanges.h"

@implementation UIView (frameChanges)

- (void) frameAddX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x += x;
    [self setFrame:frame];
}
- (void) frameAddY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y += y;
    [self setFrame:frame];
}

- (void) frameAddWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width += width;
    [self setFrame:frame];
}
- (void) frameAddHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height += height;
    [self setFrame:frame];
}
- (void) frameSetX:(CGFloat)x y:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.x = x;
    frame.origin.y = y;
    [self setFrame:frame];
}

- (void) frameSetX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    [self setFrame:frame];
}
- (void) frameSetY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    [self setFrame:frame];
}

- (void) frameSetX:(CGFloat)x width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.origin.x = x;
    frame.size.width = width;
    [self setFrame:frame];
}
- (void) frameSetY:(CGFloat)y height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.origin.y = y;
    frame.size.height = height;
    [self setFrame:frame];
}

- (void) frameSetWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    [self setFrame:frame];
}
- (void) frameSetHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    [self setFrame:frame];
}
- (void) frameSetWidth:(CGFloat)width height:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.width = width;
    frame.size.height = height;
    [self setFrame:frame];
}

- (void) frameSetOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    [self setFrame:frame];
}
- (void) frameSetSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    [self setFrame:frame];
}
- (void) frameSetOrigin:(CGPoint)origin size:(CGSize)size {
    CGRect frame = self.frame;
    frame.origin = origin;
    frame.size = size;
    [self setFrame:frame];
}

@end
