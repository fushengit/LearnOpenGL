//
//  FGLView.h
//  GLKit02-GLKit实现
//
//  Created by Fu,Sheng on 2018/11/20.
//  Copyright © 2018年 Fu,Sheng. All rights reserved.
//

#import <UIKit/UIKit.h>


@class EAGLContext;
@protocol FGLKViewDelegate;

@interface FGLKView : UIView <NSCoding>

- (instancetype)initWithFrame:(CGRect)frame context:(EAGLContext *)context;

@property (nullable, nonatomic, assign)IBOutlet id <FGLKViewDelegate> delegate;

@property (nonatomic, retain) EAGLContext *context;

@property (nonatomic, readonly) NSInteger drawableWidth;
@property (nonatomic, readonly) NSInteger drawableHeight;

- (void)display;

@end

@protocol FGLKViewDelegate <NSObject>

@required
- (void)glkView:(FGLKView *)view drawInRect:(CGRect)rect;

@end
