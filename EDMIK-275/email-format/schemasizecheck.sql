select schema, sum(size) from svv_table_info where schema='workmsmgr' group by schema
