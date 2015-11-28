//
//  ACCDataLoader.h
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/23/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DataLoaderCompletionHandler)(BOOL success, NSData * data, NSError * error);

//typedef void (^LoadCompletionHandler)(BOOL success, NSArray * items, NSError * error);

@interface ACCDataLoader : NSObject

-(instancetype)initWithURLSession:(NSURLSession*)session;

-(void)loadQuestionsDataWithSearchString:(NSString *)searchString page:(NSInteger)page andCompletionHandler:(DataLoaderCompletionHandler)handler;


-(void)loadQuestionDataWithId:(NSInteger)questionId andHandler:(DataLoaderCompletionHandler)handler;

-(void)loadAnswersDataForQuestionId:(NSInteger)questionId andHandler:(DataLoaderCompletionHandler)handler;

-(void)loadCommentsDataForQuestionId:(NSInteger)questionId andHandler:(DataLoaderCompletionHandler)handler;
-(void)loadCommentsDataForAnswerId:(NSInteger)answerId andHandler:(DataLoaderCompletionHandler)handler;

-(void)cancelCurentTask;

@end
