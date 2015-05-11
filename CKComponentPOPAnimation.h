//
//  CKComponentPOPAnimation.h
//  Quotes
//
//  Created by Kyle Levin on 4/13/15.
//  Copyright (c) 2015 LocoRobo, Inc. All rights reserved.
//

#import <ComponentKit/CKComponentAnimation.h>

@class POPPropertyAnimation;

struct CKComponentPOPAnimation : CKComponentAnimation {
    
    /**
     *    @param component the component to animate
     *    @param animation the animation to apply to the component's view/layer
     *    @param isLayer whether the animation should be applied to the component's view or that view's layer. Defaults to NO (view animation).
     */
    CKComponentPOPAnimation(CKComponent *component, POPPropertyAnimation *animation);
};
