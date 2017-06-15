SELECT
                        'anomalymon.alert_type' as t_name
                        ,count(*) as cnt
                        FROM anomalymon.alert_type ;
SELECT
                        'anomalymon.appwrx_so_job_history' as t_name
                        ,count(*) as cnt
                        FROM anomalymon.appwrx_so_job_history ;
SELECT
                        'anomalymon.distribution_list' as t_name
                        ,count(*) as cnt
                        FROM anomalymon.distribution_list ;
SELECT
                        'anomalymon.list_of_jobs_to_disable_false_alerts' as t_name
                        ,count(*) as cnt
                        FROM anomalymon.list_of_jobs_to_disable_false_alerts ;
SELECT
                        'anomalymon.model_parameters' as t_name
                        ,count(*) as cnt
                        FROM anomalymon.model_parameters ;
SELECT
                        'anomalymon.model_parameters_depl' as t_name
                        ,count(*) as cnt
                        FROM anomalymon.model_parameters_depl ;
SELECT
                        'anomalymon.model_type' as t_name
                        ,count(*) as cnt
                        FROM anomalymon.model_type ;
SELECT
                        'anomalymon.task' as t_name
                        ,count(*) as cnt
                        FROM anomalymon.task ;
SELECT
                        'anomalymon.task_depl' as t_name
                        ,count(*) as cnt
                        FROM anomalymon.task_depl ;
SELECT
                        'anomalymon.task_threshold' as t_name
                        ,count(*) as cnt
                        FROM anomalymon.task_threshold ;
SELECT
                        'anomalymon.task_threshold_depl' as t_name
                        ,count(*) as cnt
                        FROM anomalymon.task_threshold_depl ;
SELECT
                        'anomalymon.task_type' as t_name
                        ,count(*) as cnt
                        FROM anomalymon.task_type ;