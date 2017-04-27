//
//  ViewController.m
//  mosaic
//
//  Created by Apple on 2017/4/20.
//  Copyright © 2017年 wupeng. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+mosaic.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"kebi.jpg"];
    imageView.image = [UIImage transTomosaicImage:imageView.image blockLevel:4];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
