/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

Ext.define('Ovlu.model.Event', {
    extend: 'Ext.data.Model',
    config: {
        fields: [
            /*------- Fields for calendar view ----------*/
            {
                name: 'event',
                type: 'string'
            },
            {
                name: 'title',
                type: 'string'
            },
            {
                name: 'start',
                type: 'date',
                dateFormat: 'c'
            },
            {
                name: 'end',
                type: 'date',
                dateFormat: 'c'
            },
            {
                name: 'css',
                type: 'string'
            },
            /*------- Fields from JSON ----------*/
            "event_id", "event_attendee", "event_end", "event_start", 
            "event_location", "event_status","event_title" ,"from_id", "is_repeat",
            "remind","repeat_times", "event_description","transaction_id", "event_type",
            "repeat_parent_id", "repeat_pattern", "offer_id"
        ]
        
    }
});
