/**
 * ContentBox - A Modular Content Platform
 * Copyright since 2012 by Ortus Solutions, Corp
 * www.ortussolutions.com/products/contentbox
 * ---
 * Module Config
 */
component {

	// Module Properties
	this.title              = "cbReCaptcha";
	this.author             = "Aktigo Internet and Media Applications GmbH";
	this.webURL             = "https://www.akitogo.com";
	this.description        = "Implements Google reCaptcha for Contentbox 3.x and 4.x";
	this.version            = "1.2.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup   = true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint         = "cbReCaptcha";

	/**
	 * Config
	 */
	function configure(){
		// parent settings
		parentSettings = {};

		// module settings - stored in modules.name.settings
		settings = { apiUrl : "https://www.google.com/recaptcha/api/siteverify" };

		// Layout Settings
		layoutSettings = { defaultLayout : "" };

		// datasources
		datasources = {};

		// web services
		webservices = {};

		// SES Routes
		routes = [
			// Module Entry Point
			{ pattern : "/", handler : "home", action : "index" },
			// Convention Route
			{ pattern : "/:handler/:action?" }
		];

		// Custom Declared Points
		interceptorSettings = { customInterceptionPoints : "" };

		// Custom Declared Interceptors
		interceptors = [ { class : "#moduleMapping#.interceptors.reCaptcha" } ];
	}

	/**
	 * Fired when the module is registered and activated.
	 */
	function onLoad(){
		// Let's add ourselves to the main menu in the Modules section
		var menuService = controller.getWireBox().getInstance( "AdminMenuService@cb" );
		// Add Menu Contribution
		menuService.addSubMenu(
			topMenu: menuService.MODULES,
			name   : "cbReCaptcha",
			label  : "reCaptcha",
			href   : "#menuService.buildModuleLink( "cbReCaptcha", "home.settings" )#"
		);
	}

	/**
	 * Fired when the module is activated by ContentBox
	 */
	function onActivate(){
		var settingService = controller.getWireBox().getInstance( "SettingService@cb" );

		// store default settings
		var oSetting = settingService.findWhere( criteria = { name : "cbReCaptcha" } );

		if ( isNull( oSetting ) ) {
			var cbReCaptchaSettings = settingService.new(
				properties = { name : "cbReCaptcha", value : serializeJSON( settings ) }
			);

			settingService.save( cbReCaptchaSettings );

			// Flush the settings cache so our new settings are reflected
			settingService.flushSettingsCache();
		}
	}

	/**
	 * Fired when the module is unregistered and unloaded
	 */
	function onUnload(){
		// Let's remove ourselves to the main menu in the Modules section
		var menuService = controller.getWireBox().getInstance( "AdminMenuService@cb" );
		// Remove Menu Contribution
		menuService.removeSubMenu(
			topMenu = menuService.MODULES,
			name    = "cbReCaptcha"
		);
	}

	/**
	 * Fired when the module is deactivated by ContentBox
	 */
	function onDeactivate(){
		var settingService = controller.getWireBox().getInstance( "SettingService@cb" );
		var oSetting       = settingService.findWhere( criteria = { name : "cbReCaptcha" } );
		if ( !isNull( oSetting ) ) {
			settingService.delete( oSetting );
		}
	}

}
