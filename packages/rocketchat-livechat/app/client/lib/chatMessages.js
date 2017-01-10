import toastr from 'toastr'
var indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

this.ChatMessages = (function() {
	function ChatMessages() {}

	ChatMessages.prototype.init = function(node) {
		this.editing = {};
		this.wrapper = $(node).find(".wrapper");
		this.input = $(node).find(".input-message").get(0);
	};

	ChatMessages.prototype.resize = function() {
		var dif;
		dif = 60 + $(".messages-container").find("footer").outerHeight();
		return $(".messages-box").css({
			height: "calc(100% - " + dif + "px)"
		});
	};

	ChatMessages.prototype.toPrevMessage = function() {
		var msgs;
		msgs = this.wrapper.get(0).querySelectorAll(".own:not(.system)");
		if (msgs.length) {
			if (this.editing.element) {
				if (msgs[this.editing.index - 1]) {
					return this.edit(msgs[this.editing.index - 1], this.editing.index - 1);
				}
			} else {
				return this.edit(msgs[msgs.length - 1], msgs.length - 1);
			}
		}
	};

	ChatMessages.prototype.toNextMessage = function() {
		var msgs;
		if (this.editing.element) {
			msgs = this.wrapper.get(0).querySelectorAll(".own:not(.system)");
			if (msgs[this.editing.index + 1]) {
				return this.edit(msgs[this.editing.index + 1], this.editing.index + 1);
			} else {
				return this.clearEditing();
			}
		}
	};

	ChatMessages.prototype.getEditingIndex = function(element) {
		var index, j, len, msg, msgs;
		msgs = this.wrapper.get(0).querySelectorAll(".own:not(.system)");
		index = 0;
		for (j = 0, len = msgs.length; j < len; j++) {
			msg = msgs[j];
			if (msg === element) {
				return index;
			}
			index++;
		}
		return -1;
	};

	ChatMessages.prototype.edit = function(element, index) {
		var id, message;
		if (element.classList.contains("system")) {
			return;
		}
		this.clearEditing();
		id = element.getAttribute("id");
		message = ChatMessage.findOne({
			_id: id,
			'u._id': Meteor.userId()
		});
		this.input.value = message.msg;
		this.editing.element = element;
		this.editing.index = index || this.getEditingIndex(element);
		this.editing.id = id;
		element.classList.add("editing");
		this.input.classList.add("editing");
		return setTimeout((function(_this) {
			return function() {
				return _this.input.focus();
			};
		})(this), 5);
	};

	ChatMessages.prototype.clearEditing = function() {
		if (this.editing.element) {
			this.editing.element.classList.remove("editing");
			this.input.classList.remove("editing");
			this.editing.id = null;
			this.editing.element = null;
			this.editing.index = null;
			return this.input.value = this.editing.saved || "";
		} else {
			return this.editing.saved = this.input.value;
		}
	};

	ChatMessages.prototype.send = function(rid, input, churchId, instance, sendNotificationToAdmin) {
		var guest, msg, sendMessage;
		if (s.trim(input.value) !== '') {
			if (this.isMessageTooLong(input)) {
				return toastr.error(t('Message_too_long'));
			}
			msg = input.value;
			input.value = '';
			if (rid == null) {
				rid = visitor.getRoom(true);
			}
			sendMessage = function(callback) {
				var msgObject;
				msgObject = {
					_id: Random.id(),
					rid: rid,
					msg: msg,
					token: visitor.getToken(),
					churchId: churchId
				};
				MsgTyping.stop(rid);
				return Meteor.call('sendMessageLivechat', msgObject, function(error, result) {
					if (error) {
						ChatMessage.update(msgObject._id, {
							$set: {
								error: true
							}
						});
						showError(error.reason);
					}
					if (((result != null ? result.rid : void 0) != null) && !visitor.isSubscribed(result.rid)) {
						Livechat.connecting = result.showConnecting;
						ChatMessage.update(result._id, _.omit(result, '_id'));
                        if(sendNotificationToAdmin && instance) {
                            sendNotificationToAdmin(instance);
                        }
						return Livechat.room = result.rid;
					}
				});
			};
			if (!Meteor.userId()) {
				guest = {
					token: visitor.getToken()
				};
				if (Livechat.department) {
					guest.department = Livechat.department;
				}
				return Meteor.call('livechat:registerGuest', guest, function(error, result) {
					if (error != null) {
						return showError(error.reason);
					}
					return Meteor.loginWithToken(result.token, function(error) {
						if (error) {
							return showError(error.reason);
						}
						return sendMessage();
					});
				});
			} else {
				return sendMessage();
			}
		}
	};

	ChatMessages.prototype.deleteMsg = function(message) {
		return Meteor.call('deleteMessage', message, function(error, result) {
			if (error) {
				return handleError(error);
			}
		});
	};

	ChatMessages.prototype.update = function(id, rid, input) {
		var msg;
		if (s.trim(input.value) !== '') {
			msg = input.value;
			Meteor.call('updateMessage', {
				id: id,
				msg: msg
			});
			this.clearEditing();
			return MsgTyping.stop(rid);
		}
	};

	ChatMessages.prototype.startTyping = function(rid, input) {
		if (s.trim(input.value) !== '') {
			return MsgTyping.start(rid);
		} else {
			return MsgTyping.stop(rid);
		}
	};

	ChatMessages.prototype.bindEvents = function() {
		var ref;
		if ((ref = this.wrapper) != null ? ref.length : void 0) {
			return $(".input-message").autogrow({
				postGrowCallback: (function(_this) {
					return function() {
						return _this.resize();
					};
				})(this)
			});
		}
	};

	ChatMessages.prototype.tryCompletion = function(input) {
		var re, user, value;
		value = input.value.match(/[^\s]+$/);
		if ((value != null ? value.length : void 0) > 0) {
			value = value[0];
			re = new RegExp(value, 'i');
			user = Meteor.users.findOne({
				username: re
			});
			if (user != null) {
				return input.value = input.value.replace(value, "@" + user.username + " ");
			}
		}
	};

	ChatMessages.prototype.keyup = function(rid, event) {
		var i, input, j, k, keyCodes, l;
		input = event.currentTarget;
		k = event.which;
		keyCodes = [13, 20, 16, 9, 27, 17, 91, 19, 18, 93, 45, 34, 35, 144, 145];
		for (i = j = 35; j <= 40; i = ++j) {
			keyCodes.push(i);
		}
		for (i = l = 112; l <= 123; i = ++l) {
			keyCodes.push(i);
		}
		if (indexOf.call(keyCodes, k) < 0) {
			return this.startTyping(rid, input);
		}
	};

	ChatMessages.prototype.keydown = function(rid, churchId, event, instance, sendNotificationToAdmin) {
		var input, k, ref, ref1;
		input = event.currentTarget;
		k = event.which;
		this.resize(input);
		if (k === 13 && !event.shiftKey && !event.ctrlKey && !event.altKey) {
			event.preventDefault();
			event.stopPropagation();
			if (this.editing.id) {
				this.update(this.editing.id, rid, input);
			} else {
				this.send(rid, input, churchId, instance, sendNotificationToAdmin);
			}

			return;
		}
		if (k === 9) {
			event.preventDefault();
			event.stopPropagation();
			this.tryCompletion(input);
		}
		if (k === 27) {
			if (this.editing.id) {
				event.preventDefault();
				event.stopPropagation();
				this.clearEditing();
			}
		} else if (k === 75 && (((typeof navigator !== "undefined" && navigator !== null ? (ref = navigator.platform) != null ? ref.indexOf('Mac') : void 0 : void 0) !== -1 && event.metaKey && event.shiftKey) || ((typeof navigator !== "undefined" && navigator !== null ? (ref1 = navigator.platform) != null ? ref1.indexOf('Mac') : void 0 : void 0) === -1 && event.ctrlKey && event.shiftKey))) {
			return RoomHistoryManager.clear(rid);
		}
	};

	ChatMessages.prototype.isMessageTooLong = function(input) {
		return (input != null ? input.value.length : void 0) > this.messageMaxSize;
	};

	return ChatMessages;

})();

// ---
// generated by coffee-script 1.9.2
