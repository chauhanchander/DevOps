#!/bin/ksh

export ORACLE_HOME="/appinfd/oracle/product/11.1.0"
export TNS_ADMIN="/appfdr/fdr/informatica"
export PGPASSWORD="S8kw0sfg4d"

appwrx_dbuser=""
appwrx_dbpass=""
appwrx_conn="CVAPPWXP.CABLEVISION.COM"

pstgr_host="pgedm1p.cicnuemrayu5.us-east-1.rds.amazonaws.com"
pstgr_port="5452"
pstgr_usr="anomalymgr"
pstrg_db="appworxmon_uat"
psql_bin="/appfdr/fdr/informatica/Greenplum/greenplum-clients-4.2.2.0-build-5/bin"
alert_distr_list="yfedorch@cablevision.com"

