//
//  UIImage+mosaic.h
//  mosaic
//
//  Created by Apple on 2017/4/20.
//  Copyright © 2017年 wupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (mosaic)

+ (UIImage *)transTomosaicImage:(UIImage *)image blockLevel:(NSInteger)level;

@end
