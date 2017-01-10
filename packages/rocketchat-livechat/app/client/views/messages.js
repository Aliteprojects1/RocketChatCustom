/* globals Livechat, LivechatVideoCall */

isShowRegister = new ReactiveVar(false);
isUserEmailIdExist = new ReactiveVar(false);
userName = new ReactiveVar("");
isShowThanksMessage = new ReactiveVar(false);
churchName = new ReactiveVar("");
showLoading = new ReactiveVar(false);

Template.messages.helpers({
	messages() {
		var chatMessages = ChatMessage.find({
            rid: visitor.getRoom(),
            t: {
                '$ne': 't'
            }
        }, {
            sort: {
                ts: 1
            }
        });
        if(chatMessages.count() > 0) {
            parentCall('setFullPopUp');
        }
		return chatMessages;
	},
	showOptions() {
		if (Template.instance().showOptions.get()) {
			return 'show';
		} else {
			return '';
		}
	},
	optionsLink() {
		if (Template.instance().showOptions.get()) {
			return t('Close_menu');
		} else {
			return t('Options');
		}
	},
	videoCallEnabled() {
		return Livechat.videoCall;
	},
	showConnecting() {
		return Livechat.connecting;
	},
    willShowRegister() {		
		return (!isUserEmailIdExist.get() && isShowRegister.get());
	},
    churchName() {
		return churchName.get();
	},
    showLoading() {	
		return showLoading.get();
	}
});

Template.messages.events({
	'focus .input-message': function(event, instance){				
		updateReadFlag();
	},
	'keyup .input-message': function(event, instance) {
		instance.chatMessages.keyup(visitor.getRoom(), event, instance);
		instance.updateMessageInputHeight(event.currentTarget);
	},
	'keydown .input-message': function(event, instance) {
		var churchId = document.getElementById('rocketChurchId').value;
		chatMessage = instance.find('.input-message').value;
        var k = event.which;
        return instance.chatMessages.keydown(visitor.getRoom(), churchId, event, instance, sendNotificationToAdmin);
    },
	'click .send-button': function(event, instance) {
        chatMessage = instance.find('.input-message').value;
		let input = instance.find('.input-message');
		let sent = instance.chatMessages.send(visitor.getRoom(), input, instance, sendNotificationToAdmin);
		input.focus();
		instance.updateMessageInputHeight(input);
		return sent;
	},
	'click .new-message': function(event, instance) {
		instance.atBottom = true;
		return instance.find('.input-message').focus();
	},
	'click .error': function(event) {
		return $(event.currentTarget).removeClass('show');
	},
	'click .toggle-options': function(event, instance) {
		instance.showOptions.set(!instance.showOptions.get());
	},
	'click .video-button': function(event) {
		event.preventDefault();

		if (!Meteor.userId()) {
			Meteor.call('livechat:registerGuest', { token: visitor.getToken() }, (error, result) => {
				if (error) {
					return console.log(error.reason);
				}
				Meteor.loginWithToken(result.token, (error) => {
					if (error) {
						return console.log(error.reason);
					}

					LivechatVideoCall.request();
				});
			});
		} else {
			LivechatVideoCall.request();
		}
	},
    'click #btnSubmit': function(e, instance) {
        var $email, $name;
        e.preventDefault();

        $name = instance.$('input[name=name]');
        userName.set($name.val());
        $email = instance.$('input[name=email]');

        showLoading.set(true);
        Meteor.setTimeout(function() {

            if (!($name.val().trim() && $email.val().trim())) {
                return instance.showError(TAPi18n.__('Please_fill_name_and_email'));
            } else {

                var guest = {
                    token: visitor.getToken(),
                    name: $name.val(),
                    email: $email.val()
                };

                Meteor.call('livechat:registerGuest', guest, function(error, result) {
                showLoading.set(false);       
                    if (error != null) {
                        return instance.showError(error.reason);
                    }

                    if(result.email && result.email[0].address) {
                        isShowRegister.set(false);
                        isUserEmailIdExist.set(true);
                        isShowThanksMessage.set(true);
                    }

                    Meteor.loginWithToken(result.token, function(error) {
                        if (error) {
                            return instance.showError(error.reason);
                        }
                    });
                });
            }}, 3000);
	}
});

Template.messages.onCreated(function() {

    isShowRegister.set(false);
	this.atBottom = true;

	this.showOptions = new ReactiveVar(false);

	this.updateMessageInputHeight = function(input) {
		// Inital height is 28. If the scrollHeight is greater than that( we have more text than area ),
		// increase the size of the textarea. The max-height is set at 200
		// even if the scrollHeight become bigger than that it should never exceed that.
		// Account for no text in the textarea when increasing the height.
		// If there is no text, reset the height.
		let inputScrollHeight;
		inputScrollHeight = $(input).prop('scrollHeight');
		if (inputScrollHeight > 28) {
			return $(input).height($(input).val() === '' ? '15px' : (inputScrollHeight >= 200 ? inputScrollHeight - 50 : inputScrollHeight - 20));
		}
	};

	$(document).click((/*event*/) => {
		if (!this.showOptions.get()) {
			return;
		}
		let target = $(event.target);
		if (!target.closest('.options-menu').length && !target.is('.options-menu') && !target.closest('.toggle-options').length && !target.is('.toggle-options')) {
			this.showOptions.set(false);
		}
	});
});

Template.messages.onRendered(function() {
	this.chatMessages = new ChatMessages();
	this.chatMessages.init(this.firstNode);
});

Template.messages.onRendered(function() {
	var messages, newMessage, onscroll, template;
	messages = this.find('.messages');
	newMessage = this.find('.new-message');
	template = this;
	if (messages) {
		onscroll = _.throttle(function() {
			template.atBottom = messages.scrollTop >= messages.scrollHeight - messages.clientHeight;
		}, 200);
		Meteor.setInterval(function() {
			if (template.atBottom) {
				messages.scrollTop = messages.scrollHeight - messages.clientHeight;
				newMessage.className = 'new-message not';
			}
		}, 100);
		messages.addEventListener('touchstart', function() {
			template.atBottom = false;
		});
		messages.addEventListener('touchend', function() {
			onscroll();
		});
		messages.addEventListener('scroll', function() {
			template.atBottom = false;
			onscroll();
		});
		messages.addEventListener('mousewheel', function() {
			template.atBottom = false;
			onscroll();
		});
		messages.addEventListener('wheel', function() {
			template.atBottom = false;
			onscroll();
		});
	}
});

sendNotificationToAdmin = function(instance) {
    parentCall('setOnline');
    parentCall('openPopout');
	var churchId = document.getElementById('rocketChurchId').value;
	/*var rocketChurchAdminId = document.getElementById('rocketChurchAdminId').value*/
    //var churchId = "58690d660a4d0d1161fc17cf";
    var rocketChurchAdminId = "";
    /*if (Meteor.userId()) {*/
        Meteor.call('livechat:adminNotification', churchId, rocketChurchAdminId, chatMessage, visitor.getToken(), visitor.getRoom(), (error, result) => {

            if (error) {
                return console.log(error.reason);
            }
            else {
            	if(result.churchName) {
                    churchName.set(result.churchName);
                }
                else  {
                    churchName.set("Church");
				}
                Meteor.setTimeout(
                    function () { if(result.status == "offline"){
                        isShowRegister.set(true);

                    }}, 1000);
            }
        });
    /*}*/
}

updateReadFlag = function() {
    if (Meteor.userId()) {
        Meteor.call('livechat:updateIsReadFlag', visitor.getRoom(), (error, result) => {
            if (error) {
                return console.log(error.reason);
            }

        });
    }
}