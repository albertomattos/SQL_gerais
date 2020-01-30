select	OWNER, SEGMENT_NAME, SEGMENT_TYPE, TABLESPACE_NAME, BYTES from 	dba_segments
where	TABLESPACE_NAME = 'WPDINDICES' and	OWNER not in ('SYS','SYSTEM') and segment_name = 'IE_LOGCAD_2' order by BYTES desc

select * from dba_free_space where tablespace_name = 'WPDINDICES'

select max(BYTES) from dba_free_space where  tablespace_name = 'WPDINDICES'

select * from dba_segments where segment_type = 'INDEX' and segment_name = 'IE_LOGCAD_2' and tablespace_name = 'WPDINDICES';

select segment_name, blocks from dba_segments where segment_type = 'INDEX' and segment_name = 'IE_LOGCAD_2' and owner not in ('SYS','SYSTEM');

ANALYZE INDEX IE_LOGCAD_2 COMPUTE STATISTIC

ALTER INDEX FK_MODCAD_LOGCAD REBUILD