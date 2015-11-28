//
//  ACCSetDataProtocol.h
//  A-Coding_Challenge
//
//  Created by Sergiy Suprun on 11/27/15.
//  Copyright © 2015 Sergiy Suprun. All rights reserved.
//

#ifndef ACCSetDataProtocol_h
#define ACCSetDataProtocol_h

@protocol ACCAPIObjectProtocol;
@protocol ACCSetDataProtocol <NSObject>

-(void)setData:(id<ACCAPIObjectProtocol>)data;

@end


#endif /* ACCSetDataProtocol_h */
