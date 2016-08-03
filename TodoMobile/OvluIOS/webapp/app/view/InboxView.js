
Ext.define('Ovlu.view.InboxView', {
    extend: 'Ext.Panel',
    alias: 'widget.inboxView',

    requires: [
        'Ext.dataview.List',
        'Ext.XTemplate',
        'Ext.TitleBar'       
    ],

    config: {
        layout: 'fit', 
        fullscreen: true,
        items: [
            {
                xtype: 'titlebar',
                title: 'Inbox',
                cls: 'x-titlebar',
                docked: 'top',
                items: [
                    {
                        xtype: 'button',
                        html: '<img src="resources/images/menu_icon.png"/>',
                        itemId: 'revealButton',
                        align: 'left'
                    },
                    {
                        xtype: 'button',
                        text: 'Compose',
                        ui: 'action',
                        padding: '5px',
                        itemId: 'sendButton',
                        align: 'right',
                        style: 'background:#e67e22;color:#FFF;font-size:small;',
                    }
                ]
            },
            {
                xtype: 'list',
                id: 'inboxList',
                itemTpl: [
                    '<div class="msg_content">',
                        '<div class="msg_avatar">',
                            '<img alt="#" src="resources/images/img-dashboard-message.png" width="40" height="40" />',                    
                        '</div> ',
                        '<div class="msg_data"> ', 
                            '<div class="msg_mark"></div>',
                            '<span class="msg_sub">{msg_subject:ellipsis(15, true)}</span>',
                            '<span class="msg_date">{msg_sent_sm}</span><br/>',
                            '<div style="float:right"><img src="resources/images/right-arraow.png" width="20px" height="20px"/></div>',
                            '<div class="msg_body">{msg_body:ellipsis(25, true)}</div>',
                            '<div class="msg_from">from : <a href="#">{from_id}</a></div>',
                        '</div>',
                    ' </div>'
                ]
            }
        ],
        listeners: [
            {
                delegate: '#revealButton',
                event: 'tap',
                fn: 'onRevealButtonTap'
            },
            {
                delegate: '#sendButton',
                event: 'tap',
                fn: 'onSendButtonTap'
            }
        ]
    },
    doSetHidden: function(hidden) {
        this.callParent(arguments);
        //console.log("hidden :: " + hidden);
        if (!hidden) {
            var leftMenu = Ext.getCmp('mainLeftMenu');
            if(!leftMenu) {
                leftMenu = Ext.create('Ovlu.view.LeftMenu');
            }
            Ext.Viewport.setMenu(leftMenu, {
                side: 'left',
                reveal: true
            });
        } 
    },
    onRevealButtonTap: function(){
        var me = this;
        me.fireEvent('mainMenuSlideCommand');
    },
    onSendButtonTap: function(){
        var me = this;
        me.fireEvent('sendMessageCommand');
    }
    
});

