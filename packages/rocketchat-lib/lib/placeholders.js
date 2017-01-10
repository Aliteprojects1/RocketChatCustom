RocketChat.placeholders = {};

RocketChat.placeholders.replace = function(str, data) {
	if (!str) {
		return '';
	}

	str = str.replace(/\[Site_Name\]/g, RocketChat.settings.get('Site_Name') || '');
	str = str.replace(/\[Site_URL\]/g, RocketChat.settings.get('Site_Url') || '');

	if (data) {
		str = str.replace(/\[name\]/g, data.name || '');
		str = str.replace(/\[fname\]/g, _.strLeft(data.name, ' ') || '');
		str = str.replace(/\[lname\]/g, _.strRightBack(data.name, ' ') || '');
		str = str.replace(/\[email\]/g, data.email || '');
		str = str.replace(/\[password\]/g, data.password || '');
        str = str.replace(/\[username\]/g, data.username || '');
        str = str.replace(/\[message\]/g, data.message || '');
        str = str.replace(/\[churchURL\]/g, data.churchURL || '');
        str = str.replace(/\[chat_message\]/g, data.chat_message || '');
        str = str.replace(/\[status\]/g, data.status || '');
        str = str.replace(/\[adminemail\]/g, data.adminemail || '');
        str = str.replace(/\[siteUrl\]/g, data.siteUrl || '');
        str = str.replace(/\[guestName\]/g, data.guestName || '');
        str = str.replace(/\[churchName\]/g, data.churchName || '');
        str = str.replace(/\[dateTime\]/g, data.dateTime || '');
        str = str.replace(/\[churchAdminName\]/g, data.churchAdminName || '');



		if (data.unsubscribe) {
			str = str.replace(/\[unsubscribe\]/g, data.unsubscribe);
		}
	}

	str = str.replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2');


	return str;
};
