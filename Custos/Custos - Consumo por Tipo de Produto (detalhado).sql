select distinct a.set_con, e.descricao, d.descricao, sum(b.valor_tot)
from esmovcad a, esmovite b, faprdcad c, fatipcad d, fasetcad e
where a.tipo_documento = b.tipo_documento and a.documento = b.documento
and b.cod_prd = c.codigo and c.tipo_prd = d.tipo_prd
and a.set_con = e.cod_set
and a.data_mov between '01/11/2013' and '30/11/2013'
and a.tipo_documento = 'REQ' and d.natureza is null
--and a.cred_deb = 'D'
and a.set_con = '0303'
--and c.tipo_prd = 'DES'
group by a.set_con, e.descricao, d.descricao
order by 2,3
