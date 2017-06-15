SELECT 
                dr.resource_name
                ,'9:00AM - 7:00 PM ' as period
                ,count(ms.id) as total_sessions
                , min(ms.dtm_created) as first_monitor_start_time
                , max(ms.dtm_created) as last_monitor_start_time
                , min(extract(epoch from (ms.dtm_sql_end - ms.dtm_sql_start ) ) ) as min_duration_sec
                , max(extract(epoch from (ms.dtm_sql_end - ms.dtm_sql_start ) ) ) as max_duration_sec
                , avg(extract(epoch from (ms.dtm_sql_end - ms.dtm_sql_start ) ) ) as avg_duration_sec
                
FROM amperfmgr.canary_monitor_session ms 
                INNER JOIN amperfmgr.dic_canary_monitor m ON ms.monitor_id = m.id 
                INNER JOIN amperfmgr.dic_resource dr ON m.resource_id = dr.id
WHERE 
	dr.resource_name = :rname
	 AND ms.dtm_created >= date_trunc('day',current_timestamp::timestamp with time zone at time zone 'America/New_York') - interval '1 day'
	-- AND ms.dtm_created >= date_trunc('day',current_timestamp::timestamp with time zone at time zone 'America/New_York')
	AND ms.dtm_created < date_trunc('day',current_timestamp::timestamp with time zone at time zone 'America/New_York') + interval '1 day'
GROUP BY dr.resource_name ,period
;




SELECT 
                dr.resource_name
                ,ms.id as session_id
                , ms.monitor_id
                , ms.dtm_created
                , ms.dtm_sql_start
                , ms.dtm_sql_end
                , ms.alert_sent_time
                , extract(epoch from (ms.dtm_sql_end - ms.dtm_sql_start ) ) as duration_sec
FROM amperfmgr.canary_monitor_session ms 
                INNER JOIN amperfmgr.dic_canary_monitor m ON ms.monitor_id = m.id 
                INNER JOIN amperfmgr.dic_resource dr ON m.resource_id = dr.id
WHERE 
	dr.resource_name = :rname
	AND ms.dtm_created >= date_trunc('day',current_timestamp::timestamp with time zone at time zone 'America/New_York') - interval '1 day'
	AND ms.dtm_created < date_trunc('day',current_timestamp::timestamp with time zone at time zone 'America/New_York') + interval '1 day'
ORDER BY ms.id
;


