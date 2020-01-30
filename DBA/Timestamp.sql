select * from faprtcad
as of timestamp to_timestamp ('2012-12-04 16:00:00', 'YYYY-MM-DD HH24:MI:SS')
 where cod_prt = '000271801';