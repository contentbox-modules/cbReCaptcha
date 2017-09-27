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
	* this needs to be added to comment form
	*/
	function cbui_postCommentForm( event, interceptData, buffer, rc, prc ){
		if( !prc.oCurrentAuthor.isLoggedIn() ){
			
			buffer.append(
				"<script src='https://www.google.com/recaptcha/api.js'></script>
				<div class=""form-group"">
					<div class=""g-recaptcha"" data-sitekey=""#recaptchaService.getPublicKey()#""></div>
				</div>"
			);
		}
	}


	/**
	* intercept comment post
	*/
	function cbui_preCommentPost( event, interceptData, buffer, rc, prc ){
		if( structKeyExists( rc, 'g-recaptcha-response' ) and !recaptchaService.isValid( response=rc['g-recaptcha-response'] ) ){
			arrayAppend( arguments.interceptData.commentErrors, "Invalid security code. Please try again." );
		}
	}
}
