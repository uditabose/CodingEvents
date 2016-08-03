Ext.define('Ovlu.controller.Login', {
    extend: 'Ext.app.Controller',
    requires : [
        'Ovlu.view.InboxView'
    ],
    config: {
        refs: {
            loginView: 'loginView',
            mainNav: 'mainNav'
        },
        control: {
            loginView: {
                signInCommand: 'onSignInCommand'
            }
        }
    },
    launch: function(){
        //console.log('Login launch.');
        var me = this;
        var sessionStore = Ext.getStore('SessionStore');
        sessionStore.load();
        var sessionModel = sessionStore.getAt(0);
        
        if(sessionModel) {
            sessionModel = sessionModel.data;
            var access_token = sessionModel.access_token;
            if(access_token) {
                //console.log('Login launch - access_token : ' + access_token);
                me.signInSuccess();
            }
        }
    },
    signInSuccess: function () {
        //console.log('Signed in.');
        var loginView = this.getLoginView();
        var mainNav = this.getMainNav();

        //var messageList = Ext.create('Ovlu.view.MessageList');

        loginView.setMasked(false);
        Ext.Viewport.animateActiveItem(mainNav, this.getSlideLeftTransition());
        mainNav.getNavigationBar().hide();
        var navItems = mainNav.getItems().items;
        var popToIdx = -1;
        for(var i = 0; i < navItems.length; i++) {
            if(navItems[i].getId().indexOf('inboxView') >= 0 ) {
                popToIdx = i;
            }
        }

        if(popToIdx !== -1) {
            mainNav.pop(popToIdx);
        } else {
            mainNav.push(Ext.create('Ovlu.view.InboxView'));
        }
        //mainNav.push(messageList);
    },
    
    signInFailure: function (message) {
        var loginView = this.getLoginView();
        loginView.showSignInFailedMessage(message);
        loginView.setMasked(false);
    },
    
    getSlideLeftTransition: function () {
        return { type: 'slide', direction: 'left' };
    },
    getSlideRightTransition: function() {
        return { type: 'slide', direction: 'right' };
    },
    onSignInCommand: function(view, username, password) {

        //console.log('Username: ' + username + '\n' + 'Password: ' + password);

        var me = this,
        loginView = me.getLoginView();

        if (username.length === 0 || password.length === 0) {

            loginView.showSignInFailedMessage('Please enter your username and password.');
            return;
        }

        loginView.setMasked({
            xtype: 'loadmask',
            message: 'Signing In...'
        });

        Ext.Ajax.request({
            url: //'http://localhost:8080/rest/authtoken/',
                    'http://ovlu-stg.elasticbeanstalk.com/rest/authtoken/',
            withCredentials: false,
            useDefaultXhrHeader: false,
            method: 'post',
            jsonData: {
                "password":password,
                "username":username,
                "grant_type":"password",
                "client_id":"mobile_client_id"
            },
            headers: {
                "Content-Type": "application/json",
                "Accept": "application/json",
            },
            success: function(response) {

                var loginResponse = Ext.JSON.decode(response.responseText);
                if (response.status === 200) {
                    // The server will send a token that can be used throughout 
                    // the app to confirm that the user is authenticated.
                    var sessModel = Ext.create('Ovlu.model.Session', {
                        'access_token': loginResponse.access_token,
                        'expires_in': loginResponse.expires_in,
                        'refresh_token' : loginResponse.refresh_token,
                        'user_name' : 'there'
                    });
                    
                    var sessionStore = Ext.getStore('SessionStore');

                    // get the user details                    
                    var requestUrl = //'http://localhost:8080/rest/message/getmessageslist/'
                            'http://ovlu-stg.elasticbeanstalk.com/rest/account/getaccountinfo/id';
                    var msgHeader = {
                            "Content-Type": "application/json",
                            "Accept": "application/json",
                            "access_token": loginResponse.access_token
                    };
        
                    Ext.Ajax.request({
                        url: requestUrl,
                        withCredentials: false,
                        useDefaultXhrHeader: false,
                        method: 'get',
                        headers: msgHeader,
                        
                        success: function(response){
                            var responseJson = Ext.JSON.decode(response.responseText); 
                            if(responseJson.user_name || responseJson.user_name !== '') {
                                sessModel.user_name = responseJson.user_name;
                            }

                            sessModel.email = responseJson.email;
                        },
                        
                        failure: function(response){
                            console.log("No yet decided!");
                            console.log(response);
                        }
                    });
                    sessionStore.add(sessModel);
                    sessionStore.sync();
                    me.signInSuccess();     //Just simulating success.
                } else {
                    me.signInFailure(loginResponse.message);
                }
            },
            failure: function(response) {
                me.sessionToken = null;
                me.signInFailure('Login failed. Please try again later.');
            }
        });
    },
    
    onSignOffCommand: function() {
        var me = this;

        var sessionStore = Ext.getStore('SessionStore');
        sessionStore.load();
        if(sessionStore.data) {
            sessionStore.data.clear();
        }

        Ext.Viewport.animateActiveItem(this.getLoginView(), this.getSlideRightTransition());
    }
    
});
