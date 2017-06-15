-- Function: job_anomaly.f_build_ora_check_start_q_body(date)

-- DROP FUNCTION job_anomaly.f_build_ora_check_start_q_body(date);

CREATE OR REPLACE FUNCTION job_anomaly.f_build_ora_check_start_q_body(inp_curr_date date)
  RETURNS SETOF text AS
$BODY$

DECLARE max_model_date date;
BEGIN

SELECT max(dt_load::date) INTO max_model_date FROM job_anomaly.module_stats m;

RETURN QUERY
SELECT
concat('UNION ALL  
SELECT
''', m.so_parent_name,''' as so_parent_name
,''',m.so_module,''' as so_module
,',m.st_wd::character varying(30),' as st_wd
,to_date(''',(to_timestamp(  extract( epoch from inp_curr_date::date  ) + m.st_lower )::TIMESTAMP without time zone)::character varying (20),''',''yyyy-mm-dd hh24:mi:ss'') as dt_lower
,to_date(''',(to_timestamp(  extract( epoch from inp_curr_date::date ) + m.st_upper )::TIMESTAMP without time zone)::character varying (20),''',''yyyy-mm-dd hh24:mi:ss'') as dt_upper
,',m.st_upper::character varying(30),' as st_upper
,',m.duration_lower::character varying(30),' as duration_lower
,',m.duration_upper::character varying(30),' as duration_upper
,',extract ( dow from inp_curr_date::date)::INT::character (1),' as current_dw
FROM DUAL ')::TEXT as sql
FROM job_anomaly.module_stats m
WHERE
      m.st_wd = extract( dow from inp_curr_date::TIMESTAMP without time zone)::int
      AND m.dt_load::date = max_model_date 
      -- AND m.so_parent_name ='NZ_CVB_FULL_CHN_SPLIT'
; 

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION job_anomaly.f_build_ora_check_start_q_body(date)
  OWNER TO pgadmin;
GRANT EXECUTE ON FUNCTION job_anomaly.f_build_ora_check_start_q_body(date) TO pgadmin;
GRANT EXECUTE ON FUNCTION job_anomaly.f_build_ora_check_start_q_body(date) TO public;
GRANT EXECUTE ON FUNCTION job_anomaly.f_build_ora_check_start_q_body(date) TO gr_job_anomaly;
