Meteor.publish('fullChurchData', function(filter, limit) {
	var result;
	if (!this.userId) {
		return this.ready();
	}
	result = RocketChat.models.Church.find({});
	if (!result) {
		return this.ready();
	}
	return result;
});
