//
//  UIImage+mosaic.m
//  mosaic
//
//  Created by Apple on 2017/4/20.
//  Copyright © 2017年 wupeng. All rights reserved.
//

#import "UIImage+mosaic.h"

#define kBitsPerComponent (8)
#define kBitsPerPixel (32)
#define kPixelChannelCount (4)

@implementation UIImage (mosaic)

+ (UIImage *)transTomosaicImage:(UIImage *)originImage blockLevel:(NSInteger)level {
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef imageRef = originImage.CGImage;
    CGFloat width = CGImageGetWidth(imageRef);
    CGFloat height = CGImageGetHeight(imageRef);
    
    CGContextRef context = CGBitmapContextCreate(nil, width, height, kBitsPerComponent, kPixelChannelCount * width, colorSpace, kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    unsigned char *bitmapData = CGBitmapContextGetData(context);
    
    unsigned char pixel[kPixelChannelCount] = {0};
    
    NSInteger index, preIndex;
    for (NSInteger i = 0; i < height - 1; i++) {
        for (NSInteger j = 0; j < width - 1; j++) {
            index = i * width + j;
            if (i % level == 0) {
                if (j % level == 0) {
                    memcpy(pixel, bitmapData + kPixelChannelCount * index, kPixelChannelCount);
                } else {
                    memcpy(bitmapData + kPixelChannelCount * index, pixel, kPixelChannelCount);
                }
            } else {
                preIndex = (i - 1) * width + j;
                memcpy(bitmapData + kPixelChannelCount * index, bitmapData + kPixelChannelCount * preIndex, kPixelChannelCount);
            }
        }
    }
    
    NSInteger dataLength = width * height * kPixelChannelCount;
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bitmapData, dataLength, NULL);
    
    CGImageRef mosaicImageRef = CGImageCreate(width, height, kBitsPerComponent, kBitsPerPixel, width * kPixelChannelCount, colorSpace, kCGBitmapByteOrderDefault, provider, NULL, NO, kCGRenderingIntentDefault);
    
    CGContextRef outputContext = CGBitmapContextCreate(nil,
                                                       width,
                                                       height,
                                                       kBitsPerComponent,
                                                       width*kPixelChannelCount,
                                                       colorSpace,
                                                       kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(outputContext, CGRectMake(0.0f, 0.0f, width, height), mosaicImageRef);
    CGImageRef resultImageRef = CGBitmapContextCreateImage(outputContext);
    UIImage *resultImage = nil;
    if([UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
        float scale = [[UIScreen mainScreen] scale];
        resultImage = [UIImage imageWithCGImage:resultImageRef scale:scale orientation:UIImageOrientationUp];
    } else {
        resultImage = [UIImage imageWithCGImage:resultImageRef];
    }
    //释放
    if(resultImageRef){
        CFRelease(resultImageRef);
    }
    if(mosaicImageRef){
        CFRelease(mosaicImageRef);
    }
    if(colorSpace){
        CGColorSpaceRelease(colorSpace);
    }
    if(provider){
        CGDataProviderRelease(provider);
    }
    if(context){
        CGContextRelease(context);
    }
    if(outputContext){
        CGContextRelease(outputContext);
    }
    return resultImage;
    
}

@end
