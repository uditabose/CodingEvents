

Ext.define('Ovlu.view.MessageDetail', {
    extend: 'Ext.Panel',
    alias: 'widget.msgDetail',
    
    requires: [
        'Ext.TitleBar',
        'Ext.XTemplate'
    ],
    config: {
        
        layout: 'vbox',
        pack: 'center',
        align: 'center',
        
        items: [
            {
                xtype: 'panel',
                id: 'msgDetId',
                layout:'fit',
                tpl: [
                    '<div class="msgdet_content">',
                        '<div class="msgdet_avatar">',
                            '<img alt="#" src="resources/images/img-dashboard-message.png" width="40" height="40" />',                    
                        '</div> ',
                        '<div class="msgdet_data"> ', 
                            '<div class="msgdet_mark"></div>',
                            '<span class="msgdet_sub">{msg_subject}</span>',
                            '<span class="msgdet_date">{msg_sent}</span><br/>',
                            '<div class="msgdet_from">to : <a href="#">{message_recipient}</a></div>',
                            '<div class="msgdet_from">from : <a href="#">{from_id}</a></div>',
                        '</div>',
                        '<div class="msgdet_body">{msg_body}</div>',
                        '<label for="reSubId" style="font-size:small">Subject&nbsp; :&nbsp; </label><textarea rows="1" id="reSubId">Re: {msg_subject} - From Ovlu</textarea><br/>',
                        '<label for="reToId" style="font-size:small">To&nbsp; :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </label><textarea rows="1" id="reToId">{from_id}</textarea><br/>',
                        '<textarea rows="20" id="replyText" placeholder="Reply message..."></textarea>',
                    ' </div>'
                    
                ]
            },
            {
                xtype: 'titlebar',
                docked: 'bottom',
                cls: 'x-titlebar',
                items : [
                    {
                        xtype: 'button',
                        text: 'Send',
                        ui: 'action',
                        padding: '5px',
                        itemId: 'replyButton',
                        align: 'right',
                        style: 'background:#e67e22;color:#FFF;font-size:small;',
                    },
                    {
                        xtype: 'label',
                        html: 'Sent successful.',
                        itemId: 'replySuccessLabel',
                        hidden: true,
                        hideAnimation: 'fadeOut',
                        showAnimation: 'fadeIn',
                        cls: 'replySuccess',
                        align: 'center'
                                
                    },
                    {
                        xtype: 'label',
                        html: 'Sent failed. Please try later.',
                        itemId: 'replyFailedLabel',
                        hidden: true,
                        hideAnimation: 'fadeOut',
                        showAnimation: 'fadeIn',
                        cls: 'replyError',
                        align: 'center'
                    }
                ]
            }

        ],
        listeners: [{
            delegate: '#replyButton',
	    event: 'tap',
	    fn: 'onReplyButtonTap'
        }]
    },
    onReplyButtonTap: function() {
        var me = this;
        me.down('#replySuccessLabel').hide();
        me.down('#replyFailedLabel').hide();
        me.fireEvent('sendReplyCommand', me);
    },
    showReplyStatus: function(status) {
        var me = this;
        if(status === "success") {
            me.down('#replySuccessLabel').show();
        } else {
            me.down('#replyFailedLabel').show();
        }
        
    }
    
});


