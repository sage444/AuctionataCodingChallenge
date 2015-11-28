//
//  NetworkManager.h
//  TrinetixTest
//
//  Created by Sergiy Suprun on 1/13/15.
//  Copyright (c) 2015 Sergiy Suprun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^DataLoadHandler)(BOOL success, NSArray * data, NSError *error);

typedef void(^ImageLoadingHandler)(UIImage* image, NSError * error);

@interface NetworkManager : NSObject

+(NetworkManager *)sharedInstance;

-(void)loadLocationWithHandler:(DataLoadHandler)handler;

// image loading
-(BOOL)haveCachedImageForUrl:(NSString *)imageUrl;
-(void)loadImageWithUrl:(NSString *)imageUrl forView:(UIImageView*)imageView andHandler:(ImageLoadingHandler)handler;
-(void)cancelImageLoadForView:(UIImageView*)targerView;

@end
