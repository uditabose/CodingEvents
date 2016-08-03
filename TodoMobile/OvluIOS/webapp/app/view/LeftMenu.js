Ext.define('Ovlu.view.LeftMenu', {
    extend: 'Ext.Menu',
    alias: 'widget.leftMenu',
    id: 'mainLeftMenu',
    style: 'background-color:#EEEEEE;padding:3px, border-right:1px solid #168ddd',
    config: {
        
	items: [
            {
                xtype: 'panel',
                height: '100%',
                width: '100%',
                
                items : [
                    {
                        xtype:'list',
                        itemTpl: '<div style="color: #168ddd">Hi {user_name}!</div>',
                        height: '10%',
                        id: 'menuUserId',
                        style: {
                            background: '#EEEEEE',
                        }
                        
                    },
                    {
                        xtype:'list',
                        itemTpl: [
                            '<div class="{cls}">',
                                    '<img src="{icon}" width="16px" height="16px"/>',
                                    '&nbsp;&nbsp;<span>{title}</span>',
                                    '<span class="{ccls}">{count}</span>',
                            '</div>'],
                        height: '90%',
                        id: 'menuListId',
                        style: {
                            background: '#EEEEEE'
                        },
                        data : [

                            {title : 'Message', icon:'resources/images/section-clients-icon.png', cls: 'menuLevelZero menuNoSelect'},
                            {title : 'Inbox', icon:'resources/images/icon-inbox-hover.png', cls: 'menuLevelOne'},
                            {title : 'Sent', icon:'resources/images/icon-sent-hover.png', cls: 'menuLevelOne'},
                            {title : 'Event', icon:'resources/images/section-time-icon.png', cls: 'menuLevelZero'},
                            {title : 'Log-Off', icon:'resources/images/logout.png', cls: 'menuLevelZero'}
                        ]
                    }
                ]
            }

        ]
    }
    
});
