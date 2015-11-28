//
//  ACCAnswer.m
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/24/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import "ACCAnswer.h"
#import "ACCUser.h"

@implementation ACCAnswer


-(instancetype)initWithJSONData:(id)jsonData {
    self = [super init];
    if (self != nil) {
        NSNumber * i = [jsonData objectForKey:@"answer_id"];
        _answerId = i.integerValue;
        
        _owner = [[ACCUser alloc] initWithJSONData:[jsonData objectForKey:@"owner"]];
        
        _body = [jsonData objectForKey:@"body_markdown"];
        
        NSNumber * ti = [jsonData objectForKey:@"creation_date"];
        NSDate * cd = [NSDate dateWithTimeIntervalSince1970:ti.integerValue];
        _creationDate = cd;

    }
    return self;
}

@end
