Meteor.methods({
	'livechat:registerGuest': function({ token, name, email, department } = {}) {
		var stampedToken = Accounts._generateStampedLoginToken();
		var hashStampedToken = Accounts._hashStampedToken(stampedToken);

        let userId = RocketChat.Livechat.registerGuest.call(this, {
            token: token,
            name: name,
            email: email,
            department: department,
            loginToken: hashStampedToken
        });

		// update visited page history to not expire
		RocketChat.models.LivechatPageVisited.keepHistoryForToken(token);
        var userData = Meteor.users.findOne({"_id": userId});
		return {
			userId: userId,
			token: stampedToken.token,
            email: userData.emails
		};
	},
    'livechat:adminNotification': function(churchId, churchAdminId, chatMessage, token, roomId) {

	    console.log('churchId:', churchId);
	    var endUser = Meteor.users.findOne({"profile.token": token});

	    var churchData = RocketChat.models.Church.findOne({"userId" : churchId});

        var user = Meteor.users.findOne({"_id": churchId, "roles": { $in: ["church-admin"] } });

        if(churchId) {
            var churchName =  churchData.churchName;
        }

        if(user && user.status != "online") {
            //send email of conversation to admin.
            const header = RocketChat.placeholders.replace(RocketChat.settings.get('Email_Header') || '');
            //const footer = RocketChat.placeholders.replace(RocketChat.settings.get('Email_Footer') || '');

            let html = RocketChat.placeholders.replace(RocketChat.settings.get('Admin_Offline_Notification_Email') || '');

            var siteName = RocketChat.settings.get('Site_Name');

            let subject,  email;

            subject = TAPi18n.__('Admin_Offline_Notification_Email_Label', { lng: user.language || RocketChat.settings.get('language') || 'en' });
            subject = RocketChat.placeholders.replace(subject);

            var roomData = RocketChat.models.Rooms.findOneById(roomId);
            // we will replace parameters in email/html
            var siteUrl = RocketChat.settings.get('Site_Url') + "live/" + roomData.code;

            html = RocketChat.placeholders.replace(html, {
                chat_message: chatMessage,
                siteUrl: siteUrl,
                churchName: churchData.churchName,
                adminemail: user.emails[0].address
            });

                user.emails.some((email) => {
                    if (email.verified) {
                        email = {
                            to: email.address,
                            from: RocketChat.settings.get('From_Email'),
                            subject: `[${ siteName }]`,
                            html: header + html
                        };
                        Meteor.defer(() => {
                            console.log(email);
                            Email.send(email);
                        });
                        return true;
                    }
                });

            return {"churchName": churchName , "status":  "offline" };
        }
        else return {"churchName": churchName , "status":  "online" };
    },
    'livechat:updateIsReadFlag': function (roomId) {
        if(Meteor.userId()) {
            RocketChat.models.Messages.update({rid: roomId}, {
                $set: {
                    isRead: true
                }
            }, {multi :true});
        }
    }
});
