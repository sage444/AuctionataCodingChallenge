//
//  ACCCommentTableViewCell.m
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/28/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import "ACCCommentTableViewCell.h"
#import "ACCComment.h"
#import "ACCUser.h"

@interface ACCCommentTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;


@end


@implementation ACCCommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(id<ACCAPIObjectProtocol>)data {
    ACCComment * c = (ACCComment * )data;
    if (c.class == [ACCComment class]) {
        _bodyLabel.text = c.body;
        _userNameLabel.text = c.owner.name;
    }
}

@end
