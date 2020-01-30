select  upper(instance_name) as instance_name, host_name, '['||version||']' VERSAO,
        to_char(sysdate,'DD/MM/YYYY HH24:MI') DATA_ATUAL,
        to_char(STARTUP_TIME,'DD/MM/YYYY HH24:MI') STARTUP_TIME,
        ROUND(sysdate-startup_time,1) DIAS_ATIVOS
from v$instance

select a.tablespace_name as name,
             b.tablespace_name as dummy,
             sum(b.bytes)/count( distinct a.file_id||'.'||a.block_id )/1024/1024 as bytes,
             sum(b.bytes)/count( distinct a.file_id||'.'||a.block_id )/1024/1024 -
             sum(a.bytes)/count( distinct b.file_id )/1024/1024 as used,
             sum(b.maxbytes)/count( distinct a.file_id||'.'||a.block_id )/1024/1024 as maxbytes,
             sum(a.bytes)/count( distinct b.file_id )/1024/1024 as free,
             100 * ( (sum(b.bytes)/count( distinct a.file_id||'.'||a.block_id )) -
                             (sum(a.bytes)/count( distinct b.file_id ) )) /
             (sum(b.bytes)/count( distinct a.file_id||'.'||a.block_id )) as pct_used
  from sys.dba_free_space a, sys.dba_data_files b
  where a.tablespace_name = b.tablespace_name
  group by a.tablespace_name, b.tablespace_name
  order by pct_used, bytes
  
  select a.tablespace_name, a.file_name, a.maxbytes,
       a.bytes, nvl(a.bytes-sum(b.bytes),a.bytes) as BYTES_USED,
       nvl(sum(b.bytes),0) as BYTES_FREE
from dba_data_files a, dba_free_space b
where b.file_id(+)=a.file_id
and a.tablespace_name like nvl(upper('&tablespace'),'%')
group by a.tablespace_name, a.file_name, a.bytes, a.maxbytes
order by a.file_name asc

select owner, synonym_name, table_owner, table_name, db_link
from dba_synonyms
where db_link is not null

select owner, db_link, username, host from dba_db_links

select distinct owner, name, type
from dba_source
where upper(text) like upper('%&db_link%')

--Script para verificar MEDIA DE I/O em Datafiles
select substr(df.file_name,1,22) filesystem, sum(f.phyrds) phyrds, sum(f.phyblkrd) phyblkrd, sum(f.phyrds) / sum(phyrds+phywrts) AvgRD,
sum(f.phywrts) / sum(phyrds+phywrts) AvgWT, sum(f.phywrts) phywrts, sum(f.phyblkwrt) phyblkwrt,
sum(f.phyblkwrt) / sum(f.phyblkrd + f.phyblkwrt) AvgBLKWT, sum(f.phyblkrd) / sum(f.phyblkrd + f.phyblkwrt) AvgBLKRD
from v$filestat f , dba_data_files df where f.file#=df.file_id group by substr(df.file_name,1,22);

select to_number(value) shared_pool_size, 
sum_obj_size,
sum_sql_size, 
sum_user_size, 
(sum_obj_size + sum_sql_size+sum_user_size)* 1.3 min_shared_pool
from (select sum(sharable_mem) sum_obj_size 
from v$db_object_cache where type <> 'CURSOR'),
(select sum(sharable_mem) sum_sql_size
from v$sqlarea),
(select sum(250 * users_opening) sum_user_size
from v$sqlarea), v$parameter
where name = 'shared_pool_size';