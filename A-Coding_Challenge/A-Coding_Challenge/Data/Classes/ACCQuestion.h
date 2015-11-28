//
//  ACCQuestion.h
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/24/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACCAPIObjectProtocol.h"

@class ACCUser;
@class ACCComment;

@interface ACCQuestion : NSObject <ACCAPIObjectProtocol>

@property (nonatomic, readonly) NSInteger questionId;
@property (nonatomic, strong, readonly) NSString * title;
@property (nonatomic, strong, readonly) NSString * body;
@property (nonatomic, strong, readonly) NSDate * creationDate;
@property (nonatomic, strong, readonly) ACCUser * owner;
@property (nonatomic, strong) NSArray<ACCComment *> * comment;
@end
