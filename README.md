# CKComponentPOPAnimation
A simple extension to add support to ComponentKit for POP animations.

##Get Started

Once you have [POP](https://github.com/facebook/pop) and [ComponentKit](https://github.com/facebook/componentkit) in your project, simply include the `CKComponentPOPAnimation` files in your project.

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
	    return {CKComponentPOPAnimation(component, rotationAnimation)};
	}