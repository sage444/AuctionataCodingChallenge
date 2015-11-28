//
//  ACCUserTests.m
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/26/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ACCUser.h"

@interface ACCUserTests : XCTestCase

@end

@implementation ACCUserTests
{
    NSString * _sampleJSON;
    id _parsed;
}
- (void)setUp {
    [super setUp];
    
    _sampleJSON = @"{\
    \"reputation\":6478,\
    \"user_id\":665575,\
    \"user_type\":\"registered\",\
    \"profile_image\":\"https://www.gravatar.com/avatar/5b71ac3add821b6699ffe23dc7a592c1?s=128&d=identicon&r=PG\",\
    \"display_name\":\"tom\",\
    \"link\":\"http://stackoverflow.com/users/665575/tom\"}";
    
    _parsed = [NSJSONSerialization JSONObjectWithData:[_sampleJSON dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void)testUserCanParseJSON {
    ACCUser * tu = [[ACCUser alloc]initWithJSONData:_parsed];
    
    XCTAssertNotNil(tu);
}


-(void)testUserCanParseUserID {
    ACCUser * tu = [[ACCUser alloc]initWithJSONData:_parsed];
    
    XCTAssertEqual(tu.userId, 665575);
}

-(void)testUserCanParseReputationPoints {
    ACCUser * tu = [[ACCUser alloc]initWithJSONData:_parsed];
    
    XCTAssertEqual(tu.reputation, 6478);
}


-(void)testUserCanParseImageURL {
    ACCUser * tu = [[ACCUser alloc]initWithJSONData:_parsed];
    
    XCTAssertEqualObjects(tu.avatarUrlString, @"https://www.gravatar.com/avatar/5b71ac3add821b6699ffe23dc7a592c1?s=128&d=identicon&r=PG");
}

@end
