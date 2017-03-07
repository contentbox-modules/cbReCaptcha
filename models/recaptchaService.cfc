component {

	property name="config" inject="coldbox:setting:cbrecaptcha";
	property name="settingService" 	inject="settingService@cb";

	property name="privateKey" 	default="";

	/**
 	* Constructor
	*/
	recaptchaService function init(){
		return this;
	}
	
	
	boolean function isValid(string response, string remoteIP=getRemoteIp()) {
		var result = httpSend(response,remoteIp);
		
		var check = deserializeJSON(result.filecontent);

		return check.success;
	}


	struct function httpSend(required string response, string remoteIP) {

		var httpService = new http(); 
	    httpService.setMethod("post"); 
	    httpService.setUrl(config.apiUrl);
	    
	    httpService.addParam(type="header", name="Content-Type", value="application/x-www-form-urlencoded");

	    httpService.addParam(type="formfield", name="response", 	value="#arguments.response#");
	    httpService.addParam(type="formfield", name="remoteip",  	value="#arguments.remoteIp#");
	    httpService.addParam(type="formfield", name="secret",		value="#getSecretKey()#");
		    
		return httpService.send().getPrefix();
	}

	string function getRemoteIp() {
		return cgi.REMOTE_ADDR;
	}
	


	string function getPublicKey() {
		var args 	= { name="reCaptcha" };
		var settings = settingService.findWhere( criteria=args ).getValue();
		
		var allSettings=deserializeJson(settings);
		
		if(structKeyExists(allSettings,'publicKey'))
			return allSettings.publicKey;
			
		return 'Public Key Not Set';

	}
		
	string function getSecretKey() {
		var args 	= { name="reCaptcha" };
		var settings = settingService.findWhere( criteria=args ).getValue();
		
		var allSettings=deserializeJson(settings);
		
		if(structKeyExists(allSettings,'privateKey'))
			return allSettings.privateKey;
			
		return 'Private Key Not Set';

	}	
}