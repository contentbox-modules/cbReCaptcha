/**
* The handler is just used for admin
* ---
*/
component{

	// DI
	property name="settingService" 	inject="settingService@cb";
	property name="cb" 				inject="cbHelper@cb";

	/**
	 * Show the captcha settings
	 *
	 * @event 
	 * @rc 
	 * @prc 
	 */
	function settings( event, rc, prc ){
		prc.xehSave = cb.buildModuleLink( "cbReCaptcha", "home.saveSettings" );

		event.paramValue( "privatekey", "" )
			.paramValue( "publickey", "" );

		var allsettings = settingService.findWhere( criteria={ name="cbReCaptcha" } );

		if( !isNull( allsettings ) ){
			var allsettings = deserializeJSON( allsettings.getValue() );
			for( var key in allsettings ){
				event.setValue( key, allsettings[ key ] );
			}
		}
		// view
		event.setView( "home/settings" );
	}

	/**
	 * Save captcha settings
	 *
	 * @event 
	 * @rc 
	 * @prc 
	 */
	function saveSettings( event, rc, prc ){
		// Get compressor settings
		prc.settings = { publickey = '', privatekey = '' };

		// iterate over settings
		for( var key in prc.settings ){
			// save only sent in setting keys
			if( structKeyExists( rc, key ) ){
				prc.settings[ key ] = rc[ key ];
			}
		}
		// Save settings
		var args 	= { name="cbReCaptcha" };
		var setting = settingService.findWhere( criteria=args );
		if( isNull( setting ) ){
			setting = settingService.new( properties=args );
		}
		
		setting.setValue( serializeJSON( prc.settings ) );
		settingService.save( setting );

		// Messagebox
		getInstance( "messagebox@cbMessagebox" ).info( "Settings Saved & Updated!" );
		
		// Relocate via CB Helper
		cb.setNextModuleEvent( "cbReCaptcha", "home.settings" );
	}

}