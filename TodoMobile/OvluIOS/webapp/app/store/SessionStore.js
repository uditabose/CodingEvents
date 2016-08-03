/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
Ext.define('Ovlu.store.SessionStore', {
    extend: 'Ext.data.Store',

    requires: [
        'Ovlu.model.Session'
    ],

    config: {
        model: 'Ovlu.model.Session',
        storeId: 'SessionStore',
        proxy: {
            type: 'localstorage',
            id: 'session'
        }
    }
});

