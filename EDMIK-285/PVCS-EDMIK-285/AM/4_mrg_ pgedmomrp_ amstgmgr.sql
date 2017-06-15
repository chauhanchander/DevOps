SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = amstgmgr, pg_catalog;

CREATE OR REPLACE FUNCTION p_stage_rsh_cloudwatch_datapoints_insert_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF ( NEW.request_id >= 1 AND NEW.request_id < 1180000 ) THEN
        INSERT INTO amstgmgr.stage_rsh_cloudwatch_datapoints_1_1180k VALUES (NEW.*);
        
    ELSIF ( NEW.request_id >= 1180000 AND NEW.request_id < 1190000  ) THEN
        INSERT INTO amstgmgr.stage_rsh_cloudwatch_datapoints_1180k_1190k VALUES (NEW.*);       
    ELSIF ( NEW.request_id >= 1190000 AND NEW.request_id < 1200000  ) THEN
        INSERT INTO amstgmgr.stage_rsh_cloudwatch_datapoints_1190k_1200k VALUES (NEW.*); 
    ELSIF ( NEW.request_id >= 1200000 AND NEW.request_id < 1300000  ) THEN
        INSERT INTO amstgmgr.stage_rsh_cloudwatch_datapoints_1200k_1300k VALUES (NEW.*);   
     ELSIF ( NEW.request_id >= 1300000 AND NEW.request_id < 1400000  ) THEN
        INSERT INTO amstgmgr.stage_rsh_cloudwatch_datapoints_1300k_1400k VALUES (NEW.*);    
     ELSIF ( NEW.request_id >= 1400000 AND NEW.request_id < 1500000  ) THEN
        INSERT INTO amstgmgr.stage_rsh_cloudwatch_datapoints_1400k_1500k VALUES (NEW.*);        
    ELSE
        RAISE EXCEPTION 'request_id  out of range.  Fix the p_stage_rsh_cloudwatch_datapoints_insert_trigger() function!';
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION amstgmgr.p_stage_rsh_cloudwatch_datapoints_insert_trigger() OWNER TO pgadmin;


CREATE OR REPLACE FUNCTION p_stage_rsh_stl_query_insert_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   IF ( NEW.starttime >= TIMESTAMP '2015-01-01 00:00:00' AND NEW.starttime < TIMESTAMP '2015-02-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.stl_query_2015_01 VALUES (NEW.*);
        
    ELSIF ( NEW.starttime >= TIMESTAMP '2015-02-01 00:00:00' AND NEW.starttime < TIMESTAMP '2015-03-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.stl_query_2015_02 VALUES (NEW.*);
        
    ELSIF ( NEW.starttime >= TIMESTAMP '2015-03-01 00:00:00' AND NEW.starttime < TIMESTAMP '2015-04-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.stl_query_2015_03 VALUES (NEW.*);

    ELSIF ( NEW.starttime >= TIMESTAMP '2015-04-01 00:00:00' AND NEW.starttime < TIMESTAMP '2015-05-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.stl_query_2015_04 VALUES (NEW.*);
        
    ELSIF ( NEW.starttime >= TIMESTAMP '2015-05-01 00:00:00' AND NEW.starttime < TIMESTAMP '2015-06-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.stl_query_2015_05 VALUES (NEW.*);        
        
    ELSIF ( NEW.starttime >= TIMESTAMP '2015-06-01 00:00:00' AND NEW.starttime < TIMESTAMP '2015-07-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.stl_query_2015_06 VALUES (NEW.*);       

    ELSIF ( NEW.starttime >= TIMESTAMP '2015-07-01 00:00:00' AND NEW.starttime < TIMESTAMP '2015-08-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.stl_query_2015_07 VALUES (NEW.*);    

    ELSIF ( NEW.starttime >= TIMESTAMP '2015-08-01 00:00:00' AND NEW.starttime < TIMESTAMP '2015-09-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.stl_query_2015_08 VALUES (NEW.*);    

    ELSIF ( NEW.starttime >= TIMESTAMP '2015-09-01 00:00:00' AND NEW.starttime < TIMESTAMP '2015-10-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.stl_query_2015_09 VALUES (NEW.*);    

    ELSIF ( NEW.starttime >= TIMESTAMP '2015-10-01 00:00:00' AND NEW.starttime < TIMESTAMP '2015-11-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.stl_query_2015_10 VALUES (NEW.*);    

    ELSIF ( NEW.starttime >= TIMESTAMP '2015-11-01 00:00:00' AND NEW.starttime < TIMESTAMP '2015-12-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.stl_query_2015_11 VALUES (NEW.*);    

    ELSIF ( NEW.starttime >= TIMESTAMP '2015-12-01 00:00:00' AND NEW.starttime < TIMESTAMP '2016-01-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.stl_query_2015_12 VALUES (NEW.*);    
        
    ELSIF ( NEW.starttime >= TIMESTAMP '2016-01-01 00:00:00' AND NEW.starttime < TIMESTAMP '2016-02-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.stl_query_2016_01 VALUES (NEW.*);           

    ELSIF ( NEW.starttime >= TIMESTAMP '2016-02-01 00:00:00' AND NEW.starttime < TIMESTAMP '2016-03-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.stl_query_2016_02 VALUES (NEW.*);       
        
    ELSIF ( NEW.starttime >= TIMESTAMP '2016-03-01 00:00:00' AND NEW.starttime < TIMESTAMP '2016-04-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.stl_query_2016_03 VALUES (NEW.*);                 

    ELSIF ( NEW.starttime >= TIMESTAMP '2016-04-01 00:00:00' AND NEW.starttime < TIMESTAMP '2016-05-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.stl_query_2016_04 VALUES (NEW.*);      

    ELSIF ( NEW.starttime >= TIMESTAMP '2016-05-01 00:00:00' AND NEW.starttime < TIMESTAMP '2016-06-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.stl_query_2016_05 VALUES (NEW.*);      

    ELSIF ( NEW.starttime >= TIMESTAMP '2016-06-01 00:00:00' AND NEW.starttime < TIMESTAMP '2016-07-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.stl_query_2016_06 VALUES (NEW.*);        

    ELSIF ( NEW.starttime >= TIMESTAMP '2016-07-01 00:00:00' AND NEW.starttime < TIMESTAMP '2016-08-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.stl_query_2016_07 VALUES (NEW.*);   

    ELSIF ( NEW.starttime >= TIMESTAMP '2016-08-01 00:00:00' AND NEW.starttime < TIMESTAMP '2016-09-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.stl_query_2016_08 VALUES (NEW.*);   

    ELSIF ( NEW.starttime >= TIMESTAMP '2016-09-01 00:00:00' AND NEW.starttime < TIMESTAMP '2016-10-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.stl_query_2016_09 VALUES (NEW.*);  

    ELSIF ( NEW.starttime >= TIMESTAMP '2016-10-01 00:00:00' AND NEW.starttime < TIMESTAMP '2016-11-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.stl_query_2016_10 VALUES (NEW.*);   

    ELSIF ( NEW.starttime >= TIMESTAMP '2016-11-01 00:00:00' AND NEW.starttime < TIMESTAMP '2016-11-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.stl_query_2016_11 VALUES (NEW.*);  

    ELSIF ( NEW.starttime >= TIMESTAMP '2016-12-01 00:00:00' AND NEW.starttime < TIMESTAMP '2017-01-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.stl_query_2016_12 VALUES (NEW.*);                                                             
    ELSE
        RAISE EXCEPTION 'Date out of range.  Fix the p_stage_rsh_stl_query_insert_trigger() function!';
    END IF;
    RETURN NULL;

END;
$$;


ALTER FUNCTION amstgmgr.p_stage_rsh_stl_query_insert_trigger() OWNER TO pgadmin;




CREATE OR REPLACE FUNCTION p_stage_rsh_stl_wlm_query_insert_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   IF ( NEW.service_class_start_time >= TIMESTAMP '2016-01-01 00:00:00' AND NEW.service_class_start_time < TIMESTAMP '2016-02-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.STL_WLM_QUERY_2016_01 VALUES (NEW.*);
                
    ELSIF ( NEW.service_class_start_time >= TIMESTAMP '2016-02-01 00:00:00' AND NEW.service_class_start_time < TIMESTAMP '2016-03-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.STL_WLM_QUERY_2016_02 VALUES (NEW.*);       
        
    ELSIF ( NEW.service_class_start_time >= TIMESTAMP '2016-03-01 00:00:00' AND NEW.service_class_start_time < TIMESTAMP '2016-04-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.STL_WLM_QUERY_2016_03 VALUES (NEW.*);                 
    ELSIF ( NEW.service_class_start_time >= TIMESTAMP '2016-04-01 00:00:00' AND NEW.service_class_start_time < TIMESTAMP '2016-05-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.STL_WLM_QUERY_2016_04 VALUES (NEW.*);    
    ELSIF ( NEW.service_class_start_time >= TIMESTAMP '2016-05-01 00:00:00' AND NEW.service_class_start_time < TIMESTAMP '2016-06-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.STL_WLM_QUERY_2016_05 VALUES (NEW.*);    
    ELSIF ( NEW.service_class_start_time >= TIMESTAMP '2016-06-01 00:00:00' AND NEW.service_class_start_time < TIMESTAMP '2016-07-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.STL_WLM_QUERY_2016_06 VALUES (NEW.*); 
    ELSIF ( NEW.service_class_start_time >= TIMESTAMP '2016-07-01 00:00:00' AND NEW.service_class_start_time < TIMESTAMP '2016-08-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.STL_WLM_QUERY_2016_07 VALUES (NEW.*); 
    ELSIF ( NEW.service_class_start_time >= TIMESTAMP '2016-08-01 00:00:00' AND NEW.service_class_start_time < TIMESTAMP '2016-09-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.STL_WLM_QUERY_2016_08 VALUES (NEW.*); 
    ELSIF ( NEW.service_class_start_time >= TIMESTAMP '2016-09-01 00:00:00' AND NEW.service_class_start_time < TIMESTAMP '2016-10-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.STL_WLM_QUERY_2016_09 VALUES (NEW.*); 
    ELSIF ( NEW.service_class_start_time >= TIMESTAMP '2016-10-01 00:00:00' AND NEW.service_class_start_time < TIMESTAMP '2016-11-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.STL_WLM_QUERY_2016_10 VALUES (NEW.*);
    ELSIF ( NEW.service_class_start_time >= TIMESTAMP '2016-11-01 00:00:00' AND NEW.service_class_start_time < TIMESTAMP '2016-12-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.STL_WLM_QUERY_2016_11 VALUES (NEW.*);  
     ELSIF ( NEW.service_class_start_time >= TIMESTAMP '2016-12-01 00:00:00' AND NEW.service_class_start_time < TIMESTAMP '2017-01-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.STL_WLM_QUERY_2016_12 VALUES (NEW.*);      
     ELSE
        RAISE EXCEPTION 'Date out of range.  Fix the p_stage_rsh_stl_query_insert_trigger() function!';
    END IF;
    RETURN NULL;

END;
$$;


ALTER FUNCTION amstgmgr.p_stage_rsh_stl_wlm_query_insert_trigger() OWNER TO pgadmin;



CREATE OR REPLACE FUNCTION p_stage_rsh_svl_query_summary_insert_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   IF ( NEW.datetimestamp >= TIMESTAMP '2016-02-01 00:00:00' AND NEW.datetimestamp < TIMESTAMP '2016-03-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.svl_query_summary_2016_02 VALUES (NEW.*);
        
        
    ELSIF ( NEW.datetimestamp >= TIMESTAMP '2016-03-01 00:00:00' AND NEW.datetimestamp < TIMESTAMP '2016-04-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.svl_query_summary_2016_03 VALUES (NEW.*);                 

    ELSIF ( NEW.datetimestamp >= TIMESTAMP '2016-04-01 00:00:00' AND NEW.datetimestamp < TIMESTAMP '2016-05-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.svl_query_summary_2016_04 VALUES (NEW.*);      

    ELSIF ( NEW.datetimestamp >= TIMESTAMP '2016-05-01 00:00:00' AND NEW.datetimestamp < TIMESTAMP '2016-06-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.svl_query_summary_2016_05 VALUES (NEW.*);      
        
    ELSIF ( NEW.datetimestamp >= TIMESTAMP '2016-06-01 00:00:00' AND NEW.datetimestamp < TIMESTAMP '2016-07-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.svl_query_summary_2016_06 VALUES (NEW.*);  
               
    ELSIF ( NEW.datetimestamp >= TIMESTAMP '2016-07-01 00:00:00' AND NEW.datetimestamp < TIMESTAMP '2016-08-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.svl_query_summary_2016_07 VALUES (NEW.*);         

    ELSIF ( NEW.datetimestamp >= TIMESTAMP '2016-08-01 00:00:00' AND NEW.datetimestamp < TIMESTAMP '2016-09-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.svl_query_summary_2016_08 VALUES (NEW.*);     

    ELSIF ( NEW.datetimestamp >= TIMESTAMP '2016-09-01 00:00:00' AND NEW.datetimestamp < TIMESTAMP '2016-10-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.svl_query_summary_2016_09 VALUES (NEW.*);   

    ELSIF ( NEW.datetimestamp >= TIMESTAMP '2016-10-01 00:00:00' AND NEW.datetimestamp < TIMESTAMP '2016-11-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.svl_query_summary_2016_10 VALUES (NEW.*);      

    ELSIF ( NEW.datetimestamp >= TIMESTAMP '2016-11-01 00:00:00' AND NEW.datetimestamp < TIMESTAMP '2016-12-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.svl_query_summary_2016_11 VALUES (NEW.*);           

    ELSIF ( NEW.datetimestamp >= TIMESTAMP '2016-12-01 00:00:00' AND NEW.datetimestamp < TIMESTAMP '2017-01-01 00:00:00' ) THEN
        INSERT INTO amstgmgr.svl_query_summary_2016_12 VALUES (NEW.*);           
                       
    ELSE
        RAISE EXCEPTION 'Date out of range.  Fix the p_stage_rsh_stl_query_insert_trigger() function!';
    END IF;
    RETURN NULL;

END;
$$;


ALTER FUNCTION amstgmgr.p_stage_rsh_svl_query_summary_insert_trigger() OWNER TO pgadmin;



CREATE OR REPLACE FUNCTION populate_query_related_tables(request_id integer, set_resource_id integer, truncate integer, link_host text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE sql text;
	result text;
	MaxQuery integer;

BEGIN
	SET search_path TO stage, public;
	PERFORM dblink_connect('myconn', link_host);


	IF truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.STL_QUERY';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_STL_QUERY_ID RESTART WITH 1;
		sql = '';
	END IF;
	

	SELECT COALESCE(MAX(query), 0) INTO MaxQuery FROM amstgmgr.STL_QUERY WHERE resource_id = set_resource_id ;

	INSERT INTO amstgmgr.STL_QUERY (request_id, resource_id, userid, query,  pid, database, querytxt, starttime, endtime, aborted)
	SELECT request_id, set_resource_id::smallint, userid, query,  pid, database, cast (substring(querytxt from 1 for 2000) as character varying(2000) ), starttime, endtime, aborted::smallint
	FROM dblink('myconn', 'SELECT userid, query,  pid, database, querytxt, starttime, endtime, aborted FROM STL_QUERY WHERE query >' || MaxQuery || ';')
	AS res_table (userid integer, query integer,  pid integer, database character(32), querytxt character(4000), starttime timestamp, endtime timestamp, aborted smallint);
	
	MaxQuery = 0;

	IF truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.STL_QUERYTEXT';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_STL_QUERYTEXT_ID RESTART WITH 1;
		sql = '';
	END IF;

	SELECT COALESCE(MAX(query), 0) INTO MaxQuery FROM amstgmgr.STL_QUERYTEXT WHERE resource_id = set_resource_id ;

	INSERT INTO amstgmgr.STL_QUERYTEXT (request_id, resource_id, userid, query, xid, pid, sequence, text)
	SELECT request_id, set_resource_id, userid, query, xid, pid, sequence, text
	FROM dblink('myconn', 'SELECT userid, query, xid, pid, sequence, text FROM STL_QUERYTEXT WHERE query >' || MaxQuery || ';')
	AS res_table (userid integer, query integer, xid bigint, pid integer, sequence integer, text character(200));

	MaxQuery = 0;




	-- rsamp1 only 
	IF set_resource_id in  (7,39 )
	THEN

		IF truncate = 1
		THEN
			sql = 'TRUNCATE TABLE amstgmgr.SVL_QUERY_SUMMARY';
			EXECUTE sql;
			ALTER SEQUENCE amstgmgr.SEQ_SVL_QUERY_SUMMARY_ID RESTART WITH 1;
			sql = '';
		END IF;	
	
		SELECT COALESCE(MAX(query), 0) INTO MaxQuery FROM amstgmgr.SVL_QUERY_SUMMARY WHERE resource_id = set_resource_id ;

		INSERT INTO amstgmgr.SVL_QUERY_SUMMARY (request_id, resource_id, userid, query, stm, seg, step, maxtime, avgtime, rows, bytes, rate_row, rate_byte, label, is_diskbased, workmem, is_rrscan, is_delayed_scan, rows_pre_filter)
		SELECT request_id, set_resource_id::smallint, userid, query, stm, seg, step, maxtime, avgtime, rows, bytes, rate_row, rate_byte, label, is_diskbased, workmem, is_rrscan, is_delayed_scan, rows_pre_filter
		FROM dblink('myconn', 'SELECT userid, query, stm, seg, step, maxtime, avgtime, rows, bytes, rate_row, rate_byte, label, is_diskbased, workmem, is_rrscan, is_delayed_scan, rows_pre_filter FROM SVL_QUERY_SUMMARY WHERE query >' || MaxQuery || ';')
		AS res_table (userid integer, query integer, stm integer, seg integer, step integer, maxtime bigint, avgtime bigint, rows bigint, bytes bigint, rate_row double precision, rate_byte double precision, label text, is_diskbased character(1), workmem bigint, is_rrscan character(1), is_delayed_scan character(1), rows_pre_filter bigint);

		MaxQuery = 0;


		IF truncate = 1
		THEN
			sql = 'TRUNCATE TABLE amstgmgr.stl_wlm_query';
			EXECUTE sql;
			ALTER SEQUENCE amstgmgr.seq_STL_WLM_QUERY RESTART WITH 1;
			sql = '';
		END IF;

		SELECT COALESCE(MAX(query), 0) INTO MaxQuery FROM amstgmgr.stl_wlm_query WHERE resource_id = set_resource_id ;

		INSERT INTO amstgmgr.stl_wlm_query (request_id, resource_id, userid , xid ,task ,query ,service_class ,slot_count ,service_class_start_time,queue_start_time ,queue_end_time ,total_queue_time ,exec_start_time ,exec_end_time,total_exec_time ,service_class_end_time ,final_state)
		SELECT request_id, set_resource_id::smallint ,userid , xid ,task ,query ,service_class ,slot_count ,service_class_start_time,queue_start_time ,queue_end_time ,total_queue_time ,exec_start_time ,exec_end_time,total_exec_time ,service_class_end_time ,final_state
		FROM dblink('myconn', 'SELECT userid ,xid ,task , query ,service_class ,slot_count ,service_class_start_time,queue_start_time ,queue_end_time ,total_queue_time ,exec_start_time ,exec_end_time,total_exec_time ,service_class_end_time ,final_state  FROM stl_wlm_query ;')
		AS res_table (userid integer,xid integer,task integer,query integer,service_class integer,slot_count integer,service_class_start_time timestamp without time zone,queue_start_time timestamp without time zone,queue_end_time timestamp without time zone,total_queue_time bigint,exec_start_time timestamp without time zone,exec_end_time timestamp without time zone,total_exec_time bigint,service_class_end_time timestamp without time zone,final_state character varying(16)
		) ;
	END IF;
	MaxQuery = 0;
/*
	IF truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.SVL_QUERY_REPORT';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_SVL_QUERY_REPORT_ID RESTART WITH 1;
		sql = '';
	END IF;

	SELECT COALESCE(MAX(query), 0) INTO MaxQuery FROM amstgmgr.SVL_QUERY_REPORT;

	INSERT INTO amstgmgr.SVL_QUERY_REPORT (request_id, resource_id, userid, query, slice, segment, step, start_time, end_time, elapsed_time, rows, bytes, label, is_diskbased, workmem, is_rrscan, is_delayed_scan, rows_pre_filter)
	SELECT request_id, resource_id, userid, query, slice, segment, step, start_time, end_time, elapsed_time, rows, bytes, label, is_diskbased, workmem, is_rrscan, is_delayed_scan, rows_pre_filter
	FROM dblink('myconn', 'SELECT userid, query, slice, segment, step, start_time, end_time, elapsed_time, rows, bytes, label, is_diskbased, workmem, is_rrscan, is_delayed_scan, rows_pre_filter FROM SVL_QUERY_REPORT WHERE query >' || MaxQuery || ';')
	AS res_table (userid integer, query integer, slice integer, segment integer, step integer, start_time timestamp without time zone, end_time timestamp without time zone, elapsed_time bigint, rows bigint, bytes bigint, label char(256), is_diskbased character(1), workmem bigint, is_rrscan character(1), is_delayed_scan character(1), rows_pre_filter bigint);

	MaxQuery = 0;

	IF truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.STL_DIST';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_STL_DIST_ID RESTART WITH 1;
		sql = '';
	END IF;
	
	SELECT COALESCE(MAX(query), 0) INTO MaxQuery FROM amstgmgr.STL_DIST;

	INSERT INTO amstgmgr.STL_DIST (request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows, bytes, packets)
	SELECT request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows, bytes, packets
	FROM dblink('myconn', 'SELECT userid, query, slice, segment, step, starttime, endtime, tasknum, rows, bytes, packets FROM STL_DIST WHERE query >' || MaxQuery || ';')
	AS res_table (userid integer, query integer, slice integer, segment integer, step integer, starttime timestamp, endtime timestamp, tasknum integer, rows bigint, bytes bigint, packets integer);

	MaxQuery = 0;

	IF truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.STL_AGGR';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_STL_AGGR_ID RESTART WITH 1;
		sql = '';
	END IF;

	INSERT INTO amstgmgr.STL_AGGR (request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows, bytes, slots, occupied, maxlength, tbl, is_diskbased, workmem, type)
	SELECT request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows, bytes, slots, occupied, maxlength, tbl, is_diskbased, workmem, type
	FROM dblink('myconn', 'SELECT userid, query, slice, segment, step, starttime, endtime, tasknum, rows, bytes, slots, occupied, maxlength, tbl, is_diskbased, workmem, type FROM STL_AGGR WHERE query >' || MaxQuery || ';')
	AS res_table (userid integer, query integer, slice integer, segment integer, step integer, starttime timestamp, endtime timestamp, tasknum integer, rows bigint, bytes bigint, slots integer, occupied integer, maxlength integer, tbl integer, is_diskbased character(1), workmem bigint, type character(6));

	MaxQuery = 0;

	IF truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.STL_DELETE';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_STL_DELETE_ID RESTART WITH 1;
		sql = '';
	END IF;

	SELECT COALESCE(MAX(query), 0) INTO MaxQuery FROM amstgmgr.STL_DELETE;

	INSERT INTO amstgmgr.STL_DELETE (request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows, tbl)
	SELECT request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows, tbl
	FROM dblink('myconn', 'SELECT userid, query, slice, segment, step, starttime, endtime, tasknum, rows, tbl FROM STL_DELETE WHERE query >' || MaxQuery || ';')
	AS res_table (userid integer, query integer, slice integer, segment integer, step integer, starttime timestamp, endtime timestamp, tasknum integer, rows bigint, tbl integer);

	MaxQuery = 0;

	IF truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.STL_HASH';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_STL_HASH_ID RESTART WITH 1;
		sql = '';
	END IF;

	SELECT COALESCE(MAX(query), 0) INTO MaxQuery FROM amstgmgr.STL_HASH;

	INSERT INTO amstgmgr.STL_HASH (request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows, bytes, slots, occupied, maxlength, tbl, is_diskbased, workmem, num_parts, est_rows, num_blocks_permitted, row_dist_variance)
	SELECT request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows, bytes, slots, occupied, maxlength, tbl, is_diskbased, workmem, num_parts, est_rows, num_blocks_permitted, row_dist_variance
	FROM dblink('myconn', 'SELECT userid, query, slice, segment, step, starttime, endtime, tasknum, rows, bytes, slots, occupied, maxlength, tbl, is_diskbased, workmem, num_parts, est_rows, num_blocks_permitted, row_dist_variance FROM STL_HASH')
	AS res_table (userid integer, query integer, slice integer, segment integer, step integer, starttime timestamp, endtime timestamp, tasknum integer, rows bigint, bytes bigint, slots integer, occupied integer, maxlength integer, tbl integer, is_diskbased character(1), workmem bigint, num_parts integer, est_rows bigint, num_blocks_permitted integer, row_dist_variance integer);

	MaxQuery = 0;

	IF truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.STL_INSERT';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_STL_INSERT_ID RESTART WITH 1;
		sql = '';
	END IF;

	SELECT COALESCE(MAX(query), 0) INTO MaxQuery FROM amstgmgr.STL_INSERT;

	INSERT INTO amstgmgr.STL_INSERT (request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows, tbl)
	SELECT request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows, tbl
	FROM dblink('myconn', 'SELECT userid, query, slice, segment, step, starttime, endtime, tasknum, rows, tbl FROM STL_INSERT WHERE query >' || MaxQuery || ';')
	AS res_table (userid integer, query integer, slice integer, segment integer, step integer, starttime timestamp, endtime timestamp, tasknum integer, rows bigint, tbl integer);

	MaxQuery = 0;

	IF truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.STL_MERGE';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_STL_MERGE_ID RESTART WITH 1;
		sql = '';
	END IF;

	SELECT COALESCE(MAX(query), 0) INTO MaxQuery FROM amstgmgr.STL_MERGE;

	INSERT INTO amstgmgr.STL_MERGE (request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows)
	SELECT request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows
	FROM dblink('myconn', 'SELECT userid, query, slice, segment, step, starttime, endtime, tasknum, rows FROM STL_MERGE WHERE query >' || MaxQuery || ';')
	AS res_table (userid integer, query integer, slice integer, segment integer, step integer, starttime timestamp, endtime timestamp, tasknum integer, rows bigint);

	MaxQuery = 0;

	IF truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.STL_MERGEJOIN';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_STL_MERGEJOIN_ID RESTART WITH 1;
		sql = '';
	END IF;

	SELECT COALESCE(MAX(query), 0) INTO MaxQuery FROM amstgmgr.STL_MERGEJOIN;

	INSERT INTO amstgmgr.STL_MERGEJOIN (request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows, tbl)
	SELECT request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows, tbl
	FROM dblink('myconn', 'SELECT userid, query, slice, segment, step, starttime, endtime, tasknum, rows, tbl FROM STL_MERGEJOIN WHERE query >' || MaxQuery || ';')
	AS res_table (userid integer, query integer, slice integer, segment integer, step integer, starttime timestamp, endtime timestamp, tasknum integer, rows bigint, tbl integer);

	MaxQuery = 0;

	IF truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.STL_HASHJOIN';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_STL_HASHJOIN_ID RESTART WITH 1;
		sql = '';
	END IF;

	SELECT COALESCE(MAX(query), 0) INTO MaxQuery FROM amstgmgr.STL_HASHJOIN;

	INSERT INTO amstgmgr.STL_HASHJOIN (request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows, tbl, num_parts, join_type, hash_looped, switched_parts)
	SELECT request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows, tbl, num_parts, join_type, hash_looped, switched_parts
	FROM dblink('myconn', 'SELECT userid, query, slice, segment, step, starttime, endtime, tasknum, rows, tbl, num_parts, join_type, hash_looped, switched_parts FROM STL_HASHJOIN WHERE query >' || MaxQuery || ';')
	AS res_table (userid integer, query integer, slice integer, segment integer, step integer, starttime timestamp, endtime timestamp, tasknum integer, rows bigint, tbl integer, num_parts integer, join_type integer, hash_looped character(1), switched_parts character(1));

	MaxQuery = 0;

	IF truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.STL_NESTLOOP';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_STL_NESTLOOP_ID RESTART WITH 1;
		sql = '';
	END IF;

	SELECT COALESCE(MAX(query), 0) INTO MaxQuery FROM amstgmgr.STL_NESTLOOP;

	INSERT INTO amstgmgr.STL_NESTLOOP (request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows, tbl)
	SELECT request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows, tbl
	FROM dblink('myconn', 'SELECT userid, query, slice, segment, step, starttime, endtime, tasknum, rows, tbl FROM STL_NESTLOOP WHERE query >' || MaxQuery || ';')
	AS res_table (userid integer, query integer, slice integer, segment integer, step integer, starttime timestamp, endtime timestamp, tasknum integer, rows bigint, tbl integer);

	MaxQuery = 0;

	IF truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.STL_SORT';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_STL_SORT_ID RESTART WITH 1;
		sql = '';
	END IF;

	SELECT COALESCE(MAX(query), 0) INTO MaxQuery FROM amstgmgr.STL_SORT;

	INSERT INTO amstgmgr.STL_SORT (request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows, bytes, tbl, is_diskbased, workmem)
	SELECT request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows, bytes, tbl, is_diskbased, workmem
	FROM dblink('myconn', 'SELECT userid, query, slice, segment, step, starttime, endtime, tasknum, rows, bytes, tbl, is_diskbased, workmem FROM STL_SORT WHERE query >' || MaxQuery || ';')
	AS res_table (userid integer, query integer, slice integer, segment integer, step integer, starttime timestamp, endtime timestamp, tasknum integer, rows bigint, bytes bigint, tbl integer, is_diskbased character(1), workmem bigint);

	MaxQuery = 0;

	IF truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.STL_UNIQUE';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_STL_UNIQUE_ID RESTART WITH 1;
		sql = '';
	END IF;

	SELECT COALESCE(MAX(query), 0) INTO MaxQuery FROM amstgmgr.STL_UNIQUE;

	INSERT INTO amstgmgr.STL_UNIQUE (request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows, is_diskbased, slots, workmem, max_buffers_used, type)
	SELECT request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows, is_diskbased, slots, workmem, max_buffers_used, type
	FROM dblink('myconn', 'SELECT userid, query, slice, segment, step, starttime, endtime, tasknum, rows, is_diskbased, slots, workmem, max_buffers_used, type FROM STL_UNIQUE WHERE query >' || MaxQuery || ';')
	AS res_table (userid integer, query integer, slice integer, segment integer, step integer, starttime timestamp, endtime timestamp, tasknum integer, rows bigint, is_diskbased character(1), slots integer, workmem bigint, max_buffers_used bigint, type character(6));

	MaxQuery = 0;

	IF truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.STL_PARSE';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_STL_PARSE_ID RESTART WITH 1;
		sql = '';
	END IF;

	SELECT COALESCE(MAX(query), 0) INTO MaxQuery FROM amstgmgr.STL_PARSE;

	INSERT INTO amstgmgr.STL_PARSE (request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows)
	SELECT request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows
	FROM dblink('myconn', 'SELECT userid, query, slice, segment, step, starttime, endtime, tasknum, rows FROM STL_PARSE WHERE query >' || MaxQuery || ';')
	AS res_table (userid integer, query integer, slice integer, segment integer, step integer, starttime timestamp, endtime timestamp, tasknum integer, rows bigint);

	MaxQuery = 0;

	IF truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.STL_RETURN';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_STL_RETURN_ID RESTART WITH 1;
		sql = '';
	END IF;

	SELECT COALESCE(MAX(query), 0) INTO MaxQuery FROM amstgmgr.STL_RETURN;

	INSERT INTO amstgmgr.STL_RETURN (request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows, bytes, packets)
	SELECT request_id, resource_id, userid, query, slice, segment, step, starttime, endtime, tasknum, rows, bytes, packets
	FROM dblink('myconn', 'SELECT userid, query, slice, segment, step, starttime, endtime, tasknum, rows, bytes, packets FROM STL_RETURN WHERE query >' || MaxQuery || ';')
	AS res_table (userid integer, query integer, slice integer, segment integer, step integer, starttime timestamp, endtime timestamp, tasknum integer, rows bigint, bytes bigint, packets integer);
*/
	MaxQuery = 0;





	
-------------
	PERFORM dblink_disconnect('myconn');

	SELECT '('|| NOW() ||') Successful data lading from - https://' || link_host INTO result;
	RETURN result;
END
$$;


ALTER FUNCTION amstgmgr.populate_query_related_tables(request_id integer, set_resource_id integer, truncate integer, link_host text) OWNER TO pgadmin;



CREATE OR REPLACE FUNCTION populate_tables(v_request_id integer, v_resource_id integer, v_truncate integer, link_host text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE sql text;
	result text;
	MaxId integer;
	MaxTimeStamp timestamp;
BEGIN
		SET search_path TO stage, public;
	IF ('myconn' = ANY (dblink_get_connections())) 
		THEN PERFORM dblink_disconnect('myconn'); 
	END IF;
		PERFORM dblink_connect('myconn', link_host);

	IF v_truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.STV_PARTITIONS;';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_STV_PARTITIONS_ID RESTART WITH 1;
		sql = '';
	END IF;

	INSERT INTO amstgmgr.STV_PARTITIONS (request_id, resource_id, owner, host, diskno, part_begin, part_end, used, tossed, capacity, reads, writes, seek_forward, seek_back, is_san, failed, mbps)
	SELECT v_request_id, v_resource_id, res_table.owner, res_table.host, res_table.diskno, res_table.part_begin, res_table.part_end, res_table.used, res_table.tossed, res_table.capacity, res_table.reads, res_table.writes, res_table.seek_forward, res_table.seek_back, res_table.is_san, res_table.failed, res_table.mbps
	FROM dblink('myconn', 'SELECT owner, host, diskno, part_begin, part_end, used, tossed, capacity, reads, writes, seek_forward, seek_back, is_san, failed, mbps, mount FROM STV_PARTITIONS')
	AS res_table (owner integer, host integer, diskno integer, part_begin bigint, part_end bigint, used integer, tossed integer, capacity integer, reads bigint, writes bigint, seek_forward integer, seek_back integer, is_san integer, failed integer, mbps integer, mount character(256))
		LEFT JOIN amstgmgr.STV_PARTITIONS sp ON res_table.owner = sp.owner AND res_table.host = sp.host AND res_table.diskno = sp.diskno
	WHERE sp.owner IS NULL;

	IF v_truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.STV_SLICES';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_STV_SLICES_ID RESTART WITH 1;
		sql = '';
	END IF;

	INSERT INTO amstgmgr.STV_SLICES (request_id, resource_id, node, slice)
	SELECT v_request_id, v_resource_id, res_table.node, res_table.slice
	FROM dblink('myconn', 'SELECT node, slice FROM STV_SLICES')
	AS res_table (node integer, slice integer)
		LEFT JOIN amstgmgr.STV_SLICES ssls ON res_table.node = ssls.node AND res_table.slice = ssls.slice
	WHERE ssls.node IS NULL;

	IF v_truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.STV_TBL_PERM;';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_STV_TBL_PERM_ID RESTART WITH 1;
		sql = '';
	END IF;

	INSERT INTO amstgmgr.STV_TBL_PERM (request_id, resource_id, slice, Table_Id, name, rows, sorted_rows, temp, db_id)
	SELECT v_request_id, v_resource_id, slice, id, name, rows, sorted_rows, temp, db_id
	FROM dblink('myconn', 'SELECT slice, id, name, rows, sorted_rows, temp, db_id, insert_pristine, delete_pristine FROM STV_TBL_PERM')
	AS res_table (slice integer, id integer, name char(72), rows bigint, sorted_rows bigint, temp integer, db_id integer, insert_pristine integer, delete_pristine integer)
	WHERE 1 = 1;
/*
	IF v_truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.pg_attribute;';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_pg_attribute_ID RESTART WITH 1;
		sql = '';
	END IF;

	INSERT INTO amstgmgr.pg_attribute (request_id, resource_id, attrelid, attname, atttypid, attstattarget, attlen, attnum, attndims, attcacheoff, atttypmod, attbyval, attstorage, attalign, attnotnull, atthasdef, attisdropped, attislocal, attinhcount)
	SELECT v_request_id, v_resource_id, attrelid, attname, atttypid, attstattarget, attlen, attnum, attndims, attcacheoff, atttypmod, attbyval, attstorage, attalign, attnotnull, atthasdef, attisdropped, attislocal, attinhcount
	FROM dblink('myconn', 'SELECT attrelid, attname, atttypid, attstattarget, attlen, attnum, attndims, attcacheoff, atttypmod, attbyval, attstorage, attalign, attnotnull, atthasdef, attisdropped, attislocal, attinhcount FROM pg_attribute')
	AS res_table (attrelid oid, attname name, atttypid oid, attstattarget integer, attlen smallint, attnum smallint, attndims integer, attcacheoff integer, atttypmod integer, attbyval boolean, attstorage char, attalign char, attnotnull boolean, atthasdef boolean, attisdropped boolean, attislocal boolean, attinhcount integer)
	WHERE 1 = 1;

	IF v_truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.pg_class;';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_pg_class_ID RESTART WITH 1;
		sql = '';
	END IF;

	INSERT INTO amstgmgr.pg_class (request_id, resource_id, relnamespace, reltype, relowner, relam, relfilenode, reltablespace, relpages, reltuples, reltoastrelid, reltoastidxid, relhasindex, relisshared, relkind, relnatts, relchecks, reltriggers, relukeys, relfkeys, relrefs, relhasoids, relhaspkey, relhasrules, relhassubclass, relacl)
	SELECT v_request_id, v_resource_id, relnamespace, reltype, relowner, relam, relfilenode, reltablespace, relpages, reltuples, reltoastrelid, reltoastidxid, relhasindex, relisshared, relkind, relnatts, relchecks, reltriggers, relukeys, relfkeys, relrefs, relhasoids, relhaspkey, relhasrules, relhassubclass, relacl
	FROM dblink('myconn', 'SELECT relnamespace, reltype, relowner, relam, relfilenode, reltablespace, relpages, reltuples, reltoastrelid, reltoastidxid, relhasindex, relisshared, relkind, relnatts, relchecks, reltriggers, relukeys, relfkeys, relrefs, relhasoids, relhaspkey, relhasrules, relhassubclass, relacl FROM pg_class')
	AS res_table (relnamespace oid, reltype oid, relowner integer, relam oid, relfilenode oid, reltablespace oid, relpages integer, reltuples real, reltoastrelid oid, reltoastidxid oid, relhasindex boolean, relisshared boolean, relkind char, relnatts smallint, relchecks smallint, reltriggers smallint, relukeys smallint, relfkeys smallint, relrefs smallint, relhasoids boolean, relhaspkey boolean, relhasrules boolean, relhassubclass boolean, relacl aclitem[])
	WHERE 1 = 1;
*/
	IF v_truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.pg_user;';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_pg_user_ID RESTART WITH 1;
		sql = '';
	END IF;

	INSERT INTO amstgmgr.pg_user (request_id, resource_id, usename, usesysid, usecreatedb, usesuper, usecatupd, passwd, valuntil, useconfig)
	SELECT v_request_id, v_resource_id, res_table.usename, res_table.usesysid, res_table.usecreatedb, res_table.usesuper, res_table.usecatupd, res_table.passwd, res_table.valuntil, res_table.useconfig
	FROM dblink('myconn', 'SELECT usename, usesysid, usecreatedb, usesuper, usecatupd, passwd, valuntil, useconfig FROM pg_user')
	AS res_table (usename name, usesysid integer, usecreatedb boolean, usesuper boolean, usecatupd boolean, passwd text, valuntil abstime, useconfig text)
		LEFT JOIN amstgmgr.pg_user pu ON res_table.usesysid = pu.usesysid AND pu.resource_id = v_resource_id
	WHERE pu.usesysid IS NULL;
/*
	IF v_truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.pg_namespace;';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_pg_namespace_ID RESTART WITH 1;
		sql = '';
	END IF;

	INSERT INTO amstgmgr.pg_namespace (request_id, resource_id, nspname, nspowner, nspacl)
	SELECT v_request_id, v_resource_id, res_table.nspname, res_table.nspowner, res_table.nspacl
	FROM dblink('myconn', 'SELECT nspname, nspowner, nspacl FROM pg_namespace')
	AS res_table (nspname name, nspowner integer, nspacl aclitem[])
		LEFT JOIN amstgmgr.pg_namespace pnc ON res_table.nspname = pnc.nspname
	WHERE pnc.nspname IS NULL;
*/
/*
	IF v_truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.pg_database;';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_pg_database_ID RESTART WITH 1;
		sql = '';
	END IF;

	INSERT INTO amstgmgr.pg_database (request_id, resource_id, datname, datdba, encoding, datistemplate, datallowconn, datlastsysoid, datvacuumxid, datfrozenxid, dattablespace, datconfig, datacl)
	SELECT v_request_id, v_resource_id, res_table.datname, res_table.datdba, res_table.encoding, res_table.datistemplate, res_table.datallowconn, res_table.datlastsysoid, res_table.datvacuumxid, res_table.datfrozenxid, res_table.dattablespace, res_table.datconfig, res_table.datacl
	FROM dblink('myconn', 'SELECT datname, datdba, encoding, datistemplate, datallowconn, datlastsysoid, datvacuumxid, datfrozenxid, dattablespace, datconfig, datacl FROM pg_database')
	AS res_table (datname name, datdba integer, encoding integer, datistemplate boolean, datallowconn boolean, datlastsysoid oid, datvacuumxid xid, datfrozenxid xid, dattablespace oid, datconfig text, datacl aclitem[])
		LEFT JOIN amstgmgr.pg_database pd ON res_table.datname = pd.datname
	WHERE pd.datname IS NULL;

*/
	IF v_truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.STL_USERLOG;';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_STL_USERLOG_ID RESTART WITH 1;
		sql = '';
	END IF;

	SELECT COALESCE(MAX(recordtime), to_timestamp(0)) INTO MaxTimeStamp FROM amstgmgr.STL_USERLOG WHERE resource_id = v_resource_id;

	INSERT INTO amstgmgr.STL_USERLOG (request_id, resource_id, userid, username, oldusername, action, pid, xid, recordtime )
	SELECT v_request_id, v_resource_id, userid, username, oldusername, action, pid, xid, recordtime::timestamp
	FROM dblink('myconn', 'SELECT userid, username, oldusername, action, pid, xid, recordtime FROM STL_USERLOG WHERE recordtime >'''|| to_char(MaxTimeStamp, 'YYYY-MM-DD HH24:MI:SS.US')||''';')
	AS res_table (userid integer, username character(50), oldusername character(50), action character(10), pid integer, xid bigint, recordtime timestamp)
	WHERE 1 = 1;

	INSERT INTO amstgmgr.STL_USERLOG (request_id, resource_id, userid, username, oldusername, action, pid, xid, recordtime)
	SELECT v_request_id, v_resource_id, res_table.userid, res_table.username, res_table.oldusername, res_table.action, res_table.pid, res_table.xid, res_table.recordtime::timestamp
	FROM dblink('myconn', 'SELECT userid, username, oldusername, action, pid, xid, recordtime FROM STL_USERLOG WHERE recordtime ='''|| to_char(MaxTimeStamp, 'YYYY-MM-DD HH24:MI:SS.US')||''';')
	AS res_table (userid integer, username character(50), oldusername character(50), action character(10), pid integer, xid bigint, recordtime timestamp)
		LEFT JOIN amstgmgr.STL_USERLOG as ul ON res_table.recordtime = ul.recordtime AND res_table.userid = ul.userid
	WHERE ul.userid IS NULL;

	MaxTimeStamp = to_timestamp(0);

	IF v_truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.STL_S3CLIENT;';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_STL_S3CLIENT_ID RESTART WITH 1;
		sql = '';
	END IF;

	SELECT COALESCE(MAX(recordtime), to_timestamp(0)) INTO MaxTimeStamp FROM amstgmgr.STL_S3CLIENT WHERE resource_id = v_resource_id;

	INSERT INTO amstgmgr.STL_S3CLIENT (request_id, resource_id, userid, query, slice, recordtime, pid, http_method, bucket, key, transfer_size, data_size, start_time, end_time, transfer_time, compression_time, connect_time, app_connect_time, retries, request_id_from_Amazon_S3, extended_request_id_from_Amazon_S3, ip_address)
	SELECT v_request_id, v_resource_id, userid, query, slice, recordtime, pid, http_method, bucket, key, transfer_size, data_size, start_time, end_time, transfer_time, compression_time, connect_time, app_connect_time, retries, request_id_from_Amazon_S3, extended_request_id_from_Amazon_S3, ip_address
	FROM dblink('myconn', 'SELECT userid, query, slice, recordtime, pid, http_method, bucket, key, transfer_size, data_size, start_time, end_time, transfer_time, compression_time, connect_time, app_connect_time, retries, request_id, extended_request_id, ip_address FROM STL_S3CLIENT WHERE userid > 1 AND recordtime >'''|| to_char(MaxTimeStamp, 'YYYY-MM-DD HH24:MI:SS.US')||''';')
	AS res_table (userid integer, query integer, slice integer, recordtime timestamp, pid integer, http_method character(64), bucket character(64), key character(256), transfer_size bigint, data_size bigint, start_time bigint, end_time bigint, transfer_time bigint, compression_time bigint, connect_time bigint, app_connect_time bigint, retries bigint, request_id_from_Amazon_S3 char(32), extended_request_id_from_Amazon_S3 char(128), ip_address char(64))
	WHERE 1 = 1;

	INSERT INTO amstgmgr.STL_S3CLIENT (request_id, resource_id, userid, query, slice, recordtime, pid, http_method, bucket, key, transfer_size, data_size, start_time, end_time, transfer_time, compression_time, connect_time, app_connect_time, retries, request_id_from_Amazon_S3, extended_request_id_from_Amazon_S3, ip_address)
	SELECT v_request_id, v_resource_id, res_table.userid, res_table.query, res_table.slice, res_table.recordtime, res_table.pid, res_table.http_method, res_table.bucket, res_table.key, res_table.transfer_size, res_table.data_size, res_table.start_time, res_table.end_time, res_table.transfer_time, res_table.compression_time, res_table.connect_time, res_table.app_connect_time, res_table.retries, res_table.request_id_from_Amazon_S3, res_table.extended_request_id_from_Amazon_S3, res_table.ip_address
	FROM dblink('myconn', 'SELECT userid, query, slice, recordtime, pid, http_method, bucket, key, transfer_size, data_size, start_time, end_time, transfer_time, compression_time, connect_time, app_connect_time, retries, request_id, extended_request_id, ip_address FROM STL_S3CLIENT WHERE userid > 1 AND recordtime ='''|| to_char(MaxTimeStamp, 'YYYY-MM-DD HH24:MI:SS.US')||''';')
	AS res_table (userid integer, query integer, slice integer, recordtime timestamp, pid integer, http_method character(64), bucket character(64), key character(256), transfer_size bigint, data_size bigint, start_time bigint, end_time bigint, transfer_time bigint, compression_time bigint, connect_time bigint, app_connect_time bigint, retries bigint, request_id_from_Amazon_S3 char(32), extended_request_id_from_Amazon_S3 char(128), ip_address char(64))
		LEFT JOIN amstgmgr.STL_S3CLIENT scl ON res_table.recordtime = scl.recordtime AND res_table.query = scl.query AND res_table.slice = scl.slice
	WHERE scl.query IS NULL;

	MaxTimeStamp = to_timestamp(0);

	IF v_truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.STL_VACUUM;';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_STL_VACUUM_ID RESTART WITH 1;
		sql = '';
	END IF;

	SELECT COALESCE(MAX(eventtime), to_timestamp(0)) INTO MaxTimeStamp FROM amstgmgr.STL_VACUUM WHERE resource_id = v_resource_id;

	INSERT INTO amstgmgr.STL_VACUUM (request_id, resource_id, userid, xid, table_id, status, rows, sortedrows, blocks, max_merge_partitions, eventtime)
	SELECT v_request_id, v_resource_id, userid, xid, table_id, status, rows, sortedrows, blocks, max_merge_partitions, eventtime
	FROM dblink('myconn', 'SELECT userid, xid, table_id, status, rows, sortedrows, blocks, max_merge_partitions, eventtime FROM STL_VACUUM WHERE userid > 1 AND eventtime >'''|| to_char(MaxTimeStamp, 'YYYY-MM-DD HH24:MI:SS.US')||''';')
	AS res_table (userid integer, xid bigint, table_id integer, status character(30), rows bigint, sortedrows bigint, blocks bigint, max_merge_partitions integer, eventtime timestamp)
	WHERE 1 = 1;

	INSERT INTO amstgmgr.STL_VACUUM (request_id, resource_id, userid, xid, table_id, status, rows, sortedrows, blocks, max_merge_partitions, eventtime)
	SELECT v_request_id, v_resource_id, res_table.userid, res_table.xid, res_table.table_id, res_table.status, res_table.rows, res_table.sortedrows, res_table.blocks, res_table.max_merge_partitions, res_table.eventtime
	FROM dblink('myconn', 'SELECT userid, xid, table_id, status, rows, sortedrows, blocks, max_merge_partitions, eventtime FROM STL_VACUUM WHERE userid > 1 AND eventtime ='''|| to_char(MaxTimeStamp, 'YYYY-MM-DD HH24:MI:SS.US')||''';')
	AS res_table (userid integer, xid bigint, table_id integer, status character(30), rows bigint, sortedrows bigint, blocks bigint, max_merge_partitions integer, eventtime timestamp)
		LEFT JOIN amstgmgr.STL_VACUUM sv ON res_table.eventtime = sv.eventtime AND res_table.table_id = sv.table_id
	WHERE sv.xid IS NULL;

	MaxTimeStamp = to_timestamp(0);

	IF v_truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.STL_SESSIONS;';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_STL_SESSIONS_ID RESTART WITH 1;
		sql = '';
	END IF;

	SELECT COALESCE(MAX(starttime), to_timestamp(0)) INTO MaxTimeStamp FROM amstgmgr.STL_SESSIONS WHERE resource_id = v_resource_id;

	INSERT INTO amstgmgr.STL_SESSIONS (request_id, resource_id, userid, starttime, endtime, process, user_name, db_name)
	SELECT v_request_id, v_resource_id, userid, starttime, endtime, process, user_name, db_name
	FROM dblink('myconn', 'SELECT userid, starttime, endtime, process, user_name, db_name FROM STL_SESSIONS WHERE userid > 1 AND starttime >'''|| to_char(MaxTimeStamp, 'YYYY-MM-DD HH24:MI:SS.US')||''';')
	AS res_table (userid integer, starttime timestamp, endtime timestamp, process integer, user_name character(50), db_name character(50))
	WHERE 1 = 1;

	INSERT INTO amstgmgr.STL_SESSIONS (request_id, resource_id, userid, starttime, endtime, process, user_name, db_name)
	SELECT v_request_id, v_resource_id, res_table.userid, res_table.starttime, res_table.endtime, res_table.process, res_table.user_name, res_table.db_name
	FROM dblink('myconn', 'SELECT userid, starttime, endtime, process, user_name, db_name FROM STL_SESSIONS WHERE userid > 1 AND starttime ='''|| to_char(MaxTimeStamp, 'YYYY-MM-DD HH24:MI:SS.US')||''';')
	AS res_table (userid integer, starttime timestamp, endtime timestamp, process integer, user_name character(50), db_name character(50))
		LEFT JOIN amstgmgr.STL_SESSIONS sss ON res_table.starttime = sss.starttime AND res_table.process = sss.process AND res_table.userid = sss.userid AND res_table.db_name = sss.db_name
	WHERE sss.process IS NULL;

	MaxTimeStamp = to_timestamp(0);

	IF ('myconn' = ANY (dblink_get_connections())) 
		THEN PERFORM dblink_disconnect('myconn'); 
	END IF;
	
	SELECT '('|| NOW() ||') Successful data lading from - https://' || link_host INTO result;
	RETURN result;
END
$$;


ALTER FUNCTION amstgmgr.populate_tables(v_request_id integer, v_resource_id integer, v_truncate integer, link_host text) OWNER TO pgadmin;


CREATE OR REPLACE FUNCTION populate_tables_2(v_request_id integer, v_resource_id integer, v_truncate integer, link_host text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE sql text;
	result text;
	MaxTimeStamp timestamp;
BEGIN
	SET search_path TO stage, public;

	IF ('myconn' = ANY (dblink_get_connections())) 
		THEN PERFORM dblink_disconnect('myconn'); 
	END IF;

	PERFORM dblink_connect('myconn', link_host);

	IF v_truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgtst.STL_ALERT_EVENT_LOG;';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_STL_ALERT_EVENT_LOG RESTART WITH 1;
		sql = '';
	END IF;

	SELECT COALESCE(MAX(event_time), to_timestamp(0)) INTO MaxTimeStamp FROM amstgmgr.STL_ALERT_EVENT_LOG WHERE resource_id = v_resource_id;

	INSERT INTO amstgmgr.STL_ALERT_EVENT_LOG (request_id, resource_id, userid, query, slice, segment, step, pid, xid, event, solution, event_time)
	SELECT v_request_id, v_resource_id, userid, query, slice, segment, step, pid, xid, event, solution, event_time
	FROM dblink('myconn', 'SELECT userid, query, slice, segment, step, pid, xid, event, solution, event_time FROM STL_ALERT_EVENT_LOG WHERE event_time >'''|| to_char(MaxTimeStamp, 'YYYY-MM-DD HH24:MI:SS.US')||''';')
	AS res_table (userid integer, query integer, slice integer, segment integer, step integer, pid integer, xid bigint, event character(1024), solution character(1024), event_time timestamp without time zone);

	MaxTimeStamp = to_timestamp(0);

	IF v_truncate = 1
	THEN
		sql = 'TRUNCATE TABLE amstgmgr.SVV_TABLE_INFO;';
		EXECUTE sql;
		ALTER SEQUENCE amstgmgr.SEQ_SVV_TABLE_INFO RESTART WITH 1;
		sql = '';
	END IF;

	INSERT INTO amstgmgr.SVV_TABLE_INFO (request_id, resource_id, database, schema, table_id, "table", encoded, diststyle, sortkey1, max_varchar, sortkey1_enc, sortkey_num, size, pct_used, empty, unsorted, stats_off, tbl_rows, skew_sortkey1, skew_rows)
	SELECT v_request_id, v_resource_id, database, schema, table_id, "table", encoded, diststyle, sortkey1, max_varchar, sortkey1_enc, sortkey_num, size, pct_used, empty, unsorted, stats_off, tbl_rows, skew_sortkey1, skew_rows
	FROM dblink('myconn', 'SELECT database, schema, table_id, "table", encoded, diststyle, sortkey1, max_varchar, sortkey1_enc, sortkey_num, size, pct_used, empty, unsorted, stats_off, tbl_rows, skew_sortkey1, skew_rows FROM SVV_TABLE_INFO;')
	AS res_table (database text, schema text, table_id oid, "table" text, encoded text, diststyle text, sortkey1 text, max_varchar integer, sortkey1_enc character(32), sortkey_num integer,
		      size bigint, pct_used numeric(10,4), empty bigint, unsorted numeric(5,2), stats_off numeric(5,2), tbl_rows numeric(38,0), skew_sortkey1 numeric(19,2), skew_rows numeric(19,2));

	MaxTimeStamp = to_timestamp(0);

	IF ('myconn' = ANY (dblink_get_connections())) 
		THEN PERFORM dblink_disconnect('myconn'); 
	END IF;
	
	SELECT '('|| NOW() ||') Successful data loading from - https://' || link_host INTO result;
	RETURN result;
END
$$;


ALTER FUNCTION amstgmgr.populate_tables_2(v_request_id integer, v_resource_id integer, v_truncate integer, link_host text) OWNER TO pgadmin;

CREATE SEQUENCE seq_stl_wlm_query
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_stl_wlm_query OWNER TO pgadmin;




CREATE TABLE stage_rsh_cloudwatch_datapoints_1180k_1190k (
    CONSTRAINT stage_rsh_cloudwatch_datapoints_1180k_1190k_request_id_check CHECK (((request_id >= 1180000) AND (request_id < 1190000)))
)
INHERITS (stage_rsh_cloudwatch_datapoints);


ALTER TABLE stage_rsh_cloudwatch_datapoints_1180k_1190k OWNER TO pgadmin;

--
-- TOC entry 478 (class 1259 OID 44217)
-- Name: stage_rsh_cloudwatch_datapoints_1190k_1200k; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stage_rsh_cloudwatch_datapoints_1190k_1200k (
    CONSTRAINT stage_rsh_cloudwatch_datapoints_1190k_1200k_request_id_check CHECK (((request_id >= 1190000) AND (request_id < 1200000)))
)
INHERITS (stage_rsh_cloudwatch_datapoints);


ALTER TABLE stage_rsh_cloudwatch_datapoints_1190k_1200k OWNER TO pgadmin;

--
-- TOC entry 482 (class 1259 OID 44655)
-- Name: stage_rsh_cloudwatch_datapoints_1200k_1300k; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stage_rsh_cloudwatch_datapoints_1200k_1300k (
    CONSTRAINT stage_rsh_cloudwatch_datapoints_1200k_1300k_request_id_check CHECK (((request_id >= 1200000) AND (request_id < 1300000)))
)
INHERITS (stage_rsh_cloudwatch_datapoints);


ALTER TABLE stage_rsh_cloudwatch_datapoints_1200k_1300k OWNER TO pgadmin;

--
-- TOC entry 483 (class 1259 OID 44666)
-- Name: stage_rsh_cloudwatch_datapoints_1300k_1400k; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stage_rsh_cloudwatch_datapoints_1300k_1400k (
    CONSTRAINT stage_rsh_cloudwatch_datapoints_1300k_1400k_request_id_check CHECK (((request_id >= 1300000) AND (request_id < 1400000)))
)
INHERITS (stage_rsh_cloudwatch_datapoints);


ALTER TABLE stage_rsh_cloudwatch_datapoints_1300k_1400k OWNER TO pgadmin;

--
-- TOC entry 484 (class 1259 OID 44677)
-- Name: stage_rsh_cloudwatch_datapoints_1400k_1500k; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stage_rsh_cloudwatch_datapoints_1400k_1500k (
    CONSTRAINT stage_rsh_cloudwatch_datapoints_1400k_1500k_request_id_check CHECK (((request_id >= 1400000) AND (request_id < 1500000)))
)
INHERITS (stage_rsh_cloudwatch_datapoints);


ALTER TABLE stage_rsh_cloudwatch_datapoints_1400k_1500k OWNER TO pgadmin;

--
-- TOC entry 479 (class 1259 OID 44228)
-- Name: stage_rsh_cloudwatch_datapoints_1_1180k; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stage_rsh_cloudwatch_datapoints_1_1180k (
    CONSTRAINT stage_rsh_cloudwatch_datapoints_1_1180k_request_id_check CHECK (((request_id >= 1) AND (request_id < 1180000)))
)
INHERITS (stage_rsh_cloudwatch_datapoints);


ALTER TABLE stage_rsh_cloudwatch_datapoints_1_1180k OWNER TO pgadmin;

--
-- TOC entry 240 (class 1259 OID 17434)





ALTER  TABLE stl_query 
	ALTER COLUMN resource_id TYPE  smallint,
    ALTER COLUMN querytxt TYPE character varying(2000),
    ALTER COLUMN aborted TYPE smallint
;


ALTER TABLE stl_query OWNER TO pgadmin;


CREATE TABLE stl_query_2015_01 (
    CONSTRAINT stl_query_2015_01_starttime_check CHECK (((starttime >= '2015-01-01 00:00:00'::timestamp without time zone) AND (starttime < '2015-02-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_query);


ALTER TABLE stl_query_2015_01 OWNER TO pgadmin;

--
-- TOC entry 420 (class 1259 OID 40470)
-- Name: stl_query_2015_02; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_query_2015_02 (
    CONSTRAINT stl_query_2015_02_starttime_check CHECK (((starttime >= '2015-02-01 00:00:00'::timestamp without time zone) AND (starttime < '2015-03-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_query);


ALTER TABLE stl_query_2015_02 OWNER TO pgadmin;

--
-- TOC entry 421 (class 1259 OID 40479)
-- Name: stl_query_2015_03; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_query_2015_03 (
    CONSTRAINT stl_query_2015_03_starttime_check CHECK (((starttime >= '2015-03-01 00:00:00'::timestamp without time zone) AND (starttime < '2015-04-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_query);


ALTER TABLE stl_query_2015_03 OWNER TO pgadmin;

--
-- TOC entry 422 (class 1259 OID 40488)
-- Name: stl_query_2015_04; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_query_2015_04 (
    CONSTRAINT stl_query_2015_04_starttime_check CHECK (((starttime >= '2015-04-01 00:00:00'::timestamp without time zone) AND (starttime < '2015-05-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_query);


ALTER TABLE stl_query_2015_04 OWNER TO pgadmin;

--
-- TOC entry 423 (class 1259 OID 40497)
-- Name: stl_query_2015_05; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_query_2015_05 (
    CONSTRAINT stl_query_2015_05_starttime_check CHECK (((starttime >= '2015-05-01 00:00:00'::timestamp without time zone) AND (starttime < '2015-06-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_query);


ALTER TABLE stl_query_2015_05 OWNER TO pgadmin;

--
-- TOC entry 424 (class 1259 OID 40506)
-- Name: stl_query_2015_06; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_query_2015_06 (
    CONSTRAINT stl_query_2015_06_starttime_check CHECK (((starttime >= '2015-06-01 00:00:00'::timestamp without time zone) AND (starttime < '2015-07-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_query);


ALTER TABLE stl_query_2015_06 OWNER TO pgadmin;

--
-- TOC entry 425 (class 1259 OID 40515)
-- Name: stl_query_2015_07; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_query_2015_07 (
    CONSTRAINT stl_query_2015_07_starttime_check CHECK (((starttime >= '2015-07-01 00:00:00'::timestamp without time zone) AND (starttime < '2015-08-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_query);


ALTER TABLE stl_query_2015_07 OWNER TO pgadmin;

--
-- TOC entry 426 (class 1259 OID 40524)
-- Name: stl_query_2015_08; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_query_2015_08 (
    CONSTRAINT stl_query_2015_08_starttime_check CHECK (((starttime >= '2015-08-01 00:00:00'::timestamp without time zone) AND (starttime < '2015-09-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_query);


ALTER TABLE stl_query_2015_08 OWNER TO pgadmin;

--
-- TOC entry 427 (class 1259 OID 40533)
-- Name: stl_query_2015_09; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_query_2015_09 (
    CONSTRAINT stl_query_2015_09_starttime_check CHECK (((starttime >= '2015-09-01 00:00:00'::timestamp without time zone) AND (starttime < '2015-10-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_query);


ALTER TABLE stl_query_2015_09 OWNER TO pgadmin;

--
-- TOC entry 428 (class 1259 OID 40542)
-- Name: stl_query_2015_10; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_query_2015_10 (
    CONSTRAINT stl_query_2015_10_starttime_check CHECK (((starttime >= '2015-10-01 00:00:00'::timestamp without time zone) AND (starttime < '2015-11-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_query);


ALTER TABLE stl_query_2015_10 OWNER TO pgadmin;

--
-- TOC entry 429 (class 1259 OID 40551)
-- Name: stl_query_2015_11; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_query_2015_11 (
    CONSTRAINT stl_query_2015_11_starttime_check CHECK (((starttime >= '2015-11-01 00:00:00'::timestamp without time zone) AND (starttime < '2015-12-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_query);


ALTER TABLE stl_query_2015_11 OWNER TO pgadmin;

--
-- TOC entry 430 (class 1259 OID 40561)
-- Name: stl_query_2015_12; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_query_2015_12 (
    CONSTRAINT stl_query_2015_12_starttime_check CHECK (((starttime >= '2015-12-01 00:00:00'::timestamp without time zone) AND (starttime < '2016-01-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_query);


ALTER TABLE stl_query_2015_12 OWNER TO pgadmin;

--
-- TOC entry 431 (class 1259 OID 40570)
-- Name: stl_query_2016_01; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_query_2016_01 (
    CONSTRAINT stl_query_2016_01_starttime_check CHECK (((starttime >= '2016-01-01 00:00:00'::timestamp without time zone) AND (starttime < '2016-02-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_query);


ALTER TABLE stl_query_2016_01 OWNER TO pgadmin;

--
-- TOC entry 432 (class 1259 OID 40579)
-- Name: stl_query_2016_02; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_query_2016_02 (
    CONSTRAINT stl_query_2016_02_starttime_check CHECK (((starttime >= '2016-02-01 00:00:00'::timestamp without time zone) AND (starttime < '2016-03-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_query);


ALTER TABLE stl_query_2016_02 OWNER TO pgadmin;

--
-- TOC entry 433 (class 1259 OID 40588)
-- Name: stl_query_2016_03; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_query_2016_03 (
    CONSTRAINT stl_query_2016_03_starttime_check CHECK (((starttime >= '2016-03-01 00:00:00'::timestamp without time zone) AND (starttime < '2016-04-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_query);


ALTER TABLE stl_query_2016_03 OWNER TO pgadmin;

--
-- TOC entry 462 (class 1259 OID 43798)
-- Name: stl_query_2016_04; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_query_2016_04 (
    CONSTRAINT stl_query_2016_04_starttime_check CHECK (((starttime >= '2016-04-01 00:00:00'::timestamp without time zone) AND (starttime < '2016-05-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_query);


ALTER TABLE stl_query_2016_04 OWNER TO pgadmin;

--
-- TOC entry 434 (class 1259 OID 40602)
-- Name: stl_query_2016_05; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_query_2016_05 (
    CONSTRAINT stl_query_2016_05_starttime_check CHECK (((starttime >= '2016-05-01 00:00:00'::timestamp without time zone) AND (starttime < '2016-06-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_query);


ALTER TABLE stl_query_2016_05 OWNER TO pgadmin;

--
-- TOC entry 435 (class 1259 OID 40611)
-- Name: stl_query_2016_06; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_query_2016_06 (
    CONSTRAINT stl_query_2016_06_starttime_check CHECK (((starttime >= '2016-06-01 00:00:00'::timestamp without time zone) AND (starttime < '2016-07-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_query);


ALTER TABLE stl_query_2016_06 OWNER TO pgadmin;

--
-- TOC entry 436 (class 1259 OID 40630)
-- Name: stl_query_2016_07; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_query_2016_07 (
    CONSTRAINT stl_query_2016_07_starttime_check CHECK (((starttime >= '2016-07-01 00:00:00'::timestamp without time zone) AND (starttime < '2016-08-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_query);


ALTER TABLE stl_query_2016_07 OWNER TO pgadmin;

--
-- TOC entry 437 (class 1259 OID 40640)
-- Name: stl_query_2016_08; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_query_2016_08 (
    CONSTRAINT stl_query_2016_08_starttime_check CHECK (((starttime >= '2016-08-01 00:00:00'::timestamp without time zone) AND (starttime < '2016-09-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_query);


ALTER TABLE stl_query_2016_08 OWNER TO pgadmin;

--
-- TOC entry 438 (class 1259 OID 40649)
-- Name: stl_query_2016_09; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_query_2016_09 (
    CONSTRAINT stl_query_2016_09_starttime_check CHECK (((starttime >= '2016-09-01 00:00:00'::timestamp without time zone) AND (starttime < '2016-10-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_query);


ALTER TABLE stl_query_2016_09 OWNER TO pgadmin;

--
-- TOC entry 439 (class 1259 OID 40658)
-- Name: stl_query_2016_10; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_query_2016_10 (
    CONSTRAINT stl_query_2016_10_starttime_check CHECK (((starttime >= '2016-10-01 00:00:00'::timestamp without time zone) AND (starttime < '2016-11-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_query);


ALTER TABLE stl_query_2016_10 OWNER TO pgadmin;

--
-- TOC entry 440 (class 1259 OID 40667)
-- Name: stl_query_2016_11; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_query_2016_11 (
    CONSTRAINT stl_query_2016_11_starttime_check CHECK (((starttime >= '2016-11-01 00:00:00'::timestamp without time zone) AND (starttime < '2016-12-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_query);


ALTER TABLE stl_query_2016_11 OWNER TO pgadmin;

--
-- TOC entry 441 (class 1259 OID 40676)
-- Name: stl_query_2016_12; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_query_2016_12 (
    CONSTRAINT stl_query_2016_12_starttime_check CHECK (((starttime >= '2016-12-01 00:00:00'::timestamp without time zone) AND (starttime < '2017-01-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_query);


ALTER TABLE stl_query_2016_12 OWNER TO pgadmin;


ALTER TABLE stl_querytext ALTER COLUMN text TYPE character varying(200);



CREATE TABLE stl_wlm_query (
    id bigint DEFAULT nextval('seq_stl_wlm_query'::regclass) NOT NULL,
    datetimestamp timestamp without time zone DEFAULT now() NOT NULL,
    request_id integer,
    resource_id smallint,
    userid integer,
    xid integer,
    task integer,
    query integer,
    service_class integer,
    slot_count integer,
    service_class_start_time timestamp without time zone,
    queue_start_time timestamp without time zone,
    queue_end_time timestamp without time zone,
    total_queue_time bigint,
    exec_start_time timestamp without time zone,
    exec_end_time timestamp without time zone,
    total_exec_time bigint,
    service_class_end_time timestamp without time zone,
    final_state character varying(16)
);


ALTER TABLE stl_wlm_query OWNER TO pgadmin;

--
-- TOC entry 455 (class 1259 OID 42086)
-- Name: stl_wlm_query_2016_01; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_wlm_query_2016_01 (
    CONSTRAINT stl_stl_wlm_query_01_starttime_check CHECK (((service_class_start_time >= '2016-01-01 00:00:00'::timestamp without time zone) AND (service_class_start_time < '2016-02-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_wlm_query);


ALTER TABLE stl_wlm_query_2016_01 OWNER TO pgadmin;

--
-- TOC entry 456 (class 1259 OID 42092)
-- Name: stl_wlm_query_2016_02; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_wlm_query_2016_02 (
    CONSTRAINT stl_stl_wlm_query_02_starttime_check CHECK (((service_class_start_time >= '2016-02-01 00:00:00'::timestamp without time zone) AND (service_class_start_time < '2016-03-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_wlm_query);


ALTER TABLE stl_wlm_query_2016_02 OWNER TO pgadmin;

--
-- TOC entry 457 (class 1259 OID 42098)
-- Name: stl_wlm_query_2016_03; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_wlm_query_2016_03 (
    CONSTRAINT stl_stl_wlm_query_03_starttime_check CHECK (((service_class_start_time >= '2016-03-01 00:00:00'::timestamp without time zone) AND (service_class_start_time < '2016-04-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_wlm_query);


ALTER TABLE stl_wlm_query_2016_03 OWNER TO pgadmin;

--
-- TOC entry 463 (class 1259 OID 43810)
-- Name: stl_wlm_query_2016_04; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_wlm_query_2016_04 (
    CONSTRAINT stl_stl_wlm_query_04_starttime_check CHECK (((service_class_start_time >= '2016-04-01 00:00:00'::timestamp without time zone) AND (service_class_start_time < '2016-05-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_wlm_query);


ALTER TABLE stl_wlm_query_2016_04 OWNER TO pgadmin;

--
-- TOC entry 464 (class 1259 OID 43816)
-- Name: stl_wlm_query_2016_05; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_wlm_query_2016_05 (
    CONSTRAINT stl_stl_wlm_query_05_starttime_check CHECK (((service_class_start_time >= '2016-05-01 00:00:00'::timestamp without time zone) AND (service_class_start_time < '2016-06-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_wlm_query);


ALTER TABLE stl_wlm_query_2016_05 OWNER TO pgadmin;

--
-- TOC entry 465 (class 1259 OID 43822)
-- Name: stl_wlm_query_2016_06; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_wlm_query_2016_06 (
    CONSTRAINT stl_stl_wlm_query_06_starttime_check CHECK (((service_class_start_time >= '2016-06-01 00:00:00'::timestamp without time zone) AND (service_class_start_time < '2016-07-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_wlm_query);


ALTER TABLE stl_wlm_query_2016_06 OWNER TO pgadmin;

--
-- TOC entry 496 (class 1259 OID 52186)
-- Name: stl_wlm_query_2016_07; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_wlm_query_2016_07 (
    CONSTRAINT stl_stl_wlm_query_07_starttime_check CHECK (((service_class_start_time >= '2016-07-01 00:00:00'::timestamp without time zone) AND (service_class_start_time < '2016-08-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_wlm_query);


ALTER TABLE stl_wlm_query_2016_07 OWNER TO pgadmin;

--
-- TOC entry 497 (class 1259 OID 52192)
-- Name: stl_wlm_query_2016_08; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_wlm_query_2016_08 (
    CONSTRAINT stl_stl_wlm_query_08_starttime_check CHECK (((service_class_start_time >= '2016-08-01 00:00:00'::timestamp without time zone) AND (service_class_start_time < '2016-09-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_wlm_query);


ALTER TABLE stl_wlm_query_2016_08 OWNER TO pgadmin;

--
-- TOC entry 498 (class 1259 OID 52198)
-- Name: stl_wlm_query_2016_09; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_wlm_query_2016_09 (
    CONSTRAINT stl_stl_wlm_query_09_starttime_check CHECK (((service_class_start_time >= '2016-09-01 00:00:00'::timestamp without time zone) AND (service_class_start_time < '2016-10-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_wlm_query);


ALTER TABLE stl_wlm_query_2016_09 OWNER TO pgadmin;

--
-- TOC entry 499 (class 1259 OID 52204)
-- Name: stl_wlm_query_2016_10; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_wlm_query_2016_10 (
    CONSTRAINT stl_stl_wlm_query_10_starttime_check CHECK (((service_class_start_time >= '2016-10-01 00:00:00'::timestamp without time zone) AND (service_class_start_time < '2016-11-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_wlm_query);


ALTER TABLE stl_wlm_query_2016_10 OWNER TO pgadmin;

--
-- TOC entry 500 (class 1259 OID 52210)
-- Name: stl_wlm_query_2016_11; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_wlm_query_2016_11 (
    CONSTRAINT stl_stl_wlm_query_11_starttime_check CHECK (((service_class_start_time >= '2016-11-01 00:00:00'::timestamp without time zone) AND (service_class_start_time < '2016-12-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_wlm_query);


ALTER TABLE stl_wlm_query_2016_11 OWNER TO pgadmin;

--
-- TOC entry 501 (class 1259 OID 52216)
-- Name: stl_wlm_query_2016_12; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE stl_wlm_query_2016_12 (
    CONSTRAINT stl_stl_wlm_query_12_starttime_check CHECK (((service_class_start_time >= '2016-12-01 00:00:00'::timestamp without time zone) AND (service_class_start_time < '2017-01-01 00:00:00'::timestamp without time zone)))
)
INHERITS (stl_wlm_query);


ALTER TABLE stl_wlm_query_2016_12 OWNER TO pgadmin;



ALTER TABLE svl_query_summary ALTER COLUMN label TYPE character varying(255);

CREATE TABLE svl_query_summary_2016_02 (
    CONSTRAINT stl_svl_query_summary_2016_02_datetimestamp_check CHECK (((datetimestamp >= '2016-02-01 00:00:00'::timestamp without time zone) AND (datetimestamp < '2016-03-01 00:00:00'::timestamp without time zone)))
)
INHERITS (svl_query_summary);


ALTER TABLE svl_query_summary_2016_02 OWNER TO pgadmin;

--
-- TOC entry 460 (class 1259 OID 42191)
-- Name: svl_query_summary_2016_03; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE svl_query_summary_2016_03 (
    CONSTRAINT stl_svl_query_summary_2016_03_datetimestamp_check CHECK (((datetimestamp >= '2016-03-01 00:00:00'::timestamp without time zone) AND (datetimestamp < '2016-04-01 00:00:00'::timestamp without time zone)))
)
INHERITS (svl_query_summary);


ALTER TABLE svl_query_summary_2016_03 OWNER TO pgadmin;

--
-- TOC entry 461 (class 1259 OID 42197)
-- Name: svl_query_summary_2016_04; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE svl_query_summary_2016_04 (
    CONSTRAINT stl_svl_query_summary_2016_04_datetimestamp_check CHECK (((datetimestamp >= '2016-04-01 00:00:00'::timestamp without time zone) AND (datetimestamp < '2016-05-01 00:00:00'::timestamp without time zone)))
)
INHERITS (svl_query_summary);


ALTER TABLE svl_query_summary_2016_04 OWNER TO pgadmin;

--
-- TOC entry 470 (class 1259 OID 44155)
-- Name: svl_query_summary_2016_05; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE svl_query_summary_2016_05 (
    CONSTRAINT stl_svl_query_summary_2016_05_datetimestamp_check CHECK (((datetimestamp >= '2016-05-01 00:00:00'::timestamp without time zone) AND (datetimestamp < '2016-06-01 00:00:00'::timestamp without time zone)))
)
INHERITS (svl_query_summary);


ALTER TABLE svl_query_summary_2016_05 OWNER TO pgadmin;

--
-- TOC entry 471 (class 1259 OID 44162)
-- Name: svl_query_summary_2016_06; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE svl_query_summary_2016_06 (
    CONSTRAINT stl_svl_query_summary_2016_06_datetimestamp_check CHECK (((datetimestamp >= '2016-06-01 00:00:00'::timestamp without time zone) AND (datetimestamp < '2016-07-01 00:00:00'::timestamp without time zone)))
)
INHERITS (svl_query_summary);


ALTER TABLE svl_query_summary_2016_06 OWNER TO pgadmin;

--
-- TOC entry 472 (class 1259 OID 44169)
-- Name: svl_query_summary_2016_07; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE svl_query_summary_2016_07 (
    CONSTRAINT stl_svl_query_summary_2016_07_datetimestamp_check CHECK (((datetimestamp >= '2016-07-01 00:00:00'::timestamp without time zone) AND (datetimestamp < '2016-08-01 00:00:00'::timestamp without time zone)))
)
INHERITS (svl_query_summary);


ALTER TABLE svl_query_summary_2016_07 OWNER TO pgadmin;

--
-- TOC entry 473 (class 1259 OID 44176)
-- Name: svl_query_summary_2016_08; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE svl_query_summary_2016_08 (
    CONSTRAINT stl_svl_query_summary_2016_08_datetimestamp_check CHECK (((datetimestamp >= '2016-08-01 00:00:00'::timestamp without time zone) AND (datetimestamp < '2016-09-01 00:00:00'::timestamp without time zone)))
)
INHERITS (svl_query_summary);


ALTER TABLE svl_query_summary_2016_08 OWNER TO pgadmin;

--
-- TOC entry 474 (class 1259 OID 44183)
-- Name: svl_query_summary_2016_09; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE svl_query_summary_2016_09 (
    CONSTRAINT stl_svl_query_summary_2016_09_datetimestamp_check CHECK (((datetimestamp >= '2016-09-01 00:00:00'::timestamp without time zone) AND (datetimestamp < '2016-10-01 00:00:00'::timestamp without time zone)))
)
INHERITS (svl_query_summary);


ALTER TABLE svl_query_summary_2016_09 OWNER TO pgadmin;

--
-- TOC entry 475 (class 1259 OID 44190)
-- Name: svl_query_summary_2016_10; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE svl_query_summary_2016_10 (
    CONSTRAINT stl_svl_query_summary_2016_10_datetimestamp_check CHECK (((datetimestamp >= '2016-10-01 00:00:00'::timestamp without time zone) AND (datetimestamp < '2016-11-01 00:00:00'::timestamp without time zone)))
)
INHERITS (svl_query_summary);


ALTER TABLE svl_query_summary_2016_10 OWNER TO pgadmin;

--
-- TOC entry 476 (class 1259 OID 44197)
-- Name: svl_query_summary_2016_11; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE svl_query_summary_2016_11 (
    CONSTRAINT stl_svl_query_summary_2016_11_datetimestamp_check CHECK (((datetimestamp >= '2016-11-01 00:00:00'::timestamp without time zone) AND (datetimestamp < '2016-12-01 00:00:00'::timestamp without time zone)))
)
INHERITS (svl_query_summary);


ALTER TABLE svl_query_summary_2016_11 OWNER TO pgadmin;

--
-- TOC entry 477 (class 1259 OID 44204)
-- Name: svl_query_summary_2016_12; Type: TABLE; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE TABLE svl_query_summary_2016_12 (
    CONSTRAINT stl_svl_query_summary_2016_12_datetimestamp_check CHECK (((datetimestamp >= '2016-12-01 00:00:00'::timestamp without time zone) AND (datetimestamp < '2017-01-01 00:00:00'::timestamp without time zone)))
)
INHERITS (svl_query_summary);


ALTER TABLE svl_query_summary_2016_12 OWNER TO pgadmin;


ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1180k_1190k ALTER COLUMN average SET DEFAULT 0;


--
-- TOC entry 3882 (class 2604 OID 43903)
-- Name: maximum; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1180k_1190k ALTER COLUMN maximum SET DEFAULT 0;


--
-- TOC entry 3883 (class 2604 OID 43904)
-- Name: minimum; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1180k_1190k ALTER COLUMN minimum SET DEFAULT 0;


--
-- TOC entry 3884 (class 2604 OID 43905)
-- Name: samplecount; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1180k_1190k ALTER COLUMN samplecount SET DEFAULT 0;


--
-- TOC entry 3885 (class 2604 OID 43906)
-- Name: sum; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1180k_1190k ALTER COLUMN sum SET DEFAULT 0;


--
-- TOC entry 3911 (class 2604 OID 44220)
-- Name: average; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1190k_1200k ALTER COLUMN average SET DEFAULT 0;


--
-- TOC entry 3912 (class 2604 OID 44221)
-- Name: maximum; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1190k_1200k ALTER COLUMN maximum SET DEFAULT 0;


--
-- TOC entry 3913 (class 2604 OID 44222)
-- Name: minimum; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1190k_1200k ALTER COLUMN minimum SET DEFAULT 0;


--
-- TOC entry 3914 (class 2604 OID 44223)
-- Name: samplecount; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1190k_1200k ALTER COLUMN samplecount SET DEFAULT 0;


--
-- TOC entry 3915 (class 2604 OID 44224)
-- Name: sum; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1190k_1200k ALTER COLUMN sum SET DEFAULT 0;


--
-- TOC entry 3923 (class 2604 OID 44658)
-- Name: average; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1200k_1300k ALTER COLUMN average SET DEFAULT 0;


--
-- TOC entry 3924 (class 2604 OID 44659)
-- Name: maximum; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1200k_1300k ALTER COLUMN maximum SET DEFAULT 0;


--
-- TOC entry 3925 (class 2604 OID 44660)
-- Name: minimum; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1200k_1300k ALTER COLUMN minimum SET DEFAULT 0;


--
-- TOC entry 3926 (class 2604 OID 44661)
-- Name: samplecount; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1200k_1300k ALTER COLUMN samplecount SET DEFAULT 0;


--
-- TOC entry 3927 (class 2604 OID 44662)
-- Name: sum; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1200k_1300k ALTER COLUMN sum SET DEFAULT 0;


--
-- TOC entry 3929 (class 2604 OID 44669)
-- Name: average; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1300k_1400k ALTER COLUMN average SET DEFAULT 0;


--
-- TOC entry 3930 (class 2604 OID 44670)
-- Name: maximum; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1300k_1400k ALTER COLUMN maximum SET DEFAULT 0;


--
-- TOC entry 3931 (class 2604 OID 44671)
-- Name: minimum; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1300k_1400k ALTER COLUMN minimum SET DEFAULT 0;


--
-- TOC entry 3932 (class 2604 OID 44672)
-- Name: samplecount; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1300k_1400k ALTER COLUMN samplecount SET DEFAULT 0;


--
-- TOC entry 3933 (class 2604 OID 44673)
-- Name: sum; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1300k_1400k ALTER COLUMN sum SET DEFAULT 0;


--
-- TOC entry 3935 (class 2604 OID 44680)
-- Name: average; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1400k_1500k ALTER COLUMN average SET DEFAULT 0;


--
-- TOC entry 3936 (class 2604 OID 44681)
-- Name: maximum; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1400k_1500k ALTER COLUMN maximum SET DEFAULT 0;


--
-- TOC entry 3937 (class 2604 OID 44682)
-- Name: minimum; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1400k_1500k ALTER COLUMN minimum SET DEFAULT 0;


--
-- TOC entry 3938 (class 2604 OID 44683)
-- Name: samplecount; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1400k_1500k ALTER COLUMN samplecount SET DEFAULT 0;


--
-- TOC entry 3939 (class 2604 OID 44684)
-- Name: sum; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1400k_1500k ALTER COLUMN sum SET DEFAULT 0;


--
-- TOC entry 3917 (class 2604 OID 44231)
-- Name: average; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1_1180k ALTER COLUMN average SET DEFAULT 0;


--
-- TOC entry 3918 (class 2604 OID 44232)
-- Name: maximum; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1_1180k ALTER COLUMN maximum SET DEFAULT 0;


--
-- TOC entry 3919 (class 2604 OID 44233)
-- Name: minimum; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1_1180k ALTER COLUMN minimum SET DEFAULT 0;


--
-- TOC entry 3920 (class 2604 OID 44234)
-- Name: samplecount; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1_1180k ALTER COLUMN samplecount SET DEFAULT 0;


--
-- TOC entry 3921 (class 2604 OID 44235)
-- Name: sum; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stage_rsh_cloudwatch_datapoints_1_1180k ALTER COLUMN sum SET DEFAULT 0;


--
-- TOC entry 3778 (class 2604 OID 40446)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2015_01 ALTER COLUMN id SET DEFAULT nextval('seq_stl_query_id'::regclass);


--
-- TOC entry 3779 (class 2604 OID 40447)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2015_01 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3781 (class 2604 OID 40473)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2015_02 ALTER COLUMN id SET DEFAULT nextval('seq_stl_query_id'::regclass);


--
-- TOC entry 3782 (class 2604 OID 40474)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2015_02 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3784 (class 2604 OID 40482)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2015_03 ALTER COLUMN id SET DEFAULT nextval('seq_stl_query_id'::regclass);


--
-- TOC entry 3785 (class 2604 OID 40483)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2015_03 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3787 (class 2604 OID 40491)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2015_04 ALTER COLUMN id SET DEFAULT nextval('seq_stl_query_id'::regclass);


--
-- TOC entry 3788 (class 2604 OID 40492)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2015_04 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3790 (class 2604 OID 40500)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2015_05 ALTER COLUMN id SET DEFAULT nextval('seq_stl_query_id'::regclass);


--
-- TOC entry 3791 (class 2604 OID 40501)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2015_05 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3793 (class 2604 OID 40509)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2015_06 ALTER COLUMN id SET DEFAULT nextval('seq_stl_query_id'::regclass);


--
-- TOC entry 3794 (class 2604 OID 40510)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2015_06 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3796 (class 2604 OID 40518)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2015_07 ALTER COLUMN id SET DEFAULT nextval('seq_stl_query_id'::regclass);


--
-- TOC entry 3797 (class 2604 OID 40519)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2015_07 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3799 (class 2604 OID 40527)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2015_08 ALTER COLUMN id SET DEFAULT nextval('seq_stl_query_id'::regclass);


--
-- TOC entry 3800 (class 2604 OID 40528)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2015_08 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3802 (class 2604 OID 40536)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2015_09 ALTER COLUMN id SET DEFAULT nextval('seq_stl_query_id'::regclass);


--
-- TOC entry 3803 (class 2604 OID 40537)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2015_09 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3805 (class 2604 OID 40545)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2015_10 ALTER COLUMN id SET DEFAULT nextval('seq_stl_query_id'::regclass);


--
-- TOC entry 3806 (class 2604 OID 40546)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2015_10 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3808 (class 2604 OID 40554)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2015_11 ALTER COLUMN id SET DEFAULT nextval('seq_stl_query_id'::regclass);


--
-- TOC entry 3809 (class 2604 OID 40555)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2015_11 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3811 (class 2604 OID 40564)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2015_12 ALTER COLUMN id SET DEFAULT nextval('seq_stl_query_id'::regclass);


--
-- TOC entry 3812 (class 2604 OID 40565)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2015_12 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3814 (class 2604 OID 40573)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2016_01 ALTER COLUMN id SET DEFAULT nextval('seq_stl_query_id'::regclass);


--
-- TOC entry 3815 (class 2604 OID 40574)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2016_01 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3817 (class 2604 OID 40582)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2016_02 ALTER COLUMN id SET DEFAULT nextval('seq_stl_query_id'::regclass);


--
-- TOC entry 3818 (class 2604 OID 40583)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2016_02 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3820 (class 2604 OID 40591)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2016_03 ALTER COLUMN id SET DEFAULT nextval('seq_stl_query_id'::regclass);


--
-- TOC entry 3821 (class 2604 OID 40592)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2016_03 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3869 (class 2604 OID 43801)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2016_04 ALTER COLUMN id SET DEFAULT nextval('seq_stl_query_id'::regclass);


--
-- TOC entry 3870 (class 2604 OID 43802)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2016_04 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3823 (class 2604 OID 40605)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2016_05 ALTER COLUMN id SET DEFAULT nextval('seq_stl_query_id'::regclass);


--
-- TOC entry 3824 (class 2604 OID 40606)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2016_05 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3826 (class 2604 OID 40614)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2016_06 ALTER COLUMN id SET DEFAULT nextval('seq_stl_query_id'::regclass);


--
-- TOC entry 3827 (class 2604 OID 40615)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2016_06 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3829 (class 2604 OID 40633)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2016_07 ALTER COLUMN id SET DEFAULT nextval('seq_stl_query_id'::regclass);


--
-- TOC entry 3830 (class 2604 OID 40634)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2016_07 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3832 (class 2604 OID 40643)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2016_08 ALTER COLUMN id SET DEFAULT nextval('seq_stl_query_id'::regclass);


--
-- TOC entry 3833 (class 2604 OID 40644)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2016_08 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3835 (class 2604 OID 40652)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2016_09 ALTER COLUMN id SET DEFAULT nextval('seq_stl_query_id'::regclass);


--
-- TOC entry 3836 (class 2604 OID 40653)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2016_09 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3838 (class 2604 OID 40661)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2016_10 ALTER COLUMN id SET DEFAULT nextval('seq_stl_query_id'::regclass);


--
-- TOC entry 3839 (class 2604 OID 40662)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2016_10 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3841 (class 2604 OID 40670)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2016_11 ALTER COLUMN id SET DEFAULT nextval('seq_stl_query_id'::regclass);


--
-- TOC entry 3842 (class 2604 OID 40671)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2016_11 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3844 (class 2604 OID 40679)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2016_12 ALTER COLUMN id SET DEFAULT nextval('seq_stl_query_id'::regclass);


--
-- TOC entry 3845 (class 2604 OID 40680)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_query_2016_12 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3849 (class 2604 OID 42089)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_wlm_query_2016_01 ALTER COLUMN id SET DEFAULT nextval('seq_stl_wlm_query'::regclass);


--
-- TOC entry 3850 (class 2604 OID 42090)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_wlm_query_2016_01 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3852 (class 2604 OID 42095)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_wlm_query_2016_02 ALTER COLUMN id SET DEFAULT nextval('seq_stl_wlm_query'::regclass);


--
-- TOC entry 3853 (class 2604 OID 42096)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_wlm_query_2016_02 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3855 (class 2604 OID 42101)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_wlm_query_2016_03 ALTER COLUMN id SET DEFAULT nextval('seq_stl_wlm_query'::regclass);


--
-- TOC entry 3856 (class 2604 OID 42102)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_wlm_query_2016_03 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3872 (class 2604 OID 43813)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_wlm_query_2016_04 ALTER COLUMN id SET DEFAULT nextval('seq_stl_wlm_query'::regclass);


--
-- TOC entry 3873 (class 2604 OID 43814)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_wlm_query_2016_04 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3875 (class 2604 OID 43819)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_wlm_query_2016_05 ALTER COLUMN id SET DEFAULT nextval('seq_stl_wlm_query'::regclass);


--
-- TOC entry 3876 (class 2604 OID 43820)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_wlm_query_2016_05 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3878 (class 2604 OID 43825)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_wlm_query_2016_06 ALTER COLUMN id SET DEFAULT nextval('seq_stl_wlm_query'::regclass);


--
-- TOC entry 3879 (class 2604 OID 43826)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_wlm_query_2016_06 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3941 (class 2604 OID 52189)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_wlm_query_2016_07 ALTER COLUMN id SET DEFAULT nextval('seq_stl_wlm_query'::regclass);


--
-- TOC entry 3942 (class 2604 OID 52190)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_wlm_query_2016_07 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3944 (class 2604 OID 52195)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_wlm_query_2016_08 ALTER COLUMN id SET DEFAULT nextval('seq_stl_wlm_query'::regclass);


--
-- TOC entry 3945 (class 2604 OID 52196)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_wlm_query_2016_08 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3947 (class 2604 OID 52201)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_wlm_query_2016_09 ALTER COLUMN id SET DEFAULT nextval('seq_stl_wlm_query'::regclass);


--
-- TOC entry 3948 (class 2604 OID 52202)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_wlm_query_2016_09 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3950 (class 2604 OID 52207)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_wlm_query_2016_10 ALTER COLUMN id SET DEFAULT nextval('seq_stl_wlm_query'::regclass);


--
-- TOC entry 3951 (class 2604 OID 52208)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_wlm_query_2016_10 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3953 (class 2604 OID 52213)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_wlm_query_2016_11 ALTER COLUMN id SET DEFAULT nextval('seq_stl_wlm_query'::regclass);


--
-- TOC entry 3954 (class 2604 OID 52214)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_wlm_query_2016_11 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3956 (class 2604 OID 52219)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_wlm_query_2016_12 ALTER COLUMN id SET DEFAULT nextval('seq_stl_wlm_query'::regclass);


--
-- TOC entry 3957 (class 2604 OID 52220)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY stl_wlm_query_2016_12 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3860 (class 2604 OID 42188)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY svl_query_summary_2016_02 ALTER COLUMN id SET DEFAULT nextval('seq_svl_query_summary_id'::regclass);


--
-- TOC entry 3861 (class 2604 OID 42189)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY svl_query_summary_2016_02 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3863 (class 2604 OID 42194)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY svl_query_summary_2016_03 ALTER COLUMN id SET DEFAULT nextval('seq_svl_query_summary_id'::regclass);


--
-- TOC entry 3864 (class 2604 OID 42195)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY svl_query_summary_2016_03 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3866 (class 2604 OID 42200)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY svl_query_summary_2016_04 ALTER COLUMN id SET DEFAULT nextval('seq_svl_query_summary_id'::regclass);


--
-- TOC entry 3867 (class 2604 OID 42201)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY svl_query_summary_2016_04 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3887 (class 2604 OID 44158)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY svl_query_summary_2016_05 ALTER COLUMN id SET DEFAULT nextval('seq_svl_query_summary_id'::regclass);


--
-- TOC entry 3888 (class 2604 OID 44159)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY svl_query_summary_2016_05 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3890 (class 2604 OID 44165)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY svl_query_summary_2016_06 ALTER COLUMN id SET DEFAULT nextval('seq_svl_query_summary_id'::regclass);


--
-- TOC entry 3891 (class 2604 OID 44166)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY svl_query_summary_2016_06 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3893 (class 2604 OID 44172)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY svl_query_summary_2016_07 ALTER COLUMN id SET DEFAULT nextval('seq_svl_query_summary_id'::regclass);


--
-- TOC entry 3894 (class 2604 OID 44173)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY svl_query_summary_2016_07 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3896 (class 2604 OID 44179)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY svl_query_summary_2016_08 ALTER COLUMN id SET DEFAULT nextval('seq_svl_query_summary_id'::regclass);


--
-- TOC entry 3897 (class 2604 OID 44180)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY svl_query_summary_2016_08 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3899 (class 2604 OID 44186)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY svl_query_summary_2016_09 ALTER COLUMN id SET DEFAULT nextval('seq_svl_query_summary_id'::regclass);


--
-- TOC entry 3900 (class 2604 OID 44187)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY svl_query_summary_2016_09 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3902 (class 2604 OID 44193)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY svl_query_summary_2016_10 ALTER COLUMN id SET DEFAULT nextval('seq_svl_query_summary_id'::regclass);


--
-- TOC entry 3903 (class 2604 OID 44194)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY svl_query_summary_2016_10 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3905 (class 2604 OID 44200)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY svl_query_summary_2016_11 ALTER COLUMN id SET DEFAULT nextval('seq_svl_query_summary_id'::regclass);


--
-- TOC entry 3906 (class 2604 OID 44201)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY svl_query_summary_2016_11 ALTER COLUMN datetimestamp SET DEFAULT now();


--
-- TOC entry 3908 (class 2604 OID 44207)
-- Name: id; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY svl_query_summary_2016_12 ALTER COLUMN id SET DEFAULT nextval('seq_svl_query_summary_id'::regclass);


--
-- TOC entry 3909 (class 2604 OID 44208)
-- Name: datetimestamp; Type: DEFAULT; Schema: amstgmgr; Owner: pgadmin
--

ALTER TABLE ONLY svl_query_summary_2016_12 ALTER COLUMN datetimestamp SET DEFAULT now();

ALTER TABLE ONLY stl_query
    ADD CONSTRAINT pk_stl_query_id PRIMARY KEY (id);
	
ALTER TABLE ONLY stl_wlm_query
    ADD CONSTRAINT pk_stl_wlm_query_id PRIMARY KEY (id);


ALTER TABLE ONLY svl_query_summary
    ADD CONSTRAINT pk_svl_query_summary_prt PRIMARY KEY (id);


--
-- TOC entry 4050 (class 1259 OID 43908)
-- Name: ix_stage_datapoints_1180k_1190k_request_id; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stage_datapoints_1180k_1190k_request_id ON stage_rsh_cloudwatch_datapoints_1180k_1190k USING btree (request_id);


--
-- TOC entry 4060 (class 1259 OID 44226)
-- Name: ix_stage_datapoints_1190k_1200k_request_id; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stage_datapoints_1190k_1200k_request_id ON stage_rsh_cloudwatch_datapoints_1190k_1200k USING btree (request_id);


--
-- TOC entry 4062 (class 1259 OID 44664)
-- Name: ix_stage_datapoints_1200k_1300k_request_id; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stage_datapoints_1200k_1300k_request_id ON stage_rsh_cloudwatch_datapoints_1200k_1300k USING btree (request_id);


--
-- TOC entry 4064 (class 1259 OID 44675)
-- Name: ix_stage_datapoints_1300k_1400k_request_id; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stage_datapoints_1300k_1400k_request_id ON stage_rsh_cloudwatch_datapoints_1300k_1400k USING btree (request_id);


--
-- TOC entry 4066 (class 1259 OID 44686)
-- Name: ix_stage_datapoints_1400k_1500k_request_id; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stage_datapoints_1400k_1500k_request_id ON stage_rsh_cloudwatch_datapoints_1400k_1500k USING btree (request_id);


--
-- TOC entry 3984 (class 1259 OID 21296)
-- Name: ix_stage_datapoints_m_r; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stage_datapoints_m_r ON stage_rsh_cloudwatch_datapoints USING btree (metric_id, resource_id, unit);


--
-- TOC entry 4051 (class 1259 OID 43909)
-- Name: ix_stage_rsh_cloudwatch_datapoints_1180k_1190k_timestamp; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stage_rsh_cloudwatch_datapoints_1180k_1190k_timestamp ON stage_rsh_cloudwatch_datapoints_1180k_1190k USING btree ("timestamp");


--
-- TOC entry 4061 (class 1259 OID 44227)
-- Name: ix_stage_rsh_cloudwatch_datapoints_1190k_1200k_timestamp; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stage_rsh_cloudwatch_datapoints_1190k_1200k_timestamp ON stage_rsh_cloudwatch_datapoints_1190k_1200k USING btree ("timestamp");


--
-- TOC entry 4063 (class 1259 OID 44665)
-- Name: ix_stage_rsh_cloudwatch_datapoints_1200k_1300k_timestamp; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stage_rsh_cloudwatch_datapoints_1200k_1300k_timestamp ON stage_rsh_cloudwatch_datapoints_1200k_1300k USING btree ("timestamp");


--
-- TOC entry 4065 (class 1259 OID 44676)
-- Name: ix_stage_rsh_cloudwatch_datapoints_1300k_1400k_timestamp; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stage_rsh_cloudwatch_datapoints_1300k_1400k_timestamp ON stage_rsh_cloudwatch_datapoints_1300k_1400k USING btree ("timestamp");


--
-- TOC entry 4067 (class 1259 OID 44687)
-- Name: ix_stage_rsh_cloudwatch_datapoints_1400k_1500k_timestamp; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stage_rsh_cloudwatch_datapoints_1400k_1500k_timestamp ON stage_rsh_cloudwatch_datapoints_1400k_1500k USING btree ("timestamp");


--
-- TOC entry 3985 (class 1259 OID 17870)
-- Name: ix_stage_rsh_cloudwatch_datapoints_request_id; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stage_rsh_cloudwatch_datapoints_request_id ON stage_rsh_cloudwatch_datapoints USING btree (request_id);


	CREATE INDEX ix_stl_query_2015_01_resource_id ON stl_query_2015_01 USING btree (resource_id);


--
-- TOC entry 3997 (class 1259 OID 40736)
-- Name: ix_stl_query_2015_01_userid; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2015_01_userid ON stl_query_2015_01 USING btree (userid);


--
-- TOC entry 3998 (class 1259 OID 40737)
-- Name: ix_stl_query_2015_02_resource_id; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2015_02_resource_id ON stl_query_2015_02 USING btree (resource_id);


--
-- TOC entry 3999 (class 1259 OID 40738)
-- Name: ix_stl_query_2015_02_userid; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2015_02_userid ON stl_query_2015_02 USING btree (userid);


--
-- TOC entry 4000 (class 1259 OID 40741)
-- Name: ix_stl_query_2015_03_resource_id; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2015_03_resource_id ON stl_query_2015_03 USING btree (resource_id);


--
-- TOC entry 4001 (class 1259 OID 40742)
-- Name: ix_stl_query_2015_03_userid; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2015_03_userid ON stl_query_2015_03 USING btree (userid);


--
-- TOC entry 4002 (class 1259 OID 40743)
-- Name: ix_stl_query_2015_04_resource_id; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2015_04_resource_id ON stl_query_2015_04 USING btree (resource_id);


--
-- TOC entry 4003 (class 1259 OID 40744)
-- Name: ix_stl_query_2015_04_userid; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2015_04_userid ON stl_query_2015_04 USING btree (userid);


--
-- TOC entry 4004 (class 1259 OID 40745)
-- Name: ix_stl_query_2015_05_resource_id; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2015_05_resource_id ON stl_query_2015_05 USING btree (resource_id);


--
-- TOC entry 4005 (class 1259 OID 40746)
-- Name: ix_stl_query_2015_05_userid; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2015_05_userid ON stl_query_2015_05 USING btree (userid);


--
-- TOC entry 4006 (class 1259 OID 40751)
-- Name: ix_stl_query_2015_06_resource_id; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2015_06_resource_id ON stl_query_2015_06 USING btree (resource_id);


--
-- TOC entry 4007 (class 1259 OID 40752)
-- Name: ix_stl_query_2015_06_userid; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2015_06_userid ON stl_query_2015_06 USING btree (userid);


--
-- TOC entry 4008 (class 1259 OID 40753)
-- Name: ix_stl_query_2015_07_resource_id; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2015_07_resource_id ON stl_query_2015_07 USING btree (resource_id);


--
-- TOC entry 4009 (class 1259 OID 40754)
-- Name: ix_stl_query_2015_07_userid; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2015_07_userid ON stl_query_2015_07 USING btree (userid);


--
-- TOC entry 4010 (class 1259 OID 40755)
-- Name: ix_stl_query_2015_08_resource_id; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2015_08_resource_id ON stl_query_2015_08 USING btree (resource_id);


--
-- TOC entry 4011 (class 1259 OID 40756)
-- Name: ix_stl_query_2015_08_userid; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2015_08_userid ON stl_query_2015_08 USING btree (userid);


--
-- TOC entry 4012 (class 1259 OID 40757)
-- Name: ix_stl_query_2015_09_resource_id; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2015_09_resource_id ON stl_query_2015_09 USING btree (resource_id);


--
-- TOC entry 4013 (class 1259 OID 40759)
-- Name: ix_stl_query_2015_09_userid; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2015_09_userid ON stl_query_2015_09 USING btree (userid);


--
-- TOC entry 4014 (class 1259 OID 40760)
-- Name: ix_stl_query_2015_10_resource_id; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2015_10_resource_id ON stl_query_2015_10 USING btree (resource_id);


--
-- TOC entry 4015 (class 1259 OID 40763)
-- Name: ix_stl_query_2015_10_userid; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2015_10_userid ON stl_query_2015_10 USING btree (userid);


--
-- TOC entry 4016 (class 1259 OID 40775)
-- Name: ix_stl_query_2015_11_resource_id; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2015_11_resource_id ON stl_query_2015_11 USING btree (resource_id);


--
-- TOC entry 4017 (class 1259 OID 40776)
-- Name: ix_stl_query_2015_11_userid; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2015_11_userid ON stl_query_2015_11 USING btree (userid);


--
-- TOC entry 4018 (class 1259 OID 40777)
-- Name: ix_stl_query_2015_12_resource_id; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2015_12_resource_id ON stl_query_2015_12 USING btree (resource_id);


--
-- TOC entry 4019 (class 1259 OID 40778)
-- Name: ix_stl_query_2015_12_userid; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2015_12_userid ON stl_query_2015_12 USING btree (userid);


--
-- TOC entry 4020 (class 1259 OID 40779)
-- Name: ix_stl_query_2016_01_resource_id; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2016_01_resource_id ON stl_query_2016_01 USING btree (resource_id);


--
-- TOC entry 4021 (class 1259 OID 40780)
-- Name: ix_stl_query_2016_01_userid; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2016_01_userid ON stl_query_2016_01 USING btree (userid);


--
-- TOC entry 4022 (class 1259 OID 42017)
-- Name: ix_stl_query_2016_02_query; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2016_02_query ON stl_query_2016_02 USING btree (query);


--
-- TOC entry 4023 (class 1259 OID 41978)
-- Name: ix_stl_query_2016_02_resource_id; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2016_02_resource_id ON stl_query_2016_02 USING btree (resource_id);


--
-- TOC entry 4024 (class 1259 OID 43581)
-- Name: ix_stl_query_2016_03_pid; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2016_03_pid ON stl_query_2016_03 USING btree (pid);


--
-- TOC entry 4025 (class 1259 OID 43482)
-- Name: ix_stl_query_2016_03_query; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2016_03_query ON stl_query_2016_03 USING btree (query);


--
-- TOC entry 4026 (class 1259 OID 43483)
-- Name: ix_stl_query_2016_03_resource_id; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2016_03_resource_id ON stl_query_2016_03 USING btree (resource_id);


--
-- TOC entry 4043 (class 1259 OID 43807)
-- Name: ix_stl_query_2016_04_pid; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2016_04_pid ON stl_query_2016_04 USING btree (pid);


--
-- TOC entry 4044 (class 1259 OID 43808)
-- Name: ix_stl_query_2016_04_query; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2016_04_query ON stl_query_2016_04 USING btree (query);


--
-- TOC entry 4045 (class 1259 OID 43809)
-- Name: ix_stl_query_2016_04_resource_id; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2016_04_resource_id ON stl_query_2016_04 USING btree (resource_id);


--
-- TOC entry 4027 (class 1259 OID 44508)
-- Name: ix_stl_query_2016_05_pid; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2016_05_pid ON stl_query_2016_05 USING btree (pid);


--
-- TOC entry 4028 (class 1259 OID 44509)
-- Name: ix_stl_query_2016_05_query; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2016_05_query ON stl_query_2016_05 USING btree (query);


--
-- TOC entry 4029 (class 1259 OID 44510)
-- Name: ix_stl_query_2016_05_resource_id; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_query_2016_05_resource_id ON stl_query_2016_05 USING btree (resource_id);





CREATE INDEX ix_stl_query_userid ON stl_query USING btree (userid);


--
-- TOC entry 3961 (class 1259 OID 44276)
-- Name: ix_stl_s3client_query; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_s3client_query ON stl_s3client USING btree (query);


--
-- TOC entry 3962 (class 1259 OID 44275)
-- Name: ix_stl_s3client_resource_id; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_s3client_resource_id ON stl_s3client USING btree (resource_id);


CREATE INDEX ix_stl_wlm_query_2016_01_rs_query ON stl_wlm_query_2016_01 USING btree (resource_id, query);


--
-- TOC entry 4033 (class 1259 OID 44423)
-- Name: ix_stl_wlm_query_2016_01_userid; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_wlm_query_2016_01_userid ON stl_wlm_query_2016_01 USING btree (userid);


--
-- TOC entry 4034 (class 1259 OID 44416)
-- Name: ix_stl_wlm_query_2016_02_rs_query; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_wlm_query_2016_02_rs_query ON stl_wlm_query_2016_02 USING btree (resource_id, query);


--
-- TOC entry 4035 (class 1259 OID 44422)
-- Name: ix_stl_wlm_query_2016_02_userid; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_wlm_query_2016_02_userid ON stl_wlm_query_2016_02 USING btree (userid);


--
-- TOC entry 4036 (class 1259 OID 44417)
-- Name: ix_stl_wlm_query_2016_03_rs_query; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_wlm_query_2016_03_rs_query ON stl_wlm_query_2016_03 USING btree (resource_id, query);


--
-- TOC entry 4037 (class 1259 OID 44421)
-- Name: ix_stl_wlm_query_2016_03_userid; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_wlm_query_2016_03_userid ON stl_wlm_query_2016_03 USING btree (userid);


--
-- TOC entry 4046 (class 1259 OID 44413)
-- Name: ix_stl_wlm_query_2016_04_rs_query; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_wlm_query_2016_04_rs_query ON stl_wlm_query_2016_04 USING btree (resource_id, query);


--
-- TOC entry 4047 (class 1259 OID 44420)
-- Name: ix_stl_wlm_query_2016_04_userid; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_wlm_query_2016_04_userid ON stl_wlm_query_2016_04 USING btree (userid);


--
-- TOC entry 4048 (class 1259 OID 44418)
-- Name: ix_stl_wlm_query_2016_05_rs_query; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_wlm_query_2016_05_rs_query ON stl_wlm_query_2016_05 USING btree (resource_id, query);


--
-- TOC entry 4049 (class 1259 OID 44419)
-- Name: ix_stl_wlm_query_2016_05_userid; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_stl_wlm_query_2016_05_userid ON stl_wlm_query_2016_05 USING btree (userid);


--
-- TOC entry 4040 (class 1259 OID 42210)
-- Name: ix_svl_query_summary_2016_02_query; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_svl_query_summary_2016_02_query ON svl_query_summary_2016_02 USING btree (query);


--
-- TOC entry 4041 (class 1259 OID 42209)
-- Name: ix_svl_query_summary_2016_03_query; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_svl_query_summary_2016_03_query ON svl_query_summary_2016_03 USING btree (query);


--
-- TOC entry 4042 (class 1259 OID 44054)
-- Name: ix_svl_query_summary_2016_04_query; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_svl_query_summary_2016_04_query ON svl_query_summary_2016_04 USING btree (query);


--
-- TOC entry 4052 (class 1259 OID 44161)
-- Name: ix_svl_query_summary_2016_05_query; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_svl_query_summary_2016_05_query ON svl_query_summary_2016_05 USING btree (query);


--
-- TOC entry 4053 (class 1259 OID 44168)
-- Name: ix_svl_query_summary_2016_06_query; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_svl_query_summary_2016_06_query ON svl_query_summary_2016_06 USING btree (query);


--
-- TOC entry 4054 (class 1259 OID 44175)
-- Name: ix_svl_query_summary_2016_07_query; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_svl_query_summary_2016_07_query ON svl_query_summary_2016_07 USING btree (query);


--
-- TOC entry 4055 (class 1259 OID 44182)
-- Name: ix_svl_query_summary_2016_08_query; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_svl_query_summary_2016_08_query ON svl_query_summary_2016_08 USING btree (query);


--
-- TOC entry 4056 (class 1259 OID 44189)
-- Name: ix_svl_query_summary_2016_09_query; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_svl_query_summary_2016_09_query ON svl_query_summary_2016_09 USING btree (query);


--
-- TOC entry 4057 (class 1259 OID 44196)
-- Name: ix_svl_query_summary_2016_10_query; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_svl_query_summary_2016_10_query ON svl_query_summary_2016_10 USING btree (query);


--
-- TOC entry 4058 (class 1259 OID 44203)
-- Name: ix_svl_query_summary_2016_11_query; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_svl_query_summary_2016_11_query ON svl_query_summary_2016_11 USING btree (query);


--
-- TOC entry 4059 (class 1259 OID 44210)
-- Name: ix_svl_query_summary_2016_12_query; Type: INDEX; Schema: amstgmgr; Owner: pgadmin; Tablespace: 
--

CREATE INDEX ix_svl_query_summary_2016_12_query ON svl_query_summary_2016_12 USING btree (query);


--
-- TOC entry 4068 (class 2620 OID 17945)
-- Name: tr_stage_rsh_cloudwatch_datapoints_insert_trigger; Type: TRIGGER; Schema: amstgmgr; Owner: pgadmin
--

CREATE TRIGGER tr_stage_rsh_cloudwatch_datapoints_insert_trigger BEFORE INSERT ON stage_rsh_cloudwatch_datapoints FOR EACH ROW EXECUTE PROCEDURE p_stage_rsh_cloudwatch_datapoints_insert_trigger();


--
-- TOC entry 4069 (class 2620 OID 40686)
-- Name: tr_stage_stl_query_insert_trigger; Type: TRIGGER; Schema: amstgmgr; Owner: pgadmin
--

CREATE TRIGGER tr_stage_stl_query_insert_trigger BEFORE INSERT ON stl_query FOR EACH ROW EXECUTE PROCEDURE p_stage_rsh_stl_query_insert_trigger();


--
-- TOC entry 4070 (class 2620 OID 42104)
-- Name: tr_stage_stl_wlm_query_insert_trigger; Type: TRIGGER; Schema: amstgmgr; Owner: pgadmin
--

CREATE TRIGGER tr_stage_stl_wlm_query_insert_trigger BEFORE INSERT ON stl_wlm_query FOR EACH ROW EXECUTE PROCEDURE p_stage_rsh_stl_wlm_query_insert_trigger();


--
-- TOC entry 4071 (class 2620 OID 42205)
-- Name: tr_stage_svl_query_summary_insert_trigger; Type: TRIGGER; Schema: amstgmgr; Owner: pgadmin
--

CREATE TRIGGER tr_stage_svl_query_summary_insert_trigger BEFORE INSERT ON svl_query_summary FOR EACH ROW EXECUTE PROCEDURE p_stage_rsh_svl_query_summary_insert_trigger();


--
-- TOC entry 4184 (class 0 OID 0)
-- Dependencies: 19
-- Name: amstgmgr; Type: ACL; Schema: -; Owner: pgadmin
--

REVOKE ALL ON SCHEMA amstgmgr FROM PUBLIC;
REVOKE ALL ON SCHEMA amstgmgr FROM pgadmin;
GRANT ALL ON SCHEMA amstgmgr TO pgadmin;
GRANT USAGE ON SCHEMA amstgmgr TO gr_report_perfmon;


--
-- TOC entry 4185 (class 0 OID 0)
-- Dependencies: 300
-- Name: pg_namespace; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE pg_namespace FROM PUBLIC;
REVOKE ALL ON TABLE pg_namespace FROM pgadmin;
GRANT ALL ON TABLE pg_namespace TO pgadmin;
GRANT SELECT ON TABLE pg_namespace TO gr_report_perfmon;


--
-- TOC entry 4186 (class 0 OID 0)
-- Dependencies: 301
-- Name: pg_user; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE pg_user FROM PUBLIC;
REVOKE ALL ON TABLE pg_user FROM pgadmin;
GRANT ALL ON TABLE pg_user TO pgadmin;
GRANT SELECT ON TABLE pg_user TO gr_report_perfmon;


--
-- TOC entry 4187 (class 0 OID 0)
-- Dependencies: 272
-- Name: stage_rsh_cloudwatch_datapoints; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stage_rsh_cloudwatch_datapoints FROM PUBLIC;
REVOKE ALL ON TABLE stage_rsh_cloudwatch_datapoints FROM pgadmin;
GRANT ALL ON TABLE stage_rsh_cloudwatch_datapoints TO pgadmin;
GRANT SELECT ON TABLE stage_rsh_cloudwatch_datapoints TO gr_report_perfmon;


--
-- TOC entry 4188 (class 0 OID 0)
-- Dependencies: 466
-- Name: stage_rsh_cloudwatch_datapoints_1180k_1190k; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stage_rsh_cloudwatch_datapoints_1180k_1190k FROM PUBLIC;
REVOKE ALL ON TABLE stage_rsh_cloudwatch_datapoints_1180k_1190k FROM pgadmin;
GRANT ALL ON TABLE stage_rsh_cloudwatch_datapoints_1180k_1190k TO pgadmin;
GRANT SELECT ON TABLE stage_rsh_cloudwatch_datapoints_1180k_1190k TO gr_report_perfmon;


--
-- TOC entry 4189 (class 0 OID 0)
-- Dependencies: 478
-- Name: stage_rsh_cloudwatch_datapoints_1190k_1200k; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stage_rsh_cloudwatch_datapoints_1190k_1200k FROM PUBLIC;
REVOKE ALL ON TABLE stage_rsh_cloudwatch_datapoints_1190k_1200k FROM pgadmin;
GRANT ALL ON TABLE stage_rsh_cloudwatch_datapoints_1190k_1200k TO pgadmin;
GRANT SELECT ON TABLE stage_rsh_cloudwatch_datapoints_1190k_1200k TO gr_report_perfmon;


--
-- TOC entry 4190 (class 0 OID 0)
-- Dependencies: 482
-- Name: stage_rsh_cloudwatch_datapoints_1200k_1300k; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stage_rsh_cloudwatch_datapoints_1200k_1300k FROM PUBLIC;
REVOKE ALL ON TABLE stage_rsh_cloudwatch_datapoints_1200k_1300k FROM pgadmin;
GRANT ALL ON TABLE stage_rsh_cloudwatch_datapoints_1200k_1300k TO pgadmin;
GRANT SELECT ON TABLE stage_rsh_cloudwatch_datapoints_1200k_1300k TO gr_report_perfmon;


--
-- TOC entry 4191 (class 0 OID 0)
-- Dependencies: 483
-- Name: stage_rsh_cloudwatch_datapoints_1300k_1400k; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stage_rsh_cloudwatch_datapoints_1300k_1400k FROM PUBLIC;
REVOKE ALL ON TABLE stage_rsh_cloudwatch_datapoints_1300k_1400k FROM pgadmin;
GRANT ALL ON TABLE stage_rsh_cloudwatch_datapoints_1300k_1400k TO pgadmin;
GRANT SELECT ON TABLE stage_rsh_cloudwatch_datapoints_1300k_1400k TO gr_report_perfmon;


--
-- TOC entry 4192 (class 0 OID 0)
-- Dependencies: 484
-- Name: stage_rsh_cloudwatch_datapoints_1400k_1500k; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stage_rsh_cloudwatch_datapoints_1400k_1500k FROM PUBLIC;
REVOKE ALL ON TABLE stage_rsh_cloudwatch_datapoints_1400k_1500k FROM pgadmin;
GRANT ALL ON TABLE stage_rsh_cloudwatch_datapoints_1400k_1500k TO pgadmin;
GRANT SELECT ON TABLE stage_rsh_cloudwatch_datapoints_1400k_1500k TO gr_report_perfmon;


--
-- TOC entry 4193 (class 0 OID 0)
-- Dependencies: 479
-- Name: stage_rsh_cloudwatch_datapoints_1_1180k; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stage_rsh_cloudwatch_datapoints_1_1180k FROM PUBLIC;
REVOKE ALL ON TABLE stage_rsh_cloudwatch_datapoints_1_1180k FROM pgadmin;
GRANT ALL ON TABLE stage_rsh_cloudwatch_datapoints_1_1180k TO pgadmin;
GRANT SELECT ON TABLE stage_rsh_cloudwatch_datapoints_1_1180k TO gr_report_perfmon;


REVOKE ALL ON TABLE stl_query_2015_01 FROM PUBLIC;
REVOKE ALL ON TABLE stl_query_2015_01 FROM pgadmin;
GRANT ALL ON TABLE stl_query_2015_01 TO pgadmin;
GRANT SELECT ON TABLE stl_query_2015_01 TO gr_report_perfmon;


--
-- TOC entry 4207 (class 0 OID 0)
-- Dependencies: 420
-- Name: stl_query_2015_02; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_query_2015_02 FROM PUBLIC;
REVOKE ALL ON TABLE stl_query_2015_02 FROM pgadmin;
GRANT ALL ON TABLE stl_query_2015_02 TO pgadmin;
GRANT SELECT ON TABLE stl_query_2015_02 TO gr_report_perfmon;


--
-- TOC entry 4208 (class 0 OID 0)
-- Dependencies: 421
-- Name: stl_query_2015_03; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_query_2015_03 FROM PUBLIC;
REVOKE ALL ON TABLE stl_query_2015_03 FROM pgadmin;
GRANT ALL ON TABLE stl_query_2015_03 TO pgadmin;
GRANT SELECT ON TABLE stl_query_2015_03 TO gr_report_perfmon;


--
-- TOC entry 4209 (class 0 OID 0)
-- Dependencies: 422
-- Name: stl_query_2015_04; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_query_2015_04 FROM PUBLIC;
REVOKE ALL ON TABLE stl_query_2015_04 FROM pgadmin;
GRANT ALL ON TABLE stl_query_2015_04 TO pgadmin;
GRANT SELECT ON TABLE stl_query_2015_04 TO gr_report_perfmon;


--
-- TOC entry 4210 (class 0 OID 0)
-- Dependencies: 423
-- Name: stl_query_2015_05; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_query_2015_05 FROM PUBLIC;
REVOKE ALL ON TABLE stl_query_2015_05 FROM pgadmin;
GRANT ALL ON TABLE stl_query_2015_05 TO pgadmin;
GRANT SELECT ON TABLE stl_query_2015_05 TO gr_report_perfmon;


--
-- TOC entry 4211 (class 0 OID 0)
-- Dependencies: 424
-- Name: stl_query_2015_06; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_query_2015_06 FROM PUBLIC;
REVOKE ALL ON TABLE stl_query_2015_06 FROM pgadmin;
GRANT ALL ON TABLE stl_query_2015_06 TO pgadmin;
GRANT SELECT ON TABLE stl_query_2015_06 TO gr_report_perfmon;


--
-- TOC entry 4212 (class 0 OID 0)
-- Dependencies: 425
-- Name: stl_query_2015_07; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_query_2015_07 FROM PUBLIC;
REVOKE ALL ON TABLE stl_query_2015_07 FROM pgadmin;
GRANT ALL ON TABLE stl_query_2015_07 TO pgadmin;
GRANT SELECT ON TABLE stl_query_2015_07 TO gr_report_perfmon;


--
-- TOC entry 4213 (class 0 OID 0)
-- Dependencies: 426
-- Name: stl_query_2015_08; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_query_2015_08 FROM PUBLIC;
REVOKE ALL ON TABLE stl_query_2015_08 FROM pgadmin;
GRANT ALL ON TABLE stl_query_2015_08 TO pgadmin;
GRANT SELECT ON TABLE stl_query_2015_08 TO gr_report_perfmon;


--
-- TOC entry 4214 (class 0 OID 0)
-- Dependencies: 427
-- Name: stl_query_2015_09; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_query_2015_09 FROM PUBLIC;
REVOKE ALL ON TABLE stl_query_2015_09 FROM pgadmin;
GRANT ALL ON TABLE stl_query_2015_09 TO pgadmin;
GRANT SELECT ON TABLE stl_query_2015_09 TO gr_report_perfmon;


--
-- TOC entry 4215 (class 0 OID 0)
-- Dependencies: 428
-- Name: stl_query_2015_10; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_query_2015_10 FROM PUBLIC;
REVOKE ALL ON TABLE stl_query_2015_10 FROM pgadmin;
GRANT ALL ON TABLE stl_query_2015_10 TO pgadmin;
GRANT SELECT ON TABLE stl_query_2015_10 TO gr_report_perfmon;


--
-- TOC entry 4216 (class 0 OID 0)
-- Dependencies: 429
-- Name: stl_query_2015_11; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_query_2015_11 FROM PUBLIC;
REVOKE ALL ON TABLE stl_query_2015_11 FROM pgadmin;
GRANT ALL ON TABLE stl_query_2015_11 TO pgadmin;
GRANT SELECT ON TABLE stl_query_2015_11 TO gr_report_perfmon;


--
-- TOC entry 4217 (class 0 OID 0)
-- Dependencies: 430
-- Name: stl_query_2015_12; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_query_2015_12 FROM PUBLIC;
REVOKE ALL ON TABLE stl_query_2015_12 FROM pgadmin;
GRANT ALL ON TABLE stl_query_2015_12 TO pgadmin;
GRANT SELECT ON TABLE stl_query_2015_12 TO gr_report_perfmon;


--
-- TOC entry 4218 (class 0 OID 0)
-- Dependencies: 431
-- Name: stl_query_2016_01; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_query_2016_01 FROM PUBLIC;
REVOKE ALL ON TABLE stl_query_2016_01 FROM pgadmin;
GRANT ALL ON TABLE stl_query_2016_01 TO pgadmin;
GRANT SELECT ON TABLE stl_query_2016_01 TO gr_report_perfmon;


--
-- TOC entry 4219 (class 0 OID 0)
-- Dependencies: 432
-- Name: stl_query_2016_02; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_query_2016_02 FROM PUBLIC;
REVOKE ALL ON TABLE stl_query_2016_02 FROM pgadmin;
GRANT ALL ON TABLE stl_query_2016_02 TO pgadmin;
GRANT SELECT ON TABLE stl_query_2016_02 TO gr_report_perfmon;


--
-- TOC entry 4220 (class 0 OID 0)
-- Dependencies: 433
-- Name: stl_query_2016_03; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_query_2016_03 FROM PUBLIC;
REVOKE ALL ON TABLE stl_query_2016_03 FROM pgadmin;
GRANT ALL ON TABLE stl_query_2016_03 TO pgadmin;
GRANT SELECT ON TABLE stl_query_2016_03 TO gr_report_perfmon;


--
-- TOC entry 4221 (class 0 OID 0)
-- Dependencies: 462
-- Name: stl_query_2016_04; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_query_2016_04 FROM PUBLIC;
REVOKE ALL ON TABLE stl_query_2016_04 FROM pgadmin;
GRANT ALL ON TABLE stl_query_2016_04 TO pgadmin;
GRANT SELECT ON TABLE stl_query_2016_04 TO gr_report_perfmon;


--
-- TOC entry 4222 (class 0 OID 0)
-- Dependencies: 434
-- Name: stl_query_2016_05; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_query_2016_05 FROM PUBLIC;
REVOKE ALL ON TABLE stl_query_2016_05 FROM pgadmin;
GRANT ALL ON TABLE stl_query_2016_05 TO pgadmin;
GRANT SELECT ON TABLE stl_query_2016_05 TO gr_report_perfmon;


--
-- TOC entry 4223 (class 0 OID 0)
-- Dependencies: 435
-- Name: stl_query_2016_06; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_query_2016_06 FROM PUBLIC;
REVOKE ALL ON TABLE stl_query_2016_06 FROM pgadmin;
GRANT ALL ON TABLE stl_query_2016_06 TO pgadmin;
GRANT SELECT ON TABLE stl_query_2016_06 TO gr_report_perfmon;


--
-- TOC entry 4224 (class 0 OID 0)
-- Dependencies: 436
-- Name: stl_query_2016_07; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_query_2016_07 FROM PUBLIC;
REVOKE ALL ON TABLE stl_query_2016_07 FROM pgadmin;
GRANT ALL ON TABLE stl_query_2016_07 TO pgadmin;
GRANT SELECT ON TABLE stl_query_2016_07 TO gr_report_perfmon;


--
-- TOC entry 4225 (class 0 OID 0)
-- Dependencies: 437
-- Name: stl_query_2016_08; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_query_2016_08 FROM PUBLIC;
REVOKE ALL ON TABLE stl_query_2016_08 FROM pgadmin;
GRANT ALL ON TABLE stl_query_2016_08 TO pgadmin;
GRANT SELECT ON TABLE stl_query_2016_08 TO gr_report_perfmon;


--
-- TOC entry 4226 (class 0 OID 0)
-- Dependencies: 438
-- Name: stl_query_2016_09; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_query_2016_09 FROM PUBLIC;
REVOKE ALL ON TABLE stl_query_2016_09 FROM pgadmin;
GRANT ALL ON TABLE stl_query_2016_09 TO pgadmin;
GRANT SELECT ON TABLE stl_query_2016_09 TO gr_report_perfmon;


--
-- TOC entry 4227 (class 0 OID 0)
-- Dependencies: 439
-- Name: stl_query_2016_10; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_query_2016_10 FROM PUBLIC;
REVOKE ALL ON TABLE stl_query_2016_10 FROM pgadmin;
GRANT ALL ON TABLE stl_query_2016_10 TO pgadmin;
GRANT SELECT ON TABLE stl_query_2016_10 TO gr_report_perfmon;


--
-- TOC entry 4228 (class 0 OID 0)
-- Dependencies: 440
-- Name: stl_query_2016_11; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_query_2016_11 FROM PUBLIC;
REVOKE ALL ON TABLE stl_query_2016_11 FROM pgadmin;
GRANT ALL ON TABLE stl_query_2016_11 TO pgadmin;
GRANT SELECT ON TABLE stl_query_2016_11 TO gr_report_perfmon;


--
-- TOC entry 4229 (class 0 OID 0)
-- Dependencies: 441
-- Name: stl_query_2016_12; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_query_2016_12 FROM PUBLIC;
REVOKE ALL ON TABLE stl_query_2016_12 FROM pgadmin;
GRANT ALL ON TABLE stl_query_2016_12 TO pgadmin;
GRANT SELECT ON TABLE stl_query_2016_12 TO gr_report_perfmon;


REVOKE ALL ON TABLE stl_wlm_query FROM PUBLIC;
REVOKE ALL ON TABLE stl_wlm_query FROM pgadmin;
GRANT ALL ON TABLE stl_wlm_query TO pgadmin;
GRANT SELECT ON TABLE stl_wlm_query TO gr_report_perfmon;


--
-- TOC entry 4239 (class 0 OID 0)
-- Dependencies: 455
-- Name: stl_wlm_query_2016_01; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_wlm_query_2016_01 FROM PUBLIC;
REVOKE ALL ON TABLE stl_wlm_query_2016_01 FROM pgadmin;
GRANT ALL ON TABLE stl_wlm_query_2016_01 TO pgadmin;
GRANT SELECT ON TABLE stl_wlm_query_2016_01 TO gr_report_perfmon;


--
-- TOC entry 4240 (class 0 OID 0)
-- Dependencies: 456
-- Name: stl_wlm_query_2016_02; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_wlm_query_2016_02 FROM PUBLIC;
REVOKE ALL ON TABLE stl_wlm_query_2016_02 FROM pgadmin;
GRANT ALL ON TABLE stl_wlm_query_2016_02 TO pgadmin;
GRANT SELECT ON TABLE stl_wlm_query_2016_02 TO gr_report_perfmon;


--
-- TOC entry 4241 (class 0 OID 0)
-- Dependencies: 457
-- Name: stl_wlm_query_2016_03; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_wlm_query_2016_03 FROM PUBLIC;
REVOKE ALL ON TABLE stl_wlm_query_2016_03 FROM pgadmin;
GRANT ALL ON TABLE stl_wlm_query_2016_03 TO pgadmin;
GRANT SELECT ON TABLE stl_wlm_query_2016_03 TO gr_report_perfmon;


--
-- TOC entry 4242 (class 0 OID 0)
-- Dependencies: 463
-- Name: stl_wlm_query_2016_04; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_wlm_query_2016_04 FROM PUBLIC;
REVOKE ALL ON TABLE stl_wlm_query_2016_04 FROM pgadmin;
GRANT ALL ON TABLE stl_wlm_query_2016_04 TO pgadmin;
GRANT SELECT ON TABLE stl_wlm_query_2016_04 TO gr_report_perfmon;


--
-- TOC entry 4243 (class 0 OID 0)
-- Dependencies: 464
-- Name: stl_wlm_query_2016_05; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_wlm_query_2016_05 FROM PUBLIC;
REVOKE ALL ON TABLE stl_wlm_query_2016_05 FROM pgadmin;
GRANT ALL ON TABLE stl_wlm_query_2016_05 TO pgadmin;
GRANT SELECT ON TABLE stl_wlm_query_2016_05 TO gr_report_perfmon;


--
-- TOC entry 4244 (class 0 OID 0)
-- Dependencies: 465
-- Name: stl_wlm_query_2016_06; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_wlm_query_2016_06 FROM PUBLIC;
REVOKE ALL ON TABLE stl_wlm_query_2016_06 FROM pgadmin;
GRANT ALL ON TABLE stl_wlm_query_2016_06 TO pgadmin;
GRANT SELECT ON TABLE stl_wlm_query_2016_06 TO gr_report_perfmon;


--
-- TOC entry 4245 (class 0 OID 0)
-- Dependencies: 496
-- Name: stl_wlm_query_2016_07; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_wlm_query_2016_07 FROM PUBLIC;
REVOKE ALL ON TABLE stl_wlm_query_2016_07 FROM pgadmin;
GRANT ALL ON TABLE stl_wlm_query_2016_07 TO pgadmin;
GRANT SELECT ON TABLE stl_wlm_query_2016_07 TO gr_report_perfmon;


--
-- TOC entry 4246 (class 0 OID 0)
-- Dependencies: 497
-- Name: stl_wlm_query_2016_08; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_wlm_query_2016_08 FROM PUBLIC;
REVOKE ALL ON TABLE stl_wlm_query_2016_08 FROM pgadmin;
GRANT ALL ON TABLE stl_wlm_query_2016_08 TO pgadmin;
GRANT SELECT ON TABLE stl_wlm_query_2016_08 TO gr_report_perfmon;


--
-- TOC entry 4247 (class 0 OID 0)
-- Dependencies: 498
-- Name: stl_wlm_query_2016_09; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_wlm_query_2016_09 FROM PUBLIC;
REVOKE ALL ON TABLE stl_wlm_query_2016_09 FROM pgadmin;
GRANT ALL ON TABLE stl_wlm_query_2016_09 TO pgadmin;
GRANT SELECT ON TABLE stl_wlm_query_2016_09 TO gr_report_perfmon;


--
-- TOC entry 4248 (class 0 OID 0)
-- Dependencies: 499
-- Name: stl_wlm_query_2016_10; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_wlm_query_2016_10 FROM PUBLIC;
REVOKE ALL ON TABLE stl_wlm_query_2016_10 FROM pgadmin;
GRANT ALL ON TABLE stl_wlm_query_2016_10 TO pgadmin;
GRANT SELECT ON TABLE stl_wlm_query_2016_10 TO gr_report_perfmon;


--
-- TOC entry 4249 (class 0 OID 0)
-- Dependencies: 500
-- Name: stl_wlm_query_2016_11; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_wlm_query_2016_11 FROM PUBLIC;
REVOKE ALL ON TABLE stl_wlm_query_2016_11 FROM pgadmin;
GRANT ALL ON TABLE stl_wlm_query_2016_11 TO pgadmin;
GRANT SELECT ON TABLE stl_wlm_query_2016_11 TO gr_report_perfmon;


--
-- TOC entry 4250 (class 0 OID 0)
-- Dependencies: 501
-- Name: stl_wlm_query_2016_12; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE stl_wlm_query_2016_12 FROM PUBLIC;
REVOKE ALL ON TABLE stl_wlm_query_2016_12 FROM pgadmin;
GRANT ALL ON TABLE stl_wlm_query_2016_12 TO pgadmin;
GRANT SELECT ON TABLE stl_wlm_query_2016_12 TO gr_report_perfmon;


REVOKE ALL ON TABLE svl_query_summary_2016_02 FROM PUBLIC;
REVOKE ALL ON TABLE svl_query_summary_2016_02 FROM pgadmin;
GRANT ALL ON TABLE svl_query_summary_2016_02 TO pgadmin;
GRANT SELECT ON TABLE svl_query_summary_2016_02 TO gr_report_perfmon;


REVOKE ALL ON TABLE svl_query_summary_2016_03 FROM PUBLIC;
REVOKE ALL ON TABLE svl_query_summary_2016_03 FROM pgadmin;
GRANT ALL ON TABLE svl_query_summary_2016_03 TO pgadmin;
GRANT SELECT ON TABLE svl_query_summary_2016_03 TO gr_report_perfmon;


REVOKE ALL ON TABLE svl_query_summary_2016_04 FROM PUBLIC;
REVOKE ALL ON TABLE svl_query_summary_2016_04 FROM pgadmin;
GRANT ALL ON TABLE svl_query_summary_2016_04 TO pgadmin;
GRANT SELECT ON TABLE svl_query_summary_2016_04 TO gr_report_perfmon;


--
-- TOC entry 4259 (class 0 OID 0)
-- Dependencies: 470
-- Name: svl_query_summary_2016_05; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE svl_query_summary_2016_05 FROM PUBLIC;
REVOKE ALL ON TABLE svl_query_summary_2016_05 FROM pgadmin;
GRANT ALL ON TABLE svl_query_summary_2016_05 TO pgadmin;
GRANT SELECT ON TABLE svl_query_summary_2016_05 TO gr_report_perfmon;


--
-- TOC entry 4260 (class 0 OID 0)
-- Dependencies: 471
-- Name: svl_query_summary_2016_06; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE svl_query_summary_2016_06 FROM PUBLIC;
REVOKE ALL ON TABLE svl_query_summary_2016_06 FROM pgadmin;
GRANT ALL ON TABLE svl_query_summary_2016_06 TO pgadmin;
GRANT SELECT ON TABLE svl_query_summary_2016_06 TO gr_report_perfmon;


--
-- TOC entry 4261 (class 0 OID 0)
-- Dependencies: 472
-- Name: svl_query_summary_2016_07; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE svl_query_summary_2016_07 FROM PUBLIC;
REVOKE ALL ON TABLE svl_query_summary_2016_07 FROM pgadmin;
GRANT ALL ON TABLE svl_query_summary_2016_07 TO pgadmin;
GRANT SELECT ON TABLE svl_query_summary_2016_07 TO gr_report_perfmon;


--
-- TOC entry 4262 (class 0 OID 0)
-- Dependencies: 473
-- Name: svl_query_summary_2016_08; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE svl_query_summary_2016_08 FROM PUBLIC;
REVOKE ALL ON TABLE svl_query_summary_2016_08 FROM pgadmin;
GRANT ALL ON TABLE svl_query_summary_2016_08 TO pgadmin;
GRANT SELECT ON TABLE svl_query_summary_2016_08 TO gr_report_perfmon;


--
-- TOC entry 4263 (class 0 OID 0)
-- Dependencies: 474
-- Name: svl_query_summary_2016_09; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE svl_query_summary_2016_09 FROM PUBLIC;
REVOKE ALL ON TABLE svl_query_summary_2016_09 FROM pgadmin;
GRANT ALL ON TABLE svl_query_summary_2016_09 TO pgadmin;
GRANT SELECT ON TABLE svl_query_summary_2016_09 TO gr_report_perfmon;


--
-- TOC entry 4264 (class 0 OID 0)
-- Dependencies: 475
-- Name: svl_query_summary_2016_10; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE svl_query_summary_2016_10 FROM PUBLIC;
REVOKE ALL ON TABLE svl_query_summary_2016_10 FROM pgadmin;
GRANT ALL ON TABLE svl_query_summary_2016_10 TO pgadmin;
GRANT SELECT ON TABLE svl_query_summary_2016_10 TO gr_report_perfmon;


--
-- TOC entry 4265 (class 0 OID 0)
-- Dependencies: 476
-- Name: svl_query_summary_2016_11; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE svl_query_summary_2016_11 FROM PUBLIC;
REVOKE ALL ON TABLE svl_query_summary_2016_11 FROM pgadmin;
GRANT ALL ON TABLE svl_query_summary_2016_11 TO pgadmin;
GRANT SELECT ON TABLE svl_query_summary_2016_11 TO gr_report_perfmon;


--
-- TOC entry 4266 (class 0 OID 0)
-- Dependencies: 477
-- Name: svl_query_summary_2016_12; Type: ACL; Schema: amstgmgr; Owner: pgadmin
--

REVOKE ALL ON TABLE svl_query_summary_2016_12 FROM PUBLIC;
REVOKE ALL ON TABLE svl_query_summary_2016_12 FROM pgadmin;
GRANT ALL ON TABLE svl_query_summary_2016_12 TO pgadmin;
GRANT SELECT ON TABLE svl_query_summary_2016_12 TO gr_report_perfmon;


