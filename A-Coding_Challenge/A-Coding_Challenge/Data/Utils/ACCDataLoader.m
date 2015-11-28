//
//  ACCDataLoader.m
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/23/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import "ACCDataLoader.h"
#import "ACCAPIWrapperObject.h"

typedef void (^DataLoaderCompletionHandler)(BOOL success, NSData * data, NSError * error);

static NSString * const kACCDataLoaderErrorDomain = @"net.wbyte.ACCDataLoaderErrorDomain";
static NSString * const kACCDataLoaderAPIURL = @"https://api.stackexchange.com/2.2/";
const NSInteger kACCDataLoaderPageSize = 30;

@implementation ACCDataLoader
{
    NSURLSession * _session;

}

-(instancetype)initWithURLSession:(NSURLSession*)session {
    self = [super init];
    _session = session;
    return self;
}

-(void)loadDataFromUrlString:(NSString*)urlString andHandler:(DataLoaderCompletionHandler)handler {

    if (!handler) {
        return;
    }
    
    if (urlString.length > 0) {
    
        NSURL * url = [NSURL URLWithString:urlString];
        if (!url) {
            handler(NO, nil, [ACCDataLoader errorWithUnderlaingError:nil code:0 localizedMessage:NSLocalizedString(@"Invalid URL", nil)]);
            return;
        }
        
        NSURLSessionTask * task = [_session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data != nil) {
                handler(YES, data, nil);
            }else {
                handler(NO, nil, [ACCDataLoader errorWithUnderlaingError:error code:0 localizedMessage:NSLocalizedString(@"Failed to download data", nil)]);
            }
        }];
        if (task) {
            [task resume];
        } else {
            handler(NO, nil, [ACCDataLoader errorWithUnderlaingError:nil code:0 localizedMessage:NSLocalizedString(@"Failed to create download data task", nil)]);
        }
    } else {
        handler(NO, nil, [ACCDataLoader errorWithUnderlaingError:nil code:0 localizedMessage:NSLocalizedString(@"URL can't be empty", nil)]);
    }
}


-(void)loadQuestionsDataWithSearchString:(NSString *)searchString page:(NSInteger)page andCompletionHandler:(DataLoaderCompletionHandler)handler {
    if (!handler) {
        return;
    }
    
    NSString * requestUrl = [ACCDataLoader questionsUrlStringWithSearchRequest:searchString andPageNumber:page];
    
    [self loadDataFromUrlString:requestUrl andHandler:handler ];
}

-(void)loadQuestionDataWithId:(NSInteger)questionId andHandler:(DataLoaderCompletionHandler)handler {
    if (!handler) {
        return;
    }
    
    NSString * requestUrl = [ACCDataLoader questionsUrlStringWithQuestionId:(NSInteger)questionId];
    
    [self loadDataFromUrlString:requestUrl andHandler:handler];
}

-(void)loadAnswersDataForQuestionId:(NSInteger)questionId andHandler:(DataLoaderCompletionHandler)handler {
    if (!handler) {
        return;
    }
    
    NSString * requestUrl = [ACCDataLoader answersUrlStringWithQuestionId:(NSInteger)questionId];
    
    [self loadDataFromUrlString:requestUrl andHandler:handler];

}

-(void)loadCommentsDataForQuestionId:(NSInteger)questionId andHandler:(DataLoaderCompletionHandler)handler {
    if (!handler) {
        return;
    }
    
    NSString * requestUrl = [ACCDataLoader questionsComentsUrlStringWithQuestionId:questionId];
    
    [self loadDataFromUrlString:requestUrl andHandler:handler];
    
}

-(void)loadCommentsDataForAnswerId:(NSInteger)answerId andHandler:(DataLoaderCompletionHandler)handler {
    if (!handler) {
        return;
    }
    
    NSString * requestUrl = [ACCDataLoader answersComentsUrlStringWithAnswerId:answerId];
    
    [self loadDataFromUrlString:requestUrl andHandler:handler];

}


-(void)cancelCurentTask {
    [_session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        
        for (NSURLSessionTask *_task in downloadTasks)
        {
            [_task cancel];
        }
    }];
}

#pragma mark - URL formaters
// TODO: refactoring? nobody hears this strange word 

+(NSString *)questionsComentsUrlStringWithQuestionId:(NSInteger)questionId {
    
    NSString * mainParam = [NSString stringWithFormat:@"questions/%ld/comments", questionId];;
    
    NSString * kSite = @"?order=asc&sort=creation&site=stackoverflow&key=SdNhI6sK6HD1Qnoj4rLdkQ((";

    NSString * questionsFilter = @"&filter=!9YdnSO*fk";
    
    NSString * finalUrl = [NSString stringWithFormat:@"%@%@%@%@", kACCDataLoaderAPIURL, mainParam, kSite, questionsFilter];
    
    return finalUrl;
}

+(NSString *)answersComentsUrlStringWithAnswerId:(NSInteger)answerId {
    
    NSString * mainParam = [NSString stringWithFormat:@"answers/%ld/comments", answerId];;
    
    NSString * kSite = @"?order=asc&sort=creation&site=stackoverflow&key=SdNhI6sK6HD1Qnoj4rLdkQ((";
    
    NSString * questionsFilter = @"&filter=!9YdnSO*fk";
    
    NSString * finalUrl = [NSString stringWithFormat:@"%@%@%@%@", kACCDataLoaderAPIURL, mainParam, kSite, questionsFilter];
    
    return finalUrl;
}

+(NSString *)answersUrlStringWithQuestionId:(NSInteger)questionId {
    
    NSString * mainParam = [NSString stringWithFormat:@"questions/%ld/answers", questionId];;
    
    NSString * kSite = @"?site=stackoverflow&key=SdNhI6sK6HD1Qnoj4rLdkQ((";
    
    NSString * questionsFilter = @"&filter=!9YdnSMlgz";
    
    NSString * finalUrl = [NSString stringWithFormat:@"%@%@%@%@", kACCDataLoaderAPIURL, mainParam, kSite, questionsFilter];
    
    return finalUrl;
}

+(NSString *)questionsUrlStringWithQuestionId:(NSInteger)questionId {
    
    NSString * mainParam = [NSString stringWithFormat:@"questions/%ld", questionId];;
    
    NSString * kSite = @"?site=stackoverflow&key=SdNhI6sK6HD1Qnoj4rLdkQ((";
    
    NSString * questionsFilter = @"&filter=!9YdnSIoOi";
    
    NSString * finalUrl = [NSString stringWithFormat:@"%@%@%@%@", kACCDataLoaderAPIURL, mainParam, kSite, questionsFilter];
    
    return finalUrl;
}



+(NSString *)questionsUrlStringWithSearchRequest:(NSString*)searchRequest andPageNumber:(NSInteger)pageNumber {
    NSString * searchFormat = @"search?intitle=%@";

    NSString * searchParam = [NSString stringWithFormat:searchFormat, [searchRequest stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    
    NSString * kDefaultSortingAndPagingFormat = @"&order=desc&sort=activity&page_size=%d&page=%d";
    
    NSString * kSite = @"&site=stackoverflow&key=SdNhI6sK6HD1Qnoj4rLdkQ((";

    NSString * questionsFilter = @"&filter=!9YdnSQVgz";
    
    NSString * pagingParam = [NSString stringWithFormat:kDefaultSortingAndPagingFormat, kACCDataLoaderPageSize, pageNumber];
    
    NSString * finalUrl = [NSString stringWithFormat:@"%@%@%@%@%@", kACCDataLoaderAPIURL, searchParam, pagingParam, kSite, questionsFilter];
    
    return finalUrl;
}

+(NSError *)errorWithUnderlaingError:(NSError*)underError code:(NSInteger)code localizedMessage:(NSString*)message {
    NSDictionary * userInfo = nil;
    if (underError != nil) {
        userInfo = @{NSUnderlyingErrorKey:underError, NSLocalizedDescriptionKey:message};
    } else {
        userInfo = @{NSLocalizedDescriptionKey:message};
    }
 
    return [[NSError alloc] initWithDomain:kACCDataLoaderErrorDomain code:code userInfo:userInfo];
}

@end
