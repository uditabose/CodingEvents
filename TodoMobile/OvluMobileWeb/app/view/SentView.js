
Ext.define('Ovlu.view.SentView', {
    extend: 'Ext.Panel',
    alias: 'widget.sentView',

    requires: [
        'Ext.dataview.List',
        'Ext.XTemplate',
        'Ext.TitleBar',
        'Ext.plugin.ListPaging',
        'Ext.plugin.PullRefresh'
    ],

    config: {
        layout: 'fit',
        fullscreen: true,
        items: [
            {
                xtype: 'titlebar',
                title: 'Sent',
                cls: 'x-titlebar',
                docked: 'top',
                items: [
                    {
                        xtype: 'button',
                        html: '<img src="resources/images/menu_icon.png"/>',
                        itemId: 'revealButton',
                        align: 'left'
                    }                  
                ]
            },
            {
                xtype: 'list',
                id: 'sentList',
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
                ],
                plugins: [
                    {
                        xclass: 'Ext.plugin.PullRefresh',
                        pullText: 'Checking for messages...',
                        fetchLatest : function() {
                            console.log(this.getList().parent);
                            this.getList().parent.refetchSentList();
                            console.log("Time to snap");
                            if (this.getAutoSnapBack()) {
                                console.log("Snapping back");
                                this.snapBack(true);
                            }
                        }
                    },
                    {
                        xclass: 'Ext.plugin.ListPaging',
                        autoPaging: true,
                        loadNextPage: function() {
                            console.log("loading more messages");
                            var me = this;
                            me.disableDataViewMask();
                            me.setLoading(true);
                            console.log("fetching list");
                            me.getList().parent.loadMoreSentList();
                            
                        }
                    }
                ]
            }
        ],
        listeners: [{
            delegate: '#revealButton',
	    event: 'tap',
	    fn: 'onRevealButtonTap'
        }]
    },
    doSetHidden: function(hidden) {
        this.callParent(arguments);
        //console.log("hidden :: " + hidden);
        if (!hidden) {
            var leftMenu = Ext.getCmp('mainLeftMenu');
            if(!leftMenu) {
                leftMenu = Ext.create('Ovlu.view.LeftMenu');
            }
            //var leftMenu = Ext.create('Ovlu.view.LeftMenu', {});
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
    refetchSentList: function() {
        console.log("Refetching sent");
        var me = this;
        me.fireEvent('refreshSentCommand');        
    },
    loadMoreSentList: function() {
        console.log("Loading more sent");
        var me = this;
        me.fireEvent('loadNextSentPageCommand');
        
    }
    
});



