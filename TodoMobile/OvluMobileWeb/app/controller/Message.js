
Ext.define('Ovlu.controller.Message', {
    extend: 'Ext.app.Controller',
    requires: [
        'Ovlu.model.Message',
        'Ovlu.view.MessageDetail',
        'Ovlu.view.MessageCompose'
    ],
    config:{
        refs: {
            inboxList: '#inboxList',
            inboxView: 'inboxView',
            sentView: 'sentView',
            sentList: '#sentList',
            mainNav: 'mainNav',
            msgDetail: 'msgDetail',
            msgCompose: 'msgCompose'
        },
        control: {
            inboxView: {
                activate: 'inboxLaunch',
                refreshInboxCommand: 'refreshInbox',
                sendMessageCommand: 'sendMessage',
                loadNextInboxPageCommand: 'loadNextInboxPage'
            },
            "#inboxList": {
                itemtap: 'onInboxItemTap'
            },
            sentView: {
                activate: 'sentLaunch',
                refreshSentCommand: 'refreshSent',
                loadNextSentPageCommand: 'loadNextSentPage'
            },
            "#sentList": {
                itemtap: 'onSentItemTap'
            },
            msgDetail: {
                sendReplyCommand: 'sendReply'
            },
            msgCompose: {
                sendReplyCommand: 'sendNewMsg'
            }
        }
    },
    
    inboxLaunch: function() {
        var me = this;
        me.getMainNav().getNavigationBar().hide();  
        me.getInboxMessages();
    },
    
    sentLaunch: function() {
        var me = this;
        me.getMainNav().getNavigationBar().hide(); 
        me.getSentMessages();
    },

    getInboxMessages: function() {
        var me = this;
        var msgStore = Ext.getStore('InboxStore');

        if(msgStore.getCount() > 0) {
            me.getInboxView().child('#inboxList').setStore(msgStore);
            return;
        }

        Ext.Viewport.setMasked({ message: 'Loading...' });

        // TODO : Change URL
        var requestUrl = //'http://localhost:8080/rest/message/getmessageslist/'
                'http://ovlu-stg.elasticbeanstalk.com/rest/message/getmessageslist/?to=-1&from=&bucket=0&mark=0&size=10&page=1&order_by=message_id&order=desc';
        var listElement = me.getInboxView().child('#inboxList');
        me.getMessages(requestUrl, msgStore, listElement); 
 
    },
    
    refreshInbox: function() {
        var me = this;
        Ext.Viewport.setMasked({ message: 'Loading...' });
        console.log('Refreshing inbox');

        // TODO : Change URL
        var requestUrl = //'http://localhost:8080/rest/message/getmessageslist/'
                'http://ovlu-stg.elasticbeanstalk.com/rest/message/getmessageslist/?to=-1&from=&bucket=0&mark=0&size=10&page=1&order_by=message_id&order=desc';
        var listElement = me.getInboxView().child('#inboxList');
        var store = Ext.getStore('InboxStore');
        me.getMessages(requestUrl, store, listElement); 
    },
    
    loadNextInboxPage: function() {
        var me = this;
        
        console.log('Loading next page inbox');
        var store = Ext.getStore('InboxStore');
        var pageNumber = 1 + store.getCount()/10;
        // TODO : Change URL
        var requestUrl = //'http://localhost:8080/rest/message/getmessageslist/'
                'http://ovlu-stg.elasticbeanstalk.com/rest/message/getmessageslist/?' +
        'to=-1&from=&bucket=0&mark=0&size=10&page='+ pageNumber +'&order_by=message_id&order=desc';
        var listElement = me.getInboxView().child('#inboxList');
        
        me.getMessages(requestUrl, store, listElement, true); 
    },
    
    getSentMessages: function() {
        var me = this;      
        var msgStore = Ext.getStore('SentStore');
        var listElement = me.getSentView().child('#sentList');
        if(msgStore.getCount() > 0) {
            listElement.setStore(msgStore);
            return;
        }

        Ext.Viewport.setMasked({ message: 'Loading...' });

        // TODO : Change URL
        var requestUrl = //'http://localhost:8080/rest/message/getmessageslist/'
                'http://ovlu-stg.elasticbeanstalk.com/rest/message/getmessageslist/?to=-1&from=&bucket=0&mark=0&size=10&page=1&order_by=message_id&order=desc';

        me.getMessages(requestUrl, msgStore, listElement); 
        
    },

    refreshSent: function() {
        var me = this;      
        var msgStore = Ext.getStore('SentStore');
        var listElement = me.getSentView().child('#sentList');

        Ext.Viewport.setMasked({ message: 'Loading...' });

        // TODO : Change URL
        var requestUrl = //'http://localhost:8080/rest/message/getmessageslist/'
                'http://ovlu-stg.elasticbeanstalk.com/rest/message/getmessageslist/?to=-1&from=&bucket=0&mark=0&size=10&page=1&order_by=message_id&order=desc';

        me.getMessages(requestUrl, msgStore, listElement); 
        
    },
    loadNextSentPage: function() {
        var me = this;
        
        console.log('Loading next page sent');
        var store = Ext.getStore('SentStore');
        var pageNumber = 1 + store.getCount()/10;
        // TODO : Change URL
        var requestUrl = //'http://localhost:8080/rest/message/getmessageslist/'
                'http://ovlu-stg.elasticbeanstalk.com/rest/message/getmessageslist/?' +
        'to=-1&from=&bucket=0&mark=0&size=10&page='+ pageNumber +'&order_by=message_id&order=desc';
        var listElement = me.getSentView().child('#sentList');
        
        me.getMessages(requestUrl, store, listElement, true); 
    },
    
    // utility method
    getMessages : function(requestUrl, msgStore, listElement, toAppend) {
        var sessionStore = Ext.getStore('SessionStore');
        sessionStore.load();
        var sessionModel = sessionStore.getAt(0).data;
        
        var msgHeader = {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "access_token": sessionModel.access_token
        };

        Ext.Ajax.request({
            url: requestUrl,
            withCredentials: false,
            useDefaultXhrHeader: false,
            method: 'get',
            headers: msgHeader,
            
            success : function(response){
                //isSuccess = true;
                var responseJson = Ext.JSON.decode(response.responseText);               
                var records = responseJson.message_data.records;
                var recLength = records.length;

                var store = msgStore;
                // clearing store
                if(store.data && toAppend !== true) {
                    console.log("Clearing store");
                    store.removeAll();
                }
                
                for(var i = 0; i < recLength; i++) {
                    var msgModel = Ext.create('Ovlu.model.Message', {
                        'msg_subject': records[i].msg_subject,
                        'msg_body': records[i].msg_body,
                        'message_id' : records[i].message_id,
                        'from_id' : records[i].from_id,
                        'bucket' : records[i].bucket,
                        'mark' : records[i].mark,
                        'message_recipient' : records[i].message_recipient,
                        'msg_read' : records[i].msg_read,
                        'msg_sent' : records[i].msg_sent
                    });
                    store.add(msgModel);
                }
                listElement.setStore("");
                listElement.setStore(msgStore);
                Ext.Viewport.setMasked(false); 
                               
            },
            
            failure: function(response) {
                console.log(response);
                Ext.Viewport.setMasked(false); 
            }            
        });

    },
    
    onInboxItemTap: function(dataview, index, target, record, e, eOpts) {
        var me = this;
        
        if(record){
            var detailPanel = Ext.create('Ovlu.view.MessageDetail', {
                title: record.data.msg_subject
            });

            var msgDet = detailPanel.child('#msgDetId');
            msgDet.setData(record.data);
            
            me.getMainNav().push(detailPanel);
            me.getMainNav().getNavigationBar().show();
        }
    },
    
    onSentItemTap: function(dataview, index, target, record, e, eOpts) {
        var me = this;
        
        if(record){
            var detailPanel = Ext.create('Ovlu.view.MessageDetail', {
                title: record.data.msg_subject
            });

            var msgDet = detailPanel.child('#msgDetId');
            msgDet.setData(record.data);
            
            me.getMainNav().push(detailPanel);
            me.getMainNav().getNavigationBar().show();
        }
    },
    sendMessage: function() {
        var me = this;
        var composePanel = Ext.create('Ovlu.view.MessageCompose', {
            title: 'Compose message'
        });

        me.getMainNav().push(composePanel);
        me.getMainNav().getNavigationBar().show();
    },
    showReplyStatus: function(status) {
        var msgDetail = this.getMsgDetail();
        msgDetail.showReplyStatus(status);
    },
    showComposeStatus: function(status) {
        var msgCompose = this.getMsgCompose();
        msgCompose.showReplyStatus(status);
    },
    sendReply: function(dataview) {
        var me = this;
        var msgModel = me.getMsgDetail().child('#msgDetId').getData();
        
        var replyText = Ext.get('replyText').getValue();
        var to = Ext.get('reToId').getValue();
        if(!to || to === null) {
            to = msgModel.from_id;
        }
        var sub = Ext.get('reSubId').getValue();
        if(!sub || sub === null) {
            sub = 'Re: ' + msgModel.msg_subject + ' - From Ovlu';
        }

        var sessionStore = Ext.getStore('SessionStore');
        sessionStore.load();
        var sessionModel = sessionStore.getAt(0).data;

        var requestUrl = //'http://localhost:8080/rest/message/sendmessage/'
                'http://ovlu-stg.elasticbeanstalk.com/rest/message/sendmessage';
        var msgHeader = {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "access_token": sessionModel.access_token
        };
        
        Ext.Ajax.request({
            url: requestUrl,
            withCredentials: false,
            useDefaultXhrHeader: false,
            method: 'post',
            headers: msgHeader,
            jsonData: {
                'from_id' : '0',
                'message_recipient' : to,
                'msg_body': replyText,
                'msg_sent' : new Date(),
                'msg_subject' : sub,
                'mark' : '0',
                'bucket' : '0'
            },
            success: function(response) {
                console.log("success : " + response);
                me.showReplyStatus("success");
            },
            
            failure: function(response) {
                console.log("failure : " + response);
                me.showReplyStatus("failure");
                
            }
        });
        
    },
    
    sendNewMsg: function() {
        var me = this;

        var replyText = Ext.get('replyText').getValue();
        var to = Ext.get('reToId').getValue();
        var sub = Ext.get('reSubId').getValue();

        var sessionStore = Ext.getStore('SessionStore');
        sessionStore.load();
        var sessionModel = sessionStore.getAt(0).data;

        var requestUrl = //'http://localhost:8080/rest/message/sendmessage/'
                'http://ovlu-stg.elasticbeanstalk.com/rest/message/sendmessage';
        var msgHeader = {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "access_token": sessionModel.access_token
        };
        
        Ext.Ajax.request({
            url: requestUrl,
            withCredentials: false,
            useDefaultXhrHeader: false,
            method: 'post',
            headers: msgHeader,
            jsonData: {
                'from_id' : '0',
                'message_recipient' : to,
                'msg_body': replyText,
                'msg_sent' : new Date(),
                'msg_subject' : sub,
                'mark' : '0',
                'bucket' : '0'
            },
            success: function(response) {
                console.log("success : " + response);
                me.showComposeStatus("success");
            },
            
            failure: function(response) {
                console.log("failure : " + response);
                me.showComposeStatus("failure");
                
            }
        });
    }
    
});
