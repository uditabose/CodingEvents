

Ext.define('Ovlu.store.InboxStore', {
    extend: 'Ext.data.Store',

    requires: [
        'Ovlu.model.Message',
        'Ext.data.proxy.Ajax',
        'Ext.data.reader.Json'
    ],

    config: {
        model: 'Ovlu.model.Message',
        storeId: 'InboxStore',
        proxy: {
            type: 'ajax',
            reader: {
                type: 'json',
                rootProperty: 'records'
            }
        }
    }
});
