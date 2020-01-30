/*select * from faequcad order by cod_equ desc
select * from fatiscad*/

select distinct d.fantasia, b.tipo_prd, a.codigo, b.descricao, a.cod_equ, a.dt_vigencia_ini, a.dt_vigencia_fin
from faecpcad a, faprdcad b, faequcad c, faconcad d
where a.codigo = b.codigo and a.cod_equ = c.cod_equ and a.cod_con = d.cod_con
and b.tipo_prd in ('GMD', 'DIA', 'TAX', 'VID') order by 1,2,4

select t.*, t.rowid from faequcad t where t.cod_con = '073' --select max(pk_equcad) from faequcad

select * from faetpcad where cod_con = '073' --equivalência por tipo
/*delete from faecpcad where codigo in (
    select codigo from faprdcad where tipo_prd in ('TOM','ANE','ANG','CAR','CON','DEN','EXA','EXC','FIS','FRI','HEM','HMD',
    'HON','LAB','LCR','MAM','MDN','MMA','RAD','RAX','RES','ULT'))
    and cod_con = "001"*/

--delete from faecpcad where cod_con = "057" and codigo in (select codigo from faprdcad where tipo_prd not in ("TAX","DIA","GAS","TXC"))

