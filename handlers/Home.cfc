/**
* The handler is just used for admin
* ---
*/
component{

	// DI
	property name="settingService" 	inject="settingService@cb";
	property name="cb" 				inject="cbHelper@cb";

	function settings( event, rc, prc ){
		prc.xehSave = cb.buildModuleLink( "reCaptcha", "home.saveSettings" );

		event.paramValue( "privatekey", "" );
		event.paramValue( "publickey", "" );
		var args 	= { name="reCaptcha" };
		var settings = settingService.findWhere( criteria=args );

		if(!isNull(settings))
			var settings=deserializeJSON(settings.getValue());
			for( var key in settings ){
				event.setValue(key,settings[key] );
			}
		// view
		event.setView( "home/settings" );
	}

	function saveSettings( event, rc, prc ){
		// Get compressor settings
		prc.settings = {publickey='',privatekey=''};

		// iterate over settings
		for( var key in prc.settings ){
			// save only sent in setting keys
			if( structKeyExists( rc, key ) ){
				prc.settings[ key ] = rc[ key ];
			}
		}
		// Save settings
		var args 	= { name="reCaptcha" };
		var setting = settingService.findWhere( criteria=args );
		if( isNull( setting ) ){
			setting = settingService.new( properties=args );
		}
		
		setting.setValue( serializeJSON( prc.settings ) );
		settingService.save( setting );

		// Messagebox
		getModel( "messagebox@cbMessagebox" ).info( "Settings Saved & Updated!" );
		// Relocate via CB Helper
		cb.setNextModuleEvent( "reCaptcha", "home.settings" );
	}

}