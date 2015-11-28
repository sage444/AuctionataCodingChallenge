//
//  ACCQuestionTableModel.m
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/27/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import "ACCQuestionTableModel.h"
#import "ACCDataLoader.h"
#import "ACCQuestion.h"
#import "ACCQuestionTableViewCell.h"
#import "ACCDataLoader.h"
#import "ACCAPIWrapperObject.h"

static NSString * const kQuestionCellId = @"ACCQuestionTableViewCell";

@implementation ACCQuestionTableModel
{
    ACCDataLoader * _dataLoader;
    NSArray<ACCQuestion *> * _questionList;
    ACCAPIWrapperObject * _lastAPIAnswer;
    NSString * _lastRequestString;
}

-(id)init {
    self = [super init];
    
    if (self != nil) {
        _dataLoader = [[ACCDataLoader alloc] initWithURLSession:[NSURLSession sharedSession]];
    }
    
    return self;
}

-(void)loadQuestionWithSearchString:(NSString *)string page:(NSInteger)page andHandler:(ItemLoadHandler)handler;
{
    if (handler) {
        [_dataLoader loadQuestionsDataWithSearchString:string page:page andCompletionHandler:^(BOOL success, NSData *data, NSError *error) {
            if (success) {
                NSError * parsingError = nil;
                id parsed = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parsingError];
                if (parsed != nil && parsingError == nil) {
                    ACCAPIWrapperObject * wraper = [[ACCAPIWrapperObject alloc] initWithJSONData:parsed andItemClass:[ACCQuestion class]];
                    if (wraper.errorMessage == nil) {
                        _lastRequestString = string;
                        _lastAPIAnswer = wraper;
                        _questionList = [wraper.items copy];
                        handler(YES, _questionList, nil);
                    } else {
                        _questionList = nil;
                        _lastAPIAnswer = nil;
                        _lastRequestString = nil;
                        handler(NO, nil, [NSError errorWithDomain:@"QueastionTableModelEror" code:0 userInfo:@{NSLocalizedDescriptionKey: wraper.errorMessage}]);
                    }
                } else {
                    _questionList = nil;
                    handler(NO, nil, parsingError);
                }
            } else {
                _questionList = nil;
                handler(NO, nil, error);
            }
            
        }];
    }
}

-(NSInteger)questionIdForIndex:(NSInteger)index {
    if (_questionList != nil && index < _questionList.count) {
        ACCQuestion * q = [_questionList objectAtIndex:index];
        return q.questionId;
    }
    return NSNotFound;
}

#pragma mark - table view data source 

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_questionList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ACCQuestionTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kQuestionCellId forIndexPath:indexPath];
    
    [cell setData:[_questionList objectAtIndex:indexPath.row]];
    
    return cell;
}

@end
