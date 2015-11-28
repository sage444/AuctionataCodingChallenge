//
//  UIImageView+ImageFromUrl.h
//  TrinetixTest
//
//  Created by Sergiy Suprun on 1/14/15.
//  Copyright (c) 2015 Sergiy Suprun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (ImageFromUrl)

-(void)setImageFromUrl:(NSString *)imageUrl;
-(void)cancelImageLoad;

@end
