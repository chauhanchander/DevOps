--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.6
-- Dumped by pg_dump version 9.4.0
-- Started on 2015-08-07 11:07:21

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 8 (class 2615 OID 19168)
-- Name: anomalymon; Type: SCHEMA; Schema: -; Owner: pgadmin
--

CREATE SCHEMA IF NOT EXISTS anomalymon;


ALTER SCHEMA anomalymon OWNER TO pgadmin;

--
-- TOC entry 6 (class 2615 OID 17006)
-- Name: job_anomaly; Type: SCHEMA; Schema: -; Owner: pgadmin
--

CREATE SCHEMA IF NOT EXISTS job_anomaly;


ALTER SCHEMA job_anomaly OWNER TO pgadmin;

SET search_path = anomalymon, pg_catalog;

--
-- TOC entry 235 (class 1255 OID 19587)
-- Name: trf_alert_type_update_trigger(); Type: FUNCTION; Schema: anomalymon; Owner: pgadmin
--

CREATE OR REPLACE FUNCTION trf_alert_type_update_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	NEW.dtm_last_modified := (current_timestamp::timestamp  AT TIME ZONE 'America/New_York')::timestamp without time zone;
        NEW.last_updated_by := current_user;
        RETURN NEW;
END;
$$;


ALTER FUNCTION anomalymon.trf_alert_type_update_trigger() OWNER TO pgadmin;

--
-- TOC entry 234 (class 1255 OID 19499)
-- Name: trf_distribution_list_update_trigger(); Type: FUNCTION; Schema: anomalymon; Owner: pgadmin
--

CREATE OR REPLACE FUNCTION trf_distribution_list_update_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	NEW.dtm_last_modified := (current_timestamp::timestamp  AT TIME ZONE 'America/New_York')::timestamp without time zone;
        NEW.last_updated_by := current_user;
        RETURN NEW;
END;
$$;


ALTER FUNCTION anomalymon.trf_distribution_list_update_trigger() OWNER TO pgadmin;

--
-- TOC entry 238 (class 1255 OID 19439)
-- Name: trf_model_parameters_update_trigger(); Type: FUNCTION; Schema: anomalymon; Owner: pgadmin
--

CREATE OR REPLACE FUNCTION trf_model_parameters_update_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	NEW.dtm_last_modified := (current_timestamp::timestamp  AT TIME ZONE 'America/New_York')::timestamp without time zone;
        NEW.last_updated_by := current_user;
        RETURN NEW;
END;
$$;


ALTER FUNCTION anomalymon.trf_model_parameters_update_trigger() OWNER TO pgadmin;

--
-- TOC entry 237 (class 1255 OID 19423)
-- Name: trf_model_type_update_trigger(); Type: FUNCTION; Schema: anomalymon; Owner: pgadmin
--

CREATE OR REPLACE FUNCTION trf_model_type_update_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	NEW.dtm_last_modified := (current_timestamp::timestamp  AT TIME ZONE 'America/New_York')::timestamp without time zone;
        NEW.last_updated_by := current_user;
        RETURN NEW;
END;
$$;


ALTER FUNCTION anomalymon.trf_model_type_update_trigger() OWNER TO pgadmin;

--
-- TOC entry 236 (class 1255 OID 19688)
-- Name: trf_task_threshold_update_trigger(); Type: FUNCTION; Schema: anomalymon; Owner: pgadmin
--

CREATE OR REPLACE FUNCTION trf_task_threshold_update_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	NEW.dtm_last_modified := (current_timestamp::timestamp  AT TIME ZONE 'America/New_York')::timestamp without time zone;
        NEW.last_updated_by := current_user;
        RETURN NEW;
END;
$$;


ALTER FUNCTION anomalymon.trf_task_threshold_update_trigger() OWNER TO pgadmin;

--
-- TOC entry 239 (class 1255 OID 19455)
-- Name: trf_task_type_update_trigger(); Type: FUNCTION; Schema: anomalymon; Owner: pgadmin
--

CREATE OR REPLACE FUNCTION trf_task_type_update_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	NEW.dtm_last_modified := (current_timestamp::timestamp  AT TIME ZONE 'America/New_York')::timestamp without time zone;
        NEW.last_updated_by := current_user;
        RETURN NEW;
END;
$$;


ALTER FUNCTION anomalymon.trf_task_type_update_trigger() OWNER TO pgadmin;

--
-- TOC entry 233 (class 1255 OID 19471)
-- Name: trf_task_update_trigger(); Type: FUNCTION; Schema: anomalymon; Owner: pgadmin
--

CREATE OR REPLACE FUNCTION trf_task_update_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	NEW.dtm_last_modified := (current_timestamp::timestamp  AT TIME ZONE 'America/New_York')::timestamp without time zone;
        NEW.last_updated_by := current_user;
        RETURN NEW;
END;
$$;


ALTER FUNCTION anomalymon.trf_task_update_trigger() OWNER TO pgadmin;

SET search_path = job_anomaly, pg_catalog;

--
-- TOC entry 232 (class 1255 OID 17007)
-- Name: f_build_ora_check_start_q_body(date); Type: FUNCTION; Schema: job_anomaly; Owner: pgadmin
--

CREATE OR REPLACE FUNCTION f_build_ora_check_start_q_body(inp_curr_date date) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$

DECLARE max_model_date date;
BEGIN


RETURN QUERY
SELECT
concat('UNION ALL  
SELECT
''', m.so_parent_name,''' as so_parent_name
,''', m.so_module ,''' as so_module
,',m.st_wd::character varying(30),' as st_wd
,to_date(''',(to_timestamp(  extract( epoch from inp_curr_date::date  ) + m.st_lower )::TIMESTAMP without time zone)::character varying (20),''',''yyyy-mm-dd hh24:mi:ss'') as dt_lower
,to_date(''',(to_timestamp(  extract( epoch from inp_curr_date::date ) + m.st_upper  )::TIMESTAMP without time zone)::character varying (20),''',''yyyy-mm-dd hh24:mi:ss'') as dt_upper
,to_date(''',(to_timestamp(  extract( epoch from inp_curr_date::date  ) + m_pd.st_lower  )::TIMESTAMP without time zone)::character varying (20),''',''yyyy-mm-dd hh24:mi:ss'') as dt_lower_1day_ago
,to_date(''',(to_timestamp(  extract( epoch from inp_curr_date::date ) + m_pd.st_upper )::TIMESTAMP without time zone)::character varying (20),''',''yyyy-mm-dd hh24:mi:ss'') as dt_upper_1day_ago
,to_date(''',(to_timestamp(  extract( epoch from inp_curr_date::date  ) + m_pd2.st_lower )::TIMESTAMP without time zone)::character varying (20),''',''yyyy-mm-dd hh24:mi:ss'') as dt_lower_2day_ago
,to_date(''',(to_timestamp(  extract( epoch from inp_curr_date::date ) + m_pd2.st_upper )::TIMESTAMP without time zone)::character varying (20),''',''yyyy-mm-dd hh24:mi:ss'') as dt_upper_2day_ago
,',m.st_upper::character varying(30),' as st_upper
,',m.duration_lower::character varying(30),' as duration_lower
,',m.duration_upper::character varying(30),' as duration_upper
,',extract ( dow from inp_curr_date::date)::INT::character (1),' as current_dw
FROM DUAL ')::TEXT as sql
FROM job_anomaly.v_module_stats m
	LEFT JOIN job_anomaly.v_module_stats m_pd ON m.so_parent_name = m_pd.so_parent_name AND  m.so_module = m_pd.so_module  AND m_pd.st_wd = case when m.st_wd >0 then m.st_wd - 1 else 6 end 
	LEFT JOIN job_anomaly.v_module_stats m_pd2 ON m_pd.so_parent_name = m_pd2.so_parent_name AND  m_pd.so_module = m_pd2.so_module  AND m_pd2.st_wd = case when m_pd.st_wd >0 then m_pd.st_wd - 1 else 6 end 
WHERE
      m.st_wd = extract( dow from inp_curr_date::TIMESTAMP without time zone)::int
; 

END
$$;


ALTER FUNCTION job_anomaly.f_build_ora_check_start_q_body(inp_curr_date date) OWNER TO pgadmin;

--
-- TOC entry 231 (class 1255 OID 17008)
-- Name: f_build_ora_check_start_q_header_tail(smallint, date); Type: FUNCTION; Schema: job_anomaly; Owner: pgadmin
--

CREATE OR REPLACE FUNCTION f_build_ora_check_start_q_header_tail(tret smallint, appwrx_date date) RETURNS text
    LANGUAGE plpgsql
    AS $$

DECLARE sql text;
BEGIN
IF tret = 0 THEN
SELECT
concat('
SET PAGESIZE 0 SPACE 0 FEEDBACK OFF TRIMSPOOL ON HEADING OFF linesize 700  NEWPAGE 0 ECHO OFF COLSEP '','';
SET VERIFY OFF;
SET SERVEROUTPUT ON SIZE UNLIMITED;
SELECT
        trim(m.so_parent_name) as so_parent_name
        ,trim(m.so_module) as so_module
        ,m.st_wd
        ,to_char(m.dt_lower,''yyyy-mm-dd hh24:mi:ss'') as dt_lower
        ,to_char(m.dt_upper,''yyyy-mm-dd hh24:mi:ss'') as dt_upper
        ,m.duration_lower
        ,m.duration_upper
        ,trim(d.SO_MODULE) as SO_MODULE
        ,to_char(d.SO_START_DATE ,''yyyy-mm-dd hh24:mi:ss'') as SO_START_DATE
        ,to_char(d.SO_JOB_STARTED ,''yyyy-mm-dd hh24:mi:ss'') as SO_JOB_STARTED
        ,to_char(d.SO_JOB_FINISHED,''yyyy-mm-dd hh24:mi:ss'') as SO_JOB_FINISHED
        ,d.SO_STATUS_NAME
	,
      case 
        -- job not overnight
      when m.st_upper <= 86400
      then
        case
          when d.SO_MODULE is not null
          then
            case
                -- in time
                when d.SO_JOB_STARTED between m.dt_lower and m.dt_upper
                then 1
                -- early
                when d.SO_JOB_STARTED < m.dt_lower
                then 2
                -- later
                when d.SO_JOB_STARTED > m.dt_upper
                then 3
                else 0
            end
          else
            case
              -- job not started yet in time
              when sysdate between m.dt_lower and m.dt_upper
              then 4
              -- not started yet
              when sysdate < m.dt_lower
              then -1
              -- job not started after upper time
              when sysdate > m.dt_upper
              then 5
              else
                0
            end
        end
        -- overnigth jobs
      when m.st_upper > 86400
      then
            case               
              when sysdate >= m.dt_lower 
              then -- run could be in progress or not started yet
                case 
                  when d.SO_MODULE is not null 
                  then
                    case 
                      when d.SO_JOB_STARTED between m.dt_lower AND m.dt_upper
                      -- in time
                      then  1
                      -- job started after yesterday upper_time but before today lower time 
                      when d.SO_JOB_STARTED > m.dt_upper_1day_ago - 1 AND d.SO_JOB_STARTED < m.dt_lower 
                      -- early
                      then 2    
                    end
                  when d.SO_MODULE is null
                  -- job not started yet in time
                  then 4
                end
              when sysdate < m.dt_lower
              then  
                case 
                  when sysdate > m.dt_upper_1day_ago -1    
                  then 
		  -- previous run should be completed ,current not started
                  --  l 2015-07-01 23:00  s 2015-07-01 21:00 u 2015-07-02 22:00
                    case
                      when d.SO_MODULE is not null AND ( sysdate - d.SO_JOB_STARTED ) *24 <= 1 
                      then 
                        case
                          when d.SO_JOB_STARTED between m.dt_lower_1day_ago -1  AND m.dt_upper_1day_ago -1
                          -- in time
                          then  1
                          when d.SO_JOB_STARTED > m.dt_upper_1day_ago -1 and d.SO_JOB_STARTED < m.dt_lower 
                          -- later
                          then 3
                        end
                      when d.SO_MODULE is not null AND ( sysdate - d.SO_JOB_STARTED ) *24 > 1
			then -1
                      when d.SO_MODULE is null and dy.SO_MODULE is not null  AND ( sysdate - dy.SO_JOB_STARTED ) *24 <= 1 
                      then 
                        case 
                          when dy.SO_JOB_STARTED between m.dt_lower_1day_ago -1  AND m.dt_upper_1day_ago -1
                          then 1
                        end
                      when d.SO_MODULE is null and dy.SO_MODULE is not null  AND ( sysdate - dy.SO_JOB_STARTED ) *24 > 1 
			then -1
                      when d.SO_MODULE is null and dy.SO_MODULE is null
                      -- job not started after upper time
                      then 5
                    end
                  when sysdate <= m.dt_upper_1day_ago -1 
                  then  -- run could be in progress or completed or not started yet
                    case
                      when d.SO_MODULE is not null 
                      then
                        case
                          when d.SO_JOB_STARTED between m.dt_lower_1day_ago -1  AND m.dt_upper_1day_ago -1
                          -- in time
                          then  1
                          when d.SO_JOB_STARTED > m.dt_upper_2day_ago -2 AND d.SO_JOB_STARTED < m.dt_lower_1day_ago -1 
                          -- early 
                          then 2
                        end                        
                      when d.SO_MODULE is null AND dy.SO_MODULE is not null
                      then
                        case
                          when dy.SO_JOB_STARTED between m.dt_lower_1day_ago -1  AND m.dt_upper_1day_ago -1
                          -- in time
                          then  1
                          when dy.SO_JOB_STARTED > m.dt_upper_2day_ago -2 AND dy.SO_JOB_STARTED < m.dt_lower_1day_ago -1 
                          -- early
                          then  2
                        end
                      when d.SO_MODULE is null AND dy.SO_MODULE is null
			-- job not started yet in time
		      then 4 
                    end           
	         end   
              end
    else
        0    
      end
      as chk_start_time
FROM 
(')::TEXT INTO sql
;
ELSE
SELECT
concat(') m ',' LEFT JOIN
(
SELECT
        max(qh.qoh) as qoh
        ,qh.so_parent_name
        ,qh.SO_MODULE
        ,max(qh.SO_START_DATE) as SO_START_DATE
        ,max(qh.SO_JOB_STARTED) as SO_JOB_STARTED
        ,max(qh.SO_JOB_FINISHED) as SO_JOB_FINISHED
        ,min(qh.SO_STATUS_NAME) as SO_STATUS_NAME
FROM
(
SELECT
        0 as qoh
        ,h.so_parent_name
        ,h.SO_MODULE
        ,h.SO_START_DATE
        ,h.SO_JOB_STARTED
        ,h.SO_JOB_FINISHED
        ,h.SO_STATUS_NAME
FROM appwrxmgr.SO_JOB_HISTORY  h
WHERE
		h.SO_JOB_STARTED >= trunc(to_date(''', to_char(appwrx_date::date, 'YYYY-MM-DD HH24:MI:SS') ,''',''yyyy-mm-dd hh24:mi:ss''  ))
		AND h.SO_JOB_STARTED < trunc(to_date(''', to_char(appwrx_date::date, 'YYYY-MM-DD HH24:MI:SS') ,''',''yyyy-mm-dd hh24:mi:ss''  )) + 1
UNION ALL
SELECT
        1 as qoh
        ,q.so_parent_name
        ,q.SO_MODULE
        ,q.SO_START_DATE
        ,q.SO_JOB_STARTED
        ,q.SO_JOB_FINISHED
        ,q.SO_STATUS_NAME
FROM appwrxmgr.SO_JOB_QUEUE  q
WHERE
		q.SO_JOB_STARTED >= trunc(to_date(''', to_char(appwrx_date::date, 'YYYY-MM-DD HH24:MI:SS') ,''',''yyyy-mm-dd hh24:mi:ss''  ))
		AND q.SO_JOB_STARTED < trunc(to_date(''', to_char(appwrx_date::date, 'YYYY-MM-DD HH24:MI:SS') ,''',''yyyy-mm-dd hh24:mi:ss''  )) + 1
) qh GROUP BY qh.so_parent_name,qh.SO_MODULE,qh.SO_START_DATE
) d ON d.so_parent_name = m.so_parent_name AND d.SO_MODULE = m.SO_MODULE
LEFT JOIN
(
SELECT
        max(qh.qoh) as qoh
        ,qh.so_parent_name
        ,qh.SO_MODULE
        ,max(qh.SO_START_DATE) as SO_START_DATE
        ,max(qh.SO_JOB_STARTED) as SO_JOB_STARTED
        ,max(qh.SO_JOB_FINISHED) as SO_JOB_FINISHED
        ,min(qh.SO_STATUS_NAME) as SO_STATUS_NAME
FROM
(
SELECT
        0 as qoh
        ,h.so_parent_name
        ,h.SO_MODULE
        ,h.SO_START_DATE
        ,h.SO_JOB_STARTED
        ,h.SO_JOB_FINISHED
        ,h.SO_STATUS_NAME
FROM appwrxmgr.SO_JOB_HISTORY  h
WHERE
                h.SO_JOB_STARTED >= trunc(to_date(''', to_char(appwrx_date::date, 'YYYY-MM-DD HH24:MI:SS') ,''',''yyyy-mm-dd hh24:mi:ss''  )) -1
                AND h.SO_JOB_STARTED < trunc(to_date(''', to_char(appwrx_date::date, 'YYYY-MM-DD HH24:MI:SS') ,''',''yyyy-mm-dd hh24:mi:ss''  )) 
UNION ALL
SELECT
        1 as qoh
        ,q.so_parent_name
        ,q.SO_MODULE
        ,q.SO_START_DATE
        ,q.SO_JOB_STARTED
        ,q.SO_JOB_FINISHED
        ,q.SO_STATUS_NAME
FROM appwrxmgr.SO_JOB_QUEUE  q
WHERE
                q.SO_JOB_STARTED >= trunc(to_date(''', to_char(appwrx_date::date, 'YYYY-MM-DD HH24:MI:SS') ,''',''yyyy-mm-dd hh24:mi:ss''  )) -1
                AND q.SO_JOB_STARTED < trunc(to_date(''', to_char(appwrx_date::date, 'YYYY-MM-DD HH24:MI:SS') ,''',''yyyy-mm-dd hh24:mi:ss''  ))
) qh GROUP BY qh.so_parent_name,qh.SO_MODULE,qh.SO_START_DATE
) dy ON dy.so_parent_name = m.so_parent_name AND dy.SO_MODULE = m.SO_MODULE
/
SPOOL OFF
EXIT;
')::TEXT INTO sql;


END IF; 

 RETURN sql;
END
$$;


ALTER FUNCTION job_anomaly.f_build_ora_check_start_q_header_tail(tret smallint, appwrx_date date) OWNER TO pgadmin;

--
-- TOC entry 224 (class 1255 OID 17009)
-- Name: f_curr_timestamp_dummy(); Type: FUNCTION; Schema: job_anomaly; Owner: pgadmin
--

CREATE OR REPLACE FUNCTION f_curr_timestamp_dummy() RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE ret character varying(19);
BEGIN

SELECT ((current_timestamp::timestamp  AT TIME ZONE 'America/New_York')::timestamp without time zone)::character varying(19) INTO ret;

RETURN ret;

END;
$$;


ALTER FUNCTION job_anomaly.f_curr_timestamp_dummy() OWNER TO pgadmin;

--
-- TOC entry 223 (class 1255 OID 17010)
-- Name: f_query_show_module_model(integer, character varying); Type: FUNCTION; Schema: job_anomaly; Owner: pgadmin
--

CREATE OR REPLACE FUNCTION f_query_show_module_model(inp_st_wd integer, inp_so_module character varying) RETURNS TABLE(so_parent_name character varying, so_module character varying, st_wd integer, dt_lower timestamp without time zone, dt_upper timestamp without time zone, st_lower integer, st_upper integer, duration_lower integer, duration_upper integer, current_dw integer)
    LANGUAGE plpgsql
    AS $$
BEGIN

   RETURN QUERY
   SELECT 

	 m.so_parent_name
	, m.so_module
	, m.st_wd
	, to_timestamp(  extract( epoch from date_trunc('day' , current_timestamp) ) + m.st_lower )::TIMESTAMP without time zone as dt_lower
	, to_timestamp(  extract( epoch from date_trunc('day' , current_timestamp) ) + m.st_upper )::TIMESTAMP without time zone as dt_upper	
	, m.st_lower
	, m.st_upper
	, m.duration_lower
	, m.duration_upper
	, extract ( dow from current_timestamp)::INT as current_dw
	FROM job_anomaly.module_stats m
	WHERE 
		m.st_wd = inp_st_wd
		AND  m.so_module = inp_so_module
  ;

END
$$;


ALTER FUNCTION job_anomaly.f_query_show_module_model(inp_st_wd integer, inp_so_module character varying) OWNER TO pgadmin;

--
-- TOC entry 229 (class 1255 OID 17011)
-- Name: f_update_appwrx_checks(boolean, boolean, bigint); Type: FUNCTION; Schema: job_anomaly; Owner: pgadmin
--

CREATE OR REPLACE FUNCTION f_update_appwrx_checks(inp_is_completed boolean, inp_is_succesfull boolean, inp_check_id bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE ret int;
BEGIN

WITH rows AS (

UPDATE job_anomaly.appwrx_checks 
SET 
	check_completed = (current_timestamp::timestamp at time zone 'UTC-4')::timestamp without time zone
	,is_completed = inp_is_completed
	,is_succesfull = inp_is_succesfull 
WHERE id = inp_check_id
RETURNING 1
	)
SELECT count(*) into ret  FROM rows;

RETURN ret;

END;
$$;


ALTER FUNCTION job_anomaly.f_update_appwrx_checks(inp_is_completed boolean, inp_is_succesfull boolean, inp_check_id bigint) OWNER TO pgadmin;

--
-- TOC entry 230 (class 1255 OID 17012)
-- Name: f_update_appwrx_duration_alerts_history(boolean, bigint); Type: FUNCTION; Schema: job_anomaly; Owner: pgadmin
--

CREATE OR REPLACE FUNCTION f_update_appwrx_duration_alerts_history(inp_alert_sent boolean, inp_duration_alert_id bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE ret int;
BEGIN

WITH rows AS (

UPDATE job_anomaly.appwrx_duration_alerts_history 
SET 
	alert_sent=inp_alert_sent 
	,alert_sent_timestamp = (current_timestamp::timestamp at time zone 'UTC-4')::timestamp without time zone 
WHERE id = inp_duration_alert_id 
RETURNING 1
	)
SELECT count(*) into ret  FROM rows;

RETURN ret;

END;
$$;


ALTER FUNCTION job_anomaly.f_update_appwrx_duration_alerts_history(inp_alert_sent boolean, inp_duration_alert_id bigint) OWNER TO pgadmin;

--
-- TOC entry 227 (class 1255 OID 17013)
-- Name: f_update_appwrx_start_time_alerts(boolean, bigint); Type: FUNCTION; Schema: job_anomaly; Owner: pgadmin
--

CREATE OR REPLACE FUNCTION f_update_appwrx_start_time_alerts(inp_alert_sent boolean, inp_alert_id bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE ret int;
BEGIN

WITH rows AS (
UPDATE job_anomaly.appwrx_start_time_alerts 
SET alert_sent=inp_alert_sent ,alert_sent_timestamp = (current_timestamp::timestamp at time zone 'UTC-4')::timestamp without time zone 
WHERE id = inp_alert_id 
RETURNING 1
	)
SELECT count(*) into ret  FROM rows;

RETURN ret;

END;
$$;


ALTER FUNCTION job_anomaly.f_update_appwrx_start_time_alerts(inp_alert_sent boolean, inp_alert_id bigint) OWNER TO pgadmin;

--
-- TOC entry 240 (class 1255 OID 17014)
-- Name: p_create_new_alert_records(integer); Type: FUNCTION; Schema: job_anomaly; Owner: pgadmin
--

CREATE OR REPLACE FUNCTION p_create_new_alert_records(inp_check_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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
INNER JOIN job_anomaly.appwrx_checks c ON h.id_check = c.id
LEFT JOIN 
(
	SELECT h_t.id,h_t.so_parent_name,h_t.so_module,h_t.dt_lower,h_t.dt_upper,h_t.st_wd,h_t.chk_start_time
	FROM job_anomaly.appwrx_start_time_alerts a 
	INNER JOIN 
	(
	SELECT max(a.id) max_id
	FROM job_anomaly.appwrx_start_time_alerts a 
		INNER JOIN anomalymon.v_task_appwrx_starttime vs 
			ON a.so_parent_name = vs.parent_task_name AND a.so_module = vs.task_name AND a.st_wd = vs.w_d
	GROUP BY a.so_parent_name,a.so_module ) mai
	ON mai.max_id = a.id 
	INNER JOIN job_anomaly.appwrx_start_time_check_history h_t ON h_t.id = a.start_time_check_history_id

) mci
	ON h.so_parent_name = mci.so_parent_name 
	AND h.so_module = mci.so_module 
	AND mci.chk_start_time = h.chk_start_time 
	AND h.dt_lower = mci.dt_lower 
	AND h.dt_upper = mci.dt_upper
WHERE h.id_check = inp_check_id AND h.chk_start_time IN (1,2,3,4,5,0) AND mci.id IS NULL

	RETURNING 1
	)
SELECT count(*) into ret  FROM rows;
 
RETURN ret ;
EXCEPTION WHEN OTHERS THEN 
RETURN 0 ;        


END;
$$;


ALTER FUNCTION job_anomaly.p_create_new_alert_records(inp_check_id integer) OWNER TO pgadmin;

--
-- TOC entry 228 (class 1255 OID 17015)
-- Name: p_create_new_check(character varying, date); Type: FUNCTION; Schema: job_anomaly; Owner: pgadmin
--

CREATE OR REPLACE FUNCTION p_create_new_check(inp_type character varying, inp_date_check date) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE ret int;
BEGIN
	
WITH rows AS (
	INSERT INTO  job_anomaly.appwrx_checks	
	(
		date_check
		,check_type
		,check_started 
	)
	SELECT 
		inp_date_check
		,'start_time'
		,(current_timestamp::timestamp at time zone 'UTC-4')::timestamp without time zone
	RETURNING id
	)
SELECT id into ret  FROM rows;
 
RETURN ret ;
EXCEPTION WHEN OTHERS THEN 
RETURN 0 ;        


END;
$$;


ALTER FUNCTION job_anomaly.p_create_new_check(inp_type character varying, inp_date_check date) OWNER TO pgadmin;

--
-- TOC entry 241 (class 1255 OID 17016)
-- Name: p_query_duration_send_alert_records(timestamp without time zone); Type: FUNCTION; Schema: job_anomaly; Owner: pgadmin
--

CREATE OR REPLACE FUNCTION p_query_duration_send_alert_records(inp_date_time timestamp without time zone) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$
DECLARE ret int;
BEGIN

INSERT INTO job_anomaly.appwrx_duration_alerts_history
(

  dt_created ,
  so_module,
  alert_duration_code,
  alert_description,
  duration_at_alert ,
  start_time_check_history_id ,
  alert_sent 
)
SELECT
	inp_date_time::date
	,h.so_module
	,case 
		when extract(epoch from inp_date_time - h.aso_job_started) between duration_lower and duration_upper  then 1 
	        when extract(epoch from inp_date_time - h.aso_job_started) > duration_upper then 2 
	        when extract(epoch from h.aso_job_finished - h.aso_job_started) < duration_lower  then 3
	 else 
		0
	 end as chk_duration
	 ,case 
		when extract(epoch from inp_date_time - h.aso_job_started) between duration_lower and duration_upper then 'Normal' 
	        when extract(epoch from inp_date_time - h.aso_job_started) > duration_upper then 'Duration threshold exceeded' 
	        when extract(epoch from h.aso_job_finished - h.aso_job_started) < duration_lower  then 'Duration under lower threshold'
	 else 
		'NULL - please check code'
	 end as alert_description
	,extract(epoch from inp_date_time - h.aso_job_started)
	,h.id 
        ,false
FROM job_anomaly.appwrx_start_time_check_history h
	INNER JOIN job_anomaly.appwrx_checks c ON  h.id_check = c.id
		LEFT JOIN job_anomaly.appwrx_duration_alerts_history a 
			ON  h.so_module = a.so_module AND a.dt_created = c.date_check 
WHERE 
	h.aso_job_started is not null 
	AND c.date_check = inp_date_time::date
	AND h.aso_job_started between inp_date_time::date::timestamp AND inp_date_time
	AND extract(epoch from inp_date_time - h.aso_job_started) > h.duration_lower
	AND 
	(
		aso_job_finished is null 
		-- will track not finished jobs only 
		--OR (aso_job_finished is not null AND aso_job_finished between inp_date_time - interval '10 minutes' AND inp_date_time )
	)
	AND a.id is null
;
	
RETURN QUERY
SELECT 
	
	concat(a.id,';',a.so_module,';',a.alert_description,';',s.distribution_list) as m
FROM job_anomaly.appwrx_duration_alerts_history a 
	INNER JOIN job_anomaly.appwrx_start_time_check_history h ON a.start_time_check_history_id = h.id AND h.so_module = a.so_module
	INNER JOIN job_anomaly.appwrx_checks c ON  h.id_check = c.id
	LEFT JOIN anomalymon.v_task_appwrx_starttime s 
		ON s.parent_task_name = case when h.so_parent_name is null then 'N/A' else h.so_parent_name end AND s.task_name = h.so_module AND h.st_wd = s.w_d
WHERE a.alert_sent = false 
	-- need to change this condition to send alerts,
	-- value 100 is using to avoid sending duration alerts, while the thresholds will be adjusted
	AND a.alert_duration_code IN (2,3) 
	-- AND a.alert_duration_code =100
;

END;
$$;


ALTER FUNCTION job_anomaly.p_query_duration_send_alert_records(inp_date_time timestamp without time zone) OWNER TO pgadmin;

--
-- TOC entry 226 (class 1255 OID 17017)
-- Name: p_query_send_alert_records(); Type: FUNCTION; Schema: job_anomaly; Owner: pgadmin
--

CREATE OR REPLACE FUNCTION p_query_send_alert_records() RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$
DECLARE ret int;
BEGIN
	
RETURN QUERY
SELECT 
	concat(a.id,';',a.so_parent_name,';',a.so_module,';',a.chk_start_time_description,';',s.distribution_list) as m
FROM job_anomaly.appwrx_start_time_alerts a 
	LEFT JOIN anomalymon.v_task_appwrx_starttime s 
		ON s.parent_task_name = case when a.so_parent_name is null then 'N/A' else a.so_parent_name end AND s.task_name = a.so_module AND a.st_wd = s.w_d
WHERE a.alert_sent = false AND a.chk_start_time IN (1,2,3,5,0) 
;

END;
$$;


ALTER FUNCTION job_anomaly.p_query_send_alert_records() OWNER TO pgadmin;

SET search_path = anomalymon, pg_catalog;

--
-- TOC entry 203 (class 1259 OID 20461)
-- Name: sqi_alert_type; Type: SEQUENCE; Schema: anomalymon; Owner: pgadmin
--

CREATE SEQUENCE sqi_alert_type
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sqi_alert_type OWNER TO pgadmin;

SET default_with_oids = false;

--
-- TOC entry 204 (class 1259 OID 20463)
-- Name: alert_type; Type: TABLE; Schema: anomalymon; Owner: pgadmin
--

CREATE TABLE alert_type (
    id integer DEFAULT nextval('sqi_alert_type'::regclass) NOT NULL,
    alert_type_name character varying(255) NOT NULL,
    dtm_created timestamp without time zone DEFAULT (timezone('America/New_York'::text, (now())::timestamp without time zone))::timestamp without time zone,
    dtm_last_modified timestamp without time zone DEFAULT (timezone('America/New_York'::text, (now())::timestamp without time zone))::timestamp without time zone,
    last_updated_by character varying(255) DEFAULT ("current_user"())::character varying(255) NOT NULL
);


ALTER TABLE alert_type OWNER TO pgadmin;

--
-- TOC entry 201 (class 1259 OID 20446)
-- Name: sqi_distribution_list; Type: SEQUENCE; Schema: anomalymon; Owner: pgadmin
--

CREATE SEQUENCE sqi_distribution_list
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sqi_distribution_list OWNER TO pgadmin;

--
-- TOC entry 202 (class 1259 OID 20448)
-- Name: distribution_list; Type: TABLE; Schema: anomalymon; Owner: pgadmin
--

CREATE TABLE distribution_list (
    id integer DEFAULT nextval('sqi_distribution_list'::regclass) NOT NULL,
    list text NOT NULL,
    dtm_created timestamp without time zone DEFAULT (timezone('America/New_York'::text, (now())::timestamp without time zone))::timestamp without time zone,
    dtm_last_modified timestamp without time zone DEFAULT (timezone('America/New_York'::text, (now())::timestamp without time zone))::timestamp without time zone,
    last_updated_by character varying(255) DEFAULT ("current_user"())::character varying(255) NOT NULL
);


ALTER TABLE distribution_list OWNER TO pgadmin;

--
-- TOC entry 195 (class 1259 OID 20391)
-- Name: sqi_model_parameters; Type: SEQUENCE; Schema: anomalymon; Owner: pgadmin
--

CREATE SEQUENCE sqi_model_parameters
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sqi_model_parameters OWNER TO pgadmin;

--
-- TOC entry 196 (class 1259 OID 20393)
-- Name: model_parameters; Type: TABLE; Schema: anomalymon; Owner: pgadmin
--

CREATE TABLE model_parameters (
    id integer DEFAULT nextval('sqi_model_parameters'::regclass) NOT NULL,
    instructions json,
    model_type_id integer,
    dtm_created timestamp without time zone DEFAULT (timezone('America/New_York'::text, (now())::timestamp without time zone))::timestamp without time zone,
    dtm_last_modified timestamp without time zone DEFAULT (timezone('America/New_York'::text, (now())::timestamp without time zone))::timestamp without time zone,
    last_updated_by character varying(255) DEFAULT ("current_user"())::character varying(255) NOT NULL
);


ALTER TABLE model_parameters OWNER TO pgadmin;

--
-- TOC entry 193 (class 1259 OID 20379)
-- Name: sqi_model_type; Type: SEQUENCE; Schema: anomalymon; Owner: pgadmin
--

CREATE SEQUENCE sqi_model_type
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sqi_model_type OWNER TO pgadmin;

--
-- TOC entry 194 (class 1259 OID 20381)
-- Name: model_type; Type: TABLE; Schema: anomalymon; Owner: pgadmin
--

CREATE TABLE model_type (
    id integer DEFAULT nextval('sqi_model_type'::regclass) NOT NULL,
    model_type_name character varying(100) NOT NULL,
    dtm_created timestamp without time zone DEFAULT (timezone('America/New_York'::text, (now())::timestamp without time zone))::timestamp without time zone,
    dtm_last_modified timestamp without time zone DEFAULT (timezone('America/New_York'::text, (now())::timestamp without time zone))::timestamp without time zone,
    last_updated_by character varying(255) DEFAULT ("current_user"())::character varying(255) NOT NULL
);


ALTER TABLE model_type OWNER TO pgadmin;

--
-- TOC entry 199 (class 1259 OID 20426)
-- Name: sqi_task; Type: SEQUENCE; Schema: anomalymon; Owner: pgadmin
--

CREATE SEQUENCE sqi_task
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sqi_task OWNER TO pgadmin;

--
-- TOC entry 205 (class 1259 OID 20476)
-- Name: sqi_task_threshold; Type: SEQUENCE; Schema: anomalymon; Owner: pgadmin
--

CREATE SEQUENCE sqi_task_threshold
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sqi_task_threshold OWNER TO pgadmin;

--
-- TOC entry 197 (class 1259 OID 20411)
-- Name: sqi_task_type; Type: SEQUENCE; Schema: anomalymon; Owner: pgadmin
--

CREATE SEQUENCE sqi_task_type
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sqi_task_type OWNER TO pgadmin;

--
-- TOC entry 200 (class 1259 OID 20428)
-- Name: task; Type: TABLE; Schema: anomalymon; Owner: pgadmin
--

CREATE TABLE task (
    id integer DEFAULT nextval('sqi_task'::regclass) NOT NULL,
    task_name character varying(255) NOT NULL,
    task_type_id integer NOT NULL,
    dtm_created timestamp without time zone DEFAULT (timezone('America/New_York'::text, (now())::timestamp without time zone))::timestamp without time zone,
    dtm_last_modified timestamp without time zone DEFAULT (timezone('America/New_York'::text, (now())::timestamp without time zone))::timestamp without time zone,
    last_updated_by character varying(255) DEFAULT ("current_user"())::character varying(255) NOT NULL
);


ALTER TABLE task OWNER TO pgadmin;

--
-- TOC entry 206 (class 1259 OID 20478)
-- Name: task_threshold; Type: TABLE; Schema: anomalymon; Owner: pgadmin
--

CREATE TABLE task_threshold (
    id integer DEFAULT nextval('sqi_task_threshold'::regclass) NOT NULL,
    parent_task_id integer,
    task_id integer NOT NULL,
    model_parameters_id integer NOT NULL,
    w_d smallint NOT NULL,
    alert_type_id integer NOT NULL,
    distribution_list_id integer,
    thr_lower integer,
    thr_upper integer,
    low_chk_bound integer,
    up_chk_bound integer,
    dtm_created timestamp without time zone DEFAULT (timezone('America/New_York'::text, (now())::timestamp without time zone))::timestamp without time zone,
    dtm_last_modified timestamp without time zone DEFAULT (timezone('America/New_York'::text, (now())::timestamp without time zone))::timestamp without time zone,
    last_updated_by character varying(255) DEFAULT ("current_user"())::character varying(255) NOT NULL
);


ALTER TABLE task_threshold OWNER TO pgadmin;

--
-- TOC entry 198 (class 1259 OID 20413)
-- Name: task_type; Type: TABLE; Schema: anomalymon; Owner: pgadmin
--

CREATE TABLE task_type (
    id integer DEFAULT nextval('sqi_task_type'::regclass) NOT NULL,
    task_type_name character varying(255) NOT NULL,
    dtm_created timestamp without time zone DEFAULT (timezone('America/New_York'::text, (now())::timestamp without time zone))::timestamp without time zone,
    dtm_last_modified timestamp without time zone DEFAULT (timezone('America/New_York'::text, (now())::timestamp without time zone))::timestamp without time zone,
    last_updated_by character varying(255) DEFAULT ("current_user"())::character varying(255) NOT NULL
);


ALTER TABLE task_type OWNER TO pgadmin;

--
-- TOC entry 208 (class 1259 OID 20555)
-- Name: v_task_appwrx_duration; Type: VIEW; Schema: anomalymon; Owner: pgadmin
--

CREATE VIEW v_task_appwrx_duration AS
 SELECT th.id AS threshold_id,
    th.parent_task_id,
        CASE
            WHEN (tp.task_name IS NULL) THEN 'N/A'::character varying
            ELSE tp.task_name
        END AS parent_task_name,
    th.task_id,
    tch.task_name,
    th.model_parameters_id,
    th.w_d,
    th.distribution_list_id,
    dl.list AS distribution_list,
    th.alert_type_id,
    al.alert_type_name,
    th.thr_lower,
    th.thr_upper,
    mp.model_type_id,
    mt.model_type_name
   FROM ((((((((task_threshold th
     JOIN task tch ON ((th.task_id = tch.id)))
     JOIN task_type tcht ON (((tcht.id = tch.task_type_id) AND ((tcht.task_type_name)::text = 'appworx_job'::text))))
     JOIN distribution_list dl ON ((dl.id = th.distribution_list_id)))
     JOIN alert_type al ON ((al.id = th.alert_type_id)))
     LEFT JOIN task tp ON ((th.parent_task_id = tp.id)))
     LEFT JOIN task_type tpt ON (((tpt.id = tp.task_type_id) AND ((tpt.task_type_name)::text = 'appworx_chain'::text))))
     JOIN model_parameters mp ON ((mp.id = th.model_parameters_id)))
     JOIN model_type mt ON ((mt.id = mp.model_type_id)))
  WHERE ((mt.model_type_name)::text = 'duration'::text);


ALTER TABLE v_task_appwrx_duration OWNER TO pgadmin;

--
-- TOC entry 207 (class 1259 OID 20550)
-- Name: v_task_appwrx_starttime; Type: VIEW; Schema: anomalymon; Owner: pgadmin
--

CREATE VIEW v_task_appwrx_starttime AS
 SELECT th.id AS threshold_id,
    th.parent_task_id,
        CASE
            WHEN (tp.task_name IS NULL) THEN 'N/A'::character varying
            ELSE tp.task_name
        END AS parent_task_name,
    th.task_id,
    tch.task_name,
    th.model_parameters_id,
    th.w_d,
    th.distribution_list_id,
    dl.list AS distribution_list,
    th.alert_type_id,
    al.alert_type_name,
    th.thr_lower,
    th.thr_upper,
    mp.model_type_id,
    mt.model_type_name
   FROM ((((((((task_threshold th
     JOIN task tch ON ((th.task_id = tch.id)))
     JOIN task_type tcht ON (((tcht.id = tch.task_type_id) AND ((tcht.task_type_name)::text = 'appworx_job'::text))))
     JOIN distribution_list dl ON ((dl.id = th.distribution_list_id)))
     JOIN alert_type al ON ((al.id = th.alert_type_id)))
     LEFT JOIN task tp ON ((th.parent_task_id = tp.id)))
     LEFT JOIN task_type tpt ON (((tpt.id = tp.task_type_id) AND ((tpt.task_type_name)::text = 'appworx_chain'::text))))
     JOIN model_parameters mp ON ((mp.id = th.model_parameters_id)))
     JOIN model_type mt ON ((mt.id = mp.model_type_id)))
  WHERE ((mt.model_type_name)::text = 'start_time'::text);


ALTER TABLE v_task_appwrx_starttime OWNER TO pgadmin;

SET search_path = job_anomaly, pg_catalog;




SET search_path = anomalymon, pg_catalog;

--
-- TOC entry 2926 (class 2606 OID 20474)
-- Name: alert_type_pkey; Type: CONSTRAINT; Schema: anomalymon; Owner: pgadmin
--

ALTER TABLE ONLY alert_type
    ADD CONSTRAINT alert_type_pkey PRIMARY KEY (id);


--
-- TOC entry 2924 (class 2606 OID 20459)
-- Name: distribution_list_pkey; Type: CONSTRAINT; Schema: anomalymon; Owner: pgadmin
--

ALTER TABLE ONLY distribution_list
    ADD CONSTRAINT distribution_list_pkey PRIMARY KEY (id);


--
-- TOC entry 2918 (class 2606 OID 20404)
-- Name: model_parameters_pkey; Type: CONSTRAINT; Schema: anomalymon; Owner: pgadmin
--

ALTER TABLE ONLY model_parameters
    ADD CONSTRAINT model_parameters_pkey PRIMARY KEY (id);


--
-- TOC entry 2915 (class 2606 OID 20389)
-- Name: model_type_pkey; Type: CONSTRAINT; Schema: anomalymon; Owner: pgadmin
--

ALTER TABLE ONLY model_type
    ADD CONSTRAINT model_type_pkey PRIMARY KEY (id);


--
-- TOC entry 2922 (class 2606 OID 20439)
-- Name: task_pkey; Type: CONSTRAINT; Schema: anomalymon; Owner: pgadmin
--

ALTER TABLE ONLY task
    ADD CONSTRAINT task_pkey PRIMARY KEY (id);


--
-- TOC entry 2930 (class 2606 OID 20486)
-- Name: task_threshold_pkey; Type: CONSTRAINT; Schema: anomalymon; Owner: pgadmin
--

ALTER TABLE ONLY task_threshold
    ADD CONSTRAINT task_threshold_pkey PRIMARY KEY (id);


--
-- TOC entry 2920 (class 2606 OID 20424)
-- Name: task_type_pkey; Type: CONSTRAINT; Schema: anomalymon; Owner: pgadmin
--

ALTER TABLE ONLY task_type
    ADD CONSTRAINT task_type_pkey PRIMARY KEY (id);


SET search_path = job_anomaly, pg_catalog;

--
-- TOC entry 2881 (class 2606 OID 17084)
-- Name: pk_appwrx_checks; Type: CONSTRAINT; Schema: job_anomaly; Owner: pgadmin
--


SET search_path = anomalymon, pg_catalog;

--
-- TOC entry 2916 (class 1259 OID 20518)
-- Name: model_parameters_model_type_id_idx; Type: INDEX; Schema: anomalymon; Owner: pgadmin
--

CREATE INDEX model_parameters_model_type_id_idx ON model_parameters USING btree (model_type_id);


--
-- TOC entry 2927 (class 1259 OID 20514)
-- Name: task_threshold_parent_task_id_task_id_model_parameters_id_idx; Type: INDEX; Schema: anomalymon; Owner: pgadmin
--

CREATE INDEX task_threshold_parent_task_id_task_id_model_parameters_id_idx ON task_threshold USING btree (parent_task_id, task_id, model_parameters_id);


--
-- TOC entry 2928 (class 1259 OID 20515)
-- Name: task_threshold_parent_task_id_task_id_w_d_idx; Type: INDEX; Schema: anomalymon; Owner: pgadmin
--

CREATE INDEX task_threshold_parent_task_id_task_id_w_d_idx ON task_threshold USING btree (parent_task_id, task_id, w_d);


--
-- TOC entry 2931 (class 1259 OID 20517)
-- Name: task_threshold_task_id_idx; Type: INDEX; Schema: anomalymon; Owner: pgadmin
--

CREATE INDEX task_threshold_task_id_idx ON task_threshold USING btree (task_id);


--
-- TOC entry 2932 (class 1259 OID 20516)
-- Name: task_threshold_w_d_idx; Type: INDEX; Schema: anomalymon; Owner: pgadmin
--

CREATE INDEX task_threshold_w_d_idx ON task_threshold USING btree (w_d);


SET search_path = job_anomaly, pg_catalog;


SET search_path = anomalymon, pg_catalog;

--
-- TOC entry 2948 (class 2620 OID 20475)
-- Name: tr_alert_type_update; Type: TRIGGER; Schema: anomalymon; Owner: pgadmin
--

CREATE TRIGGER tr_alert_type_update BEFORE UPDATE ON alert_type FOR EACH ROW EXECUTE PROCEDURE trf_alert_type_update_trigger();


--
-- TOC entry 2947 (class 2620 OID 20460)
-- Name: tr_distribution_list_update; Type: TRIGGER; Schema: anomalymon; Owner: pgadmin
--

CREATE TRIGGER tr_distribution_list_update BEFORE UPDATE ON distribution_list FOR EACH ROW EXECUTE PROCEDURE trf_distribution_list_update_trigger();


--
-- TOC entry 2944 (class 2620 OID 20410)
-- Name: tr_model_parameters_upd; Type: TRIGGER; Schema: anomalymon; Owner: pgadmin
--

CREATE TRIGGER tr_model_parameters_upd BEFORE UPDATE ON model_parameters FOR EACH ROW EXECUTE PROCEDURE trf_model_parameters_update_trigger();


--
-- TOC entry 2943 (class 2620 OID 20390)
-- Name: tr_model_type_upd; Type: TRIGGER; Schema: anomalymon; Owner: pgadmin
--

CREATE TRIGGER tr_model_type_upd BEFORE UPDATE ON model_type FOR EACH ROW EXECUTE PROCEDURE trf_model_type_update_trigger();


--
-- TOC entry 2949 (class 2620 OID 20512)
-- Name: tr_task_threshold_update; Type: TRIGGER; Schema: anomalymon; Owner: pgadmin
--

CREATE TRIGGER tr_task_threshold_update BEFORE UPDATE ON task_threshold FOR EACH ROW EXECUTE PROCEDURE trf_task_threshold_update_trigger();


--
-- TOC entry 2945 (class 2620 OID 20425)
-- Name: tr_task_type_update; Type: TRIGGER; Schema: anomalymon; Owner: pgadmin
--

CREATE TRIGGER tr_task_type_update BEFORE UPDATE ON task_type FOR EACH ROW EXECUTE PROCEDURE trf_task_type_update_trigger();


--
-- TOC entry 2946 (class 2620 OID 20445)
-- Name: tr_task_update; Type: TRIGGER; Schema: anomalymon; Owner: pgadmin
--

CREATE TRIGGER tr_task_update BEFORE UPDATE ON task FOR EACH ROW EXECUTE PROCEDURE trf_task_update_trigger();


--
-- TOC entry 2936 (class 2606 OID 20405)
-- Name: model_parameters_model_type_id_fkey; Type: FK CONSTRAINT; Schema: anomalymon; Owner: pgadmin
--

ALTER TABLE ONLY model_parameters
    ADD CONSTRAINT model_parameters_model_type_id_fkey FOREIGN KEY (model_type_id) REFERENCES model_type(id);


--
-- TOC entry 2937 (class 2606 OID 20440)
-- Name: task_task_type_id_fkey; Type: FK CONSTRAINT; Schema: anomalymon; Owner: pgadmin
--

ALTER TABLE ONLY task
    ADD CONSTRAINT task_task_type_id_fkey FOREIGN KEY (task_type_id) REFERENCES task_type(id);


--
-- TOC entry 2941 (class 2606 OID 20502)
-- Name: task_threshold_alert_type_id_fkey; Type: FK CONSTRAINT; Schema: anomalymon; Owner: pgadmin
--

ALTER TABLE ONLY task_threshold
    ADD CONSTRAINT task_threshold_alert_type_id_fkey FOREIGN KEY (alert_type_id) REFERENCES alert_type(id);


--
-- TOC entry 2942 (class 2606 OID 20507)
-- Name: task_threshold_distribution_list_id_fkey; Type: FK CONSTRAINT; Schema: anomalymon; Owner: pgadmin
--

ALTER TABLE ONLY task_threshold
    ADD CONSTRAINT task_threshold_distribution_list_id_fkey FOREIGN KEY (distribution_list_id) REFERENCES distribution_list(id);


--
-- TOC entry 2940 (class 2606 OID 20497)
-- Name: task_threshold_model_parameters_id_fkey; Type: FK CONSTRAINT; Schema: anomalymon; Owner: pgadmin
--

ALTER TABLE ONLY task_threshold
    ADD CONSTRAINT task_threshold_model_parameters_id_fkey FOREIGN KEY (model_parameters_id) REFERENCES model_parameters(id);


--
-- TOC entry 2938 (class 2606 OID 20487)
-- Name: task_threshold_parent_task_id_fkey; Type: FK CONSTRAINT; Schema: anomalymon; Owner: pgadmin
--

ALTER TABLE ONLY task_threshold
    ADD CONSTRAINT task_threshold_parent_task_id_fkey FOREIGN KEY (parent_task_id) REFERENCES task(id);


--
-- TOC entry 2939 (class 2606 OID 20492)
-- Name: task_threshold_task_id_fkey; Type: FK CONSTRAINT; Schema: anomalymon; Owner: pgadmin
--

ALTER TABLE ONLY task_threshold
    ADD CONSTRAINT task_threshold_task_id_fkey FOREIGN KEY (task_id) REFERENCES task(id);


SET search_path = job_anomaly, pg_catalog;

--
-- TOC entry 3064 (class 0 OID 0)
-- Dependencies: 8
-- Name: anomalymon; Type: ACL; Schema: -; Owner: pgadmin
--

REVOKE ALL ON SCHEMA anomalymon FROM PUBLIC;
REVOKE ALL ON SCHEMA anomalymon FROM pgadmin;
GRANT ALL ON SCHEMA anomalymon TO pgadmin;
GRANT ALL ON SCHEMA anomalymon TO modelmgr;
GRANT ALL ON SCHEMA anomalymon TO gr_job_anomaly;


--
-- TOC entry 3065 (class 0 OID 0)
-- Dependencies: 6
-- Name: job_anomaly; Type: ACL; Schema: -; Owner: pgadmin
--

REVOKE ALL ON SCHEMA job_anomaly FROM PUBLIC;
REVOKE ALL ON SCHEMA job_anomaly FROM pgadmin;
GRANT ALL ON SCHEMA job_anomaly TO pgadmin;
GRANT ALL ON SCHEMA job_anomaly TO modelmgr;
GRANT ALL ON SCHEMA job_anomaly TO gr_job_anomaly;


--
-- TOC entry 3066 (class 0 OID 0)
-- Dependencies: 232
-- Name: f_build_ora_check_start_q_body(date); Type: ACL; Schema: job_anomaly; Owner: pgadmin
--

REVOKE ALL ON FUNCTION f_build_ora_check_start_q_body(inp_curr_date date) FROM PUBLIC;
REVOKE ALL ON FUNCTION f_build_ora_check_start_q_body(inp_curr_date date) FROM pgadmin;
GRANT ALL ON FUNCTION f_build_ora_check_start_q_body(inp_curr_date date) TO pgadmin;
GRANT ALL ON FUNCTION f_build_ora_check_start_q_body(inp_curr_date date) TO PUBLIC;
GRANT ALL ON FUNCTION f_build_ora_check_start_q_body(inp_curr_date date) TO gr_job_anomaly;


--
-- TOC entry 3067 (class 0 OID 0)
-- Dependencies: 231
-- Name: f_build_ora_check_start_q_header_tail(smallint, date); Type: ACL; Schema: job_anomaly; Owner: pgadmin
--

REVOKE ALL ON FUNCTION f_build_ora_check_start_q_header_tail(tret smallint, appwrx_date date) FROM PUBLIC;
REVOKE ALL ON FUNCTION f_build_ora_check_start_q_header_tail(tret smallint, appwrx_date date) FROM pgadmin;
GRANT ALL ON FUNCTION f_build_ora_check_start_q_header_tail(tret smallint, appwrx_date date) TO pgadmin;
GRANT ALL ON FUNCTION f_build_ora_check_start_q_header_tail(tret smallint, appwrx_date date) TO PUBLIC;
GRANT ALL ON FUNCTION f_build_ora_check_start_q_header_tail(tret smallint, appwrx_date date) TO gr_job_anomaly;


--
-- TOC entry 3068 (class 0 OID 0)
-- Dependencies: 224
-- Name: f_curr_timestamp_dummy(); Type: ACL; Schema: job_anomaly; Owner: pgadmin
--

REVOKE ALL ON FUNCTION f_curr_timestamp_dummy() FROM PUBLIC;
REVOKE ALL ON FUNCTION f_curr_timestamp_dummy() FROM pgadmin;
GRANT ALL ON FUNCTION f_curr_timestamp_dummy() TO pgadmin;
GRANT ALL ON FUNCTION f_curr_timestamp_dummy() TO PUBLIC;
GRANT ALL ON FUNCTION f_curr_timestamp_dummy() TO gr_job_anomaly;


--
-- TOC entry 3069 (class 0 OID 0)
-- Dependencies: 229
-- Name: f_update_appwrx_checks(boolean, boolean, bigint); Type: ACL; Schema: job_anomaly; Owner: pgadmin
--

REVOKE ALL ON FUNCTION f_update_appwrx_checks(inp_is_completed boolean, inp_is_succesfull boolean, inp_check_id bigint) FROM PUBLIC;
REVOKE ALL ON FUNCTION f_update_appwrx_checks(inp_is_completed boolean, inp_is_succesfull boolean, inp_check_id bigint) FROM pgadmin;
GRANT ALL ON FUNCTION f_update_appwrx_checks(inp_is_completed boolean, inp_is_succesfull boolean, inp_check_id bigint) TO pgadmin;
GRANT ALL ON FUNCTION f_update_appwrx_checks(inp_is_completed boolean, inp_is_succesfull boolean, inp_check_id bigint) TO PUBLIC;
GRANT ALL ON FUNCTION f_update_appwrx_checks(inp_is_completed boolean, inp_is_succesfull boolean, inp_check_id bigint) TO gr_job_anomaly;


--
-- TOC entry 3070 (class 0 OID 0)
-- Dependencies: 230
-- Name: f_update_appwrx_duration_alerts_history(boolean, bigint); Type: ACL; Schema: job_anomaly; Owner: pgadmin
--

REVOKE ALL ON FUNCTION f_update_appwrx_duration_alerts_history(inp_alert_sent boolean, inp_duration_alert_id bigint) FROM PUBLIC;
REVOKE ALL ON FUNCTION f_update_appwrx_duration_alerts_history(inp_alert_sent boolean, inp_duration_alert_id bigint) FROM pgadmin;
GRANT ALL ON FUNCTION f_update_appwrx_duration_alerts_history(inp_alert_sent boolean, inp_duration_alert_id bigint) TO pgadmin;
GRANT ALL ON FUNCTION f_update_appwrx_duration_alerts_history(inp_alert_sent boolean, inp_duration_alert_id bigint) TO PUBLIC;
GRANT ALL ON FUNCTION f_update_appwrx_duration_alerts_history(inp_alert_sent boolean, inp_duration_alert_id bigint) TO gr_job_anomaly;


--
-- TOC entry 3071 (class 0 OID 0)
-- Dependencies: 227
-- Name: f_update_appwrx_start_time_alerts(boolean, bigint); Type: ACL; Schema: job_anomaly; Owner: pgadmin
--

REVOKE ALL ON FUNCTION f_update_appwrx_start_time_alerts(inp_alert_sent boolean, inp_alert_id bigint) FROM PUBLIC;
REVOKE ALL ON FUNCTION f_update_appwrx_start_time_alerts(inp_alert_sent boolean, inp_alert_id bigint) FROM pgadmin;
GRANT ALL ON FUNCTION f_update_appwrx_start_time_alerts(inp_alert_sent boolean, inp_alert_id bigint) TO pgadmin;
GRANT ALL ON FUNCTION f_update_appwrx_start_time_alerts(inp_alert_sent boolean, inp_alert_id bigint) TO PUBLIC;
GRANT ALL ON FUNCTION f_update_appwrx_start_time_alerts(inp_alert_sent boolean, inp_alert_id bigint) TO gr_job_anomaly;


--
-- TOC entry 3072 (class 0 OID 0)
-- Dependencies: 240
-- Name: p_create_new_alert_records(integer); Type: ACL; Schema: job_anomaly; Owner: pgadmin
--

REVOKE ALL ON FUNCTION p_create_new_alert_records(inp_check_id integer) FROM PUBLIC;
REVOKE ALL ON FUNCTION p_create_new_alert_records(inp_check_id integer) FROM pgadmin;
GRANT ALL ON FUNCTION p_create_new_alert_records(inp_check_id integer) TO pgadmin;
GRANT ALL ON FUNCTION p_create_new_alert_records(inp_check_id integer) TO PUBLIC;
GRANT ALL ON FUNCTION p_create_new_alert_records(inp_check_id integer) TO gr_job_anomaly;


--
-- TOC entry 3073 (class 0 OID 0)
-- Dependencies: 228
-- Name: p_create_new_check(character varying, date); Type: ACL; Schema: job_anomaly; Owner: pgadmin
--

REVOKE ALL ON FUNCTION p_create_new_check(inp_type character varying, inp_date_check date) FROM PUBLIC;
REVOKE ALL ON FUNCTION p_create_new_check(inp_type character varying, inp_date_check date) FROM pgadmin;
GRANT ALL ON FUNCTION p_create_new_check(inp_type character varying, inp_date_check date) TO pgadmin;
GRANT ALL ON FUNCTION p_create_new_check(inp_type character varying, inp_date_check date) TO PUBLIC;
GRANT ALL ON FUNCTION p_create_new_check(inp_type character varying, inp_date_check date) TO gr_job_anomaly;


--
-- TOC entry 3074 (class 0 OID 0)
-- Dependencies: 241
-- Name: p_query_duration_send_alert_records(timestamp without time zone); Type: ACL; Schema: job_anomaly; Owner: pgadmin
--

REVOKE ALL ON FUNCTION p_query_duration_send_alert_records(inp_date_time timestamp without time zone) FROM PUBLIC;
REVOKE ALL ON FUNCTION p_query_duration_send_alert_records(inp_date_time timestamp without time zone) FROM pgadmin;
GRANT ALL ON FUNCTION p_query_duration_send_alert_records(inp_date_time timestamp without time zone) TO pgadmin;
GRANT ALL ON FUNCTION p_query_duration_send_alert_records(inp_date_time timestamp without time zone) TO PUBLIC;
GRANT ALL ON FUNCTION p_query_duration_send_alert_records(inp_date_time timestamp without time zone) TO gr_job_anomaly;


--
-- TOC entry 3075 (class 0 OID 0)
-- Dependencies: 226
-- Name: p_query_send_alert_records(); Type: ACL; Schema: job_anomaly; Owner: pgadmin
--

REVOKE ALL ON FUNCTION p_query_send_alert_records() FROM PUBLIC;
REVOKE ALL ON FUNCTION p_query_send_alert_records() FROM pgadmin;
GRANT ALL ON FUNCTION p_query_send_alert_records() TO pgadmin;
GRANT ALL ON FUNCTION p_query_send_alert_records() TO PUBLIC;
GRANT ALL ON FUNCTION p_query_send_alert_records() TO gr_job_anomaly;


SET search_path = anomalymon, pg_catalog;

--
-- TOC entry 3076 (class 0 OID 0)
-- Dependencies: 203
-- Name: sqi_alert_type; Type: ACL; Schema: anomalymon; Owner: pgadmin
--

REVOKE ALL ON SEQUENCE sqi_alert_type FROM PUBLIC;
REVOKE ALL ON SEQUENCE sqi_alert_type FROM pgadmin;
GRANT ALL ON SEQUENCE sqi_alert_type TO pgadmin;
GRANT ALL ON SEQUENCE sqi_alert_type TO gr_job_anomaly;


--
-- TOC entry 3077 (class 0 OID 0)
-- Dependencies: 204
-- Name: alert_type; Type: ACL; Schema: anomalymon; Owner: pgadmin
--

REVOKE ALL ON TABLE alert_type FROM PUBLIC;
REVOKE ALL ON TABLE alert_type FROM pgadmin;
GRANT ALL ON TABLE alert_type TO pgadmin;
GRANT ALL ON TABLE alert_type TO modelmgr;
GRANT ALL ON TABLE alert_type TO gr_job_anomaly;


--
-- TOC entry 3078 (class 0 OID 0)
-- Dependencies: 201
-- Name: sqi_distribution_list; Type: ACL; Schema: anomalymon; Owner: pgadmin
--

REVOKE ALL ON SEQUENCE sqi_distribution_list FROM PUBLIC;
REVOKE ALL ON SEQUENCE sqi_distribution_list FROM pgadmin;
GRANT ALL ON SEQUENCE sqi_distribution_list TO pgadmin;
GRANT ALL ON SEQUENCE sqi_distribution_list TO gr_job_anomaly;


--
-- TOC entry 3079 (class 0 OID 0)
-- Dependencies: 202
-- Name: distribution_list; Type: ACL; Schema: anomalymon; Owner: pgadmin
--

REVOKE ALL ON TABLE distribution_list FROM PUBLIC;
REVOKE ALL ON TABLE distribution_list FROM pgadmin;
GRANT ALL ON TABLE distribution_list TO pgadmin;
GRANT ALL ON TABLE distribution_list TO modelmgr;
GRANT ALL ON TABLE distribution_list TO gr_job_anomaly;


--
-- TOC entry 3080 (class 0 OID 0)
-- Dependencies: 195
-- Name: sqi_model_parameters; Type: ACL; Schema: anomalymon; Owner: pgadmin
--

REVOKE ALL ON SEQUENCE sqi_model_parameters FROM PUBLIC;
REVOKE ALL ON SEQUENCE sqi_model_parameters FROM pgadmin;
GRANT ALL ON SEQUENCE sqi_model_parameters TO pgadmin;
GRANT ALL ON SEQUENCE sqi_model_parameters TO gr_job_anomaly;


--
-- TOC entry 3081 (class 0 OID 0)
-- Dependencies: 196
-- Name: model_parameters; Type: ACL; Schema: anomalymon; Owner: pgadmin
--

REVOKE ALL ON TABLE model_parameters FROM PUBLIC;
REVOKE ALL ON TABLE model_parameters FROM pgadmin;
GRANT ALL ON TABLE model_parameters TO pgadmin;
GRANT ALL ON TABLE model_parameters TO modelmgr;
GRANT ALL ON TABLE model_parameters TO gr_job_anomaly;


--
-- TOC entry 3082 (class 0 OID 0)
-- Dependencies: 193
-- Name: sqi_model_type; Type: ACL; Schema: anomalymon; Owner: pgadmin
--

REVOKE ALL ON SEQUENCE sqi_model_type FROM PUBLIC;
REVOKE ALL ON SEQUENCE sqi_model_type FROM pgadmin;
GRANT ALL ON SEQUENCE sqi_model_type TO pgadmin;
GRANT ALL ON SEQUENCE sqi_model_type TO gr_job_anomaly;


--
-- TOC entry 3083 (class 0 OID 0)
-- Dependencies: 194
-- Name: model_type; Type: ACL; Schema: anomalymon; Owner: pgadmin
--

REVOKE ALL ON TABLE model_type FROM PUBLIC;
REVOKE ALL ON TABLE model_type FROM pgadmin;
GRANT ALL ON TABLE model_type TO pgadmin;
GRANT ALL ON TABLE model_type TO modelmgr;
GRANT ALL ON TABLE model_type TO gr_job_anomaly;


--
-- TOC entry 3084 (class 0 OID 0)
-- Dependencies: 199
-- Name: sqi_task; Type: ACL; Schema: anomalymon; Owner: pgadmin
--

REVOKE ALL ON SEQUENCE sqi_task FROM PUBLIC;
REVOKE ALL ON SEQUENCE sqi_task FROM pgadmin;
GRANT ALL ON SEQUENCE sqi_task TO pgadmin;
GRANT ALL ON SEQUENCE sqi_task TO gr_job_anomaly;


--
-- TOC entry 3085 (class 0 OID 0)
-- Dependencies: 205
-- Name: sqi_task_threshold; Type: ACL; Schema: anomalymon; Owner: pgadmin
--

REVOKE ALL ON SEQUENCE sqi_task_threshold FROM PUBLIC;
REVOKE ALL ON SEQUENCE sqi_task_threshold FROM pgadmin;
GRANT ALL ON SEQUENCE sqi_task_threshold TO pgadmin;
GRANT ALL ON SEQUENCE sqi_task_threshold TO gr_job_anomaly;


--
-- TOC entry 3086 (class 0 OID 0)
-- Dependencies: 197
-- Name: sqi_task_type; Type: ACL; Schema: anomalymon; Owner: pgadmin
--

REVOKE ALL ON SEQUENCE sqi_task_type FROM PUBLIC;
REVOKE ALL ON SEQUENCE sqi_task_type FROM pgadmin;
GRANT ALL ON SEQUENCE sqi_task_type TO pgadmin;
GRANT ALL ON SEQUENCE sqi_task_type TO gr_job_anomaly;


--
-- TOC entry 3087 (class 0 OID 0)
-- Dependencies: 200
-- Name: task; Type: ACL; Schema: anomalymon; Owner: pgadmin
--

REVOKE ALL ON TABLE task FROM PUBLIC;
REVOKE ALL ON TABLE task FROM pgadmin;
GRANT ALL ON TABLE task TO pgadmin;
GRANT ALL ON TABLE task TO modelmgr;
GRANT ALL ON TABLE task TO gr_job_anomaly;


--
-- TOC entry 3088 (class 0 OID 0)
-- Dependencies: 206
-- Name: task_threshold; Type: ACL; Schema: anomalymon; Owner: pgadmin
--

REVOKE ALL ON TABLE task_threshold FROM PUBLIC;
REVOKE ALL ON TABLE task_threshold FROM pgadmin;
GRANT ALL ON TABLE task_threshold TO pgadmin;
GRANT ALL ON TABLE task_threshold TO modelmgr;
GRANT ALL ON TABLE task_threshold TO gr_job_anomaly;


--
-- TOC entry 3089 (class 0 OID 0)
-- Dependencies: 198
-- Name: task_type; Type: ACL; Schema: anomalymon; Owner: pgadmin
--

REVOKE ALL ON TABLE task_type FROM PUBLIC;
REVOKE ALL ON TABLE task_type FROM pgadmin;
GRANT ALL ON TABLE task_type TO pgadmin;
GRANT ALL ON TABLE task_type TO modelmgr;
GRANT ALL ON TABLE task_type TO gr_job_anomaly;


--
-- TOC entry 3090 (class 0 OID 0)
-- Dependencies: 208
-- Name: v_task_appwrx_duration; Type: ACL; Schema: anomalymon; Owner: pgadmin
--

REVOKE ALL ON TABLE v_task_appwrx_duration FROM PUBLIC;
REVOKE ALL ON TABLE v_task_appwrx_duration FROM pgadmin;
GRANT ALL ON TABLE v_task_appwrx_duration TO pgadmin;
GRANT ALL ON TABLE v_task_appwrx_duration TO modelmgr;
GRANT ALL ON TABLE v_task_appwrx_duration TO gr_job_anomaly;


--
-- TOC entry 3091 (class 0 OID 0)
-- Dependencies: 207
-- Name: v_task_appwrx_starttime; Type: ACL; Schema: anomalymon; Owner: pgadmin
--

REVOKE ALL ON TABLE v_task_appwrx_starttime FROM PUBLIC;
REVOKE ALL ON TABLE v_task_appwrx_starttime FROM pgadmin;
GRANT ALL ON TABLE v_task_appwrx_starttime TO pgadmin;
GRANT ALL ON TABLE v_task_appwrx_starttime TO modelmgr;
GRANT ALL ON TABLE v_task_appwrx_starttime TO gr_job_anomaly;


--
-- TOC entry 3113 (class 0 OID 0)
-- Dependencies: 209
-- Name: v_module_stats; Type: ACL; Schema: job_anomaly; Owner: pgadmin
--

--
-- PostgreSQL database dump complete
--

