CREATE SCHEMA am_anomalymon_migrate
  AUTHORIZATION pgadmin;

  
  
  CREATE OR REPLACE FUNCTION am_anomalymon_migrate.migrate_anomalymon_tables(link_host text)
  RETURNS text AS
$BODY$
DECLARE sql text;
	result text;
	MaxQuery integer;

BEGIN
	SET search_path TO stage, public;
	PERFORM dblink_connect('myconn', link_host);

-------------

INSERT INTO anomalymon.alert_type( 
id
,alert_type_name
,dtm_created
,dtm_last_modified
,last_updated_by
) SELECT 
id
,alert_type_name
,dtm_created
,dtm_last_modified
,last_updated_by
 FROM dblink('myconn', ' SELECT * FROM anomalymon.alert_type;') AS res_table (
id integer
,alert_type_name character varying
,dtm_created timestamp without time zone
,dtm_last_modified timestamp without time zone
,last_updated_by character varying
);

--------------------
INSERT INTO anomalymon.distribution_list( 
id
,list
,dtm_created
,dtm_last_modified
,last_updated_by
) SELECT 
id
,list
,dtm_created
,dtm_last_modified
,last_updated_by
 FROM dblink('myconn', ' SELECT * FROM anomalymon.distribution_list;') AS res_table (
id integer
,list text
,dtm_created timestamp without time zone
,dtm_last_modified timestamp without time zone
,last_updated_by character varying
);

--------------------------
INSERT INTO anomalymon.appwrx_so_job_history( 
id
,rowid
,so_jobid
,so_job_pid
,so_parents_jobid
,so_predecessor_jobids
,so_condition
,so_queue
,so_module
,so_parent_name
,so_predecessors
,so_job_started
,so_start_date
,so_job_finished
,so_status
,so_status_name
,so_chain_order
,so_max_run_time
) SELECT 
id
,rowid
,so_jobid
,so_job_pid
,so_parents_jobid
,so_predecessor_jobids
,so_condition
,so_queue
,so_module
,so_parent_name
,so_predecessors
,so_job_started
,so_start_date
,so_job_finished
,so_status
,so_status_name
,so_chain_order
,so_max_run_time
 FROM dblink('myconn', ' SELECT * FROM anomalymon.appwrx_so_job_history;') AS res_table (
id bigint
,rowid integer
,so_jobid numeric
,so_job_pid character varying
,so_parents_jobid bigint
,so_predecessor_jobids character varying
,so_condition character varying
,so_queue character varying
,so_module character varying
,so_parent_name character varying
,so_predecessors character varying
,so_job_started timestamp without time zone
,so_start_date timestamp without time zone
,so_job_finished timestamp without time zone
,so_status integer
,so_status_name character varying
,so_chain_order integer
,so_max_run_time integer
);




-----------------------------------
INSERT INTO anomalymon.list_of_jobs_to_disable_false_alerts( 
so_parent_name
,so_module
,cnt_false
) SELECT 
so_parent_name
,so_module
,cnt_false
 FROM dblink('myconn', ' SELECT * FROM anomalymon.list_of_jobs_to_disable_false_alerts;') AS res_table (
so_parent_name character varying
,so_module character varying
,cnt_false integer
);


---------------------------------------------------------
INSERT INTO anomalymon.model_type( 
id
,model_type_name
,dtm_created
,dtm_last_modified
,last_updated_by
) SELECT 
id
,model_type_name
,dtm_created
,dtm_last_modified
,last_updated_by
 FROM dblink('myconn', ' SELECT * FROM anomalymon.model_type;') AS res_table (
id integer
,model_type_name character varying
,dtm_created timestamp without time zone
,dtm_last_modified timestamp without time zone
,last_updated_by character varying
);


------------------------------------------

INSERT INTO anomalymon.model_parameters( 
id
,instructions
,model_type_id
,dtm_created
,dtm_last_modified
,last_updated_by
) SELECT 
id
,instructions
,model_type_id
,dtm_created
,dtm_last_modified
,last_updated_by
 FROM dblink('myconn', ' SELECT * FROM anomalymon.model_parameters;') AS res_table (
id integer
,instructions json
,model_type_id integer
,dtm_created timestamp without time zone
,dtm_last_modified timestamp without time zone
,last_updated_by character varying
);

---------------------------------------------------
INSERT INTO anomalymon.task_type( 
id
,task_type_name
,dtm_created
,dtm_last_modified
,last_updated_by
) SELECT 
id
,task_type_name
,dtm_created
,dtm_last_modified
,last_updated_by
 FROM dblink('myconn', ' SELECT * FROM anomalymon.task_type;') AS res_table (
id integer
,task_type_name character varying
,dtm_created timestamp without time zone
,dtm_last_modified timestamp without time zone
,last_updated_by character varying
);



---------------------------------------------------------

INSERT INTO anomalymon.task( 
id
,task_name
,task_type_id
,dtm_created
,dtm_last_modified
,last_updated_by
) SELECT 
id
,task_name
,task_type_id
,dtm_created
,dtm_last_modified
,last_updated_by
 FROM dblink('myconn', ' SELECT * FROM anomalymon.task;') AS res_table (
id integer
,task_name character varying
,task_type_id integer
,dtm_created timestamp without time zone
,dtm_last_modified timestamp without time zone
,last_updated_by character varying
);

-----------------------------------------------------------------

INSERT INTO anomalymon.task_threshold( 
id
,parent_task_id
,task_id
,model_parameters_id
,w_d
,alert_type_id
,distribution_list_id
,thr_lower
,thr_upper
,low_chk_bound
,up_chk_bound
,dtm_created
,dtm_last_modified
,last_updated_by
,is_active
) SELECT 
id
,parent_task_id
,task_id
,model_parameters_id
,w_d
,alert_type_id
,distribution_list_id
,thr_lower
,thr_upper
,low_chk_bound
,up_chk_bound
,dtm_created
,dtm_last_modified
,last_updated_by
,is_active
 FROM dblink('myconn', ' SELECT * FROM anomalymon.task_threshold;') AS res_table (
id integer
,parent_task_id integer
,task_id integer
,model_parameters_id integer
,w_d smallint
,alert_type_id integer
,distribution_list_id integer
,thr_lower integer
,thr_upper integer
,low_chk_bound integer
,up_chk_bound integer
,dtm_created timestamp without time zone
,dtm_last_modified timestamp without time zone
,last_updated_by character varying
,is_active boolean
);

---------------------

INSERT INTO job_anomaly.appwrx_checks( 
id
,date_check
,check_started
,check_completed
,check_type
,is_completed
,is_succesfull
,error_body
,error_code
) SELECT 
id
,date_check
,check_started
,check_completed
,check_type
,is_completed
,is_succesfull
,error_body
,error_code
 FROM dblink('myconn', ' SELECT * FROM job_anomaly.appwrx_checks;') AS res_table (
id bigint
,date_check date
,check_started timestamp without time zone
,check_completed timestamp without time zone
,check_type character varying
,is_completed boolean
,is_succesfull boolean
,error_body text
,error_code smallint
);

------------------------------------------------
INSERT INTO job_anomaly.appwrx_duration_alerts_history( 
id
,dt_created
,so_module
,st_wd
,alert_duration_code
,alert_description
,duration_at_alert
,start_time_check_history_id
,alert_sent
,alert_sent_timestamp
,check_send_reciept
) SELECT 
id
,dt_created
,so_module
,st_wd
,alert_duration_code
,alert_description
,duration_at_alert
,start_time_check_history_id
,alert_sent
,alert_sent_timestamp
,check_send_reciept
 FROM dblink('myconn', ' SELECT * FROM job_anomaly.appwrx_duration_alerts_history;') AS res_table (
id bigint
,dt_created date
,so_module character varying
,st_wd integer
,alert_duration_code integer
,alert_description character varying
,duration_at_alert integer
,start_time_check_history_id bigint
,alert_sent boolean
,alert_sent_timestamp timestamp without time zone
,check_send_reciept boolean
);


------------------------------------------------------

INSERT INTO job_anomaly.appwrx_start_time_alerts( 
id
,dt_created
,so_parent_name
,so_module
,st_wd
,start_time_check_history_id
,alert_sent
,alert_sent_timestamp
,check_send_reciept
,chk_start_time
,chk_start_time_description
) SELECT 
id
,dt_created
,so_parent_name
,so_module
,st_wd
,start_time_check_history_id
,alert_sent
,alert_sent_timestamp
,check_send_reciept
,chk_start_time
,chk_start_time_description
 FROM dblink('myconn', ' SELECT * FROM job_anomaly.appwrx_start_time_alerts;') AS res_table (
id bigint
,dt_created date
,so_parent_name character varying
,so_module character varying
,st_wd integer
,start_time_check_history_id bigint
,alert_sent boolean
,alert_sent_timestamp timestamp without time zone
,check_send_reciept boolean
,chk_start_time integer
,chk_start_time_description character varying
);

----------------------------------------------------------

INSERT INTO job_anomaly.map_rs_nz_jobs( 
rs_chain
,rs_job
,nz_chain
,nz_job
,w_d
,st_lower
,st_upper
,dur_lower
,dur_upper
) SELECT 
rs_chain
,rs_job
,nz_chain
,nz_job
,w_d
,st_lower
,st_upper
,dur_lower
,dur_upper
 FROM dblink('myconn', ' SELECT * FROM job_anomaly.map_rs_nz_jobs;') AS res_table (
rs_chain character varying
,rs_job character varying
,nz_chain character varying
,nz_job character varying
,w_d character varying
,st_lower character varying
,st_upper character varying
,dur_lower character varying
,dur_upper character varying
);
---------------------------------------------
INSERT INTO job_anomaly.module_stats( 
id
,dt_load
,so_parent_name
,so_module
,st_wd
,st_lower
,st_upper
,duration_lower
,duration_upper
) SELECT 
id
,dt_load
,so_parent_name
,so_module
,st_wd
,st_lower
,st_upper
,duration_lower
,duration_upper
 FROM dblink('myconn', ' SELECT * FROM job_anomaly.module_stats;') AS res_table (
id bigint
,dt_load timestamp without time zone
,so_parent_name character varying
,so_module character varying
,st_wd integer
,st_lower integer
,st_upper integer
,duration_lower integer
,duration_upper integer
);
---------------------------------------------


INSERT INTO job_anomaly.module_stats_stg( 
id
,dt_load
,so_parent_name
,so_module
,st_wd
,st_lower
,st_upper
,duration_lower
,duration_upper
) SELECT 
id
,dt_load
,so_parent_name
,so_module
,st_wd
,st_lower
,st_upper
,duration_lower
,duration_upper
 FROM dblink('myconn', ' SELECT * FROM job_anomaly.module_stats_stg;') AS res_table (
id bigint
,dt_load timestamp without time zone
,so_parent_name character varying
,so_module character varying
,st_wd integer
,st_lower integer
,st_upper integer
,duration_lower integer
,duration_upper integer
);
---------------------------------------------




-------------
	PERFORM dblink_disconnect('myconn');

	SELECT '('|| NOW() ||') completed data loading for statistic_data tables ' || link_host INTO result;
	RETURN result;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION am_anomalymon_migrate.migrate_anomalymon_tables(text)
  OWNER TO pgadmin;
