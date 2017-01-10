RocketChat.models.Church = new Meteor.Collection('rocketchat_church');
Meteor.methods({
	'church:addChurch'(username, churchName) {

		if (!Meteor.userId() || !RocketChat.authz.hasPermission(Meteor.userId(), "view-church-administration")) {
			throw new Meteor.Error('error-not-allowed', 'Not allowed', { method: 'church:addChurch' });
		}

		check(username, String);

		const user = RocketChat.models.Users.findOneByUsername(username, { fields: { _id: 1, username: 1, 'emails.address' : 1} });

		if (!user) {
			throw new Meteor.Error('error-invalid-user', 'Invalid user', { method: 'church:addChurch' });
		}

		if (RocketChat.authz.addUserRoles(user._id, 'church-admin')) {

			if(checkIsChurchAlreadyCreated(churchName)) {

				RocketChat.models.Church.insert(createObjectToInsertIntoChurch(username, churchName, user));
			}
			else {
				throw new Meteor.Error('error-invalid-church-name', 'Church already exist', { method: 'church:addChurch' });
			}
			return user;
		}

		return false;
	},
	'eraseChurch'(churchId) {
		//TODO need to check is there admin role then and then allow to delete it otherwise throw erro msg

		if (!Meteor.userId() || !RocketChat.authz.hasPermission(Meteor.userId(), "remove-church")) {
			throw new Meteor.Error('error-not-allowed', 'Not allowed', { method: 'eraseChurch' });
		}

		var fromId, ref, roomType;
		check(churchId, String);
		if (!Meteor.userId()) {
			throw new Meteor.Error('error-invalid-user', 'Invalid user', {
				method: 'eraseChurch'
			});
		}
		fromId = Meteor.userId();
		return RocketChat.models.Church.remove({"_id": churchId})
	},
	'saveChurchName'(churchId, fieldKey, fieldValue) {
		check(churchId, String);
		if (!Meteor.userId()  || !RocketChat.authz.hasPermission(Meteor.userId(), "update-churchname")) {
			throw new Meteor.Error('error-invalid-user', 'Invalid user', {
				method: 'saveChurchName'
			});
		}
		var updateObject = {}
		updateObject[fieldKey] = fieldValue;
		updateObject["modifiedDate"] = new Date();
		updateObject["modifiedBy"] = Meteor.userId();

		RocketChat.models.Church.update({'_id': churchId}, {$set: updateObject});
		console.log('successfull updated');
	},
	'saveChurchAdminUser'(churchId, fieldKey, fieldValue) {
		check(churchId, String);
		if (!Meteor.userId() || !RocketChat.authz.hasPermission(Meteor.userId(), "update-church-username")) {
			throw new Meteor.Error('error-invalid-user', 'Invalid user', {
				method: 'saveChurchName'
			});
		}
		const user = RocketChat.models.Users.findOneByUsername(fieldValue, { fields: { _id: 1, username: 1, 'emails.address' : 1} });

		var updateObject = {}
		updateObject[fieldKey] = fieldValue;
		updateObject["userId"] = new Date();
		updateObject["userEmailId"] = user.emails[0].address;
		updateObject["modifiedDate"] = new Date();
		updateObject["modifiedBy"] = Meteor.userId();

		RocketChat.models.Church.update({'_id': churchId}, {$set: updateObject});
		console.log('successfull updated');
	}
});

checkIsChurchAlreadyCreated = function(churchName) {
	var churchData = RocketChat.models.Church.findOne({"churchName": churchName});
	return churchData ? false : true;
}

createObjectToInsertIntoChurch = function(username, churchName, user) {
	return {
		"churchName": churchName,
		"username": username,
		"userId": user._id,
		"createdDate": new Date(),
		"modifiedDate": new Date(),
		"modifiedBy": Meteor.userId(),
		"createdBy": Meteor.userId(),
		"userEmailId": user.emails[0].address
	}
}
