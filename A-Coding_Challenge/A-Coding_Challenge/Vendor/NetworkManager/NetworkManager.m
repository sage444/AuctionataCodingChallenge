//
//  NetworkManager.m
//  TrinetixTest
//
//  Created by Sergiy Suprun on 1/13/15.
//  Copyright (c) 2015 Sergiy Suprun. All rights reserved.
//

#import "NetworkManager.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

static NSString * const DATA_URL = @"http://public.example.net/test.json";

static NSString * const kTASK_KEY = @"downloaderTaskKey";
static NSString * const kTASK_URL_KEY = @"downloaderTaskURLKey";


static NetworkManager* _instance = nil;


static const int kImageCacheMemoryLimit = 15*1024*1024;
static const int kImageCacheDiskLimit = 100*1024*1024;

@implementation NetworkManager
{
    NSURLSession * _dataSession;
    NSURLSession * _imageSession;
    NSURLCache * _imageCache;
}

-(id)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration * conf = [NSURLSessionConfiguration defaultSessionConfiguration];
        _dataSession = [NSURLSession sessionWithConfiguration:conf];
        
        NSURLSessionConfiguration * imageConf = [NSURLSessionConfiguration defaultSessionConfiguration];
        imageConf.HTTPMaximumConnectionsPerHost = 8;
        _imageCache = [[NSURLCache alloc] initWithMemoryCapacity:kImageCacheMemoryLimit diskCapacity:kImageCacheDiskLimit diskPath:@"ImageCache"];
        imageConf.URLCache = _imageCache;
        
        _imageSession = [NSURLSession sessionWithConfiguration:imageConf];
    }
    return self;

}

+(NetworkManager*)sharedInstance {
    
    if (!_instance) {
        _instance = [[self alloc] init];
    }
    return _instance;
}


-(void)loadLocationWithHandler:(DataLoadHandler)handler {
    NSURL * dataUrl = [NSURL URLWithString:DATA_URL];
    NSURLSessionDataTask * task =
    [_dataSession dataTaskWithURL:dataUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!data || error != nil) {
            if (handler) {
                handler(NO, nil, error);
            }
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError * err = nil;
                NSArray * result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
                
                if (handler) {
                    handler(err == nil && result != nil, result, err);
                }
            });
        }
    }];
    [task resume];
}


-(BOOL)haveCachedImageForUrl:(NSString *)imageUrl {
    NSURL * url =  [NSURL URLWithString:imageUrl];
    
    if (url) {
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        return nil != [_imageCache cachedResponseForRequest:request];
    }
    
    return NO;
}

-(void)cancelImageLoadForView:(UIImageView*)targerView {
    NSURLSessionDataTask * currentTask = objc_getAssociatedObject(targerView, (__bridge const void *)(kTASK_KEY));
    if (currentTask) {
        [currentTask cancel];
        objc_setAssociatedObject(targerView, (__bridge const void *)(kTASK_KEY), nil, OBJC_ASSOCIATION_RETAIN);
        objc_setAssociatedObject(targerView, (__bridge const void *)(kTASK_URL_KEY), nil, OBJC_ASSOCIATION_RETAIN);
    }
}

-(void)loadImageWithUrl:(NSString *)imageUrl forView:(UIImageView*)imageView andHandler:(ImageLoadingHandler)handler {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL * url =  [NSURL URLWithString:imageUrl];
        if (url && handler) {
            NSURL * currentURL = objc_getAssociatedObject(imageView, (__bridge const void *)(kTASK_URL_KEY));
            if ([currentURL.absoluteString isEqualToString:url.absoluteString]) {
                handler(imageView.image, nil);
                return;
            }
            [self cancelImageLoadForView:imageView];
            NSURLRequest * request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
            NSCachedURLResponse * cachedResponse =  [_imageCache cachedResponseForRequest:request];
            if (cachedResponse) {
                if (cachedResponse.data.length >0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIImage * img = [UIImage imageWithData:cachedResponse.data scale:[UIScreen mainScreen].scale];
                        if (img){
                            if (handler) {
                                handler(img, nil);
                            }
                        }else {
                            NSLog(@"failed to load cached image");
                        }
                    });
                }
            } else {
                NSURLSessionDataTask * task =
                [_imageSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIImage * img = nil;
                        if (data && !error) {
                            NSCachedURLResponse * cached = [[NSCachedURLResponse alloc] initWithResponse:response data:data userInfo:nil storagePolicy:NSURLCacheStorageAllowed];
                            [_imageCache storeCachedResponse:cached forRequest:request];
                            
                            img = [UIImage imageWithData:data scale:[UIScreen mainScreen].scale];
                            if (!img) {
                                NSLog(@"failed to load image from web");
                            }
                        }
                        
                        if (handler) {
                            handler(img, error);
                        }
                        objc_setAssociatedObject(imageView, (__bridge const void *)(kTASK_URL_KEY), url, OBJC_ASSOCIATION_RETAIN);
                    });
                }];
                [task resume];
                if (!task) {
                    NSLog(@"big trouble");
                }
                objc_setAssociatedObject(imageView, (__bridge const void *)(kTASK_KEY), task, OBJC_ASSOCIATION_RETAIN);
            }
        }else {
            if (handler) {
                
                handler(nil, nil); // TODO: create propper error or so
            }
            NSLog(@"possible invalid url provided");
            
        }
    });
}



@end
