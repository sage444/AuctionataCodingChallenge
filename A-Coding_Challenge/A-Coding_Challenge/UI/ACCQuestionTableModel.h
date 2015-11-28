//
//  ACCQuestionTableModel.h
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/27/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import  "ACCDataLoader.h"

typedef void (^ItemLoadHandler)(BOOL success, NSArray * items, NSError * error);

@interface ACCQuestionTableModel : NSObject <UITableViewDataSource>

-(void)loadQuestionWithSearchString:(NSString *)string page:(NSInteger)page andHandler:(ItemLoadHandler)handler;

-(NSInteger)questionIdForIndex:(NSInteger)index;

@end
