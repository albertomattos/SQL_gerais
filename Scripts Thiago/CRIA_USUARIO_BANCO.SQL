create user BUILD identified by BUILD
default tablespace MXMDAD
TEMPORARY TABLESPACE MXMTMP; 

ALTER USER BUILD temporary tablespace mxmtmp;

grant create session,connect,resource,MXMSYS,MXMDBA to BUILD;

  
alter user BUILD quota unlimited on MXMDAD

alter user BUILD quota unlimited on mxmtmp;
alter user BUILDquota unlimited on mxmdad;
alter user BUILD quota unlimited on mxmidad;
alter user BUILD quota unlimited on mxmrbs;