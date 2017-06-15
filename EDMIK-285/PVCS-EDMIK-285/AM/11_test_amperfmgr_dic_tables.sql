SELECT
                        'amperfmgr.dic_instance' as t_name
                        ,count(*) as cnt
                        ,min(id) as min_id
                        , max(id) as max_id
                        FROM amperfmgr.dic_instance ;
SELECT
                        'amperfmgr.dic_metric' as t_name
                        ,count(*) as cnt
                        ,min(id) as min_id
                        , max(id) as max_id
                        FROM amperfmgr.dic_metric ;
SELECT
                        'amperfmgr.dic_metric_dimension' as t_name
                        ,count(*) as cnt
                        ,min(id) as min_id
                        , max(id) as max_id
                        FROM amperfmgr.dic_metric_dimension ;
SELECT
                        'amperfmgr.dic_request_type' as t_name
                        ,count(*) as cnt
                        ,min(id) as min_id
                        , max(id) as max_id
                        FROM amperfmgr.dic_request_type ;
SELECT
                        'amperfmgr.dic_resource' as t_name
                        ,count(*) as cnt
                        ,min(id) as min_id
                        , max(id) as max_id
                        FROM amperfmgr.dic_resource ;
SELECT
                        'amperfmgr.dic_rs_resource_connection' as t_name
                        ,count(*) as cnt
                        ,min(id) as min_id
                        , max(id) as max_id
                        FROM amperfmgr.dic_rs_resource_connection ;
SELECT
                        'amperfmgr.dic_unit' as t_name
                        ,count(*) as cnt
                        ,min(id) as min_id
                        , max(id) as max_id
                        FROM amperfmgr.dic_unit ;
SELECT
                        'amperfmgr.dic_value_type' as t_name
                        ,count(*) as cnt
                        ,min(id) as min_id
                        , max(id) as max_id
                        FROM amperfmgr.dic_value_type ;

