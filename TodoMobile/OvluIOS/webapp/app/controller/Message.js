
Ext.define('Ovlu.controller.Message', {
    extend: 'Ext.app.Controller',
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
                sendMessageCommand: 'sendMessage'
            },
            "#inboxList": {
                itemtap: 'onInboxItemTap'
            },
            sentView: {
                activate: 'sentLaunch'
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

    getInboxMessages: function(callback) {
        var me = this;
        var msgStore = Ext.getStore('InboxStore');

        if(msgStore.getCount() > 0) {
            me.getInboxView().child('#inboxList').setStore(msgStore);
            return;
        }

        Ext.Viewport.setMasked({ message: 'Loading messages...' });
        
        var sessionStore = Ext.getStore('SessionStore');
        sessionStore.load();
        var sessionModel = sessionStore.getAt(0).data;
        
        // TODO : Change URL
        var requestUrl = //'http://localhost:8080/rest/message/getmessageslist/'
                'http://ovlu-stg.elasticbeanstalk.com/rest/message/getmessageslist/?to=-1&from=&bucket=0&mark=0&size=10&page=1&order_by=message_id&order=desc';
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

                var responseJson = Ext.JSON.decode(response.responseText);               
                var records = responseJson.message_data.records;
                var recLength = records.length;
                
                var sStore = Ext.getStore('SessionStore');
                sStore.load();
                var sModel = sessionStore.getAt(0);
                sModel.set('inMsgCnt', recLength);
                sStore.sync();
                
                var store = Ext.getStore('InboxStore');
                // clearing store
                if(store.data) {
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
                me.getInboxView().child('#inboxList').setStore("");

                // Bind data to the list and display it
                me.getInboxView().child('#inboxList').setStore(store);
                Ext.Viewport.setMasked(false);
                
            },
            
            failure: function(response) {
                console.log(response);
            }
            
        });
        
    },
    
    getSentMessages: function(callback) {
        var me = this;      
        var msgStore = Ext.getStore('SentStore');

        if(msgStore.getCount() > 0) {
            me.getSentView().child('#sentList').setStore(msgStore);
            return;
        }

        Ext.Viewport.setMasked({ message: 'Loading messages...' });
        
        var sessionStore = Ext.getStore('SessionStore');
        sessionStore.load();
        var sessionModel = sessionStore.getAt(0).data;
        
        // TODO : Change URL
        var requestUrl = //'http://localhost:8080/rest/message/getmessageslist/'
                'http://ovlu-stg.elasticbeanstalk.com/rest/message/getmessageslist/?to=-1&from=&bucket=0&mark=0&size=10&page=1&order_by=message_id&order=desc';
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

                var responseJson = Ext.JSON.decode(response.responseText);               
                var records = responseJson.message_data.records;
                var recLength = records.length;
                
                var sStore = Ext.getStore('SessionStore');
                sStore.load();
                var sModel = sessionStore.getAt(0);
                sModel.set('sentMsgCnt', recLength);
                sStore.sync();
                
                var store = Ext.getStore('SentStore');
                // clearing store
                if(store.data) {
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
                me.getSentView().child('#sentList').setStore("");

                // Bind data to the list and display it
                me.getSentView().child('#sentList').setStore(store);
                Ext.Viewport.setMasked(false);                
            },
            
            failure: function(response) {
                console.log(response);
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
