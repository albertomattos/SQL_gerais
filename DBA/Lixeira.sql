SELECT * FROM RECYCLEBIN where type = 'TABLE' and original_name like '%ARQFATPRD';

SELECT * FROM RECYCLEBIN order by droptime desc;

FLASHBACK TABLE ARQFATPRD TO BEFORE DROP;