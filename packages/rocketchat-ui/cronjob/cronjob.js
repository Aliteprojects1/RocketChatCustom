SyncedCron.add({
    name: 'User/Guest Notification',
    schedule: function(parser) {
        return parser.text('every 1 mins');
    },
    job: function() {
        console.log("Guest notification sending started");
        sendGuestNotification();
    }
});

Meteor.startup(function () {
    SyncedCron.start();
});


sendGuestNotification = function () {
    var messages = RocketChat.models.Messages.find({ isRead: { $exists: true, $eq: false }, isMailSent: {$exists: false} });
    messages.forEach(function(currentMessage) {
        console.log('working on messageId:' + currentMessage._id);
        var messageId =  currentMessage._id;
        var rId = currentMessage.rid;
        var msgTimeStamp = moment(currentMessage.ts);
        var difference = moment().diff(msgTimeStamp, 'minutes');
        if(difference > 1) {
            var guestSentMessage = RocketChat.models.Messages.findOne({ token: { $exists: true} ,churchId: { $exists: true} , rid : rId});
            if(guestSentMessage) {
                var guestUserId = guestSentMessage.u._id;
                var userDetail = Meteor.users.findOne({_id: guestUserId});
                console.log("guest email id is:" , userDetail.emails[0].address);
                var churchData = RocketChat.models.Church.findOne({ userId : guestSentMessage.churchId});
                if(churchData){
                    sendEmailToGuest(userDetail, messageId, currentMessage, churchData, guestSentMessage.token);
                }
            }
        }
    })
}

sendEmailToGuest = function(user, messageId, message, churchData, guestToken) {

    var pageVisitedData = RocketChat.models.LivechatPageVisited.findOneByToken(guestToken);
    console.log(user.emails[0].address);
    const header = RocketChat.placeholders.replace(RocketChat.settings.get('Email_Header') || '');
    //const footer = RocketChat.placeholders.replace(RocketChat.settings.get('Email_Footer') || '');

    let html = RocketChat.placeholders.replace(RocketChat.settings.get('Guest_Offline_Notification_Email') || '');

    html = RocketChat.placeholders.replace(html, {
        chat_message: message.msg,
        churchURL: pageVisitedData[0].page.location.href,
        churchName: churchData.churchName,
        churchAdminName: churchData.username,
        email: user.emails[0].address,
        dateTime: moment(message.ts).format("DD/MM/YYYY HH:mm A")
    });

    var siteName = RocketChat.settings.get('Site_Name');
    let subject,  email;
    subject = TAPi18n.__('Guest_Offline_Notification_Email_Subject', { lng: user.language || RocketChat.settings.get('language') || 'en' });
    subject = RocketChat.placeholders.replace(subject);
    user.emails.some((email) => {
        email = {
            to: user.emails[0].address,
            from: RocketChat.settings.get('From_Email'),
            subject: `[${ siteName }]`,
            html: header + html
        };
        Meteor.defer(() => {
            console.log(email);
            Email.send(email);
        });
        RocketChat.models.Messages.update({_id: messageId}, {$set: {isMailSent: true, isRead: true}});
        return true;
    });
}