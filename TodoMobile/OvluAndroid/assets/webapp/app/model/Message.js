
Ext.define('Ovlu.model.Message', {
        extend: 'Ext.data.Model',
        
        config: {
            fields: ['message_id', 'from_id', 'bucket', 
                'mark', 'message_recipient', 'msg_body',
                'msg_read', 'msg_sent', 'msg_subject'
            ] 
        }
    }

);


