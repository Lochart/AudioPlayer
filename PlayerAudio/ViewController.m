//
//  ViewController.m
//  PlayerAudio
//
//  Created by Nikolay on 21.10.15.
//  Copyright © 2015 Nikolay. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

//UILabeL timeMusic
@property (weak, nonatomic) IBOutlet UILabel *beginTimerMusic;
//Name controller volume
@property (weak, nonatomic) IBOutlet UISlider *volumeControl;
//Name controller music
@property (weak, nonatomic) IBOutlet UISlider *progressControl;
@property (weak, nonatomic) IBOutlet UIButton *playMusic;

@property (strong, nonatomic) NSMutableArray *trackList;
//UITableView
@property (weak, nonatomic) IBOutlet UITableView *tableV;
@property (strong, nonatomic) NSIndexPath *currentIndex;

@property (nonatomic) AVAudioPlayer *audioPlayer;
@property (nonatomic) NSTimer *playbackTimer;

@end

int count;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *listOfPath = [[NSBundle mainBundle] pathsForResourcesOfType:@".mp3" inDirectory:@"OSTAnime/."]; // Array of path for tracks
    
    for(NSString *path in listOfPath){
        Track *tmpTrack = [Track new];
        NSURL *trackURL = [NSURL fileURLWithPath:path];
        tmpTrack.filePathURL = trackURL;
        
        AVAsset *trackAsset = [AVURLAsset URLAssetWithURL:trackURL options:nil];
        NSArray *metadata = [trackAsset commonMetadata];
        for (AVMetadataItem* item in metadata) {
            if ([item.commonKey  isEqual: @"title"])
                tmpTrack.title = item.stringValue;
        }
        
        tmpTrack.duration = trackAsset.duration;
        
        [self.trackList addObject:tmpTrack];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.trackList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MusicListTableViewList *cell = [tableView dequeueReusableCellWithIdentifier:@"TrackList"];
    
    Track *item = self.trackList[indexPath.row];
    cell.trackName.text = item.title;
    cell.trackDuration.text = item.durationString;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    Track *selectTrack = self.trackList[indexPath.row];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: selectTrack.filePathURL error: nil];
    
    self.playMusic.selected = YES;
    
    [self playAudioTrack];
    
}

-(void)playAudioTrack
{
    self.playbackTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    
//    [self.progressControl addTarget:self action:@selector(progressTrack:) forControlEvents:UIControlEventValueChanged];
    
    
    [self.audioPlayer play];
}

-(NSString *)stringForminterval:(NSTimeInterval)interval{
    NSInteger time = (NSInteger)interval;
    
    int second = time % 60;
    int minute = (time / 60) % 60;
    int hour = ( time / 3600);
    
    if (time <= 3600) {
        return [NSString stringWithFormat:@"%02d:%02d", minute, second];
    }
    
    return [NSString stringWithFormat:@"%02d:%02d", hour, minute, second];
}

//Music start time and the end
-(void)updateTime
{
    
    self.progressControl.value = 0;
    self.progressControl.maximumValue = self.audioPlayer.duration;
    
    self.progressControl.value = self.audioPlayer.currentTime;
    self.beginTimerMusic.text = [self stringForminterval:self.audioPlayer.currentTime];
}

-(void)pauseAudioTrack{
    [self.audioPlayer pause];
}

- (IBAction)nextTrack:(id)sender {
    NSInteger offset;
    offset = +1;
    [self trackSelection:offset];
}

- (IBAction)previousTrack:(id)sender {
    NSInteger offset;
    offset = -1;
    [self trackSelection:offset];
}

//Сontrol the volume
- (IBAction)volumeSound:(id)sender {
    self.audioPlayer.volume = self.volumeControl.value;
}

- (IBAction)progressTrack:(id)sender {
    [self.audioPlayer stop];
    [self.audioPlayer setCurrentTime:self.progressControl.value];
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}

- (IBAction)playMusicButton:(UIButton *)sender {
    if (self.audioPlayer) {
        if (sender.selected ) {
            [self pauseAudioTrack];
            UIImage * buttonImage =[UIImage imageNamed:@"media-play-4x.png"];
            [self.playMusic setImage:buttonImage forState:UIControlStateNormal];
            sender.selected = NO;
        } else {
            [self playAudioTrack];
            UIImage * buttonImage =[UIImage imageNamed:@"media-pause-4x.png"];
            [self.playMusic setImage:buttonImage forState:UIControlStateNormal];
            sender.selected = YES;
        }
        
    } else {
        [self starPlayTrack];
        UIImage * buttonImage =[UIImage imageNamed:@"media-pause-4x.png"];
        [self.playMusic setImage:buttonImage forState:UIControlStateNormal];

    }
    
}



- (void)starPlayTrack{

    [self trackSelection:0];
    
    self.beginTimerMusic.text = [self stringForminterval:self.audioPlayer.duration];
//    self.progressControl.value = 0;
    self.progressControl.maximumValue = self.audioPlayer.duration;
    
    [self.tableV selectRowAtIndexPath:self.currentIndex animated:YES scrollPosition:UITableViewScrollPositionNone]; // color table call
    [self.tableV scrollToRowAtIndexPath:self.currentIndex atScrollPosition:UITableViewScrollPositionNone animated:YES]; //scroll table
    [self tableView:self.tableV didSelectRowAtIndexPath:self.currentIndex];

}

- (void)trackSelection:(NSInteger)offset {
    NSInteger sectionIndex = self.tableV.numberOfSections - 1;
    
    if (!self.currentIndex) {
        self.currentIndex = [NSIndexPath indexPathForRow:0 inSection:sectionIndex];
    } else {
        NSInteger tmpIndex = self.currentIndex.row;
        tmpIndex += offset;
        NSInteger maxIndex = [self.tableV numberOfRowsInSection:sectionIndex] - 1;
        
        [[self.tableV cellForRowAtIndexPath:self.currentIndex] setSelected:NO animated:YES];
        
        if (tmpIndex >= 0 && tmpIndex <= maxIndex) {
            self.currentIndex = [NSIndexPath indexPathForRow:tmpIndex inSection:sectionIndex];
        } else if (tmpIndex < 0) {
            self.currentIndex = [NSIndexPath indexPathForRow:maxIndex inSection:sectionIndex];
        } else if (tmpIndex > maxIndex) {
            self.currentIndex = [NSIndexPath indexPathForRow:0 inSection:sectionIndex];
        }
    }
}

- (NSMutableArray *)trackList {
    if (!_trackList) {
        _trackList = [NSMutableArray new];
    }
    return _trackList;
}

@end
