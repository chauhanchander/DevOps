SELECT
                        'job_anomaly.appwrx_checks' as t_name
                        ,count(*) as cnt
                        FROM job_anomaly.appwrx_checks ;
SELECT
                        'job_anomaly.appwrx_duration_alerts_history' as t_name
                        ,count(*) as cnt
                        FROM job_anomaly.appwrx_duration_alerts_history ;
SELECT
                        'job_anomaly.appwrx_duration_alerts_history_bckp' as t_name
                        ,count(*) as cnt
                        FROM job_anomaly.appwrx_duration_alerts_history_bckp ;
SELECT
                        'job_anomaly.appwrx_start_time_alerts' as t_name
                        ,count(*) as cnt
                        FROM job_anomaly.appwrx_start_time_alerts ;
SELECT
                        'job_anomaly.appwrx_start_time_check_history' as t_name
                        ,count(*) as cnt
                        FROM job_anomaly.appwrx_start_time_check_history ;
SELECT
                        'job_anomaly.map_rs_nz_jobs' as t_name
                        ,count(*) as cnt
                        FROM job_anomaly.map_rs_nz_jobs ;
SELECT
                        'job_anomaly.module_stats' as t_name
                        ,count(*) as cnt
                        FROM job_anomaly.module_stats ;
SELECT
                        'job_anomaly.module_stats_stg' as t_name
                        ,count(*) as cnt
                        FROM job_anomaly.module_stats_stg ;
SELECT
                        'job_anomaly.test1' as t_name
                        ,count(*) as cnt
                        FROM job_anomaly.test1 ;
