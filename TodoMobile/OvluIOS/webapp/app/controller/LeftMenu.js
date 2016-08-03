
Ext.define('Ovlu.controller.LeftMenu', {
    extend: 'Ext.app.Controller',
    config: {
        refs: {
            loginView: 'loginView',
            inboxView: 'inboxView',
            sentView: 'sentView',
            eventsView: 'eventsView',
            leftMenu: 'leftMenu',
            menuUserId: '#menuUserId',
            mainNav: 'mainNav',
            menuList: '#menuListId'
        },
        control: {
            leftMenu: {
                activate: 'updateMsgCount'
            },
            inboxView: {
                mainMenuSlideCommand: 'mainMenuSlide',  
            },
            sentView: {
                mainMenuSlideCommand: 'mainMenuSlide',  
            },
            eventsView: {
                mainMenuSlideCommand: 'mainMenuSlide',  
            },
            "#menuListId": {
                itemtap: 'onMenuItemTap'
            }
            
        }
    },
    getSlideRightTransition: function() {
        return { type: 'slide', direction: 'right' };
    },
    
    mainMenuSlide: function(){
        //console.log("mainMenuSlide");
        
        Ext.Viewport.toggleMenu('left');
        this.updateMsgCount();
    },
    
    updateMsgCount: function() {
        var sessStore = Ext.getStore('SessionStore');
        sessStore.load();
        var sessModel = sessStore.getAt(0).data;

        this.getMenuUserId().setStore(sessStore);
        
        var inboxStore = Ext.getStore('InboxStore');
        var sentStore = Ext.getStore('SentStore');
        
        var inMsgCount = inboxStore.getCount();
        var sentCount = sentStore.getCount();
        
        var menuList = this.getMenuList();
        var menuListStore = menuList.getStore();
        
        if(menuListStore) {
            for(var c = 0; c < menuListStore.getCount(); c++) {
                //console.log(menuListStore.getAt(c));
                if(menuListStore.getAt(c).data.title === "Inbox") {
                    menuListStore.getAt(c).set('count', inMsgCount);
                    menuListStore.getAt(c).set('ccls', 'menuCount');
                    
                } else if(menuListStore.getAt(c).data.title === "Sent") {
                    menuListStore.getAt(c).set('count', sentCount);
                    menuListStore.getAt(c).set('ccls', 'menuCount');
                   
                }
            }
        }

        
       
    },
    
    onMenuItemTap: function(dataview, index, target, record, e, eOpts) {
        var me = this;
        
        if(record) {
            if(record.data.title === "Inbox") {
                me.showInboxMessageList();
            }else if(record.data.title === "Sent"){
                me.showSentMessageList();
            } else if(record.data.title === "Event"){
                me.showEvents();
            } else if(record.data.title === "Log-Off") {
                me.signOff();
            }
        }

        
    },
    
    showInboxMessageList: function() {
        var activeItemId = this.getMainNav().getActiveItem().getId();
        Ext.Viewport.hideMenu('left');
        if(activeItemId.indexOf('inboxView') < 0) {
            // this is not message view
            
            // find the correct nav item
            var navItems = this.getMainNav().getItems().items;
            var popToIdx = -1;
            for(var i = 0; i < navItems.length; i++) {
                if(navItems[i].getId().indexOf('inboxView') >= 0 ) {
                    popToIdx = i;
                }
                
            }
            
            if(popToIdx !== -1) {
                this.getMainNav().pop(popToIdx);
            } else {
                this.getMainNav().push(Ext.create('Ovlu.view.InboxView'));
            }
        }
        
    },
    
    showSentMessageList: function() {
        var activeItemId = this.getMainNav().getActiveItem().getId();
        console.log("showMessageList :: " + activeItemId);
        Ext.Viewport.hideMenu('left');
        if(activeItemId.indexOf('sentView') < 0) {
            // this is not message view
            
            // find the correct nav item
            var navItems = this.getMainNav().getItems().items;
            var popToIdx = -1;
            for(var i = 0; i < navItems.length; i++) {
                if(navItems[i].getId().indexOf('sentView') >= 0 ) {
                    popToIdx = i;
                }                
            }
            
            if(popToIdx !== -1) {
                this.getMainNav().pop(popToIdx);
            } else {
                this.getMainNav().push(Ext.create('Ovlu.view.SentView'));
            }
        }        
    },
    
    showEvents: function() {
        var activeItemId = this.getMainNav().getActiveItem().getId();
        console.log("showEvents :: " + activeItemId);
        Ext.Viewport.hideMenu('left');
        if(activeItemId.indexOf('eventsView') < 0) {
            // this is not events view
            var navItems = this.getMainNav().getItems().items;
            var popToIdx = -1;
            for(var i = 0; i < navItems.length; i++) {
                if(navItems[i].getId().indexOf('eventsView') >= 0 ) {
                    popToIdx = i;
                }               
            }
            
            if(popToIdx !== -1) {
                this.getMainNav().pop(popToIdx);
            } else {
                var eventsView = Ext.create('Ovlu.view.Events');
                this.getMainNav().push(eventsView);
            }
        }
        
    },
    signOff: function() {
        console.log("signOff :: " );
        var me = this;

        var sessionStore = Ext.getStore('SessionStore');
        sessionStore.load();
        if(sessionStore.data) {
            sessionStore.data.clear();
        }
        if(sessionStore.getProxy()) {
            sessionStore.getProxy().clear();
        }
        sessionStore.sync();
        
        // clearing store
        //var msgStore = Ext.getStore('MessageStore');
        //msgStore.removeAll();

        Ext.Viewport.removeMenu('left');
        Ext.Viewport.animateActiveItem(me.getLoginView(), me.getSlideRightTransition());
        
    }
});

