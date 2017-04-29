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
    SKSpriteNode *tableSprite;
    
    //checks to see bottle is good or not
    bool gameOver;
    
    SKLabelNode* scoreLabel;
    SKLabelNode* gameOverLabel;
    SKLabelNode* finalScore;
    SKLabelNode* startNode;
    
    int scoreNumber;
    int clickCount;
}

@end


@implementation GameScene

-(void) setUp {
    NSLog(@"Click Count Set Up: %d",clickCount);
    gameOver = false;
    scoreNumber = 02;
    
    self.physicsWorld.gravity = CGVectorMake(0.0f, -9.8f);
    //allowing the platforms to change set y velocity
    self.physicsWorld.contactDelegate = self;
    
    
    //create table sprite
    float bottom = CGRectGetMinY(self.frame);
    float horizMid = CGRectGetMidY(self.frame);
    //float top = CGRectGetMaxY(self.frame);
    //float left = CGRectGetMinX(self.frame);
    float vertMid = CGRectGetMidX(self.frame);
    //float right = CGRectGetMaxX(self.frame);
    //float topQuarter = (top+horizMid)/2;
    float bottomQuarter = (horizMid + bottom)/2;
    //float leftQuarter = (left+vertMid)/2;
    
    SKTexture *tableTexture = [SKTexture textureWithImageNamed:@"table"];
    tableTexture.filteringMode = SKTextureFilteringNearest;
    tableSprite = [SKSpriteNode spriteNodeWithTexture:tableTexture];
    [tableSprite setScale:.75];
    tableSprite.position = CGPointMake(vertMid,bottomQuarter-100);
    CGSize tableHitBox = CGSizeMake(tableSprite.frame.size.width,tableSprite.frame.size.height - 200);
    SKPhysicsBody *tableBody = [SKPhysicsBody bodyWithRectangleOfSize:tableHitBox];
    tableSprite.physicsBody = tableBody;
    tableSprite.physicsBody.dynamic = NO;
    
    //adding collision handling to the table
    tableSprite.physicsBody.usesPreciseCollisionDetection = YES;
    tableSprite.physicsBody.categoryBitMask = CollisionCategoryTable;
    tableSprite.physicsBody.collisionBitMask = CollisionCategoryBottle;
    [self addChild:tableSprite];
    
    
    //creating bottle sprite
    SKTexture * bottleTexture = [SKTexture textureWithImageNamed:@"Water-Bottle-PNG-Clipart"];
    bottleTexture.filteringMode = SKTextureFilteringNearest;
    bottleSprite = [SKSpriteNode spriteNodeWithTexture:bottleTexture];
    [bottleSprite setScale:.1];
    
    //setting up physics for bottle
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
    bottleSprite.physicsBody.collisionBitMask = CollisionCategoryTable; // will simulate using predetmined actions by platforms
    bottleSprite.physicsBody.contactTestBitMask = CollisionCategoryTable;
    [self addChild:bottleSprite];
    
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.fontSize = 50;
    scoreLabel.fontColor = [SKColor whiteColor];
    scoreLabel.position = CGPointMake(0, self.frame.size.height/2 -100);
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    scoreLabel.text = [NSString stringWithFormat:@"Score: %d", scoreNumber];
    [self addChild:scoreLabel];
}

- (void)didMoveToView:(SKView *)view {
    [self setUp];
    clickCount = 1;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(gameOver) {
        for (SKNode *node in [self children]) {
            [node removeFromParent];
        }
        
        [self setUp];
    }
    clickCount++;
    NSLog(@"Click Count touchesBegan: %d",clickCount);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(bottleSprite.physicsBody.dynamic == NO && !gameOver && clickCount == 2) {
        bottleSprite.physicsBody.dynamic = YES;
        //[bottleSprite.physicsBody applyAngularImpulse:12];

    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!gameOver && clickCount == 2) {
        UITouch *touch = [touches anyObject];
        CGPoint touchLocation = [touch locationInNode:self];
        SKAction *moveSpriteToPointX = [SKAction moveToX:(touchLocation.x) duration:0.01];
        SKAction *moveSpriteToPointY = [SKAction moveToY:(touchLocation.y) duration:0.01];
        SKAction *moveGroup = [SKAction group:@[moveSpriteToPointY,moveSpriteToPointX]];
        [bottleSprite runAction:moveGroup];
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"Contacted Table");
    bottleSprite.physicsBody.velocity = CGVectorMake(0,0);
}

-(void)update:(CFTimeInterval)currentTime {
    if(bottleSprite.position.y < -self.frame.size.height/2) {
        gameOver = true;
        for (SKNode *node in [self children]) {
            [node removeFromParent];
        }
        [self gameEnded];
    }
}

-(void)gameEnded {
    clickCount = 0;
    gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    gameOverLabel.fontSize = 70;
    gameOverLabel.fontColor = [SKColor whiteColor];
    gameOverLabel.position = CGPointMake(0.0f, 250.0f);;
    gameOverLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [gameOverLabel setText:@"Game Over"];
    [self addChild:gameOverLabel];
    
    finalScore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    finalScore.fontSize = 70;
    finalScore.fontColor = [SKColor whiteColor];
    finalScore.position = CGPointMake(0.0f, 0.0f);
    finalScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [finalScore setText:[NSString stringWithFormat:@"Final Score: %d", scoreNumber]];
    [self addChild:finalScore];
    
    startNode = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    startNode.fontSize = 55;
    startNode.fontColor = [SKColor whiteColor];
    startNode.position = CGPointMake(0.0f, -250.0f);
    startNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    [startNode setText:@"Tap to Try Again"];
    [self addChild:startNode];
}

@end
