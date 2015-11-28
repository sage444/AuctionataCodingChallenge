//
//  ACCComment.m
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/24/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import "ACCComment.h"
#import "ACCUser.h"

@implementation ACCComment

-(instancetype)initWithJSONData:(id)jsonData {
    self = [super init];
    if (self != nil) {
        NSNumber * ci = [jsonData objectForKey:@"comment_id"];
        _commentId = ci.integerValue;

        
        NSNumber * pi = [jsonData objectForKey:@"post_id"];
        _postId = pi.integerValue;
        
        _body = [jsonData objectForKey:@"body_markdown"];
        
        _owner = [[ACCUser alloc] initWithJSONData:[jsonData objectForKey:@"owner"]];
    }
    return self;
}

@end
