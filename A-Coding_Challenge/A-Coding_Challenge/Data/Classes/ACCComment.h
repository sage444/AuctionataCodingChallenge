//
//  ACCComment.h
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/24/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACCAPIObjectProtocol.h"

@class  ACCUser;

@interface ACCComment : NSObject <ACCAPIObjectProtocol>

@property (nonatomic, readonly) NSInteger commentId;
@property (nonatomic, strong, readonly) NSString * body;
@property (nonatomic, strong, readonly) ACCUser * owner;
@property (nonatomic, readonly) NSInteger postId;

@end
