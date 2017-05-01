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
    SKSpriteNode *bottleTopSprite;
    SKSpriteNode *bottleBottomSprite;
    SKSpriteNode *tableSprite;
    SKSpriteNode *holdNode;
    
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
    self.physicsWorld.speed = 1.5;
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
    
    //create texture for table
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
    
    
    //creating bottle top sprite
    SKTexture * bottleTopTexture = [SKTexture textureWithImageNamed:@"bottletop"];
    bottleTopTexture.filteringMode = SKTextureFilteringNearest;
    bottleTopSprite = [SKSpriteNode spriteNodeWithTexture:bottleTopTexture];
    [bottleTopSprite setScale:.1];
    
    //creating bottom bottle sprite
    SKTexture * bottleBottomTexture = [SKTexture textureWithImageNamed:@"bottlebottom"];
    bottleBottomTexture.filteringMode = SKTextureFilteringNearest;
    bottleBottomSprite = [SKSpriteNode spriteNodeWithTexture:bottleBottomTexture];
    [bottleBottomSprite setScale:.1];
    
    bottleTopSprite.position = CGPointMake(CGRectGetMidX(self.frame),bottleBottomSprite.position.y+150);
    
    //setting up physics for bottle
    SKPhysicsBody *bottleTopBody = [SKPhysicsBody bodyWithRectangleOfSize:bottleTopSprite.size];
    bottleTopSprite.physicsBody = bottleTopBody;
    bottleTopSprite.physicsBody.dynamic = YES; //enables forces to interact
    bottleTopSprite.physicsBody.allowsRotation = YES; //needs to stay upright
    bottleTopSprite.physicsBody.restitution = 0.1f;
    //bottleTopSprite.physicsBody.friction = 0.0f;
    bottleTopSprite.physicsBody.angularDamping = 0.0f;
    bottleTopSprite.physicsBody.linearDamping = 0.0f;
    bottleTopSprite.physicsBody.mass = 1;
    
    //adding collision handling to correctly determine if it hit the table
    /*bottleTopSprite.physicsBody.usesPreciseCollisionDetection = YES;
    bottleTopSprite.physicsBody.categoryBitMask = CollisionCategoryBottle;
    bottleTopSprite.physicsBody.collisionBitMask = CollisionCategoryTable; // will simulate using predetmined actions by platforms
    bottleTopSprite.physicsBody.contactTestBitMask = CollisionCategoryTable;*/
    
    [self addChild:bottleTopSprite];
    
    //setting up physics for bottle
    SKPhysicsBody *bottleBottomBody = [SKPhysicsBody bodyWithRectangleOfSize:bottleBottomSprite.size];
    bottleBottomSprite.physicsBody = bottleBottomBody;
    bottleBottomSprite.physicsBody.dynamic = YES; //enables forces to interact
    bottleBottomSprite.physicsBody.allowsRotation = YES; //needs to stay upright
    bottleBottomSprite.physicsBody.restitution = 0.1f;
    //bottleBottomSprite.physicsBody.friction = 0.0f;
    bottleBottomSprite.physicsBody.angularDamping = 0.0f;
    bottleBottomSprite.physicsBody.linearDamping = 0.0f;
    bottleBottomSprite.physicsBody.mass = bottleTopSprite.physicsBody.mass * 10;
    
    //adding collision handling to correctly determine if it hit the table
    bottleBottomSprite.physicsBody.usesPreciseCollisionDetection = YES;
    bottleBottomSprite.physicsBody.categoryBitMask = CollisionCategoryBottle;
    bottleBottomSprite.physicsBody.collisionBitMask = CollisionCategoryTable; // will simulate using predetmined actions by platforms
    bottleBottomSprite.physicsBody.contactTestBitMask = CollisionCategoryTable;
    [self addChild:bottleBottomSprite];
    
    CGPoint fusePoint = CGPointMake(bottleTopSprite.position.x, CGRectGetMaxY(bottleTopSprite.frame));
    SKPhysicsJointFixed *bottleFuse = [SKPhysicsJointFixed jointWithBodyA:bottleTopSprite.physicsBody bodyB:bottleBottomSprite.physicsBody anchor:fusePoint];
    [self.scene.physicsWorld addJoint:bottleFuse];
    
    //create invisible node that we use to hold the bottle
    UIColor *color = [UIColor blueColor];
    holdNode = [SKSpriteNode spriteNodeWithColor:color size:CGSizeMake(5, 5)];
    holdNode.position = CGPointMake(holdNode.position.x,bottleTopSprite.position.y + (bottleTopSprite.size.height/2));
    holdNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:holdNode.size];
    holdNode.physicsBody.dynamic = NO;
    holdNode.physicsBody.allowsRotation = YES;
    holdNode.physicsBody.friction = 0.0f;
    holdNode.physicsBody.angularDamping = 0.0f;
    holdNode.physicsBody.linearDamping = 0.0f;
    //holdNode.hidden = true;
    [self addChild:holdNode];
    
    
    //SKPhysicsJointLimit *joint = [SKPhysicsJointLimit jointWithBodyA: holdNode.physicsBody bodyB: bottleSprite.physicsBody anchor: CGPointMake(CGRectGetMaxX(holdNode.frame), CGRectGetMinY(bottleSprite.frame))];
    CGPoint bottleCap = CGPointMake(bottleTopSprite.position.x,bottleTopSprite.position.y + 100);
    //SKPhysicsJointLimit *joint = [SKPhysicsJointLimit jointWithBodyA:holdNode.physicsBody bodyB:bottleSprite.physicsBody anchorA:holdNode.position anchorB:bottleCap];
    SKPhysicsJointPin *joint = [SKPhysicsJointPin jointWithBodyA:holdNode.physicsBody bodyB:bottleTopSprite.physicsBody anchor:bottleCap];
    
    [self.scene.physicsWorld addJoint:joint];
    
    
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
    if(holdNode.physicsBody.dynamic == NO && !gameOver && clickCount == 2) {
        holdNode.physicsBody.dynamic = YES;
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
        [holdNode runAction:moveGroup];
    }
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"Contacted Table");
    gameOver = true;
    clickCount = 0;
    //bottleSprite.physicsBody.velocity = CGVectorMake(0,0);
}

-(void)update:(CFTimeInterval)currentTime {
    if(bottleBottomSprite.position.y < -self.frame.size.height/2) {
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
