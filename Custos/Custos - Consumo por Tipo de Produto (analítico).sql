select distinct a.cred_deb, a.set_con, a.data_mov, e.descricao, d.descricao, sum(b.valor_tot),
decode(a.cred_deb,'C',sum(b.valor_tot)*(-1),sum(b.valor_tot)) total, b.quant, c.descricao
from esmovcad a, esmovite b, faprdcad c, fatipcad d, fasetcad e
where a.tipo_documento = b.tipo_documento and a.documento = b.documento
and b.cod_prd = c.codigo and c.tipo_prd = d.tipo_prd
and a.set_con = e.cod_set
and a.data_mov between '01/01/2013' and '31/08/2013'
and a.tipo_documento = 'REQ' and d.natureza is null
and c.tipo_prd not in ('IMO','EQU','GAS')
--and a.cred_deb = 'D'
--and a.set_con in ('0128','0047')
--and c.tipo_prd = 'MED'
group by a.cred_deb, a.set_con, a.data_mov, e.descricao, d.descricao, b.quant, c.descricao
order by 4,9
