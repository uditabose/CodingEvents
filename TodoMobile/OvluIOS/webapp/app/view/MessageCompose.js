Ext.define('Ovlu.view.MessageCompose', {
    extend: 'Ext.Panel',
    alias: 'widget.msgCompose',
    
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
                id: 'msgComposeId',
                layout:'fit',
                html: [
                    '<div class="msgdet_content">' +
                        '<label for="reSubId" style="font-size:small">Subject&nbsp; :&nbsp; </label><textarea rows="1" id="reSubId"> - From Ovlu</textarea><br/>' +
                        '<label for="reToId" style="font-size:small">To&nbsp; :&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </label><textarea rows="1" id="reToId"></textarea><br/>' +
                        '<textarea rows="20" id="replyText" placeholder="Compose message..."></textarea>' +
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
                        html: 'Send successful.',
                        itemId: 'replySuccessLabel',
                        hidden: true,
                        hideAnimation: 'fadeOut',
                        showAnimation: 'fadeIn',
                        cls: 'replySuccess'
                    },
                    {
                        xtype: 'label',
                        html: 'Send failed. Please try later.',
                        itemId: 'replyFailedLabel',
                        hidden: true,
                        hideAnimation: 'fadeOut',
                        showAnimation: 'fadeIn',
                        cls: 'replyError'
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