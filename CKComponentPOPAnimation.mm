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

@property (nonatomic, strong, readonly) id animatable;
@property (nonatomic, copy, readonly) NSString *key;

- (instancetype)initWithTargetAnimatable:(id)animatable key:(NSString *)key;

@end

@implementation CKAppliedPOPAnimationContext

- (instancetype)initWithTargetAnimatable:(CALayer *)animatable key:(NSString *)key
{
    if (self = [super init]) {
        _animatable = animatable;
        _key = [key copy];
    }
    return self;
}

@end

static CKComponentAnimationHooks hooksForPOPAnimation(CKComponent *component, POPPropertyAnimation *origAnimation)
{
    CKCAssertNotNil(component, @"Component being animated must be non-nil");
    CKCAssertNotNil(origAnimation, @"Animation being added must be non-nil");
    
    // Don't mutate the animation the component returned, in case it is a static or otherwise reused. (Also copy
    // immediately to protect against the *caller* mutating the animation after this point but before it's used.)
    POPPropertyAnimation *copiedAnimation = [origAnimation copy];
    
    return {
        .didRemount = ^(id context){
            CALayer *layer = component.viewForAnimation.layer;
            id animatable = copiedAnimation.isLayerAnimation ? layer : component.viewForAnimation;

            CKCAssertNotNil(layer, @"%@ has no mounted view, so it cannot be animated", [component class]);
            NSString *key = [[NSUUID UUID] UUIDString];
            
            // CAMediaTiming beginTime is specified in the time space of the superlayer. Since the component has no way to
            // access the superlayer when constructing the animation, we document that beginTime should be specified in
            // absolute time and perform the adjustment here.
            if (copiedAnimation.beginTime != 0.0) {
                copiedAnimation.beginTime = [layer.superlayer convertTime:copiedAnimation.beginTime fromLayer:nil];
            }
            [animatable pop_addAnimation:copiedAnimation forKey:key];
            return [[CKAppliedPOPAnimationContext alloc] initWithTargetAnimatable:animatable key:key];
        },
        .cleanup = ^(CKAppliedPOPAnimationContext *context){
            [context.animatable pop_removeAnimationForKey:context.key];
        }
    };
}

CKComponentPOPAnimation::CKComponentPOPAnimation(CKComponent *component, POPPropertyAnimation *animation) :
CKComponentAnimation(hooksForPOPAnimation(component, animation)) {}









