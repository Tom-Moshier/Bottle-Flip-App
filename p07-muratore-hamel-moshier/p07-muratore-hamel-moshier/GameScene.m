//
//  GameScene.m
//  p07-muratore-hamel-moshier
//
//  Created by Anthony Muratore on 4/25/17.
//  Copyright © 2017 Anthony Muratore & David Hamel & Tom Moshier. All rights reserved.
//

#import "GameScene.h"

typedef NS_OPTIONS(uint32_t, CollisionCategory) {
    CollisionCategoryBottle   = 0x1 << 0,
    CollisionCategoryTable = 0x1 << 1,
};

@interface GameScene () <SKPhysicsContactDelegate> {
    SKSpriteNode *bottleSprite;
    bool isMoving;
}

@end

@implementation GameScene

- (void)didMoveToView:(SKView *)view {
    isMoving = false;
    
    self.physicsWorld.gravity = CGVectorMake(0.0f, -9.8f);
    //allowing the platforms to change set y velocity
    self.physicsWorld.contactDelegate = self;
    //creating bottle sprite
    SKTexture * bottleTexture = [SKTexture textureWithImageNamed:@"Water-Bottle-PNG-Clipart"];
    bottleTexture.filteringMode = SKTextureFilteringNearest;
    bottleSprite = [SKSpriteNode spriteNodeWithTexture:bottleTexture];
    [bottleSprite setScale:.1];
    
    SKPhysicsBody *bottleBody = [SKPhysicsBody bodyWithRectangleOfSize:bottleSprite.size];
    bottleSprite.physicsBody = bottleBody;
    bottleSprite.physicsBody.dynamic = NO; //enables forces to interact
    bottleSprite.physicsBody.allowsRotation = YES; //needs to stay upright
    bottleSprite.physicsBody.restitution = 1.0f;
    bottleSprite.physicsBody.friction = 0.0f;
    bottleSprite.physicsBody.angularDamping = 0.0f;
    bottleSprite.physicsBody.linearDamping = 0.0f;
    
    //adding collision handling to enable to correctly determine if it hit the table
    bottleSprite.physicsBody.usesPreciseCollisionDetection = YES;
    bottleSprite.physicsBody.categoryBitMask = CollisionCategoryBottle;
    bottleSprite.physicsBody.collisionBitMask = 0; // will simulate using predetmined actions by platforms
    bottleSprite.physicsBody.contactTestBitMask = CollisionCategoryTable;
    [self addChild:bottleSprite];
    
    //setting up physics for bottle

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    isMoving = true;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    isMoving = false;
    if(bottleSprite.physicsBody.dynamic == NO) {
        bottleSprite.physicsBody.dynamic = YES;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    isMoving = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (isMoving) {
        UITouch *touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInNode:self];
        SKAction *moveSpriteToPointX = [SKAction moveToX:(touchLocation.x) duration:0.01];
        SKAction *moveSpriteToPointY = [SKAction moveToY:(touchLocation.y) duration:0.01];
        SKAction *moveGroup = [SKAction group:@[moveSpriteToPointY,moveSpriteToPointX]];
        [bottleSprite runAction:moveGroup];
    }
}

-(void)update:(CFTimeInterval)currentTime {
}

@end
