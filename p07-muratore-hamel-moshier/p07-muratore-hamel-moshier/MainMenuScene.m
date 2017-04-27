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
#import "math.h"

@interface MainMenuScene () {
    SKLabelNode* instruct1;
    SKLabelNode* instruct2;
    SKLabelNode* instruct3;
    SKLabelNode* instruct4;
    SKLabelNode* instruct5;
    SKSpriteNode *bottleSprite;
    
}

@end

@implementation MainMenuScene

- (void)didMoveToView:(SKView *)view {
    self.backgroundColor = [SKColor blackColor];
    [self startScene];
}

-(void) startScene {
    [self createStartLabels];
    //https://makeapppie.com/2014/04/01/slippyflippy-1-1-adding-a-fading-in-and-out-label-with-background-in-spritekit/
    //found code here for fading in an out, then made it ran forever
    SKAction *flashAction = [SKAction sequence:@[
                                                 [SKAction fadeInWithDuration:1],
                                                 [SKAction waitForDuration:0],
                                                 [SKAction fadeOutWithDuration:1]
                                                 ]];
    SKAction *repeat = [SKAction repeatActionForever:flashAction];
    [instruct5 runAction:repeat];
    SKAction *flipBottle = [SKAction sequence:@[
                                                 [SKAction runBlock:^{ [self flip:1]; }], [SKAction waitForDuration:.75],
                                                 [SKAction runBlock:^{ [self flip:2]; }], [SKAction waitForDuration:.75],
                                                 [SKAction runBlock:^{ [self flip:3]; }], [SKAction waitForDuration:.75],
                                                 [SKAction runBlock:^{ [self flip:4]; }], [SKAction waitForDuration:.75],
                                                 ]];
    SKAction *repeatFlip = [SKAction repeatActionForever:flipBottle];
    [self runAction:repeatFlip];
}

-(void) createStartLabels {
    instruct1 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    instruct1.fontSize = 70;
    instruct1.fontColor = [SKColor whiteColor];
    instruct1.position = CGPointMake(0, self.frame.size.height/2 -100);
    instruct1.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [instruct1 setText:@"Bottle Flip"];
    [self addChild:instruct1];
    
    instruct2 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    instruct2.fontSize = 35;
    instruct2.fontColor = [SKColor whiteColor];
    instruct2.position = CGPointMake(0.0, -200);
    instruct2.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [instruct2 setText:@"Grab and hold onto the bottle"];
    [self addChild:instruct2];
    
    instruct3 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    instruct3.fontSize = 35;
    instruct3.fontColor = [SKColor whiteColor];
    instruct3.position = CGPointMake(0, -300);
    instruct3.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [instruct3 setText:@"Flip it onto the table"];
    [self addChild:instruct3];
    
    instruct4 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    instruct4.fontSize = 35;
    instruct4.fontColor = [SKColor whiteColor];
    instruct4.position = CGPointMake(0, -400);
    instruct4.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [instruct4 setText:@"Keep Doing it"];
    [self addChild:instruct4];
    
    instruct5 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    instruct5.fontSize = 70;
    instruct5.fontColor = [SKColor whiteColor];
    instruct5.position = CGPointMake(0, -self.frame.size.height/2 + 100);
    instruct5.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [instruct5 setText:@"Tap to start"];
    [self addChild:instruct5];
    
    SKTexture * bottleTexture = [SKTexture textureWithImageNamed:@"Water-Bottle-PNG-Clipart"];
    bottleTexture.filteringMode = SKTextureFilteringNearest;
    bottleSprite = [SKSpriteNode spriteNodeWithTexture:bottleTexture];
    [bottleSprite setScale:.1];
    [self addChild:bottleSprite];
    
}

-(void) flip:(int)num {
    if(num == 1) {
        bottleSprite.position = CGPointMake(-self.frame.size.width/2 + 100, self.frame.size.height/2 - 600);
    }
    else if(num == 2) {
        bottleSprite.zRotation =  M_PI;
        bottleSprite.position = CGPointMake(-self.frame.size.width/2 + 300, self.frame.size.height/2 - 300);
    }
    else if(num == 3) {
        bottleSprite.position = CGPointMake(self.frame.size.width/2 - 300, self.frame.size.height/2 - 300);
        bottleSprite.zRotation =  1;
    }
    else {
        bottleSprite.zRotation =  0;
        bottleSprite.position = CGPointMake(self.frame.size.width/2 - 100, self.frame.size.height/2 - 600);
    }
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
