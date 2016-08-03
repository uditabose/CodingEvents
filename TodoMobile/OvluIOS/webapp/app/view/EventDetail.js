Ext.define('Ovlu.view.EventDetail', {
    extend: 'Ext.Panel',
    alias: 'widget.eventDetail',
    
    requires: [
        'Ext.XTemplate',
        'Ext.TitleBar'
    ],
    
    config: {
        layout: 'fit',
        styleHtmlContent: true,
        hidden: true,
        modal:true,
        hideOnMaskTap:true,
        height: '70%',
        width: '70%',
        scrollable: 'vertical',
        centered: true,
        showAnimation:{
            type: 'popIn',
            duration: 250,
            easing: 'ease-out'

        },
        hideAnimation:{
            type: 'popOut',
            duration: 250,
            easing: 'ease-out'
        },
        items: [
            {
                xtype: 'titlebar',
                docked: 'top',
                cls: 'x-titlebar',
                title: 'Event details'
            },
            {
                xtype: 'titlebar',
                docked: 'bottom',
                cls: 'x-titlebar',
                items: [
                    {
                        xtype: 'button',
                        text: 'Save',
                        ui: 'action',
                        padding: '5px',
                        itemId: 'saveEvtButton',
                        align: 'right',
                        style: 'background:#e67e22;color:#FFF;font-size:small;'
                    },
                    {
                        xtype: 'button',
                        text: 'Close',
                        ui: 'action',
                        padding: '5px',
                        itemId: 'closeEvtButton',
                        align: 'right',
                        style: 'background:#e67e22;color:#FFF;font-size:small;',
                    }
                ]
            },
            {
                xtype: 'panel',
                id: 'evtDetId',
                tpl: [
                    '<div class="evtdet_content">',
                        '<div><label for="evtdet_title" class="cursiveSmall">Event title</label>',
                        '<textarea id="evtdet_title" row="1">{event_title}</textarea></div>',
                        '<div><label for="evtdet_desc" class="cursiveSmall">Event Description</label>',
                        '<textarea id="evtdet_desc" row="1">{event_description}</textarea></div>',
                        '<div><label for="evtdet_loc" class="cursiveSmall">Event location</label><br/>',
                        '<textarea id="evtdet_loc" row="1">{event_location}</textarea></div>',
                        '<div><label for="evtdet_st_date" class="cursiveSmall">Start date/time</label>',
                        '<textarea id="evtdet_st_date" row="1">{event_start}</textarea></div>',
                        '<div><label for="evtdet_ed_date" class="cursiveSmall">End date/time</label>',
                        '<textarea id="evtdet_ed_date" row="1">{event_end}</textarea></div>',
                    '</div>'
                ]  
            }
        ],
        
        listeners: [
            {
                delegate: '#saveEvtButton',
                event: 'tap',
                fn: 'onSaveEvtButtonTap'
            },
            {
                delegate: '#closeEvtButton',
                event: 'tap',
                fn: 'onCloseButtonTap'
            }
        ]
        
    },
    onSaveEvtButtonTap: function() {
        this.fireEvent('saveEventCommand');
    },
    onCloseButtonTap: function() {
        this.hide();
    },
    
});


