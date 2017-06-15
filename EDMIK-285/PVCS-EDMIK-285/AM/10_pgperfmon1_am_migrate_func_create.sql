--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.5
-- Dumped by pg_dump version 9.4.5
-- Started on 2016-06-16 11:02:08

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 9 (class 2615 OID 34045)
-- Name: am_migrate; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA am_migrate;


ALTER SCHEMA am_migrate OWNER TO postgres;

SET search_path = am_migrate, pg_catalog;

--
-- TOC entry 435 (class 1255 OID 34047)
-- Name: f_query_dblink_insert_body(character varying, character varying); Type: FUNCTION; Schema: am_migrate; Owner: pgadmin
--

CREATE FUNCTION f_query_dblink_insert_body(inp_table_schema character varying, inp_table_name character varying) RETURNS SETOF text
    LANGUAGE plpgsql
    AS $$
BEGIN

   RETURN QUERY

	SELECT 
		ut.body_descr

	FROM
	(
	
	SELECT 1 as order_1,1 as order_2 ,'INSERT INTO '|| inp_table_schema||'.'|| inp_table_name || '( ' as body_descr
   
	UNION 
	
	SELECT 2 as order_1 , ordinal_position as order_2,case when ordinal_position <> 1 then ',' else '' end || column_name as body_descr
	FROM (
		SELECT  ordinal_position ,column_name 
		FROM INFORMATION_SCHEMA.COLUMNS 
		WHERE table_name = inp_table_name and table_schema = inp_table_schema
		ORDER BY ordinal_position
	) d 

	UNION 

	SELECT 3 as order_1 ,1 as order_2 , ') SELECT ' as body_descr

	UNION 

	SELECT 4 as order_1 , ordinal_position as order_2,case when ordinal_position <> 1 then ',' else '' end || column_name as body_descr
	FROM (
		SELECT  ordinal_position ,column_name 
		FROM INFORMATION_SCHEMA.COLUMNS 
		WHERE table_name = inp_table_name and table_schema = inp_table_schema
		ORDER BY ordinal_position
	) d 	 

	UNION

	SELECT 5 as order_1 ,1 as order_2, ' FROM dblink(''myconn'', '' SELECT * FROM '|| inp_table_schema||'.'|| inp_table_name  ||';'') AS res_table (' as body_descr

	UNION

	SELECT 6 as order_1 , ordinal_position as order_2,case when ordinal_position <> 1 then ',' else '' end || column_name as body_descr
	FROM (
		SELECT  ordinal_position ,column_name ||' '|| data_type as column_name
		FROM INFORMATION_SCHEMA.COLUMNS 
		WHERE table_name = inp_table_name and table_schema = inp_table_schema
		ORDER BY ordinal_position
	) d 	

	UNION

	SELECT 7 as order_1 , 1 as order_2,');' as body_descr
	
	) ut
	
	ORDER BY ut.order_1 ,ut.order_2
  ;

END
$$;


ALTER FUNCTION am_migrate.f_query_dblink_insert_body(inp_table_schema character varying, inp_table_name character varying) OWNER TO pgadmin;

--
-- TOC entry 433 (class 1255 OID 40968)
-- Name: migrate_amperfmgr_analytics_tables(text); Type: FUNCTION; Schema: am_migrate; Owner: postgres
--

CREATE FUNCTION migrate_amperfmgr_analytics_tables(link_host text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE sql text;
	result text;
	MaxQuery integer;

BEGIN
	SET search_path TO stage, public;
	PERFORM dblink_connect('myconn', link_host);

--- auto_am_metric_data

INSERT INTO amperfmgr.auto_am_metric_data( 
id
,request_id
,resource_id
,metric_id
,unit_id
,metric_source_time
,value
) SELECT 
id
,request_id
,resource_id
,metric_id
,unit_id
,metric_source_time
,value
 FROM dblink('myconn', ' SELECT * FROM amperfmgr.auto_am_metric_data;') AS res_table (
id bigint
,request_id bigint
,resource_id integer
,metric_id integer
,unit_id smallint
,metric_source_time timestamp without time zone
,value numeric
);

--- auto_am_metric_sql

INSERT INTO amperfmgr.auto_am_metric_sql( 
id
,resource_id
,metric_id
,metric_sql
,unit_id
) SELECT 
id
,resource_id
,metric_id
,metric_sql
,unit_id
 FROM dblink('myconn', ' SELECT * FROM amperfmgr.auto_am_metric_sql;') AS res_table (
id bigint
,resource_id integer
,metric_id integer
,metric_sql text
,unit_id integer
);


-- kpi_data_sets

INSERT INTO amperfmgr.kpi_data_sets( 
instance_name
,sla
,capacity
,backup
,system_utilization
,user_experience
,data_quality
,overall
) SELECT 
instance_name
,sla
,capacity
,backup
,system_utilization
,user_experience
,data_quality
,overall
 FROM dblink('myconn', ' SELECT * FROM amperfmgr.kpi_data_sets;') AS res_table (
instance_name character varying
,sla smallint
,capacity smallint
,backup smallint
,system_utilization smallint
,user_experience smallint
,data_quality smallint
,overall smallint
);


-- nz_total_weekly_capacity_predict

INSERT INTO amperfmgr.nz_total_weekly_capacity_predict( 
dt
,instance_name
,m1
,m2
,m3
,m4
,m5
,m6
,m7
,m8
,m9
,m10
,m11
,m12
) SELECT 
dt
,instance_name
,m1
,m2
,m3
,m4
,m5
,m6
,m7
,m8
,m9
,m10
,m11
,m12
 FROM dblink('myconn', ' SELECT * FROM amperfmgr.nz_total_weekly_capacity_predict;') AS res_table (
dt date
,instance_name character varying
,m1 bigint
,m2 bigint
,m3 bigint
,m4 bigint
,m5 bigint
,m6 bigint
,m7 bigint
,m8 bigint
,m9 bigint
,m10 bigint
,m11 bigint
,m12 bigint
);

-- nz_weekly_capacity_predict


INSERT INTO amperfmgr.nz_weekly_capacity_predict( 
dt
,instance_name
,db_name
,m1
,m2
,m3
,m4
,m5
,m6
,m7
,m8
,m9
,m10
,m11
,m12
) SELECT 
dt
,instance_name
,db_name
,m1
,m2
,m3
,m4
,m5
,m6
,m7
,m8
,m9
,m10
,m11
,m12
 FROM dblink('myconn', ' SELECT * FROM amperfmgr.nz_weekly_capacity_predict;') AS res_table (
dt date
,instance_name character varying
,db_name character varying
,m1 bigint
,m2 bigint
,m3 bigint
,m4 bigint
,m5 bigint
,m6 bigint
,m7 bigint
,m8 bigint
,m9 bigint
,m10 bigint
,m11 bigint
,m12 bigint
);


	
-------------
	PERFORM dblink_disconnect('myconn');

	SELECT '('|| NOW() ||') completed data loading for statistic_data tables ' || link_host INTO result;
	RETURN result;
END
$$;


ALTER FUNCTION am_migrate.migrate_amperfmgr_analytics_tables(link_host text) OWNER TO postgres;

--
-- TOC entry 436 (class 1255 OID 40965)
-- Name: migrate_amperfmgr_dic_tables(text); Type: FUNCTION; Schema: am_migrate; Owner: pgadmin
--

CREATE FUNCTION migrate_amperfmgr_dic_tables(link_host text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE sql text;
	result text;
	MaxQuery integer;

BEGIN
	SET search_path TO stage, public;
	PERFORM dblink_connect('myconn', link_host);


--                         f_query_dblink_insert_body
-------------------------------------------------------------------------------
 INSERT INTO amperfmgr.dic_instance(
 id
 ,parent_id
 ,instance_name
 ,instance_identifier
 ,instance_description
 ,is_active
 ,created_at
 ,updated_at
 ) SELECT
 id
 ,parent_id
 ,instance_name
 ,instance_identifier
 ,instance_description
 ,is_active
 ,created_at
 ,updated_at
  FROM dblink('myconn', ' SELECT * FROM amperfmgr.dic_instance') AS res_table (
 id integer
 ,parent_id integer
 ,instance_name character varying
 ,instance_identifier text
 ,instance_description text
 ,is_active boolean
 ,created_at timestamp without time zone
 ,updated_at timestamp without time zone
 );


 --                             f_query_dblink_insert_body
---------------------------------------------------------------------------------------
 INSERT INTO amperfmgr.dic_metric_dimension(
 id
 ,dimension_name
 ,created_at
 ,updated_at
 ) SELECT
 id
 ,dimension_name
 ,created_at
 ,updated_at
  FROM dblink('myconn', ' SELECT * FROM amperfmgr.dic_metric_dimension') AS res_table (
 id smallint
 ,dimension_name character varying
 ,created_at timestamp without time zone
 ,updated_at timestamp without time zone
 );


--                          f_query_dblink_insert_body
-------------------------------------------------------------------------------
 INSERT INTO amperfmgr.dic_resource(
 id
 ,parent_id
 ,resource_name
 ,instance_id
 ,metric_dim_id
 ,is_active
 ,resource_description
 ,created_at
 ,updated_at
 ) SELECT
 id
 ,parent_id
 ,resource_name
 ,instance_id
 ,metric_dim_id
 ,is_active
 ,resource_description
 ,created_at
 ,updated_at
  FROM dblink('myconn', ' SELECT * FROM amperfmgr.dic_resource') AS res_table (
 id integer
 ,parent_id integer
 ,resource_name character varying
 ,instance_id smallint
 ,metric_dim_id smallint
 ,is_active boolean
 ,resource_description text
 ,created_at timestamp without time zone
 ,updated_at timestamp without time zone
 );


 --                        f_query_dblink_insert_body
-----------------------------------------------------------------------------
 INSERT INTO amperfmgr.dic_metric(
 id
 ,metric_name
 ,created_at
 ,updated_at
 ) SELECT
 id
 ,metric_name
 ,created_at
 ,updated_at
  FROM dblink('myconn', ' SELECT * FROM amperfmgr.dic_metric') AS res_table (
 id integer
 ,metric_name character varying
 ,created_at timestamp without time zone
 ,updated_at timestamp without time zone
 );


 --                       f_query_dblink_insert_body
---------------------------------------------------------------------------
 INSERT INTO amperfmgr.dic_unit(
 id
 ,unit_name
 ,unit_dispaly_name
 ,created_at
 ,updated_at
 ) SELECT
 id
 ,unit_name
 ,unit_dispaly_name
 ,created_at
 ,updated_at
  FROM dblink('myconn', ' SELECT * FROM amperfmgr.dic_unit') AS res_table (
 id integer
 ,unit_name character varying
 ,unit_dispaly_name character varying
 ,created_at timestamp without time zone
 ,updated_at timestamp without time zone
 );


 --                          f_query_dblink_insert_body
---------------------------------------------------------------------------------
 INSERT INTO amperfmgr.dic_value_type(
 id
 ,value_type_name
 ,created_at
 ,updated_at
 ) SELECT
 id
 ,value_type_name
 ,created_at
 ,updated_at
  FROM dblink('myconn', ' SELECT * FROM amperfmgr.dic_value_type') AS res_table (
 id smallint
 ,value_type_name character varying
 ,created_at timestamp without time zone
 ,updated_at timestamp without time zone
 );


 --                           f_query_dblink_insert_body
-----------------------------------------------------------------------------------
 INSERT INTO amperfmgr.dic_request_type(
 id
 ,request_type_name
 ,created_at
 ,updated_at
 ) SELECT
 id
 ,request_type_name
 ,created_at
 ,updated_at
  FROM dblink('myconn', ' SELECT * FROM amperfmgr.dic_request_type') AS res_table (
 id smallint
 ,request_type_name character varying
 ,created_at timestamp without time zone
 ,updated_at timestamp without time zone
 );


--                            f_query_dblink_insert_body
----------------------------------------------------------------------------------
 INSERT INTO amperfmgr.resource_method(
 id
 ,method_name
 ,created_at
 ,updated_at
 ) SELECT
 id
 ,method_name
 ,created_at
 ,updated_at
  FROM dblink('myconn', ' SELECT * FROM amperfmgr.resource_method') AS res_table (
 id integer
 ,method_name character varying
 ,created_at timestamp without time zone
 ,updated_at timestamp without time zone
 );


--                                 f_query_dblink_insert_body
---------------------------------------------------------------------------------------------
 INSERT INTO amperfmgr.dic_rs_resource_connection(
 id
 ,resource_id
 ,host
 ,port
 ,db_name
 ,user_name
 ) SELECT
 id
 ,resource_id
 ,host
 ,port
 ,db_name
 ,user_name
  FROM dblink('myconn', ' SELECT * FROM amperfmgr.dic_rs_resource_connection') AS res_table (
 id integer
 ,resource_id integer
 ,host character varying
 ,port character varying
 ,db_name character varying
 ,user_name character varying
 );


--                              f_query_dblink_insert_body
---------------------------------------------------------------------------------------
 INSERT INTO amperfmgr.link_method_resource(
 id
 ,method_id
 ,resource_id
 ,is_active
 ,created_at
 ,updated_at
 ) SELECT
 id
 ,method_id
 ,resource_id
 ,is_active
 ,created_at
 ,updated_at
  FROM dblink('myconn', ' SELECT * FROM amperfmgr.link_method_resource') AS res_table (
 id integer
 ,method_id integer
 ,resource_id integer
 ,is_active boolean
 ,created_at timestamp without time zone
 ,updated_at timestamp without time zone
 );


--                              f_query_dblink_insert_body
---------------------------------------------------------------------------------------
 INSERT INTO amperfmgr.link_metric_resource(
 id
 ,metric_id
 ,resource_id
 ,is_active
 ,created_at
 ,updated_at
 ) SELECT
 id
 ,metric_id
 ,resource_id
 ,is_active
 ,created_at
 ,updated_at
  FROM dblink('myconn', ' SELECT * FROM amperfmgr.link_metric_resource') AS res_table (
 id integer
 ,metric_id integer
 ,resource_id integer
 ,is_active boolean
 ,created_at timestamp without time zone
 ,updated_at timestamp without time zone
 );



--                            f_query_dblink_insert_body
----------------------------------------------------------------------------------
 INSERT INTO amperfmgr.request_history(
 id
 ,resource_id
 ,request_parameters
 ,type_request_id
 ,request_period
 ,started_at
 ,finished_at
 ,is_done
 ,is_aborted
 ,is_sucesfull
 ,is_reloaded
 ,is_purged
 ,is_added_to_stats 
 ) SELECT
 id
 ,resource_id
 ,request_parameters
 ,type_request_id
 ,request_period
 ,started_at
 ,finished_at
 ,is_done
 ,is_aborted
 ,is_sucesfull
 ,is_reloaded
 ,is_purged
 ,is_added_to_stats 
  FROM dblink('myconn', ' SELECT * FROM amperfmgr.request_history') AS res_table (
 id integer
 ,resource_id integer
 ,request_parameters text
 ,type_request_id smallint
 ,request_period bigint
 ,started_at timestamp without time zone
 ,finished_at timestamp without time zone
 ,is_done boolean
 ,is_aborted boolean
 ,is_sucesfull boolean
 ,is_reloaded boolean
 ,is_purged boolean
 ,is_added_to_stats boolean
 );


 
	
-------------
	PERFORM dblink_disconnect('myconn');

	SELECT '('|| NOW() ||') cotleted ' || link_host INTO result;
	RETURN result;
END
$$;


ALTER FUNCTION am_migrate.migrate_amperfmgr_dic_tables(link_host text) OWNER TO pgadmin;

--
-- TOC entry 437 (class 1255 OID 40966)
-- Name: migrate_amperfmgr_stat_aggr_tables(text); Type: FUNCTION; Schema: am_migrate; Owner: pgadmin
--

CREATE FUNCTION migrate_amperfmgr_stat_aggr_tables(link_host text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE sql text;
	result text;
	MaxQuery integer;

BEGIN
	SET search_path TO stage, public;
	PERFORM dblink_connect('myconn', link_host);

-- statistic_aggr_query

INSERT INTO amperfmgr.statistic_aggr_query( 
id
,resource_id
,userid
,q_date
,query_count
,avg_dur
,max_dur
) SELECT 
id
,resource_id
,userid
,q_date
,query_count
,avg_dur
,max_dur
 FROM dblink('myconn', ' SELECT * FROM amperfmgr.statistic_aggr_query;') AS res_table (
id integer
,resource_id integer
,userid integer
,q_date date
,query_count bigint
,avg_dur integer
,max_dur integer
);


-- amperfmgr.statistic_aggr_query_day

INSERT INTO amperfmgr.statistic_aggr_query_day( 
id
,resource_id
,userid
,q_time
,query_count
,avg_dur
,max_dur
) SELECT 
id
,resource_id
,userid
,q_time
,query_count
,avg_dur
,max_dur
 FROM dblink('myconn', ' SELECT * FROM amperfmgr.statistic_aggr_query_day;') AS res_table (
id integer
,resource_id integer
,userid integer
,q_time timestamp without time zone
,query_count bigint
,avg_dur integer
,max_dur integer
);

-- amperfmgr.statistic_aggr_query_hour

INSERT INTO amperfmgr.statistic_aggr_query_hour( 
id
,resource_id
,userid
,q_time
,query_count
,avg_dur
,max_dur
) SELECT 
id
,resource_id
,userid
,q_time
,query_count
,avg_dur
,max_dur
 FROM dblink('myconn', ' SELECT * FROM amperfmgr.statistic_aggr_query_hour;') AS res_table (
id integer
,resource_id integer
,userid integer
,q_time timestamp without time zone
,query_count bigint
,avg_dur integer
,max_dur integer
);


-- statistic_data_aggr_hour
INSERT INTO amperfmgr.statistic_data_aggr_hour( 
resource_id
,dt
,resource_name
,metric_name
,dimension_name
,unit_name
,average
) SELECT 
resource_id
,dt
,resource_name
,metric_name
,dimension_name
,unit_name
,average
 FROM dblink('myconn', ' SELECT * FROM amperfmgr.statistic_data_aggr_hour;') AS res_table (
resource_id integer
,dt timestamp without time zone
,resource_name character varying
,metric_name character varying
,dimension_name character varying
,unit_name character varying
,average numeric
);


-- stg_statistic_data_aggr_hour

INSERT INTO amperfmgr.stg_statistic_data_aggr_hour( 
id
,request_id
,resource_id
,metric_id
,unit_id
,metric_source_time
,value
,value_type_id
) SELECT 
id
,request_id
,resource_id
,metric_id
,unit_id
,metric_source_time
,value
,value_type_id
 FROM dblink('myconn', ' SELECT * FROM amperfmgr.stg_statistic_data_aggr_hour;') AS res_table (
id bigint
,request_id bigint
,resource_id integer
,metric_id integer
,unit_id smallint
,metric_source_time timestamp without time zone
,value numeric
,value_type_id smallint
);



 
	
-------------
	PERFORM dblink_disconnect('myconn');

	SELECT '('|| NOW() ||') cotleted ' || link_host INTO result;
	RETURN result;
END
$$;


ALTER FUNCTION am_migrate.migrate_amperfmgr_stat_aggr_tables(link_host text) OWNER TO pgadmin;

--
-- TOC entry 442 (class 1255 OID 40967)
-- Name: migrate_amperfmgr_stat_tables(text); Type: FUNCTION; Schema: am_migrate; Owner: postgres
--

CREATE FUNCTION migrate_amperfmgr_stat_tables(link_host text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE sql text;
	result text;
	MaxQuery integer;

BEGIN
	SET search_path TO stage, public;
	PERFORM dblink_connect('myconn', link_host);


-- less than 2016-01-01

INSERT INTO amperfmgr.statistic_data( 
id
,request_id
,resource_id
,metric_id
,unit_id
,metric_source_time
,value
,value_type_id
) 


SELECT 
id
,request_id
,resource_id
,metric_id
,unit_id
,metric_source_time
,value
,value_type_id
 FROM dblink('myconn', ' SELECT * FROM amperfmgr.statistic_data WHERE metric_source_time < ''2016-01-01'' ') AS res_table (
id bigint
,request_id bigint
,resource_id integer
,metric_id integer
,unit_id smallint
,metric_source_time timestamp without time zone
,value numeric(18,6)
,value_type_id smallint
);


-- statistic_data_2016_01

INSERT INTO amperfmgr.statistic_data( 
id
,request_id
,resource_id
,metric_id
,unit_id
,metric_source_time
,value
,value_type_id
) 


SELECT 
id
,request_id
,resource_id
,metric_id
,unit_id
,metric_source_time
,value
,value_type_id
 FROM dblink('myconn', ' SELECT * FROM amperfmgr.statistic_data_2016_01 ') AS res_table (
id bigint
,request_id bigint
,resource_id integer
,metric_id integer
,unit_id smallint
,metric_source_time timestamp without time zone
,value numeric(18,6)
,value_type_id smallint
);



-- statistic_data_2016_02

INSERT INTO amperfmgr.statistic_data( 
id
,request_id
,resource_id
,metric_id
,unit_id
,metric_source_time
,value
,value_type_id
) 


SELECT 
id
,request_id
,resource_id
,metric_id
,unit_id
,metric_source_time
,value
,value_type_id
 FROM dblink('myconn', ' SELECT * FROM amperfmgr.statistic_data_2016_02 ') AS res_table (
id bigint
,request_id bigint
,resource_id integer
,metric_id integer
,unit_id smallint
,metric_source_time timestamp without time zone
,value numeric(18,6)
,value_type_id smallint
);


-- statistic_data_2016_03

INSERT INTO amperfmgr.statistic_data( 
id
,request_id
,resource_id
,metric_id
,unit_id
,metric_source_time
,value
,value_type_id
) 


SELECT 
id
,request_id
,resource_id
,metric_id
,unit_id
,metric_source_time
,value
,value_type_id
 FROM dblink('myconn', ' SELECT * FROM amperfmgr.statistic_data_2016_03 ') AS res_table (
id bigint
,request_id bigint
,resource_id integer
,metric_id integer
,unit_id smallint
,metric_source_time timestamp without time zone
,value numeric(18,6)
,value_type_id smallint
);


-- statistic_data_2016_04

INSERT INTO amperfmgr.statistic_data( 
id
,request_id
,resource_id
,metric_id
,unit_id
,metric_source_time
,value
,value_type_id
) 


SELECT 
id
,request_id
,resource_id
,metric_id
,unit_id
,metric_source_time
,value
,value_type_id
 FROM dblink('myconn', ' SELECT * FROM amperfmgr.statistic_data_2016_04 ') AS res_table (
id bigint
,request_id bigint
,resource_id integer
,metric_id integer
,unit_id smallint
,metric_source_time timestamp without time zone
,value numeric(18,6)
,value_type_id smallint
);



-- statistic_data_2016_05

INSERT INTO amperfmgr.statistic_data( 
id
,request_id
,resource_id
,metric_id
,unit_id
,metric_source_time
,value
,value_type_id
) 


SELECT 
id
,request_id
,resource_id
,metric_id
,unit_id
,metric_source_time
,value
,value_type_id
 FROM dblink('myconn', ' SELECT * FROM amperfmgr.statistic_data_2016_05 ') AS res_table (
id bigint
,request_id bigint
,resource_id integer
,metric_id integer
,unit_id smallint
,metric_source_time timestamp without time zone
,value numeric(18,6)
,value_type_id smallint
);


-- statistic_data_2016_06

INSERT INTO amperfmgr.statistic_data( 
id
,request_id
,resource_id
,metric_id
,unit_id
,metric_source_time
,value
,value_type_id
) 


SELECT 
id
,request_id
,resource_id
,metric_id
,unit_id
,metric_source_time
,value
,value_type_id
 FROM dblink('myconn', ' SELECT * FROM amperfmgr.statistic_data_2016_06 ') AS res_table (
id bigint
,request_id bigint
,resource_id integer
,metric_id integer
,unit_id smallint
,metric_source_time timestamp without time zone
,value numeric(18,6)
,value_type_id smallint
);

--------------------------------------

INSERT INTO amperfmgr.statistic_max_loaded_dt_res_metric( 
id
,resource_id
,metric_id
,request_period
,metric_source_time
) SELECT 
id
,resource_id
,metric_id
,request_period
,metric_source_time
 FROM dblink('myconn', ' SELECT * FROM amperfmgr.statistic_max_loaded_dt_res_metric;') AS res_table (
id integer
,resource_id integer
,metric_id integer
,request_period bigint
,metric_source_time timestamp without time zone
);

	
-------------
	PERFORM dblink_disconnect('myconn');

	SELECT '('|| NOW() ||') completed data loading for statistic_data tables ' || link_host INTO result;
	RETURN result;
END
$$;


ALTER FUNCTION am_migrate.migrate_amperfmgr_stat_tables(link_host text) OWNER TO postgres;

--
-- TOC entry 438 (class 1255 OID 40969)
-- Name: migrate_amstgmgr_stage_tables(text); Type: FUNCTION; Schema: am_migrate; Owner: pgadmin
--

CREATE FUNCTION migrate_amstgmgr_stage_tables(link_host text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE sql text;
	result text;
	MaxQuery integer;

BEGIN
	SET search_path TO stage, public;
	PERFORM dblink_connect('myconn', link_host);


INSERT INTO amstgmgr.stage_uniq_user( 
usesysid
,usename
) SELECT 
usesysid
,usename
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.stage_uniq_user;') AS res_table (
usesysid integer
,usename name
);

	

-- stage_rsh_cloudwatch_datapoints
INSERT INTO amstgmgr.stage_rsh_cloudwatch_datapoints( 
request_id
,resource_id
,metric_id
,average
,maximum
,minimum
,samplecount
,sum
,timestamp
,unit
) SELECT 
request_id
,resource_id
,metric_id
,average
,maximum
,minimum
,samplecount
,sum
,timestamp
,unit
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.stage_rsh_cloudwatch_datapoints;') AS res_table (
request_id integer
,resource_id integer
,metric_id integer
,average numeric
,maximum numeric
,minimum numeric
,samplecount numeric
,sum numeric
,timestamp timestamp with time zone
,unit character varying
);



-- amstgmgr.stl_query_   less than 2016_01

INSERT INTO amstgmgr.stl_query( 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,pid
,database
,querytxt
,starttime
,endtime
,aborted
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,pid
,database
,querytxt
,starttime
,endtime
,aborted
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.stl_query WHERE datetimestamp < ''2016-01-01 00:00:00'' ; '  ) AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id smallint
,userid integer
,query integer
,pid integer
,database character varying
,querytxt character varying
,starttime timestamp without time zone
,endtime timestamp without time zone
,aborted smallint
);


-- amstgmgr.stl_query_2016_01

INSERT INTO amstgmgr.stl_query( 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,pid
,database
,querytxt
,starttime
,endtime
,aborted
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,pid
,database
,querytxt
,starttime
,endtime
,aborted
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.stl_query_2016_01'  ) AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id smallint
,userid integer
,query integer
,pid integer
,database character varying
,querytxt character varying
,starttime timestamp without time zone
,endtime timestamp without time zone
,aborted smallint
);



-- amstgmgr.stl_query_2016_02

INSERT INTO amstgmgr.stl_query( 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,pid
,database
,querytxt
,starttime
,endtime
,aborted
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,pid
,database
,querytxt
,starttime
,endtime
,aborted
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.stl_query_2016_02'  ) AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id smallint
,userid integer
,query integer
,pid integer
,database character varying
,querytxt character varying
,starttime timestamp without time zone
,endtime timestamp without time zone
,aborted smallint
);


-- amstgmgr.stl_query_2016_03

INSERT INTO amstgmgr.stl_query( 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,pid
,database
,querytxt
,starttime
,endtime
,aborted
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,pid
,database
,querytxt
,starttime
,endtime
,aborted
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.stl_query_2016_03'  ) AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id smallint
,userid integer
,query integer
,pid integer
,database character varying
,querytxt character varying
,starttime timestamp without time zone
,endtime timestamp without time zone
,aborted smallint
);




-- amstgmgr.stl_query_2016_04

INSERT INTO amstgmgr.stl_query( 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,pid
,database
,querytxt
,starttime
,endtime
,aborted
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,pid
,database
,querytxt
,starttime
,endtime
,aborted
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.stl_query_2016_04'  ) AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id smallint
,userid integer
,query integer
,pid integer
,database character varying
,querytxt character varying
,starttime timestamp without time zone
,endtime timestamp without time zone
,aborted smallint
);


-- amstgmgr.stl_query_2016_05


INSERT INTO amstgmgr.stl_query( 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,pid
,database
,querytxt
,starttime
,endtime
,aborted
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,pid
,database
,querytxt
,starttime
,endtime
,aborted
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.stl_query_2016_05'  ) AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id smallint
,userid integer
,query integer
,pid integer
,database character varying
,querytxt character varying
,starttime timestamp without time zone
,endtime timestamp without time zone
,aborted smallint
);


-- amstgmgr.stl_query_2016_06

INSERT INTO amstgmgr.stl_query( 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,pid
,database
,querytxt
,starttime
,endtime
,aborted
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,pid
,database
,querytxt
,starttime
,endtime
,aborted
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.stl_query_2016_06'  ) AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id smallint
,userid integer
,query integer
,pid integer
,database character varying
,querytxt character varying
,starttime timestamp without time zone
,endtime timestamp without time zone
,aborted smallint
);




-- stl_querytext

INSERT INTO amstgmgr.stl_querytext( 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,xid
,pid
,sequence
,text
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,xid
,pid
,sequence
,text
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.stl_querytext;') AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id integer
,userid integer
,query integer
,xid bigint
,pid integer
,sequence integer
,text character varying
);


-- stl_s3client

INSERT INTO amstgmgr.stl_s3client( 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,slice
,recordtime
,pid
,http_method
,bucket
,key
,transfer_size
,data_size
,start_time
,end_time
,transfer_time
,compression_time
,connect_time
,app_connect_time
,retries
,request_id_from_amazon_s3
,extended_request_id_from_amazon_s3
,ip_address
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,slice
,recordtime
,pid
,http_method
,bucket
,key
,transfer_size
,data_size
,start_time
,end_time
,transfer_time
,compression_time
,connect_time
,app_connect_time
,retries
,request_id_from_amazon_s3
,extended_request_id_from_amazon_s3
,ip_address
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.stl_s3client;') AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id integer
,userid integer
,query integer
,slice integer
,recordtime timestamp without time zone
,pid integer
,http_method character
,bucket character
,key character
,transfer_size bigint
,data_size bigint
,start_time bigint
,end_time bigint
,transfer_time bigint
,compression_time bigint
,connect_time bigint
,app_connect_time bigint
,retries bigint
,request_id_from_amazon_s3 character
,extended_request_id_from_amazon_s3 character
,ip_address character
);


-- stl_sessions

INSERT INTO amstgmgr.stl_sessions( 
id
,datetimestamp
,request_id
,resource_id
,userid
,starttime
,endtime
,process
,user_name
,db_name
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,userid
,starttime
,endtime
,process
,user_name
,db_name
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.stl_sessions;') AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id integer
,userid integer
,starttime timestamp without time zone
,endtime timestamp without time zone
,process integer
,user_name character
,db_name character
);


-- stl_vacuum

INSERT INTO amstgmgr.stl_vacuum( 
id
,datetimestamp
,request_id
,resource_id
,userid
,xid
,table_id
,status
,rows
,sortedrows
,blocks
,max_merge_partitions
,eventtime
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,userid
,xid
,table_id
,status
,rows
,sortedrows
,blocks
,max_merge_partitions
,eventtime
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.stl_vacuum;') AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id integer
,userid integer
,xid bigint
,table_id integer
,status character
,rows bigint
,sortedrows bigint
,blocks integer
,max_merge_partitions integer
,eventtime timestamp without time zone
);


--- 

INSERT INTO amstgmgr.stl_wlm_query( 
id
,datetimestamp
,request_id
,resource_id
,userid
,xid
,task
,query
,service_class
,slot_count
,service_class_start_time
,queue_start_time
,queue_end_time
,total_queue_time
,exec_start_time
,exec_end_time
,total_exec_time
,service_class_end_time
,final_state
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,userid
,xid
,task
,query
,service_class
,slot_count
,service_class_start_time
,queue_start_time
,queue_end_time
,total_queue_time
,exec_start_time
,exec_end_time
,total_exec_time
,service_class_end_time
,final_state
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.stl_wlm_query_2016_01;') AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id smallint
,userid integer
,xid integer
,task integer
,query integer
,service_class integer
,slot_count integer
,service_class_start_time timestamp without time zone
,queue_start_time timestamp without time zone
,queue_end_time timestamp without time zone
,total_queue_time bigint
,exec_start_time timestamp without time zone
,exec_end_time timestamp without time zone
,total_exec_time bigint
,service_class_end_time timestamp without time zone
,final_state character varying
);



--- 

INSERT INTO amstgmgr.stl_wlm_query( 
id
,datetimestamp
,request_id
,resource_id
,userid
,xid
,task
,query
,service_class
,slot_count
,service_class_start_time
,queue_start_time
,queue_end_time
,total_queue_time
,exec_start_time
,exec_end_time
,total_exec_time
,service_class_end_time
,final_state
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,userid
,xid
,task
,query
,service_class
,slot_count
,service_class_start_time
,queue_start_time
,queue_end_time
,total_queue_time
,exec_start_time
,exec_end_time
,total_exec_time
,service_class_end_time
,final_state
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.stl_wlm_query_2016_02;') AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id smallint
,userid integer
,xid integer
,task integer
,query integer
,service_class integer
,slot_count integer
,service_class_start_time timestamp without time zone
,queue_start_time timestamp without time zone
,queue_end_time timestamp without time zone
,total_queue_time bigint
,exec_start_time timestamp without time zone
,exec_end_time timestamp without time zone
,total_exec_time bigint
,service_class_end_time timestamp without time zone
,final_state character varying
);



--- 

INSERT INTO amstgmgr.stl_wlm_query( 
id
,datetimestamp
,request_id
,resource_id
,userid
,xid
,task
,query
,service_class
,slot_count
,service_class_start_time
,queue_start_time
,queue_end_time
,total_queue_time
,exec_start_time
,exec_end_time
,total_exec_time
,service_class_end_time
,final_state
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,userid
,xid
,task
,query
,service_class
,slot_count
,service_class_start_time
,queue_start_time
,queue_end_time
,total_queue_time
,exec_start_time
,exec_end_time
,total_exec_time
,service_class_end_time
,final_state
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.stl_wlm_query_2016_03;') AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id smallint
,userid integer
,xid integer
,task integer
,query integer
,service_class integer
,slot_count integer
,service_class_start_time timestamp without time zone
,queue_start_time timestamp without time zone
,queue_end_time timestamp without time zone
,total_queue_time bigint
,exec_start_time timestamp without time zone
,exec_end_time timestamp without time zone
,total_exec_time bigint
,service_class_end_time timestamp without time zone
,final_state character varying
);



--- 

INSERT INTO amstgmgr.stl_wlm_query( 
id
,datetimestamp
,request_id
,resource_id
,userid
,xid
,task
,query
,service_class
,slot_count
,service_class_start_time
,queue_start_time
,queue_end_time
,total_queue_time
,exec_start_time
,exec_end_time
,total_exec_time
,service_class_end_time
,final_state
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,userid
,xid
,task
,query
,service_class
,slot_count
,service_class_start_time
,queue_start_time
,queue_end_time
,total_queue_time
,exec_start_time
,exec_end_time
,total_exec_time
,service_class_end_time
,final_state
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.stl_wlm_query_2016_04;') AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id smallint
,userid integer
,xid integer
,task integer
,query integer
,service_class integer
,slot_count integer
,service_class_start_time timestamp without time zone
,queue_start_time timestamp without time zone
,queue_end_time timestamp without time zone
,total_queue_time bigint
,exec_start_time timestamp without time zone
,exec_end_time timestamp without time zone
,total_exec_time bigint
,service_class_end_time timestamp without time zone
,final_state character varying
);



--- 

INSERT INTO amstgmgr.stl_wlm_query( 
id
,datetimestamp
,request_id
,resource_id
,userid
,xid
,task
,query
,service_class
,slot_count
,service_class_start_time
,queue_start_time
,queue_end_time
,total_queue_time
,exec_start_time
,exec_end_time
,total_exec_time
,service_class_end_time
,final_state
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,userid
,xid
,task
,query
,service_class
,slot_count
,service_class_start_time
,queue_start_time
,queue_end_time
,total_queue_time
,exec_start_time
,exec_end_time
,total_exec_time
,service_class_end_time
,final_state
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.stl_wlm_query_2016_05;') AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id smallint
,userid integer
,xid integer
,task integer
,query integer
,service_class integer
,slot_count integer
,service_class_start_time timestamp without time zone
,queue_start_time timestamp without time zone
,queue_end_time timestamp without time zone
,total_queue_time bigint
,exec_start_time timestamp without time zone
,exec_end_time timestamp without time zone
,total_exec_time bigint
,service_class_end_time timestamp without time zone
,final_state character varying
);




--- 
INSERT INTO amstgmgr.stl_wlm_query( 
id
,datetimestamp
,request_id
,resource_id
,userid
,xid
,task
,query
,service_class
,slot_count
,service_class_start_time
,queue_start_time
,queue_end_time
,total_queue_time
,exec_start_time
,exec_end_time
,total_exec_time
,service_class_end_time
,final_state
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,userid
,xid
,task
,query
,service_class
,slot_count
,service_class_start_time
,queue_start_time
,queue_end_time
,total_queue_time
,exec_start_time
,exec_end_time
,total_exec_time
,service_class_end_time
,final_state
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.stl_wlm_query_2016_06;') AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id smallint
,userid integer
,xid integer
,task integer
,query integer
,service_class integer
,slot_count integer
,service_class_start_time timestamp without time zone
,queue_start_time timestamp without time zone
,queue_end_time timestamp without time zone
,total_queue_time bigint
,exec_start_time timestamp without time zone
,exec_end_time timestamp without time zone
,total_exec_time bigint
,service_class_end_time timestamp without time zone
,final_state character varying
);



--- 

--- stl_userlog

INSERT INTO amstgmgr.stl_userlog( 
id
,datetimestamp
,request_id
,resource_id
,userid
,username
,oldusername
,action
,pid
,xid
,recordtime
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,userid
,username
,oldusername
,action
,pid
,xid
,recordtime
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.stl_userlog;') AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id integer
,userid integer
,username character
,oldusername character
,action character
,pid integer
,xid bigint
,recordtime timestamp without time zone
);


-- stv_partitions

INSERT INTO amstgmgr.stv_partitions( 
id
,datetimestamp
,request_id
,resource_id
,owner
,host
,diskno
,part_begin
,part_end
,used
,tossed
,capacity
,reads
,writes
,seek_forward
,seek_back
,is_san
,failed
,mbps
,mount
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,owner
,host
,diskno
,part_begin
,part_end
,used
,tossed
,capacity
,reads
,writes
,seek_forward
,seek_back
,is_san
,failed
,mbps
,mount
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.stv_partitions;') AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id integer
,owner integer
,host integer
,diskno integer
,part_begin bigint
,part_end bigint
,used integer
,tossed integer
,capacity integer
,reads bigint
,writes bigint
,seek_forward integer
,seek_back integer
,is_san integer
,failed integer
,mbps integer
,mount character
);

-- stv_slices

INSERT INTO amstgmgr.stv_slices( 
id
,datetimestamp
,request_id
,resource_id
,node
,slice
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,node
,slice
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.stv_slices;') AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id integer
,node integer
,slice integer
);


-- stv_tbl_perm

INSERT INTO amstgmgr.stv_tbl_perm( 
id
,datetimestamp
,request_id
,resource_id
,slice
,table_id
,name
,rows
,sorted_rows
,temp
,db_id
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,slice
,table_id
,name
,rows
,sorted_rows
,temp
,db_id
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.stv_tbl_perm;') AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id integer
,slice integer
,table_id integer
,name character
,rows bigint
,sorted_rows bigint
,temp integer
,db_id integer
);

-- svl_query_report

INSERT INTO amstgmgr.svl_query_report( 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,slice
,segment
,step
,start_time
,end_time
,elapsed_time
,rows
,bytes
,label
,is_diskbased
,workmem
,is_rrscan
,is_delayed_scan
,rows_pre_filter
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,slice
,segment
,step
,start_time
,end_time
,elapsed_time
,rows
,bytes
,label
,is_diskbased
,workmem
,is_rrscan
,is_delayed_scan
,rows_pre_filter
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.svl_query_report;') AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id integer
,userid integer
,query integer
,slice integer
,segment integer
,step integer
,start_time timestamp without time zone
,end_time timestamp without time zone
,elapsed_time bigint
,rows bigint
,bytes bigint
,label character
,is_diskbased character
,workmem bigint
,is_rrscan character
,is_delayed_scan character
,rows_pre_filter bigint
);


-- svl_query_summary_2016_02
INSERT INTO amstgmgr.svl_query_summary( 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,stm
,seg
,step
,maxtime
,avgtime
,rows
,bytes
,rate_row
,rate_byte
,label
,is_diskbased
,workmem
,is_rrscan
,is_delayed_scan
,rows_pre_filter
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,stm
,seg
,step
,maxtime
,avgtime
,rows
,bytes
,rate_row
,rate_byte
,label
,is_diskbased
,workmem
,is_rrscan
,is_delayed_scan
,rows_pre_filter
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.svl_query_summary_2016_02;') AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id integer
,userid integer
,query integer
,stm integer
,seg integer
,step integer
,maxtime bigint
,avgtime bigint
,rows bigint
,bytes bigint
,rate_row double precision
,rate_byte double precision
,label character varying
,is_diskbased character
,workmem bigint
,is_rrscan character
,is_delayed_scan character
,rows_pre_filter bigint
);



INSERT INTO amstgmgr.svl_query_summary( 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,stm
,seg
,step
,maxtime
,avgtime
,rows
,bytes
,rate_row
,rate_byte
,label
,is_diskbased
,workmem
,is_rrscan
,is_delayed_scan
,rows_pre_filter
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,stm
,seg
,step
,maxtime
,avgtime
,rows
,bytes
,rate_row
,rate_byte
,label
,is_diskbased
,workmem
,is_rrscan
,is_delayed_scan
,rows_pre_filter
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.svl_query_summary_2016_03;') AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id integer
,userid integer
,query integer
,stm integer
,seg integer
,step integer
,maxtime bigint
,avgtime bigint
,rows bigint
,bytes bigint
,rate_row double precision
,rate_byte double precision
,label character varying
,is_diskbased character
,workmem bigint
,is_rrscan character
,is_delayed_scan character
,rows_pre_filter bigint
);



-- svl_query_summary_2016_04

INSERT INTO amstgmgr.svl_query_summary( 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,stm
,seg
,step
,maxtime
,avgtime
,rows
,bytes
,rate_row
,rate_byte
,label
,is_diskbased
,workmem
,is_rrscan
,is_delayed_scan
,rows_pre_filter
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,stm
,seg
,step
,maxtime
,avgtime
,rows
,bytes
,rate_row
,rate_byte
,label
,is_diskbased
,workmem
,is_rrscan
,is_delayed_scan
,rows_pre_filter
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.svl_query_summary_2016_04;') AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id integer
,userid integer
,query integer
,stm integer
,seg integer
,step integer
,maxtime bigint
,avgtime bigint
,rows bigint
,bytes bigint
,rate_row double precision
,rate_byte double precision
,label character varying
,is_diskbased character
,workmem bigint
,is_rrscan character
,is_delayed_scan character
,rows_pre_filter bigint
);



-- svl_query_summary_2016_05

INSERT INTO amstgmgr.svl_query_summary( 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,stm
,seg
,step
,maxtime
,avgtime
,rows
,bytes
,rate_row
,rate_byte
,label
,is_diskbased
,workmem
,is_rrscan
,is_delayed_scan
,rows_pre_filter
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,stm
,seg
,step
,maxtime
,avgtime
,rows
,bytes
,rate_row
,rate_byte
,label
,is_diskbased
,workmem
,is_rrscan
,is_delayed_scan
,rows_pre_filter
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.svl_query_summary_2016_05;') AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id integer
,userid integer
,query integer
,stm integer
,seg integer
,step integer
,maxtime bigint
,avgtime bigint
,rows bigint
,bytes bigint
,rate_row double precision
,rate_byte double precision
,label character varying
,is_diskbased character
,workmem bigint
,is_rrscan character
,is_delayed_scan character
,rows_pre_filter bigint
);



-- svl_query_summary_2016_06

INSERT INTO amstgmgr.svl_query_summary( 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,stm
,seg
,step
,maxtime
,avgtime
,rows
,bytes
,rate_row
,rate_byte
,label
,is_diskbased
,workmem
,is_rrscan
,is_delayed_scan
,rows_pre_filter
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,userid
,query
,stm
,seg
,step
,maxtime
,avgtime
,rows
,bytes
,rate_row
,rate_byte
,label
,is_diskbased
,workmem
,is_rrscan
,is_delayed_scan
,rows_pre_filter
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.svl_query_summary_2016_06;') AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id integer
,userid integer
,query integer
,stm integer
,seg integer
,step integer
,maxtime bigint
,avgtime bigint
,rows bigint
,bytes bigint
,rate_row double precision
,rate_byte double precision
,label character varying
,is_diskbased character
,workmem bigint
,is_rrscan character
,is_delayed_scan character
,rows_pre_filter bigint
);



-- svv_table_info

INSERT INTO amstgmgr.svv_table_info( 
id
,datetimestamp
,request_id
,resource_id
,database
,schema
,table_id
,"table"
,encoded
,diststyle
,sortkey1
,max_varchar
,sortkey1_enc
,sortkey_num
,size
,pct_used
,empty
,unsorted
,stats_off
,tbl_rows
,skew_sortkey1
,skew_rows
) SELECT 
id
,datetimestamp
,request_id
,resource_id
,database
,schema
,table_id
,"table"
,encoded
,diststyle
,sortkey1
,max_varchar
,sortkey1_enc
,sortkey_num
,size
,pct_used
,empty
,unsorted
,stats_off
,tbl_rows
,skew_sortkey1
,skew_rows
 FROM dblink('myconn', ' SELECT * FROM amstgmgr.svv_table_info;') AS res_table (
id bigint
,datetimestamp timestamp without time zone
,request_id integer
,resource_id integer
,database text
,schema text
,table_id oid
,"table" text
,encoded text
,diststyle text
,sortkey1 text
,max_varchar integer
,sortkey1_enc character
,sortkey_num integer
,size bigint
,pct_used numeric
,empty bigint
,unsorted numeric
,stats_off numeric
,tbl_rows numeric
,skew_sortkey1 numeric
,skew_rows numeric
);

	
-------------
	PERFORM dblink_disconnect('myconn');

	SELECT '('|| NOW() ||') Successful data lading from - https://' || link_host INTO result;
	RETURN result;
END
$$;


ALTER FUNCTION am_migrate.migrate_amstgmgr_stage_tables(link_host text) OWNER TO pgadmin;

--
-- TOC entry 2583 (class 0 OID 0)
-- Dependencies: 9
-- Name: am_migrate; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA am_migrate FROM PUBLIC;
REVOKE ALL ON SCHEMA am_migrate FROM postgres;
GRANT ALL ON SCHEMA am_migrate TO postgres;
GRANT ALL ON SCHEMA am_migrate TO pgadmin;


-- Completed on 2016-06-16 11:02:08

--
-- PostgreSQL database dump complete
--

