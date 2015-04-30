# CKComponentPOPAnimation
A simple extension to add support to ComponentKit for POP animations.  This extension relies on `NSCopying` adherance for `POPAniamtion` and its subclasses, which is not yet in a version release, but is live in the POP's master branch.

##Get Started

Once you have [POP](https://github.com/facebook/pop) and [ComponentKit](https://github.com/facebook/componentkit) in your project, simply include the `CKComponentPOPAnimation` files in your project.

At this point, you'll need to either use the 'bleeding edge' instructions for POP or manually embed the framework into your project until a new version release is made for CocoaPods.

##Usage

	- (std::vector<CKComponentAnimation>)animationsFromPreviousComponent:(CKComponent *)previousComponent {
	    
	    CKComponent *component = ...; (self, subcomponent, etc.)

		// Create a POP animation exactly as you normally would.
        POPSpringAnimation *rotationAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
	    rotate.fromValue = @(M_PI);
	    rotate.toValue = @(M_PI_2);
	    rotate.springSpeed = 5;
	    rotate.springBounciness = 10;

		// 	Return a vector containing the CKComponentPOPAnimation constructor.
	    return {CKComponentPOPAnimation(component, rotationAnimation, YES)}; // YES for layer animation (kPOPLayerRotation)
	}
