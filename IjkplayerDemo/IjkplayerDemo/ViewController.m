//
//  ViewController.m
//  IjkplayerDemo
//
//  Created by HXB-xiaoYang on 2018/6/13.
//  Copyright © 2018年 VansXY. All rights reserved.
//

#import "ViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

static NSString *const mp4Url = @"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4";
static NSString *const m3u8Url = @"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8";

@interface ViewController ()

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) id <IJKMediaPlayback> player;
@property (nonatomic, strong) UIView *PlayerView;
@property (nonatomic, strong) UIButton *playButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setUI];
    [self addObservers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    if (![_player isPlaying]) {
        [_player prepareToPlay];
    }
}

- (void)setUI {
    _url = [NSURL URLWithString:m3u8Url];
    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:_url withOptions:nil];
    [_player setScalingMode:(IJKMPMovieScalingModeAspectFit)];
    
    UIView *playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 180)];
    playerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:playerView];
    
    _PlayerView = playerView;
    
    UIView *playView = [self.player view];
    playView.frame = _PlayerView.bounds;
    playView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_PlayerView addSubview:playView];
    [_PlayerView insertSubview:playView atIndex:1];
    
    UIButton *playButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    playButton.frame = CGRectMake(50, 500, self.view.bounds.size.width - 100, 50);
    [playButton setTitle:@"暂停" forState:(UIControlStateNormal)];
    [playButton setBackgroundColor:[UIColor blackColor]];
    [playButton setTintColor:[UIColor whiteColor]];
    [playButton addTarget:self action:@selector(playMovie:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:playButton];
}

- (void)playMovie:(UIButton *)sender {
    if (![self.player isPlaying]) {
        [self.player play];
        [sender setTitle:@"暂停" forState:(UIControlStateNormal)];
    } else {
        [self.player pause];
        [sender setTitle:@"开始" forState:(UIControlStateNormal)];
    }
}


- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
}

#pragma mark --- Observers

/**
 播放状态监视

 @param notification 观察者
 */
- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}


/**
 视频播放结束的原因监视

 @param notification 观察者
 */
- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}


/**
 视频将要播放

 @param notification 观察者
 */
- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPrepareToPlayDidChange\n");
}


/**
 视频状态变化监视

 @param notification 观察者
 */
- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    switch (_player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
            
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
