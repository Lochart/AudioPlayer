//
//  ViewController.h
//  PlayerAudio
//
//  Created by Nikolay on 21.10.15.
//  Copyright © 2015 Nikolay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MusicListTableViewList.h"
#import "Track.h"

@interface ViewController : UIViewController<AVAudioPlayerDelegate, UITableViewDataSource, UITableViewDelegate>

@end

