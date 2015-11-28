//
//  ACCAnswerTests.m
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/26/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ACCAnswer.h"

@interface ACCAnswerTests : XCTestCase

@end

@implementation ACCAnswerTests
{
    NSString * _sampleJSON;
    id _parsed;
}
- (void)setUp {
    [super setUp];

    _sampleJSON = @"{\"owner\":{\
    \"reputation\":6478,\"user_id\":665575,\"user_type\":\"registered\",\"profile_image\":\"https://www.gravatar.com/avatar/5b71ac3add821b6699ffe23dc7a592c1?s=128&d=identicon&r=PG\",\"display_name\":\"tom\",\"link\":\"http://stackoverflow.com/users/665575/tom\"},\
    \"is_accepted\":false,\
    \"score\":0,\
    \"last_activity_date\":1448572266,\
    \"creation_date\":1448572266,\
    \"answer_id\":33947040,\
    \"question_id\":33947005}";
    
    _parsed = [NSJSONSerialization JSONObjectWithData:[_sampleJSON dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testAnswerCanParseJSON {
    ACCAnswer * ta = [[ACCAnswer alloc] initWithJSONData:_parsed];
    XCTAssertNotNil(ta);
}

-(void)testAnswerCanParseAnswerId {
    ACCAnswer * ta = [[ACCAnswer alloc] initWithJSONData:_parsed];
    XCTAssertEqual(ta.answerId, 33947040);
}


-(void)testAnswerCanParseOwner {
    ACCAnswer * ta = [[ACCAnswer alloc] initWithJSONData:_parsed];
    XCTAssertNotNil(ta.owner);
}

@end
