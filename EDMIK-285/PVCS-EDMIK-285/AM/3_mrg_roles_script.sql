CREATE ROLE tbrostek WITH PASSWORD 'xxxxxxxxxx' 
  LOGIN
  NOSUPERUSER 
  INHERIT 
  NOCREATEDB 
  NOCREATEROLE 
  NOREPLICATION;
GRANT edmopusr_select_dev TO tbrostek;
GRANT gr_report_job_anomaly TO tbrostek;
GRANT gr_report_perfmon TO tbrostek;
GRANT stbmtx_select_dev TO tbrostek;
COMMENT ON ROLE tbrostek IS 'Thomas Brostek';