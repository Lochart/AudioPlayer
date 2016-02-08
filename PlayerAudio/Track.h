//
//  Track.h
//  PlayerAudio
//
//  Created by Nikolay on 23.10.15.
//  Copyright © 2015 Nikolay. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

@interface Track : NSObject

@property (strong, nonatomic) NSURL *filePathURL;
@property (strong, nonatomic) NSString *title;
@property (nonatomic) CMTime duration;
@property (nonatomic) NSString *durationString;

@end
