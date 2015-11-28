//
//  ACCQuestionTableViewCell.m
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/27/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import "ACCQuestionTableViewCell.h"
#import "ACCQuestion.h"
#import "ACCUserView.h"
#import "ACCUser.h"

@interface ACCQuestionTableViewCell ()


@property (weak, nonatomic) IBOutlet UIView *userInfoContainer;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *creationDateLabel;

@end


@implementation ACCQuestionTableViewCell
{
    ACCUserView * _userView;
}

- (void)awakeFromNib {
    
    _userView = [[[NSBundle mainBundle] loadNibNamed:@"UserView" owner:self options:nil] firstObject];
    _userView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_userInfoContainer addSubview:_userView];
    // Width constraint, half of parent view width
    [_userInfoContainer addConstraint:[NSLayoutConstraint constraintWithItem:_userView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_userInfoContainer
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1
                                                           constant:0]];
    
    // Height constraint, half of parent view height
    [_userInfoContainer addConstraint:[NSLayoutConstraint constraintWithItem:_userView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_userInfoContainer
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1
                                                           constant:0]];
    
    // Center horizontally
    [_userInfoContainer addConstraint:[NSLayoutConstraint constraintWithItem:_userView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_userInfoContainer
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    // Center vertically
    [_userInfoContainer addConstraint:[NSLayoutConstraint constraintWithItem:_userView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_userInfoContainer
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse {
    [super prepareForReuse];
    
    _titleLabel.text = @"";
    _creationDateLabel.text = @"";
    [_userView prepareForReuse];
}

-(void)setData:(id<ACCAPIObjectProtocol>)data {
    
    ACCQuestion * question = (ACCQuestion *)data;
    
    if ([question isKindOfClass:[ACCQuestion class]]) {
        
        _titleLabel.text = question.title;
        _creationDateLabel.text = [NSString stringWithFormat:@"Created: %@", [NSDateFormatter localizedStringFromDate:question.creationDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]];
        [_userView setData:question.owner];
    }
}

@end
