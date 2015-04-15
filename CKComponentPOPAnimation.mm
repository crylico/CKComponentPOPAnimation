//
//  CKComponentPOPAnimation.cpp
//  Quotes
//
//  Created by Kyle Levin on 4/13/15.
//  Copyright (c) 2015 LocoRobo, Inc. All rights reserved.
//

#import <pop/POP.h>

#import "CKComponentPOPAnimation.h"
#import "CKComponentInternal.h"

@interface CKAppliedPOPAnimationContext : NSObject

@property (nonatomic, strong, readonly) CALayer *targetLayer;
@property (nonatomic, copy, readonly) NSString *key;

- (instancetype)initWithTargetLayer:(CALayer *)layer key:(NSString *)key;

@end

@implementation CKAppliedPOPAnimationContext

- (instancetype)initWithTargetLayer:(CALayer *)targetLayer key:(NSString *)key
{
    if (self = [super init]) {
        _targetLayer = targetLayer;
        _key = [key copy];
    }
    return self;
}

@end

static CKComponentAnimationHooks hooksForPOPAnimation(CKComponent *component, POPAnimation *origAnimation)
{
    CKCAssertNotNil(component, @"Component being animated must be non-nil");
    CKCAssertNotNil(origAnimation, @"Animation being added must be non-nil");
    
    // Don't mutate the animation the component returned, in case it is a static or otherwise reused. (Also copy
    // immediately to protect against the *caller* mutating the animation after this point but before it's used.)
    POPAnimation *copiedAnimation = [origAnimation copy];
    
    return {
        .didRemount = ^(id context){
            CALayer *layer = component.viewForAnimation.layer;
            CKCAssertNotNil(layer, @"%@ has no mounted view, so it cannot be animated", [component class]);
            NSString *key = [[NSUUID UUID] UUIDString];
            
            // CAMediaTiming beginTime is specified in the time space of the superlayer. Since the component has no way to
            // access the superlayer when constructing the animation, we document that beginTime should be specified in
            // absolute time and perform the adjustment here.
            if (copiedAnimation.beginTime != 0.0) {
                copiedAnimation.beginTime = [layer.superlayer convertTime:copiedAnimation.beginTime fromLayer:nil];
            }
            [layer pop_addAnimation:copiedAnimation forKey:key];
            return [[CKAppliedPOPAnimationContext alloc] initWithTargetLayer:layer key:key];
        },
        .cleanup = ^(CKAppliedPOPAnimationContext *context){
            [context.targetLayer pop_removeAnimationForKey:context.key];
        }
    };
}

CKComponentPOPAnimation::CKComponentPOPAnimation(CKComponent *component, POPAnimation *animation) :
CKComponentAnimation(hooksForPOPAnimation(component, animation)) {}
