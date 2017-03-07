component extends="coldbox.system.Interceptor"{

	// DI
	property name="recaptchaService"	inject="id:recaptchaService@cbrecaptcha";

	/**
	* Configure interceptor
	*/
	function configure(){
		return this;
	}

	/**
	* Add Js to Head section
	*/
	function cbui_beforeHeadEnd(event,interceptData){
		appendToBuffer( "<script src='https://www.google.com/recaptcha/api.js'></script>" );
	}

		
	/**
	* this needs to be added to comment form
	*/
	function cbui_postCommentForm(event,interceptData){
		appendToBuffer( '<div class="g-recaptcha" data-sitekey="#recaptchaService.getPublicKey()#"></div>' );
	}


	/**
	* intercept comment post
	*/
	function cbui_preCommentPost(event,interceptData){
		var rc	= event.getCollection();
		var captchacheck = false;
		if(structKeyExists(rc,'g-recaptcha-response'))
			captchacheck=recaptchaService.isValid(response=rc['g-recaptcha-response']);
		if(!captchacheck)
			ArrayAppend( arguments.interceptData.commentErrors, "Invalid security code. Please try again." );
	}	
		

	
	
}