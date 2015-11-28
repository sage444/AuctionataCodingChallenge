//
//  ACCUser.h
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/24/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACCAPIObjectProtocol.h"

@interface ACCUser : NSObject <ACCAPIObjectProtocol>
@property (nonatomic, readonly) NSInteger userId;
@property (nonatomic, strong, readonly) NSString * name;
@property (nonatomic, strong, readonly) NSString * avatarUrlString;
@property (nonatomic, readonly) NSInteger reputation;

@end
