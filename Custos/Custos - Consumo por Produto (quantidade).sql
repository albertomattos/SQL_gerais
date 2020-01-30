select distinct a.set_con, e.descricao, d.descricao, sum(b.Quant), c.descricao
from esmovcad a, esmovite b, faprdcad c, fatipcad d, fasetcad e
where a.tipo_documento = b.tipo_documento and a.documento = b.documento
and b.cod_prd = c.codigo and c.tipo_prd = d.tipo_prd
and a.set_con = e.cod_set
and a.data_mov between '01/01/2013' and '31/12/2013'
and a.tipo_documento = 'REQ' and d.natureza is null
--and a.cred_deb = 'D'
--and a.set_con = '0124'
--and e.descricao like 'POSTO%'
and c.tipo_prd = 'MEX'-- AND C.DESCRICAO LIKE 'PAPEL O%'
group by a.set_con, e.descricao, d.descricao, c.descricao
order by 5,2
