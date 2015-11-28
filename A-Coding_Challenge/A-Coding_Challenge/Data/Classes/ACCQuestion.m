//
//  ACCQuestion.m
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/24/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import "ACCQuestion.h"
#import "ACCUser.h"

@implementation ACCQuestion


-(instancetype)initWithJSONData:(id)jsonData {
    self = [super init];
    if (self != nil) {
        NSNumber * i = [jsonData objectForKey:@"question_id"];
        _questionId = i.integerValue;
        
        _title = [jsonData objectForKey:@"title"];
        
        NSNumber * ti = [jsonData objectForKey:@"creation_date"];
        NSDate * cd = [NSDate dateWithTimeIntervalSince1970:ti.integerValue];
        _creationDate = cd;
        
        id userJson = [jsonData objectForKey:@"owner"];
        _owner = [[ACCUser alloc] initWithJSONData:userJson];
        
        _body = [jsonData objectForKey:@"body_markdown"];
    }
    return self;
}


@end
