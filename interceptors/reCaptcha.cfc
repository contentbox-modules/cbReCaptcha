component extends="coldbox.system.Interceptor" {

	// DI
	property name="recaptchaService" inject="id:recaptchaService@cbrecaptcha";

	/**
	 * Configure interceptor
	 */
	function configure(){
		return this;
	}

	/**
	 * this needs to be added to comment form
	 */
	function cbui_postCommentForm(
		event,
		interceptData,
		buffer,
		rc,
		prc
	){
		buffer.append( reCaptchaService.renderForm() );
	}


	/**
	 * intercept comment post
	 */
	function cbui_preCommentPost(
		event,
		interceptData,
		buffer,
		rc,
		prc
	){
		// Don't validate logged in users. Do a passthrough
		if ( prc.oCurrentAuthor.isLoggedIn() ) {
			return;
		}

		event.paramValue( "g-recaptcha-response", "" );

		if ( !recaptchaService.isValid( response = rc[ "g-recaptcha-response" ] ) ) {
			arrayAppend(
				arguments.interceptData.commentErrors,
				"Invalid security code. Please try again."
			);
		}
	}

}
