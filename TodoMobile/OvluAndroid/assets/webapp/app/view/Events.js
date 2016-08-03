
Ext.define('Ovlu.view.Events', {
    extend: 'Ext.Panel',
    alias: 'widget.eventsView',
    
    requires: [
        'Ext.XTemplate',
        'Ext.TitleBar',
        'Ext.ux.TouchCalendar',
        'Ext.ux.TouchCalendarView',
        'Ext.ux.TouchCalendarSimpleEvents',
    ],
    
    config: {
        layout: 'fit',
        fullscreen: true,
        items: [
            {
                xtype: 'titlebar',
                title: 'Events',
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
                        text: '+',
                        ui: 'action',
                        padding: '5px',
                        itemId: 'addButton',
                        align: 'right',
                        style: 'background:#e67e22;color:#FFF',
                    }

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
                delegate: '#addButton',
                event: 'tap',
                fn: 'onAddButtonTap'
            }
        ]
    },
    doSetHidden: function(hidden) {
        this.callParent(arguments);
        //console.log("events hidden :: " + hidden);
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
    onAddButtonTap: function() {
        var me = this;
        me.fireEvent('addNewEventCommand');
    }
});


