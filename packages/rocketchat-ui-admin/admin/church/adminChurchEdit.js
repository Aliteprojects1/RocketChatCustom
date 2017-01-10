import toastr from 'toastr'

Template.adminChurchEdit.helpers({
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
	}
});

Template.adminChurchEdit.events({
	'click .cancel': function(e, instance) {
		e.stopPropagation();
		e.preventDefault();
		instance.clearForm();
		return RocketChat.TabBar.closeFlex();
	},
	'click .save': function(e, template){
		e.preventDefault();

		var userName  = $('#txtUserName').val();
		var churchName  = $('#txtChurchName').val();
		if (userName.trim() === '') {
			return toastr.error(t('Please_fill_a_username'));
		}

		if (churchName.trim() === '') {
			return toastr.error(t('Please_fill_a_username'));
		}

		var oldBtnValue = $('.save').text();
		$('.save').text(t('Saving'));

		//e.currentTarget.elements.add.value = t('Saving');

		Meteor.call('church:addChurch', userName, churchName, function(error/*, result*/) {
			$('.save').text(oldBtnValue);
			if (error) {
				return handleError(error);
			}
			toastr.success(t('Church_added'));
		});
	}
});
Template.adminChurchEdit.onCreated(function() {
	return this.clearForm = function() {
		 $('#txtUserName').val('');
		 $('#txtChurchName').val('');
	};
});
