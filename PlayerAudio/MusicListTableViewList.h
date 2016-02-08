//
//  MusicListTableViewList.h
//  PlayerAudio
//
//  Created by Nikolay on 23.10.15.
//  Copyright © 2015 Nikolay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicListTableViewList : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *trackName;
@property (weak, nonatomic) IBOutlet UILabel *trackDuration;

@end
