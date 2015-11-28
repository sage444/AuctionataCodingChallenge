//
//  ACCQuestionDetailsViewController.m
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/28/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import "ACCQuestionDetailsViewController.h"
#import "ACCQuestionDetailsModel.h"

const CGFloat kACCQuestionDetailsViewControllerEstimatedRowHeight = 20.0;

@interface ACCQuestionDetailsViewController () <ACCQuestionDetailsModelDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ACCQuestionDetailsViewController
{
    ACCQuestionDetailsModel * _dataModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataModel = [[ACCQuestionDetailsModel alloc]initWithQuestionId:_questionId];
    _dataModel.dalegate = self;
    _tableView.dataSource = _dataModel;
    
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = kACCQuestionDetailsViewControllerEstimatedRowHeight;
    
    
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    _tableView.estimatedRowHeight = kACCQuestionDetailsViewControllerEstimatedRowHeight;
    [_tableView reloadData];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_dataModel loadData];
}


#pragma mark - data model delegate 

-(void)reloadTableView {
    [_tableView reloadData];
    
    NSString *title = [NSString stringWithFormat:@"%@:%ld", NSLocalizedString(@"Question", nil), _questionId];
    self.title = title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
