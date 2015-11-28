//
//  ACCAPIWrapperObject.m
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/25/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import "ACCAPIWrapperObject.h"
#import "ACCAPIObjectProtocol.h"


@implementation ACCAPIWrapperObject

-(instancetype)initWithJSONData:(id)JSONData andItemClass:(Class)itemClass {
    self = [super init];
    if (self != nil) {
        NSNumber * p = [JSONData objectForKey:@"page"];
        _page = p.integerValue;

        NSNumber * ps = [JSONData objectForKey:@"page_size"];
        _pageSize = ps.integerValue;

        NSNumber * t = [JSONData objectForKey:@"total"];
        _total = t.integerValue;
        
        NSNumber * hm = [JSONData objectForKey:@"has_more"];
        _hasMore = hm.boolValue;
        
        _errorMessage = [JSONData objectForKey:@"error_message"];

        if ([itemClass conformsToProtocol:@protocol(ACCAPIObjectProtocol)]) {
            NSMutableArray * itemsArray = [NSMutableArray new];
            NSArray * items = [JSONData objectForKey:@"items"];

            for (id obj in items) {
                [itemsArray addObject:[[itemClass alloc] initWithJSONData:obj]];
            }
            _items = [itemsArray copy];
        }
    }
    return self;
}

@end
