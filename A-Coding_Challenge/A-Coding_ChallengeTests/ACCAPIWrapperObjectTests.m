//
//  ACCAPIWrapperObjectTests.m
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/25/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ACCAPIWrapperObject.h"
#import "ACCQuestion.h"


@interface ACCAPIWrapperObjectTests : XCTestCase

@end

@implementation ACCAPIWrapperObjectTests
{
    NSString * _sampleJSON;
    id _parsedJSON;
}


- (void)setUp {
    [super setUp];
    _sampleJSON = @"{\"items\":[{\
    \"tags\":[\"jquery\",\"jquery-ui\",\"date\",\"datepicker\"],\
    \"owner\":{\
    \"reputation\":537,\
    \"user_id\":1739313,\
    \"user_type\":\"registered\",\
    \"accept_rate\":89,\
    \"profile_image\":\"https://www.gravatar.com/avatar/829faa2293133976fe5ce2ff139fa0cc?s=128&d=identicon&r=PG\",\
    \"display_name\":\"Sbpro\",\
    \"link\":\"http://stackoverflow.com/users/1739313/sbpro\"},\
    \"is_answered\":false,\
    \"view_count\":8,\
    \"answer_count\":1,\
    \"score\":0,\
    \"last_activity_date\":1448481252,\
    \"creation_date\":1448480840,\
    \"last_edit_date\":1448481252,\
    \"question_id\":33925215,\
    \"link\":\"http://stackoverflow.com/questions/33925215/display-message-when-user-tries-to-click-after-max-date\",\
    \"title\":\"Display message when user tries to click after max date\"\
    },\
    {\"tags\":[\"java\",\"struts2\"],\"owner\":{\"reputation\":1,\"user_id\":5605695,\"user_type\":\"registered\",\"profile_image\":\"https://www.gravatar.com/avatar/0548b905ab0f0e0d2442aa8be29fa9c2?s=128&d=identicon&r=PG&f=1\",\"display_name\":\"Kumar Saket\",\"link\":\"http://stackoverflow.com/users/5605695/kumar-saket\"},\"is_answered\":false,\"view_count\":8,\"answer_count\":0,\"score\":0,\"last_activity_date\":1448480968,\"creation_date\":1448479187,\"last_edit_date\":1448480968,\"question_id\":33924779,\"link\":\"http://stackoverflow.com/questions/33924779/message-resource-element-not-defined\",\"title\":\"message resource element not defined\"}, \
    {\"tags\":[\"php\",\"twitter\"],\"owner\":{\"reputation\":1682,\"user_id\":273266,\"user_type\":\"registered\",\"accept_rate\":68,\"profile_image\":\"https://www.gravatar.com/avatar/fd448062324c270a03d19c316a5356f6?s=128&d=identicon&r=PG\",\"display_name\":\"Warrior\",\"link\":\"http://stackoverflow.com/users/273266/warrior\"},\"is_answered\":true,\"view_count\":179,\"accepted_answer_id\":7963266,\"answer_count\":2,\"score\":0,\"last_activity_date\":1448480231,\"creation_date\":1320128100,\"last_edit_date\":1417017586,\"question_id\":7963078,\"link\":\"http://stackoverflow.com/questions/7963078/sending-message-to-twitter-followers-from-facebook-app\",\"title\":\"Sending message to Twitter followers from facebook app\"},{\"tags\":[\"php\",\"laravel\",\"phpstorm\"],\"owner\":{\"reputation\":581,\"user_id\":498504,\"user_type\":\"registered\",\"accept_rate\":79,\"profile_image\":\"https://www.gravatar.com/avatar/3364e7baa857383af5cfe1ce39e06efb?s=128&d=identicon&r=PG\",\"display_name\":\"ahmad\",\"link\":\"http://stackoverflow.com/users/498504/ahmad\"},\"is_answered\":false,\"view_count\":20,\"answer_count\":1,\"score\":3,\"last_activity_date\":1448479949,\"creation_date\":1448468021,\"last_edit_date\":1448479949,\"question_id\":33921310,\"link\":\"http://stackoverflow.com/questions/33921310/waiting-for-incoming-connection-with-ide-key-message-on-phpstorm-with-laravel\",\"title\":\"Waiting for incoming connection with ide key Message on PHPStorm with laravel\"},{\"tags\":[\"sockets\",\"tcl\"],\"owner\":{\"reputation\":1053,\"user_id\":670078,\"user_type\":\"registered\",\"accept_rate\":60,\"profile_image\":\"https://www.gravatar.com/avatar/c53b2e36160e23d854e613bad2157669?s=128&d=identicon&r=PG\",\"display_name\":\"Panagiotis\",\"link\":\"http://stackoverflow.com/users/670078/panagiotis\"},\"is_answered\":false,\"view_count\":6,\"answer_count\":0,\"score\":0,\"last_activity_date\":1448478429,\"creation_date\":1448478429,\"question_id\":33924563,\"link\":\"http://stackoverflow.com/questions/33924563/tcl-ping-message-every-30-seconds\",\"title\":\"tcl ping message every 30 seconds\"}\
    ],\"has_more\":true,\"quota_max\":300,\"quota_remaining\":143,\"page\":14,\"page_size\":50}";

    _parsedJSON = [NSJSONSerialization JSONObjectWithData:[_sampleJSON dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

-(void)testWrapperObjectCanParseJSON {
    
    ACCAPIWrapperObject * wrp = [[ACCAPIWrapperObject alloc]initWithJSONData:_parsedJSON andItemClass:[NSObject class]];
    
    XCTAssertNotNil(wrp);
}

-(void)testHasMoreIsTrue {
    ACCAPIWrapperObject * wrp = [[ACCAPIWrapperObject alloc]initWithJSONData:_parsedJSON andItemClass:[NSObject class]];
    
    XCTAssert(wrp.hasMore == YES);

}

-(void)testPageIs14 {
    ACCAPIWrapperObject * wrp = [[ACCAPIWrapperObject alloc]initWithJSONData:_parsedJSON andItemClass:[NSObject class]];
    
    XCTAssert(wrp.page == 14);
    
}

-(void)testPageSizeIs50 {
    ACCAPIWrapperObject * wrp = [[ACCAPIWrapperObject alloc]initWithJSONData:_parsedJSON andItemClass:[NSObject class]];
    
    XCTAssert(wrp.pageSize == 50);
    
}


-(void)testQuestionItemsCountIs5 {
    ACCAPIWrapperObject * wrp = [[ACCAPIWrapperObject alloc]initWithJSONData:_parsedJSON andItemClass:[ACCQuestion class]];
    
    XCTAssert(wrp.items.count == 5);

}

-(void)testItemsClassIsCorrect {
    Class qc = [ACCQuestion class];
    
    ACCAPIWrapperObject * wrp = [[ACCAPIWrapperObject alloc]initWithJSONData:_parsedJSON andItemClass:qc];
    
    XCTAssertEqual([[wrp.items firstObject] class], qc);
}


@end
