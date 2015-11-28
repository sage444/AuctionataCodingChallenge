//
//  ACCQuestionDetailsCell.m
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/28/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import "ACCQuestionDetailsCell.h"
#import "ACCQuestion.h"
#import "ACCAnswer.h"
#import "ACCUserView.h"
#import "ACCUser.h"


@interface ACCQuestionDetailsCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdDateLabel;
@property (weak, nonatomic) IBOutlet UIView *userInfoContainer;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;


@end

@implementation ACCQuestionDetailsCell
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

-(void)prepareForReuse {
    [super prepareForReuse];
    
    _titleLabel.text = @"";
    _createdDateLabel.text = @"";
    _bodyLabel.text = @"";
    [_userView prepareForReuse];
}

-(void)setData:(id<ACCAPIObjectProtocol>)data {
    
    if ([data isKindOfClass:[ACCQuestion class]]) {
        ACCQuestion * question = (ACCQuestion *)data;
        _titleLabel.text = question.title;
        _bodyLabel.text = question.body;
        _createdDateLabel.text = [NSString stringWithFormat:@"Created: %@", [NSDateFormatter localizedStringFromDate:question.creationDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]];
        [_userView setData:question.owner];
    } else if ([data isKindOfClass:[ACCAnswer class]]){
        ACCAnswer * answer = (ACCAnswer *)data;
        _titleLabel.text = @"";
        _bodyLabel.text = answer.body;
        _createdDateLabel.text = @"";
        [_userView setData:answer.owner];
    }
}


@end
