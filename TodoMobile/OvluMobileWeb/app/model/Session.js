Ext.define('Ovlu.model.Session', {
        extend: 'Ext.data.Model',
        config: {
            fields: ['access_token', 'expires_in', 'refresh_token', 'user_name', 'email',
            'inMsgCnt', 'sentMsgCnt']
        }
    }

);



