//
//  MainMenuScene.m
//  p07-muratore-hamel-moshier
//
//  Created by Tom Moshier on 4/27/17.
//  Copyright © 2017 Anthony Muratore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainMenuScene.h"
#import "GameScene.h"

@interface MainMenuScene () {
    
}

@end

@implementation MainMenuScene

- (void)didMoveToView:(SKView *)view {
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    // Set the scale mode to scale to fit the window
    scene.scaleMode = SKSceneScaleModeAspectFill;
    SKView *skView = (SKView *)self.view;
    // Present the scene
    [skView presentScene:scene];
}

-(void)update:(CFTimeInterval)currentTime {
    
}

@end
