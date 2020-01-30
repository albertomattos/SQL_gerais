SELECT t.table_name AS "TABLE_NAME", t.num_rows AS "Rows", t.avg_row_len AS "Avg Row Len", Trunc((t.blocks * p.value)/1024) AS "Size KB",
t.last_analyzed AS "Last Analyzed" FROM dba_tables t, v$parameter p WHERE t.owner = Decode(Upper('ADMWPD'), 'ALL', t.owner, Upper('ADMWPD'))AND
p.name = 'db_block_size' and t.last_analyzed is not null ORDER by 4 desc;

select substr(a.tablespace_name,1,20) "Tablespaces",(b.BYTES/1048576) as "TotalMB",(b.BYTES/1048576)-(c.BYTES/1048576) as "UsedMB",
(c.BYTES/1048576) as "FreeMB" from dba_tablespaces a,(select tablespace_name,sum(bytes) as "BYTES" from dba_data_files
group by tablespace_name ) b, (select tablespace_name,sum(bytes) as "BYTES" from dba_free_space group by tablespace_name) c
where a.tablespace_name = b.tablespace_name(+) and b.tablespace_name = c.tablespace_name(+) order by a.tablespace_name;

--ALTER DATABASE DATAFILE 'H:\oradata\HOMOL\DATAFILE\O1_MF_MEDVINDI_BLDTVJC6_.DBF' RESIZE 20M;

select substr(file_name,1,140) as "FileSystem", sum(bytes)/1024/1024 as "Tamanho(MB)" from dba_data_files
group by rollup(substr(file_name,1,140)) order by substr(file_name,1,140)

select tablespace_name, sum(bytes)/1024/1024 as "TAMANHO(MB)" from dba_free_space group by tablespace_name order by sum(bytes);

select 'alter database datafile ''' || file_name || ''' resize ' || ceil( (nvl(hwm,1)*8192*1.2)/1024/1024 )  || 'm;' cmd
from dba_data_files a,( select file_id, max(block_id+blocks-1) hwm from dba_extents group by file_id ) b
where a.file_id = b.file_id(+) and ceil( (nvl(hwm,1)*8192*1.2)/1024/1024 ) < ceil( blocks*8192/1024/1024)
and ceil( (nvl(hwm,1)*8192*1.2)/1024/1024 ) > 100

--alter database datafile 'H:\ORADATA\PROD\DATAFILE\O1_MF_UNDOTBS1_85S6ND5K_.DBF' resize 2100m;
--alter database datafile 'H:\ORADATA\PROD\DATAFILE\O1_MF_AUXWPD_884C87BH_.DBF' resize 700m;

alter database datafile 'H:\ORADATA\HOMOLOGA\HOMOLOGA\UNDOTBS01.DBF' resize 102m;
--alter database datafile 'H:\ORADATA\HOMOL\DATAFILE\O1_MF_AUXWPD_BLDTNOCW_.DBF' resize 169m;
--alter database datafile 'H:\ORADATA\HOMOL\DATAFILE\O1_MF_WSUSINDI_BLDTVGQF_.DBF' resize 175m;