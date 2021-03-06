/* globals Department, Livechat, LivechatVideoCall */

Template.register.helpers({
	error() {
		return Template.instance().error.get();
	},
	welcomeMessage() {
		return '';
	},
	showDepartments() {
		return Department.find({ showOnRegistration: true }).count() > 1;
	},
	departments() {
		return Department.find({ showOnRegistration: true });
	},
	videoCallEnabled() {
		return Livechat.videoCall;
	},
	selectedDepartment() {
		return this._id === Livechat.department;
	}
});

Template.register.events({
	'submit #livechat-registration'(e, instance) {
		var $email, $name;
		e.preventDefault();

		let start = () => {
			instance.hideError();
			if (instance.request === 'video') {
				LivechatVideoCall.request();
			}
		};

		$name = instance.$('input[name=name]');
		$email = instance.$('input[name=email]');
		if (!($name.val().trim() && $email.val().trim())) {
			return instance.showError(TAPi18n.__('Please_fill_name_and_email'));
		} else {
			var departmentId = instance.$('select[name=department]').val();
			if (!departmentId) {
				var department = Department.findOne({ showOnRegistration: true });
				if (department) {
					departmentId = department._id;
				}
			}

            var guest = {
                token: visitor.getToken(),
            };

			/*var guest = {
				token: visitor.getToken(),
				name: $name.val(),
				email: $email.val(),
				department: Livechat.deparment || departmentId
			};*/
			Meteor.call('livechat:registerGuest', guest, function(error, result) {
				if (error != null) {
					return instance.showError(error.reason);
				}
				Meteor.loginWithToken(result.token, function(error) {
					if (error) {
						return instance.showError(error.reason);
					}
					parentCall('setOnline');
					parentCall('openPopout');
					start();
				});
			});
		}
	},
	'click .error'(e, instance) {
		return instance.hideError();
	},
	'click .request-chat'(e, instance) {
		instance.request = 'chat';
	},
	'click .request-video'(e, instance) {
		instance.request = 'video';
	}
});

Template.register.onCreated(function() {
	console.log('tokenId:' + visitor.getToken());
	this.error = new ReactiveVar();
	this.request = '';
	this.showError = (msg) => {
		$('.error').addClass('show');
		this.error.set(msg);
	};
	this.hideError = () => {
		$('.error').removeClass('show');
		this.error.set();
	};
});
