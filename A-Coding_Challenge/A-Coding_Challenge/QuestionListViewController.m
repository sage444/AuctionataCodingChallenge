//
//  QuestionListViewController.m
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/23/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import "QuestionListViewController.h"
#import "ACCQuestionTableModel.h"
#import "ACCQuestionDetailsViewController.h"

@interface QuestionListViewController () <UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;


@end

const CGFloat kQuestionListViewControllerEstimatedRowHeight = 40.0;

@implementation QuestionListViewController
{
    ACCQuestionTableModel * _tableDataSource;
    NSInteger _curentPage;
    BOOL _isLoaded;
    
    NSInteger _selectedQuestionId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchBar.delegate = self;
    
    _tableDataSource = [[ACCQuestionTableModel alloc] init];
    
    _tableView.dataSource = _tableDataSource;
    _tableView.delegate = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = kQuestionListViewControllerEstimatedRowHeight;
    
    _curentPage = 1;
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    _tableView.estimatedRowHeight = kQuestionListViewControllerEstimatedRowHeight;
    [_tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    if (!_isLoaded) {
        [self startSearchForText:_searchBar.text];
    }
}

#pragma mark - navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UITableViewCell * cell = (UITableViewCell *)sender;
    if ([cell isKindOfClass:[UITableViewCell class]]) {
        
        NSIndexPath * ip = [_tableView indexPathForCell:cell];
        _selectedQuestionId = [_tableDataSource questionIdForIndex:ip.row];
    }
    ACCQuestionDetailsViewController * vc = (ACCQuestionDetailsViewController *)segue.destinationViewController;
    
    if ([vc isKindOfClass:[ACCQuestionDetailsViewController class]]) {
        vc.questionId = _selectedQuestionId;
    }
}

#pragma mark - data load

-(void)startSearchForText:(NSString *)text {
    [self.view endEditing:YES];
    [_tableDataSource loadQuestionWithSearchString:text page:_curentPage andHandler:^(BOOL success, NSArray *items, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _isLoaded = YES;
            if (success) {
                _infoLabel.hidden = YES;
                if (items.count == 0) {
                    _infoLabel.hidden = NO;
                    _infoLabel.text = NSLocalizedString(@"Nothing found for your request", nil);
                }
            } else {
                _infoLabel.hidden = NO;
                _infoLabel.text = NSLocalizedString(@"Failed to load questions, try later please", nil);
                NSLog(@"error %s %@", __PRETTY_FUNCTION__, error);
            }
            [_tableView reloadData];
        });
    }];
}


#pragma mark - search bar

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self startSearchForText:searchBar.text];
}

#pragma mark - table view delegate 

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedQuestionId = [_tableDataSource questionIdForIndex:indexPath.row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
