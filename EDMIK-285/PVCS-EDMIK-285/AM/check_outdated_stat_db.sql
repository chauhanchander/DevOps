SELECT
		current_timestamp as RUN_DATE, database, tablename,

        CASE
            WHEN RECENT::smallint =    85  THEN 'FULL'        -- Full
            WHEN RECENT::smallint =     1  THEN 'FULL'        -- Full Min/Max OK
            WHEN RECENT::smallint =     0  THEN 'FULL'        -- Full Outdated

            WHEN RECENT::smallint =   341  THEN 'EXPRESS'     -- Express
            WHEN RECENT::smallint =   257  THEN 'EXPRESS'     -- Express Min/Max OK
            WHEN RECENT::smallint =   256  THEN 'EXPRESS'     -- Express Outdated

            WHEN RECENT::smallint =   149  THEN 'BASIC'       -- Basic
            WHEN RECENT::smallint =   129  THEN 'BASIC'       -- Basic Min/Max OK
            WHEN RECENT::smallint =   128  THEN 'BASIC'       -- Basic Outdated

            WHEN RECENT::smallint =   170  THEN 'UNAVAILABLE'
            WHEN RECENT::smallint = 16554  THEN 'UNAVAILABLE'

            WHEN RECENT::smallint =   169  THEN 'MINMAXONLY'

            ELSE                                'UNKNOWN'
        END as stats_type,

        CASE
            WHEN RECENT::smallint in (85,341,149) THEN  'UP TO DATE'
            ELSE                                        'OUTDATED'
        END as stats_state

        from _v_statistic

        WHERE   
		upper(objtype) in ('TABLE','SECURE TABLE') 
        AND attnum=1 
		AND 
        CASE
            WHEN RECENT::smallint in (85,341,149) THEN  'UP TO DATE'
            ELSE                                        'OUTDATED'
        END <> 'UP TO DATE'
		AND  
		CASE
            WHEN RECENT::smallint =    85  THEN 'FULL'        -- Full
            WHEN RECENT::smallint =     1  THEN 'FULL'        -- Full Min/Max OK
            WHEN RECENT::smallint =     0  THEN 'FULL'        -- Full Outdated

            WHEN RECENT::smallint =   341  THEN 'EXPRESS'     -- Express
            WHEN RECENT::smallint =   257  THEN 'EXPRESS'     -- Express Min/Max OK
            WHEN RECENT::smallint =   256  THEN 'EXPRESS'     -- Express Outdated

            WHEN RECENT::smallint =   149  THEN 'BASIC'       -- Basic
            WHEN RECENT::smallint =   129  THEN 'BASIC'       -- Basic Min/Max OK
            WHEN RECENT::smallint =   128  THEN 'BASIC'       -- Basic Outdated

            WHEN RECENT::smallint =   170  THEN 'UNAVAILABLE'
            WHEN RECENT::smallint = 16554  THEN 'UNAVAILABLE'

            WHEN RECENT::smallint =   169  THEN 'MINMAXONLY'

            ELSE                                'UNKNOWN'
        END IN ('FULL','EXPRESS','BASIC')
;
