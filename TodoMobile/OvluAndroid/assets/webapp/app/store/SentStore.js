

Ext.define('Ovlu.store.SentStore', {
    extend: 'Ext.data.Store',

    requires: [
        'Ovlu.model.Message',
        'Ext.data.proxy.Ajax',
        'Ext.data.reader.Json'
    ],

    config: {
        model: 'Ovlu.model.Message',
        storeId: 'SentStore',
        proxy: {
            type: 'ajax',
            reader: {
                type: 'json',
                rootProperty: 'records'
            }
        }
    }
});


