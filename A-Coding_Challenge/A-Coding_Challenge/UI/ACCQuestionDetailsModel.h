//
//  ACCQuestionDetailsModel.h
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/28/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ACCQuestionDetailsModelDelegate <NSObject>

-(void)reloadTableView;

@end

@interface ACCQuestionDetailsModel : NSObject <UITableViewDataSource>

@property (nonatomic, weak) id<ACCQuestionDetailsModelDelegate> dalegate;

-(id)initWithQuestionId:(NSInteger)questionId;

-(void)loadData;

@end
