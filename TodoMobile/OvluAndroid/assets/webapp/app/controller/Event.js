
Ext.define('Ovlu.controller.Event', {
    extend: 'Ext.app.Controller',
    requires: ['Ovlu.view.EventDetail'],
    config: {
        refs: {
            eventsView: 'eventsView',
            mainNav: 'mainNav',
            evtList: '#evtList',
            eventDetail: 'eventDetail',
            evtDetSec: '#evtDetId'
        },
        control: {
            eventsView: {
                activate: 'lazyLaunch',
                addNewEventCommand: 'createEvent'
            },
            '#evtList': {
                itemtap: 'editEvent'
            },
            eventDetail: {
                saveEventCommand : 'saveEvent'
            }
        }
    },
    
    lazyLaunch: function(){
        console.log('events lazyLaunch');
        Ext.Viewport.setMasked({ message: 'Loading events...' });
 
        var me = this;
        var eventStore = Ext.getStore('EventStore');        
        var calendar = Ext.create('Ext.ux.TouchCalendarView', {
            viewMode: 'month',
            weekStart: 0,
            value: new Date(),
            eventStore: eventStore,
            id:'evtCalendar',
            
            plugins: [Ext.create('Ext.ux.TouchCalendarSimpleEvents')]
        });
        
        var calendarPanel = Ext.create('Ext.Panel', {
            fullscreen: true,
            layout: 'fit',
            items: [calendar,  {
                docked: 'bottom',
                xtype: 'list',
                id: 'evtList',
                height: (window.innerHeight * 0.35),
                itemTpl: [
                    '<div class="evt_content">',
                        '<div class="evt_title">{event_title}<div>',
                        '<div class="evt_detail">',
                            '<ul class="evt_attendee">',
                                '<li><span class="cursiveSmall">from:</span> {from_id}</li>',
                                '<li><span class="cursiveSmall">to:</span> {event_attendee}</li>',
                            '</ul>',
                            '<div style="float:right"><img src="resources/images/right-arraow.png" width="20px" height="20px"/></div>',
                        '</div>',
                        '<div class="evt_time"><span class="cursiveSmall">where:</span>{event_location}</div>',
                        '<div class="evt_time"><span class="cursiveSmall">when:</span> {event_start}&nbsp;-&nbsp;{event_end}</div>',
                    '</div>'
                ],
                store: new Ext.data.Store({
                    model: 'Ovlu.model.Event',
                    data: []
                })
            }]
        });

        calendar.on('selectionchange', function(calendarview, newDate, prevDate){
            //console.log('selectionchange');
            var eventList = calendarPanel.getDockedItems()[0];

            calendar.eventStore.clearFilter();
            calendar.eventStore.filterBy(function(record){
                var startDate = Ext.Date.clearTime(record.get('start'), true).getTime(), 
                    endDate = Ext.Date.clearTime(record.get('end'), true).getTime();

                return (startDate <= newDate) && (endDate >= newDate);
            }, this);

            eventList.getStore().setData(calendar.eventStore.getRange());
        });
        
        calendar.on('periodchange', function(calendarview, minDate, maxDate, direction) {
            me.getEvents(minDate, maxDate);
        });
        
        me.getEvents();

        this.getEventsView().add(calendarPanel);       
    },
    getEvents: function(startDate, endDate) {
        var me = this;
        var sessionStore = Ext.getStore('SessionStore');
        sessionStore.load();
        var sessionModel = sessionStore.getAt(0).data;
        
        var requestUrl = //'http://localhost:8080/rest/event/geteventslist'
                'http://ovlu-stg.elasticbeanstalk.com/rest/event/geteventslist'

        var msgHeader = {
                "Content-Type": "application/json",
                "Accept": "application/json",
                "access_token": sessionModel.access_token
        };
        
        var toDay = new Date();
        
        if(!startDate) {
            startDate = new Date(toDay.getFullYear(), toDay.getMonth(), 1);
        }
        if(!endDate) {
            endDate = new Date(toDay.getFullYear(), toDay.getMonth() + 1, 0);
        }
        var day = startDate.getDate(),
            month = startDate.getMonth(),
            year = startDate.getFullYear();

        Ext.Ajax.request({
            url: requestUrl,
            withCredentials: false,
            useDefaultXhrHeader: false,
            method: 'get',
            headers: msgHeader,
            params: {
                'event_start': (month + 1) + '/' + day + '/' + year + ' 00:00',
                'event_end': (endDate.getMonth() +1) + '/' + endDate.getDate() + '/' + endDate.getFullYear() + ' 11:59'
            },
            
            success : function(response){
                var eventStore = Ext.getStore('EventStore');
                // clear old data
                if(eventStore.data) {
                    eventStore.data.clear();
                }
                var responseJson = Ext.JSON.decode(response.responseText);

                var eventsArr = responseJson.events;
                for(var i = 0; i < eventsArr.length; i++) {
                    var event = eventsArr[i];
                    var nevent = Ext.create('Ovlu.model.Event', {
                        'event_attendee' : event.event_attendee,
                        'event_description' : event.event_description,
                        'event_end' : event.event_end,
                        'event_id' : event.event_id,
                        'event_location' : event.event_location,
                        'event_start' : event.event_start,
                        'event_status' : event.event_status,
                        'event_title' : event.event_title,
                        'event_type' : event.event_type,
                        'from_id' : event.from_id,
                        'is_repeat' : event.is_repeat,
                        'offer_id' : event.offer_id,
                        'remind' : event.remind,
                        'repeat_parent_id' : event.repeat_parent_id,
                        'repeat_pattern' : event.repeat_pattern,
                        'repeat_times' : event.repeat_times,
                        'transaction_id' : event.transaction_id,
                        // needed for date to work
                        'event': event.event_description,
                        'title': event.event_title,
                        'start': new Date(Date.parse(event.event_start)),
                        'end':  new Date(Date.parse(event.event_end))                        
                    });
                    eventStore.add(nevent);
                }
                
                var evtCalendar = Ext.getCmp('evtCalendar');
                if(evtCalendar) {
                    evtCalendar.refresh();
                }
                //console.log(eventStore);                
            }                        
        });
        Ext.Viewport.setMasked(false);        
    },
    editEvent: function(dataview, index, target, record, e, eOpts) {
        if(record) {
            var evtDet = '';
            if(!this.getEventDetail()) {
                evtDet = Ext.create('Ovlu.view.EventDetail');
            } else {
                evtDet = this.getEventDetail();
            }
            //var evtDet = Ext.create('Ovlu.view.EventDetail');
            //var evtSec = evtDet.child('#evtDetId');
            evtDet.child('#evtDetId').setData(record.data);
            evtDet.show();
        }
        
    },
    createEvent: function() {
        var nevent = Ext.create('Ovlu.model.Event', {
            'event_attendee' : '',
            'event_description' : '',
            'event_end' : '',
            'event_id' : '',
            'event_location' : '',
            'event_start' : '',
            'event_status' : '',
            'event_title' : '',
            'event_type' : '',
            'from_id' : '',
            'is_repeat' : '',
            'offer_id' : '',
            'remind' : '',
            'repeat_parent_id' : '',
            'repeat_pattern' : '',
            'repeat_times' : '',
            'transaction_id' : '',                       
        });
        var evtDet = '';
        if(!this.getEventDetail()) {
            evtDet = Ext.create('Ovlu.view.EventDetail');
        } else {
            evtDet = this.getEventDetail();
        }

        evtDet.child('#evtDetId').setData(nevent);
        evtDet.show();
    },
    saveEvent: function() {
        var me = this;
        var sessionStore = Ext.getStore('SessionStore');
        sessionStore.load();
        var sessionModel = sessionStore.getAt(0).data;

        var msgHeader = {
                "Content-Type": "application/json",
                "Accept": "application/json",
                "access_token": sessionModel.access_token
        };
        var requestUrl = //'http://localhost:8080/rest/event/geteventslist'
                'http://ovlu-stg.elasticbeanstalk.com/rest/event/createevent';
        
        
        var evtDet = this.getEventDetail();
        
        var evtData = this.getEvtDetSec().getData();
        var evtId = evtData.event_id;
        var method = 'post';
        if(evtId && evtId !== '') {
            requestUrl = 'http://ovlu-stg.elasticbeanstalk.com/rest/event/updateevent';
            method = 'put';
        } else {
            evtId = '';
        }

        Ext.Ajax.request({
            url: requestUrl,
            withCredentials: false,
            useDefaultXhrHeader: false,
            method: method,
            headers: msgHeader,
            jsonData: {
                'event_attendee' : '0',
                'event_description' : Ext.get('evtdet_desc').getValue(),
                'event_end' : Ext.get('evtdet_ed_date').getValue(),
                'event_id' : evtId,
                'event_location' : Ext.get('evtdet_loc').getValue(),
                'event_start' : Ext.get('evtdet_st_date').getValue(),
                'event_status' : '',
                'event_title' : Ext.get('evtdet_title').getValue(),
                'event_type' : '',
                'from_id' : '',
                'is_repeat' : '',
                'offer_id' : '',
                'remind' : '',
                'repeat_parent_id' : '',
                'repeat_pattern' : '',
                'repeat_times' : '',
                'transaction_id' : '',  
            },
            
            success : function(response){
                console.log(response);
            },
            failure: function(response){
                console.log(response);
            },
        });
        
        evtDet.hide();
    }
});

