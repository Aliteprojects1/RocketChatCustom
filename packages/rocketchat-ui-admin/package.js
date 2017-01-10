Package.describe({
	name: 'rocketchat:ui-admin',
	version: '0.1.0',
	// Brief, one-line summary of the package.
	summary: '',
	// URL to the Git repository containing the source code for this package.
	git: '',
	// By default, Meteor will default to using README.md for documentation.
	// To avoid submitting documentation, set this field to null.
	documentation: 'README.md'
});

Package.onUse(function(api) {
	api.use([
		'ecmascript',
		'templating',
		'coffeescript',
		'underscore',
		'rocketchat:lib'
	]);

	// template files
	api.addFiles('admin/admin.html', 'client');
	api.addFiles('admin/adminFlex.html', 'client');
	api.addFiles('admin/adminInfo.html', 'client');

	api.addFiles('admin/rooms/adminRooms.html', 'client');
	api.addFiles('admin/rooms/adminRoomInfo.html', 'client');
	api.addFiles('admin/rooms/adminRoomInfo.coffee', 'client');
	/*api.addFiles('admin/rooms/adminRoomInfo.js', 'client');*/
	api.addFiles('admin/rooms/channelSettingsDefault.html', 'client');
	api.addFiles('admin/rooms/channelSettingsDefault.js', 'client');

	api.addFiles('admin/users/adminInviteUser.html', 'client');
	api.addFiles('admin/users/adminUserChannels.html', 'client');
	api.addFiles('admin/users/adminUserEdit.html', 'client');
	api.addFiles('admin/users/adminUserInfo.html', 'client');
	api.addFiles('admin/users/adminUsers.html', 'client');

	// coffee files
	api.addFiles('admin/admin.coffee', 'client');
	api.addFiles('admin/adminFlex.coffee', 'client');
	/*api.addFiles('admin/adminFlex.js', 'client');*/
	api.addFiles('admin/adminInfo.coffee', 'client');

	api.addFiles('admin/rooms/adminRooms.coffee', 'client');
	/*api.addFiles('admin/rooms/adminRooms.js', 'client');*/

	/*api.addFiles('admin/users/adminInviteUser.coffee', 'client');*/
	api.addFiles('admin/users/adminInviteUser.js', 'client');
	/*api.addFiles('admin/users/adminUserChannels.coffee', 'client');*/
	api.addFiles('admin/users/adminUserChannels.js', 'client');
	api.addFiles('admin/users/adminUsers.coffee', 'client');
	/*api.addFiles('admin/users/adminUsers.js', 'client');*/

	api.addFiles('admin/church/adminChurch.html', 'client');
	api.addFiles('admin/church/adminChurch.js', 'client');
	api.addFiles('admin/church/adminChurchEdit.html', 'client');
	api.addFiles('admin/church/adminChurchEdit.js', 'client');
	api.addFiles('admin/church/adminChurchInfo.html', 'client');
	api.addFiles('admin/church/adminChurchInfo.js', 'client');

	api.addFiles('publications/adminRooms.js', 'server');
	api.addFiles('admin/church/server/church.js', 'server');
	api.addFiles('admin/church/server/publication.js', 'server');
	// api.addAssets('styles/side-nav.less', 'client');
});
