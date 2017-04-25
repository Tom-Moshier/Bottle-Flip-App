//
//  GameScene.m
//  p07-muratore-hamel-moshier
//
//  Created by Anthony Muratore on 4/25/17.
//  Copyright © 2017 Anthony Muratore & David Hamel & Tom Moshier. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene {
    SKSpriteNode *ballSprite;
}

- (void)didMoveToView:(SKView *)view {
    //creating bottle sprite
    SKTexture * bottleTexture = [SKTexture textureWithImageNamed:@"Water-Bottle-PNG-Clipart"];
    bottleTexture.filteringMode = SKTextureFilteringNearest;
    ballSprite = [SKSpriteNode spriteNodeWithTexture:bottleTexture];
    
    
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

}

-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
