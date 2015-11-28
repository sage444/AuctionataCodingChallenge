//
//  ACCUserView.h
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/27/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ACCSetDataProtocol.h"

@class ACCUser;

@interface ACCUserView : UIView <ACCSetDataProtocol>

-(void)prepareForReuse;
@end
