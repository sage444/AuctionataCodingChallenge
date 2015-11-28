//
//  ACCQuestionDetailsModel.m
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/28/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import "ACCQuestionDetailsModel.h"
#import "ACCQuestion.h"
#import "ACCAnswer.h"
#import "ACCComment.h"
#import "ACCDataLoader.h"
#import "ACCQuestionDetailsCell.h"
#import "ACCCommentTableViewCell.h"
#import "ACCAPIWrapperObject.h"

@implementation ACCQuestionDetailsModel
{
    NSInteger _questionId;
    NSArray<ACCAnswer*> * _answers;
    ACCQuestion * _question;
    ACCDataLoader * _dataLoader;
    
    dispatch_group_t _commentLoadGroup;
    dispatch_group_t _answerLoadGroup;
}

-(id)initWithQuestionId:(NSInteger)questionId {
    self = [super init];
    if (self != nil) {
        _questionId = questionId;
        _dataLoader = [[ACCDataLoader alloc] initWithURLSession:[NSURLSession sharedSession]];
    }
    return self;
}

#pragma mark - data load 

-(void)loadData {
    [self loadQuestionData];
}


-(void)loadQuestionData {
    _answerLoadGroup = dispatch_group_create();
    
    dispatch_group_enter(_answerLoadGroup);
    [_dataLoader loadQuestionDataWithId:_questionId andHandler:^(BOOL success, NSData *data, NSError *error) {
        if (!error && data != nil) {
            NSError * parsingError = nil;
            id parsed = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parsingError];
            if (parsingError != nil || parsed == nil) {
                // TODO: handle parsing error
            } else {
                ACCAPIWrapperObject * w = [[ACCAPIWrapperObject alloc] initWithJSONData:parsed andItemClass:[ACCQuestion class]];
                if (w.errorMessage == nil) {
                    _question = [w.items objectAtIndex:0];
                }
            }
        }
        dispatch_group_leave(_answerLoadGroup);
        
    }];
    
    
    dispatch_group_enter(_answerLoadGroup);
    [_dataLoader loadAnswersDataForQuestionId:_questionId andHandler:^(BOOL success, NSData *data, NSError *error) {
        if (!error && data != nil) {
            NSError * parsingError = nil;
            id parsed = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parsingError];
            if (parsingError != nil || parsed == nil) {
                // TODO: handle parsing error
            } else {
                ACCAPIWrapperObject * w = [[ACCAPIWrapperObject alloc] initWithJSONData:parsed andItemClass:[ACCAnswer class]];
                if (w.errorMessage == nil) {
                    _answers = [w.items copy];
                }
            }
        }
        dispatch_group_leave(_answerLoadGroup);
    }];
    
    
    dispatch_group_notify(_answerLoadGroup, dispatch_get_main_queue(), ^{
        [self loadComments];
    });
    
}

-(void)loadComments {
    _commentLoadGroup = dispatch_group_create();
    
    dispatch_group_enter(_commentLoadGroup);
    [_dataLoader loadCommentsDataForQuestionId:_questionId andHandler:^(BOOL success, NSData *data, NSError *error) {
        if (!error && data != nil) {
            NSError * parsingError = nil;
            id parsed = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parsingError];
            if (parsingError != nil || parsed == nil) {
                // TODO: handle parsing error
            } else {
                ACCAPIWrapperObject * w = [[ACCAPIWrapperObject alloc] initWithJSONData:parsed andItemClass:[ACCComment class]];
                if (w.errorMessage == nil) {
                    _question.comment = [w.items copy];
                }
            }
        }
        dispatch_group_leave(_commentLoadGroup);
    }];
    
    for (ACCAnswer * answer in _answers) {
        dispatch_group_enter(_commentLoadGroup);
        [_dataLoader loadCommentsDataForAnswerId:answer.answerId andHandler:^(BOOL success, NSData *data, NSError *error) {
            if (!error && data != nil) {
                NSError * parsingError = nil;
                id parsed = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parsingError];
                if (parsingError != nil || parsed == nil) {
                    // TODO: handle parsing error
                } else {
                    ACCAPIWrapperObject * w = [[ACCAPIWrapperObject alloc] initWithJSONData:parsed andItemClass:[ACCComment class]];
                    if (w.errorMessage == nil) {
                        answer.comment = [w.items copy];
                    }
                }
            }
            dispatch_group_leave(_commentLoadGroup);
        }];
    }
    
    dispatch_group_notify(_commentLoadGroup, dispatch_get_main_queue(), ^{
        [self reloadTable];
    });

}

-(void)reloadTable {
    if (_dalegate != nil) {
        [_dalegate reloadTableView];
    }
}

#pragma mark - table data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if (!_question) {
        return 0;
    } else if (_answers != nil) {
        return _answers.count + 1;
    } else {
        return 1;
    }
    
    return 0;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
    
        if (_question != nil) {
            return _question.comment.count + 1;
        } else {
            return 0;
        }
    } else {
    
       return [_answers[section - 1].comment count] + 1;
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell<ACCSetDataProtocol> * cell = nil;
    id <ACCAPIObjectProtocol> data = nil;
    if (indexPath.row == 0) { // question details
        cell = [tableView dequeueReusableCellWithIdentifier:@"ACCQuestionDetailsCell" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            data = _question;
        } else {
            data = [_answers objectAtIndex:indexPath.section -1];
        }
    } else { //comment
        cell = [tableView dequeueReusableCellWithIdentifier:@"ACCCommentTableViewCell" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            data = [_question.comment objectAtIndex:indexPath.row - 1];
        } else {
            data = [[_answers objectAtIndex:indexPath.section -1].comment objectAtIndex:indexPath.row - 1];
        }
    }
    
    [cell setData:data];
    
    return cell;
}


-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section > 0) {
        NSString * header = [NSString stringWithFormat:@"%@ #%ld", NSLocalizedString(@"Answer", ), section];
        return header;
    }
    return nil;
}


-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0 && [_answers count] == 0) {
        return NSLocalizedString(@"No Answers Yet", );
    }
    return nil;
}
@end
