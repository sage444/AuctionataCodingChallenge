//
//  ACCAPIWrapperObject.h
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/25/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACCAPIObjectProtocol.h"

@interface ACCAPIWrapperObject : NSObject

@property (nonatomic, readonly) NSInteger page;
@property (nonatomic, readonly) NSInteger pageSize;
@property (nonatomic, readonly) NSInteger total;

@property (nonatomic, readonly) BOOL hasMore;

@property (nonatomic, strong, readonly, nullable) NSArray<id<ACCAPIObjectProtocol>> * items;
@property (nonatomic, strong, readonly, nullable) NSString * errorMessage;

-(nonnull instancetype)initWithJSONData:(nonnull id)JSONData andItemClass:(nonnull Class)itemClass;

@end
