Template.adminChurch.helpers({
	isReady: function() {
		var ref;
		return (ref = Template.instance().ready) != null ? ref.get() : void 0;
	},
	users: function() {
		return Template.instance().church();
	},
	isLoading: function() {
		var ref;
		if (!((ref = Template.instance().ready) != null ? ref.get() : void 0)) {
			return 'btn-loading';
		}
	},
	hasMore: function() {
		var base, ref;
		return ((ref = Template.instance().limit) != null ? ref.get() : void 0) === (typeof (base = Template.instance()).church === "function" ? base.church().length : void 0);
	},
	flexTemplate: function() {
		return RocketChat.TabBar.getTemplate();
	},
	flexData: function() {
		return RocketChat.TabBar.getData();
	},
	emailAddress: function() {
		return _.map(this.emails, function(e) {
			return e.address;
		}).join(', ');
	}
});

Template.adminChurch.onCreated(function() {
	var instance;
	instance = this;
	this.limit = new ReactiveVar(50);
	this.filter = new ReactiveVar('');
	this.ready = new ReactiveVar(true);
	RocketChat.TabBar.addButton({
		groups: ['adminchurch'],
		id: 'admin-church',
		i18nTitle: 'Church_info',
		icon: 'icon-info-circled',
		template: 'adminChurchInfo',
		order: 1
	});
	RocketChat.TabBar.addButton({
		groups: ['adminchurch', 'adminchurch-selected'],
		id: 'add-church',
		i18nTitle: 'Add_Church',
		icon: 'icon-plus',
		template: 'adminChurchEdit',
		openClick: function(e, t) {
			RocketChat.TabBar.setData();
			return true;
		},
		order: 2
	});
	RocketChat.TabBar.addButton({
		groups: ['adminchurch-selected'],
		id: 'admin-user-info',
		i18nTitle: 'User_Info',
		icon: 'icon-user',
		template: 'adminUserInfo',
		order: 3
	});
	this.autorun(function() {
		var filter, limit, subscription;
		filter = instance.filter.get();
		limit = instance.limit.get();
		subscription = instance.subscribe('fullChurchData', filter, limit);
		return instance.ready.set(subscription.ready());
	});
	return this.church = function() {
		var filter, filterReg, query, ref, ref1;
		filter = _.trim((ref = instance.filter) != null ? ref.get() : void 0);
		if (filter) {
			filterReg = new RegExp(s.escapeRegExp(filter), "i");
			query = {
				$or: [
					{
						churchName: filterReg
					}, {
						username: filterReg
					}, {
						userEmailId: filterReg
					}
				]
			};
		} else {
			query = {};
		};
		return RocketChat.models.Church.find(query, {
			limit: (ref1 = instance.limit) != null ? ref1.get() : void 0,
			sort: {
				churchName: 1,
				username: 1
			}
		}).fetch();
	};
});

Template.adminChurch.onRendered(function() {
	return Tracker.afterFlush(function() {
		SideNav.setFlex("adminFlex");
		return SideNav.openFlex();
	});
});

Template.adminChurch.events({
	'keydown #users-filter': function(e) {
		if (e.which === 13) {
			e.stopPropagation();
			return e.preventDefault();
		}
	},
	'keyup #users-filter': function(e, t) {
		e.stopPropagation();
		e.preventDefault();
		return t.filter.set(e.currentTarget.value);
	},
	'click .flex-tab .more': function() {
		if (RocketChat.TabBar.isFlexOpen()) {
			return RocketChat.TabBar.closeFlex();
		} else {
			return RocketChat.TabBar.openFlex();
		}
	},
	'click .user-info': function(e) {
		e.preventDefault();
		RocketChat.TabBar.setTemplate('adminUserInfo');
		RocketChat.TabBar.setData(RocketChat.models.Church.findOne(this._id));
		RocketChat.TabBar.openFlex();
		return RocketChat.TabBar.showGroup('adminusers-selected');
	},
	'click .info-tabs button': function(e) {
		e.preventDefault();
		$('.info-tabs button').removeClass('active');
		$(e.currentTarget).addClass('active');
		$('.user-info-content').hide();
		return $($(e.currentTarget).attr('href')).show();
	},
	'click .load-more': function(e, t) {
		e.preventDefault();
		e.stopPropagation();
		return t.limit.set(t.limit.get() + 50);
	},
	'click .church-info': function(e, t) {
		e.preventDefault();
		Session.set('adminChurchSelected', { churchId: this._id });
		return RocketChat.TabBar.setTemplate('adminChurchInfo');
	}
});
