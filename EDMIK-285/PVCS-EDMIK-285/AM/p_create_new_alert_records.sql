-- Function: job_anomaly.p_create_new_alert_records(integer)

-- DROP FUNCTION job_anomaly.p_create_new_alert_records(integer);

CREATE OR REPLACE FUNCTION job_anomaly.p_create_new_alert_records(inp_check_id integer)
  RETURNS integer AS
$BODY$
DECLARE ret int;
BEGIN
	
WITH rows AS (
	INSERT INTO job_anomaly.appwrx_start_time_alerts
(
	so_parent_name
	,so_module
	,dt_created
	,st_wd
	,start_time_check_history_id
	,alert_sent
	,chk_start_time
	,chk_start_time_description
)
SELECT 
	h.so_parent_name
	,h.so_module
	,(job_anomaly.f_curr_timestamp_dummy())::date
	,h.st_wd
	,h.id as start_time_check_history_id
	,false as alert_sent
	,h.chk_start_time
	,h.chk_start_time_description
FROM job_anomaly.appwrx_start_time_check_history h 
INNER JOIN job_anomaly.appwrx_checks c ON  h.id_check = c.id
LEFT JOIN job_anomaly.appwrx_start_time_alerts a 
	ON h.so_parent_name = a.so_parent_name AND h.so_module = a.so_module AND a.dt_created = c.date_check AND a.chk_start_time = h.chk_start_time
WHERE h.id_check = inp_check_id AND h.chk_start_time IN (1,2,3,4,5,0) AND a.id IS NULL

	RETURNING 1
	)
SELECT count(*) into ret  FROM rows;
 
RETURN ret ;
EXCEPTION WHEN OTHERS THEN 
RETURN 0 ;        


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION job_anomaly.p_create_new_alert_records(integer)
  OWNER TO pgadmin;
GRANT EXECUTE ON FUNCTION job_anomaly.p_create_new_alert_records(integer) TO pgadmin;
GRANT EXECUTE ON FUNCTION job_anomaly.p_create_new_alert_records(integer) TO public;
GRANT EXECUTE ON FUNCTION job_anomaly.p_create_new_alert_records(integer) TO gr_job_anomaly;
