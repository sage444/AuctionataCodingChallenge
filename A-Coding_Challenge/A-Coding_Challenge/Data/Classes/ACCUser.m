//
//  ACCUser.m
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/24/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import "ACCUser.h"

@implementation ACCUser


-(instancetype)initWithJSONData:(id)jsonData {
    self = [super init];
    if (self != nil) {
        NSNumber * i = [jsonData objectForKey:@"user_id"];
        _userId = i.integerValue;
        
        _name = [jsonData objectForKey:@"display_name"];
        
        _avatarUrlString = [jsonData objectForKey:@"profile_image"];
        
        NSNumber * rp = [jsonData objectForKey:@"reputation"];
        _reputation = rp.integerValue;
    }
    return self;
}

@end
