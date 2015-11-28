//
//  UIImageView+ImageFromUrl.m
//  TrinetixTest
//
//  Created by Sergiy Suprun on 1/14/15.
//  Copyright (c) 2015 Sergiy Suprun. All rights reserved.
//

#import "UIImageView+ImageFromUrl.h"


#import "NetworkManager.h"

const int kActivityIndicatorTag = 123456;

@implementation UIImageView (ImageFromUrl)

-(void)setImageFromUrl:(NSString *)imageUrl {
    UIActivityIndicatorView * ai = (UIActivityIndicatorView *)[self viewWithTag:kActivityIndicatorTag];
    
    if (!ai) {
        ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:ai];
        ai.tag = kActivityIndicatorTag;
        ai.center = self.center;
        ai.hidesWhenStopped = YES;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.image == nil) {
            ai.hidden = NO;
            [ai startAnimating];
        }
    });
    [[NetworkManager sharedInstance] loadImageWithUrl:imageUrl forView:self andHandler:^(UIImage *image, NSError *error) {
        if (!image || error != nil) {
            //TODO: set default image
            self.image = nil;
        } else {
            self.image = image;
        }
        [ai stopAnimating];
    }];
}


-(void)cancelImageLoad {
    UIActivityIndicatorView * ai = (UIActivityIndicatorView *)[self viewWithTag:kActivityIndicatorTag];
    
    if (ai != nil) {
        ai.hidden = YES;
        [ai removeFromSuperview];
    }
    
    [[NetworkManager sharedInstance] cancelImageLoadForView:self];
}
@end
