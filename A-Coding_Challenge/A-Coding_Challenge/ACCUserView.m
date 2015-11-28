//
//  ACCUserView.m
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/27/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import "ACCUserView.h"
#import "ACCUser.h"
#import "UIImageView+ImageFromUrl.h"

@interface ACCUserView ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *scorePointsLabel;

@end

@implementation ACCUserView

-(void)prepareForReuse {
    _avatarImageView.image = nil;
    [_avatarImageView cancelImageLoad];
    
    _userNameLabel.text = @"";
    _scorePointsLabel.text = @"";
}

-(void)setData:(id<ACCAPIObjectProtocol>)data {
    ACCUser * user = (ACCUser * )data;
    if ([user isKindOfClass:[ACCUser class]]) {
        _userNameLabel.text = user.name;
        _scorePointsLabel.text = [NSString stringWithFormat:@"%ld", (long)user.reputation];
        
        if (user.avatarUrlString) {
            [_avatarImageView setImageFromUrl:user.avatarUrlString];
        } else {
            _avatarImageView.image = nil;
        }
    }
}

@end
