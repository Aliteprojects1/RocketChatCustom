import toastr from 'toastr'
Template.adminChurchInfo.helpers({
	agentAutocompleteSettings() {
		return {
			limit: 10,
			// inputDelay: 300
			rules: [{
				// @TODO maybe change this 'collection' and/or template
				collection: 'UserAndRoom',
				subscription: 'userAutocomplete',
				field: 'username',
				template: Template.userSearch,
				noMatchTemplate: Template.userSearchEmpty,
				matchAll: true,
				filter: {
					exceptions: _.map(AgentUsers.find({}, { fields: { username: 1 } }).fetch(), user => { return user.username; })
				},
				selector(match) {
					return { term: match };
				},
				sort: 'username'
			}]
		};
	},
	selectedRoom: function() {
		return Session.get('adminChurchSelected');
	},
	canEdit: function() {
		return RocketChat.authz.hasAllPermission('edit-church', this.churchId);
	},
	editing: function(field) {
		console.log('********* : ' + Template.instance().editing.get() === field);
		return Template.instance().editing.get() === field;
	},
	churchName: function() {
		var ref;
		return (ref = RocketChat.models.Church.findOne(this.churchId, {
			fields: {
				churchName: 1
			}
		})) != null ? ref.churchName : void 0;
	},
	username:  function() {
		var ref;
		return (ref = RocketChat.models.Church.findOne(this.churchId, {
			fields: {
				username: 1
			}
		})) != null ? ref.username : void 0;
	}
});

Template.adminChurchInfo.events({
	'click .delete': function() {
		return swal({
			title: t('Are_you_sure'),
			text: t('Delete_Church_Warning'),
			type: 'warning',
			showCancelButton: true,
			confirmButtonColor: '#DD6B55',
			confirmButtonText: t('Yes_delete_it'),
			cancelButtonText: t('Cancel'),
			closeOnConfirm: false,
			html: false
		}, (function(_this) {
			return function() {
				swal.disableButtons();
				return Meteor.call('eraseChurch', _this.churchId, function(error, result) {
					if (error) {
						handleError(error);
						return swal.enableButtons();
					} else {
						return swal({
							title: t('Deleted'),
							text: t('Church_has_been_deleted'),
							type: 'success',
							timer: 2000,
							showConfirmButton: false
						});
					}
				});
			};
		})(this));
	},
	'keydown input[type=text]': function(e, t) {
		if (e.keyCode === 13) {
			e.preventDefault();
			return t.saveSetting(this.churchId);
		}
	},
	'click [data-edit]': function(e, t) {
		e.preventDefault();
		t.editing.set($(e.currentTarget).data('edit'));
		return setTimeout((function() {
			return t.$('input.editing').focus().select();
		}), 100);
	},
	'click .cancel': function(e, t) {
		e.preventDefault();
		return t.editing.set();
	},
	'click .save': function(e, t) {
		e.preventDefault();
		return t.saveSetting(this.churchId);
	}
});

Template.adminChurchInfo.onCreated(function() {
	this.editing = new ReactiveVar;

	this.validateChurchName = (function(_this) {
		return function(churchId) {
			var name, nameValidation, ref, room;
			room = RocketChat.models.Church.findOne({"_id": churchId});
			/*if (!RocketChat.authz.hasAllPermission('edit-church', churchId) || ((ref = room.t) !== 'c' && ref !== 'p')) {
				toastr.error(t('error-not-allowed'));
				return false;
			}*/
			name = $('input[name=churchName]').val();
			try {
				nameValidation = new RegExp('^' + RocketChat.settings.get('UTF8_Names_Validation') + '$');
			} catch (_error) {
				nameValidation = new RegExp('^[0-9a-zA-Z-_.]+$');
			}
			if (!nameValidation.test(name)) {
				toastr.error(t('error-invalid-church-name', {
					church_name: name
				}));
				return false;
			}
			return true;
		};
	})(this);

	return this.saveSetting = (function(_this) {
		return function(churchId) {
			var ref, ref1;
			switch (_this.editing.get()) {
				case 'churchName':
					if (_this.validateChurchName(churchId)) {
						/*RocketChat.callbacks.run('roomNameChanged', ChatRoom.findOne(churchId));*/
						Meteor.call('saveChurchName', churchId, 'churchName', _this.$('input[name=churchName]').val(), function(err, result) {
							if (err) {
								return handleError(err);
							}
							toastr.success(TAPi18n.__('church_name_changed_successfully'));
							return;
						});
					}
					break;
				case 'username':
						Meteor.call('saveChurchAdminUser', churchId, 'username', _this.$('input[name=username]').val(), function(err, result) {
							if (err) {
								return handleError(err);
							}
							toastr.success(TAPi18n.__('church_admin_user_changed_successfully'));
							return;
						});
					break;

			}
			return _this.editing.set();
		};
	})(this);
});

