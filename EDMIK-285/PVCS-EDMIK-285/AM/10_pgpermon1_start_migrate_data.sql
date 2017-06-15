SELECT am_migrate.migrate_amperfmgr_analytics_tables('host=pgedm1p.cicnuemrayu5.us-east-1.rds.amazonaws.com port=5452 user=pgadmin password=xxxxxxxxxx dbname=pgperfmon1'); --1 min 

SELECT am_migrate.migrate_amperfmgr_dic_tables('host=pgedm1p.cicnuemrayu5.us-east-1.rds.amazonaws.com port=5452 user=pgadmin password=xxxxxxxxxx dbname=pgperfmon1');  -- 1 min 

SELECT am_migrate.migrate_amperfmgr_stat_aggr_tables('host=pgedm1p.cicnuemrayu5.us-east-1.rds.amazonaws.com port=5452 user=pgadmin password=xxxxxxxxxx dbname=pgperfmon1'); -- 229 sec

SELECT am_migrate.migrate_amstgmgr_stage_tables('host=pgedm1p.cicnuemrayu5.us-east-1.rds.amazonaws.com port=5452 user=pgadmin password=xxxxxxxxxx dbname=pgperfmon1'); 