//
//  ACCDataLoaderTests.m
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/26/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ACCDataLoader.h"

@interface PrivateDataLoader : ACCDataLoader

-(void)loadDataFromUrlString:(NSString*)urlString andHandler:(DataLoaderCompletionHandler)handler;

@end

@implementation PrivateDataLoader


@end

@interface FakeNSURLSessionDataTask : NSObject
@property (nonatomic, copy) void(^completionHandler)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error);
-(void)resume;

-(id)initWithError:(NSError*)error data:(NSData*)data andCompletionHandler:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler;

@end

@implementation FakeNSURLSessionDataTask
{
    NSError * _error;
    NSData * _data;
}


-(id)initWithError:(NSError *)error data:(NSData *)data andCompletionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
    self = [super init];
    if (self != nil) {
        _error = error;
        _completionHandler = [completionHandler copy];
        _data = data;
    }
    
    return self;
}

-(void)resume {
    if (self.completionHandler) {
        self.completionHandler(_data, nil, _error);
    }
}

@end

@interface FakeNSURLSession : NSObject
    - (NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url completionHandler:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler;
@end

@implementation FakeNSURLSession

- (NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url completionHandler:(void (^)(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error))completionHandler {
    return nil;
}

@end

@interface  ErrorFakeNSURLSession: FakeNSURLSession

@end

@implementation ErrorFakeNSURLSession

-(NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
    return (NSURLSessionDataTask *)[[FakeNSURLSessionDataTask alloc]initWithError:[NSError errorWithDomain:@"test domain" code:123 userInfo:@{NSLocalizedDescriptionKey:@"fake network error test message"}] data:nil andCompletionHandler:completionHandler];
}


@end


@interface  NOErrorFakeNSURLSession: FakeNSURLSession

@end

@implementation NOErrorFakeNSURLSession

-(NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
    return (NSURLSessionDataTask *)[[FakeNSURLSessionDataTask alloc]initWithError:nil data:[@"{\"isValidJson\":true}" dataUsingEncoding:NSUTF8StringEncoding] andCompletionHandler:completionHandler];
}


@end

@interface ACCDataLoaderTests : XCTestCase

@end

@implementation ACCDataLoaderTests
{
    XCTestExpectation * exp;
}

- (void)setUp {
    [super setUp];
    exp = [self expectationWithDescription:@"something loaded expectation"];

    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void)testDataLoaderCanHandleNetworkError {
    
    PrivateDataLoader * loader = (PrivateDataLoader *)[[ACCDataLoader alloc] initWithURLSession:(NSURLSession*)[[ErrorFakeNSURLSession alloc]init]];
    
    [loader loadDataFromUrlString:@"www.example.com" andHandler:^(BOOL success, NSData *data, NSError *error) {
        
        XCTAssertNotNil(error);
        XCTAssertNil(data);
        
        XCTAssertEqualObjects(error.localizedDescription, @"Failed to download data");
        
        NSString * testErrorMessage = [error valueForKeyPath:@"userInfo.NSUnderlyingError.userInfo.NSLocalizedDescription"];
        XCTAssertEqualObjects(testErrorMessage, @"fake network error test message");
        
        
        [exp fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}


-(void)testDataLoaderCanHandleTaskCreationError {
    
    PrivateDataLoader * loader = (PrivateDataLoader *)[[ACCDataLoader alloc] initWithURLSession:(NSURLSession*)[[FakeNSURLSession alloc]init]];
    
    [loader loadDataFromUrlString:@"www.example.com" andHandler:^(BOOL success, NSData *data, NSError *error) {
        
        XCTAssertNotNil(error);
        XCTAssertNil(data);
        [exp fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}


-(void)testDataLoaderHandleInvalidUrl {
    
    PrivateDataLoader * loader = (PrivateDataLoader *)[[ACCDataLoader alloc] initWithURLSession:[NSURLSession sharedSession]];
    
    
    [loader loadDataFromUrlString:@"invalid url string" andHandler:^(BOOL success, NSData *data, NSError *error) {
        XCTAssertFalse(success);
        XCTAssertNotNil(error);
        [exp fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}


-(void)testDataLoaderCanLoadData {
    PrivateDataLoader * loader = (PrivateDataLoader *)[[ACCDataLoader alloc] initWithURLSession:(NSURLSession*)[[NOErrorFakeNSURLSession alloc]init]];
    
    
    [loader loadDataFromUrlString:@"www.example.com" andHandler:^(BOOL success, NSData *data, NSError *error) {
        XCTAssertTrue(success);
        XCTAssertNil(error);
        XCTAssertNotNil(data);
        [exp fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
    
}

// not real test :)
-(void)testDataLoaderCanLoadRealQuestionsData {
    ACCDataLoader * loader = [[ACCDataLoader alloc] initWithURLSession:[NSURLSession sharedSession]];
    
    [loader loadQuestionsDataWithSearchString:@"message" page:1 andCompletionHandler:^(BOOL success, NSData *data, NSError *error) {
        
        XCTAssertNotNil(data);
        [exp fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:15.0 handler:^(NSError *error) {
        if (error) {
            NSLog(@"Timeout Error: %@", error);
        }
    }];
}

@end
