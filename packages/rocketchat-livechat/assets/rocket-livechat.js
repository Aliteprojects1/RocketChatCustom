(function(w) {
    w.RocketChat = w.RocketChat || { _: [] };
    var config = {};
    var widget;
    var widgetOpener;
    var iframe;
    var hookQueue = [];
    var ready = false;
    var isOnline = false;
    var isFullPopUp = false;

    var closeWidget = function() {
        widget.dataset.state = 'closed';
        widget.style.height = 0;
        widget.style.width = 0;
        widget.style.opacity = 0;
        widget.style.right = '36px';
        widget.style.bottom = '100px';
        widget.style.top = '';
        widgetOpener.style.bottom = '36px';
        widgetOpener.style.right = '36px';
        widgetOpener.style.display = "block";
        iframe.contentWindow.postMessage('close', '*');
        widgetOpener.innerHTML = '<i style="line-height: 0;display: block;">' +
            '<svg width="25" height="25" preserveAspectRatio="xMidYMin" viewBox="0 0 25 25" xmlns="http://www.w3.org/2000/svg" style="transform: translate(-50%, -50%);bottom: 50%;top: 50%;position: absolute;">' +
            '<path d="M23.295 24.412a.987.987 0 0 1-1.123-.43L19.9 20.358H9.527c-1.392 0-2.523-1.153-2.523-2.57V16.3c0-.563.448-1.02 1-1.02.553 0 1 .457 1 1.02v1.485c0 .295.235.533.523.533h10.92c.036 0 .067.018.103.022a.96.96 0 0 1 .527.224.984.984 0 0 1 .14.15c.023.026.054.043.073.075l.725 1.154V9.7a.528.528 0 0 0-.523-.532h-1.48c-.55 0-1-.457-1-1.02 0-.56.45-1.018 1-1.018h1.48c1.392 0 2.524 1.152 2.524 2.57V23.433c0 .452-.293.85-.72.978zM14.49 13.226H4.116L1.844 16.85a.997.997 0 0 1-1.124.43 1.017 1.017 0 0 1-.72-.978V2.57C0 1.152 1.132 0 2.523 0H14.49c1.39 0 2.52 1.152 2.52 2.57v8.085c0 1.418-1.13 2.57-2.52 2.57zm.52-10.656a.528.528 0 0 0-.52-.532H2.522c-.288 0-.522.24-.522.532v10.242l.726-1.153c.02-.032.05-.05.07-.076a.897.897 0 0 1 .296-.256.92.92 0 0 1 .372-.118c.037-.004.068-.022.104-.022h10.92c.288 0 .522-.238.522-.533V2.57z" fill="#FFF" fill-rule="evenodd"></path>' +
            '</svg></i>';
    };

    var openWidget = function() {
        widget.dataset.state = 'opened';
        widget.style.height = '300px';
        widget.style.width = '370px';
        widget.style.opacity = 1;
        widgetOpener.style.display = "none";
        widgetOpener.innerHTML = '<i style="line-height: 0;display: block;">' +
            '<svg width="17" height="17" viewBox="0 0 17 17" preserveAspectRatio="xMidYMin" xmlns="http://www.w3.org/2000/svg" style="transform: translate(-50%, -50%);bottom: 50%;top: 50%;position: absolute;">' +
            '<path d="M16.726 15.402c.365.366.365.96 0 1.324-.178.178-.416.274-.663.274-.246 0-.484-.096-.663-.274L8.323 9.648h.353L1.6 16.726c-.177.178-.416.274-.663.274-.246 0-.484-.096-.663-.274-.365-.365-.365-.958 0-1.324L7.35 8.324v.35L.275 1.6C-.09 1.233-.09.64.274.274c.367-.365.96-.365 1.326 0l7.076 7.078h-.353L15.4.274c.366-.365.96-.365 1.326 0 .365.366.365.958 0 1.324L9.65 8.675v-.35l7.076 7.077z" fill="#FFF" fill-rule="evenodd"></path>' +
            '</svg></i>';

        if(isOnline) {
            api.openPopout();
        }
    };

    // hooks
    var callHook = function(action, params) {
        if (!ready) {
            return hookQueue.push(arguments);
        }
        var data = {
            src: 'rocketchat',
            fn: action,
            args: params
        };
        iframe.contentWindow.postMessage(data, '*');
    };

    var api = {
        ready: function() {
            ready = true;
            if (hookQueue.length > 0) {
                hookQueue.forEach(function(hookParams) {
                    callHook.apply(this, hookParams);
                });
                hookQueue = [];
            }
        },
        toggleWindow: function(/*forceClose*/) {
            if (widget.dataset.state === 'closed') {
                openWidget();
            } else {
                closeWidget();
            }
        },
        openPopout: function() {
            widget.style.right = '0';
            widget.style.top = '0';
            widget.style.bottom = '0';
            widget.style.width = '370px';
            /*if(isFullPopUp) {*/
                widget.style.height = '100%';
            /*}*/
            widget.style.opacity = 1;
            widgetOpener.style.right = '335px';
            widgetOpener.style.bottom = '5px';
            iframe.contentWindow.postMessage('maximize', '*');
            // closeWidget();
            // var popup = window.open(config.url + '?mode=popout', 'livechat-popout', 'width=400, height=450, toolbars=no');
            // popup.focus();
        },
        openWidget: function() {
            openWidget();
        },
        removeWidget: function() {
            document.getElementsByTagName('body')[0].removeChild(widget);
        },
        setOnline: function(){
            isOnline = true;
        },
        setOffline: function(){
            isOnline = false;
        },
        setFullPopUp: function() {
            isFullPopUp = true;
        }
    };

    var pageVisited = function(change) {
        callHook('pageVisited', {
            change: change,
            location: JSON.parse(JSON.stringify(document.location)),
            title: document.title
        });
    };

    var setCustomField = function(key, value) {
        callHook('setCustomField', [ key, value ]);
    };

    var setTheme = function(theme) {
        callHook('setTheme', theme);
    };

    var currentPage = {
        href: null,
        title: null
    };
    var trackNavigation = function() {
        setInterval(function() {
            if (document.location.href !== currentPage.href) {
                pageVisited('url');
                currentPage.href = document.location.href;
            }
            if (document.title !== currentPage.title) {
                pageVisited('title');
                currentPage.title = document.title;
            }
        }, 800);
    };

    var init = function(url) {
        if (!url) {
            return;
        }

        config.url = url;

        var chatWidget = document.createElement('div');
        var chatWidgetOpener = document.createElement('div');

        chatWidgetOpener.className = 'floating-livechat';

        chatWidgetOpener.innerHTML = '<i style="line-height: 0;display: block;">' +
            '<svg width="25" height="25" preserveAspectRatio="xMidYMin" viewBox="0 0 25 25" xmlns="http://www.w3.org/2000/svg" style="transform: translate(-50%, -50%);bottom: 50%;top: 50%;position: absolute;">' +
            '<path d="M23.295 24.412a.987.987 0 0 1-1.123-.43L19.9 20.358H9.527c-1.392 0-2.523-1.153-2.523-2.57V16.3c0-.563.448-1.02 1-1.02.553 0 1 .457 1 1.02v1.485c0 .295.235.533.523.533h10.92c.036 0 .067.018.103.022a.96.96 0 0 1 .527.224.984.984 0 0 1 .14.15c.023.026.054.043.073.075l.725 1.154V9.7a.528.528 0 0 0-.523-.532h-1.48c-.55 0-1-.457-1-1.02 0-.56.45-1.018 1-1.018h1.48c1.392 0 2.524 1.152 2.524 2.57V23.433c0 .452-.293.85-.72.978zM14.49 13.226H4.116L1.844 16.85a.997.997 0 0 1-1.124.43 1.017 1.017 0 0 1-.72-.978V2.57C0 1.152 1.132 0 2.523 0H14.49c1.39 0 2.52 1.152 2.52 2.57v8.085c0 1.418-1.13 2.57-2.52 2.57zm.52-10.656a.528.528 0 0 0-.52-.532H2.522c-.288 0-.522.24-.522.532v10.242l.726-1.153c.02-.032.05-.05.07-.076a.897.897 0 0 1 .296-.256.92.92 0 0 1 .372-.118c.037-.004.068-.022.104-.022h10.92c.288 0 .522-.238.522-.533V2.57z" fill="#FFF" fill-rule="evenodd"></path>' +
            '</svg></i>';

        chatWidgetOpener.style.display = 'block';
        chatWidgetOpener.style.position = 'fixed';
        chatWidgetOpener.style.height = '52px';
        chatWidgetOpener.style.width = '52px';
        chatWidgetOpener.style.background = '#00afff';
        chatWidgetOpener.style.padding = 0;
        chatWidgetOpener.style.borderRadius = '3px';
        chatWidgetOpener.style.bottom = '36px';
        chatWidgetOpener.style.right = '36px';
        chatWidgetOpener.style.zIndex = 12345;
        chatWidgetOpener.style.cursor = 'pointer';
        chatWidgetOpener.style.textAlign = 'center';
        chatWidgetOpener.style.boxShadow = '0 2px 6px 0 rgba(0,0,0,.4)';
        chatWidgetOpener.style.overflow = 'hidden';
        chatWidgetOpener.onclick = api.toggleWindow;

        chatWidget.dataset.state = 'closed';
        chatWidget.className = 'rocketchat-widget';
        chatWidget.innerHTML = '<div class="rocketchat-container" style="width:100%;height:100%">' +
            '<iframe id="rocketchat-iframe" src="' + url + '" style="width:100%;height:100%;border:none;background-color:transparent" allowTransparency="true"></iframe> '+
            '</div><div class="rocketchat-overlay"></div>';

        chatWidget.style.position = 'fixed';
        chatWidget.style.height = '0';
        chatWidget.style.width = '0';
        chatWidget.style.right = '36px';
        chatWidget.style.bottom = '100px';
        chatWidget.style.transition = 'all 0.2s ease-in-out';
        chatWidget.style.opacity = 0;
        chatWidget.style.borderRadius = '5px';
        chatWidget.style.zIndex = '12345';

        document.getElementsByTagName('body')[0].appendChild(chatWidget);
        document.getElementsByTagName('body')[0].appendChild(chatWidgetOpener);

        widget = document.querySelector('.rocketchat-widget');
        widgetOpener = document.querySelector('.floating-livechat');
        iframe = document.getElementById('rocketchat-iframe');

        w.addEventListener('message', function(msg) {
            if (typeof msg.data === 'object' && msg.data.src !== undefined && msg.data.src === 'rocketchat') {
                if (api[msg.data.fn] !== undefined && typeof api[msg.data.fn] === 'function') {
                    var args = [].concat(msg.data.args || []);
                    api[msg.data.fn].apply(null, args);
                }
            }
        }, false);

        var mediaqueryresponse = function(mql) {
            if (mql.matches) {
                chatWidget.style.left = '0';
                chatWidget.style.right = '0';
                chatWidget.style.width = '100%';
            } else {
                chatWidget.style.left = 'auto';
                chatWidget.style.right = '36px';
                chatWidget.style.width = 0;
            }
        };

        var mql = window.matchMedia('screen and (max-device-width: 480px) and (orientation: portrait)');
        mediaqueryresponse(mql);
        mql.addListener(mediaqueryresponse);

        // track user navigation
        trackNavigation();
    };

    if (typeof w.initRocket !== 'undefined') {
        console.warn('initRocket is now deprecated. Please update the livechat code.');
        init(w.initRocket[0]);
    }

    if (typeof w.RocketChat.url !== 'undefined') {
        init(w.RocketChat.url);
    }

    var queue = w.RocketChat._;

    w.RocketChat = w.RocketChat._.push = function(c) {
        c.call(w.RocketChat.livechat);
    };

    // exports
    w.RocketChat.livechat = {
        pageVisited: pageVisited,
        setCustomField: setCustomField,
        setTheme: setTheme
    };

    // proccess queue
    queue.forEach(function(c) {
        c.call(w.RocketChat.livechat);
    });
}(window));