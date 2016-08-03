/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
Ext.define('Ovlu.store.EventStore', {
    extend: 'Ext.data.Store',

    requires: [
        'Ovlu.model.Event',
        'Ext.data.proxy.Ajax',
        'Ext.data.reader.Json'
    ],

    config: {
        model: 'Ovlu.model.Event',
        storeId: 'EventStore',
        proxy: {
            type: 'ajax',
            reader: {
                type: 'json',
                rootProperty: 'records'
            }
        }
    }
});

