-- Function: job_anomaly.f_build_ora_check_start_q_header_tail(smallint, date)

-- DROP FUNCTION job_anomaly.f_build_ora_check_start_q_header_tail(smallint, date);

CREATE OR REPLACE FUNCTION job_anomaly.f_build_ora_check_start_q_header_tail(
    tret smallint,
    appwrx_date date)
  RETURNS text AS
$BODY$

DECLARE sql text;
BEGIN
IF tret = 0 THEN
SELECT
concat('
SET PAGESIZE 0 SPACE 0 FEEDBACK OFF TRIMSPOOL ON HEADING OFF linesize 700  NEWPAGE 0 ECHO OFF COLSEP '','';
SET VERIFY OFF;
SET SERVEROUTPUT ON SIZE UNLIMITED;
SELECT
        m.so_parent_name
        ,m.so_module
        ,m.st_wd
        ,to_char(m.dt_lower,''yyyy-mm-dd hh24:mi:ss'') as dt_lower
        ,to_char(m.dt_upper,''yyyy-mm-dd hh24:mi:ss'') as dt_upper
        ,m.duration_lower
        ,m.duration_upper
        ,d.SO_MODULE
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
                      -- job started after yesterday upper_time but before today lower time and yesterday run within 
                      when d.SO_JOB_STARTED < m.dt_lower and d.SO_JOB_STARTED > m.dt_upper - 1
                      -- early
                      then 2    
                      when d.SO_JOB_STARTED > m.dt_upper
                      --impossible
                      then  -7
                    end
                  when d.SO_MODULE is null
                  -- not started yet
                  then -1
                end
               when sysdate < m.dt_lower
              then  
                case 
                  when sysdate > m.dt_upper -1    
                  then 
				  -- previous run should be completed ,current not started
                  --  l 2015-07-01 23:00  s 2015-07-01 21:00 u 2015-07-02 22:00
                    case
                      when d.SO_MODULE is not null 
                      then 
                        case
                          when d.SO_JOB_STARTED between m.dt_lower -1  AND m.dt_upper -1
                          -- in time
                          then  1
                          when d.SO_JOB_STARTED > m.dt_upper -1 and d.SO_JOB_STARTED < m.dt_lower 
                          -- early or later
                          then 3
                        end
                      when d.SO_MODULE is null and dy.SO_MODULE is not null 
                      then 
                        case 
                          when dy.SO_JOB_STARTED between m.dt_lower -1  AND m.dt_upper -1
                          then 1
                          when dy.SO_JOB_STARTED < m.dt_lower -1 AND dy.SO_JOB_STARTED > m.dt_upper -2
                          -- early yesterday
                          then 2
                        end
                      when d.SO_MODULE is null and dy.SO_MODULE is null
                      -- job not started after upper time
                      then 5
                    end
                  when sysdate <= m.dt_upper -1 
                  then  -- run could be in progress or completed or not started yet
                    case
                      when d.SO_MODULE is not null 
                      then
                        case
                          when d.SO_JOB_STARTED between m.dt_lower -1  AND m.dt_upper -1
                          -- in time
                          then  1
                          when d.SO_JOB_STARTED < m.dt_lower -1 and d.SO_JOB_STARTED > m.dt_upper -2
                          -- early 
                          then 2
                        end                        
                      when d.SO_MODULE is null AND dy.SO_MODULE is not null
                      then
                        case
                          when dy.SO_JOB_STARTED between m.dt_lower -1  AND m.dt_upper -1
                          -- in time
                          then  1
                          when dy.SO_JOB_STARTED < m.dt_lower -1 AND dy.SO_JOB_STARTED > m.dt_upper -2
                          -- early
                          then  2
                        end
                      when d.SO_MODULE is null AND dy.SO_MODULE is null
                        -- not started yet
                        then -1   
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION job_anomaly.f_build_ora_check_start_q_header_tail(smallint, date)
  OWNER TO pgadmin;
GRANT EXECUTE ON FUNCTION job_anomaly.f_build_ora_check_start_q_header_tail(smallint, date) TO pgadmin;
GRANT EXECUTE ON FUNCTION job_anomaly.f_build_ora_check_start_q_header_tail(smallint, date) TO public;
GRANT EXECUTE ON FUNCTION job_anomaly.f_build_ora_check_start_q_header_tail(smallint, date) TO gr_job_anomaly;
