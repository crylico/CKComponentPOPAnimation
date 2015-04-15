//
//  CKComponentPOPAnimation.h
//  Quotes
//
//  Created by Kyle Levin on 4/13/15.
//  Copyright (c) 2015 LocoRobo, Inc. All rights reserved.
//

#import <ComponentKit/CKComponentAnimation.h>

@class POPAnimation;

struct CKComponentPOPAnimation : CKComponentAnimation {
    
    CKComponentPOPAnimation(CKComponent *component, POPAnimation *animation);
};
