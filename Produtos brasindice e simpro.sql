select t.tipo_prd, t.descricao, t.co_tuss, t.cod_simpro, t.co_tuss_simpro, t.cod_bras, t.cod_bras_tiss, t.co_tuss_bras, t.rowid
from faprdcad t
where t.tipo_prd in ('MED','DES','FIO','FNU')
and t.bloqueado = 'N'
order by t.tipo_prd
