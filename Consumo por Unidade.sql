select a.descricao, a.cod_apresent, d.descricao, sum(c.quant)
from faprdcad a, esmovcad b, esmovite c, escarcad d, escarprd e where b.documento = c.documento and b.tipo_documento = c.tipo_documento
and c.cod_prd = a.codigo and a.codigo = e.cod_prd and d.cod_car = e.cod_car
and b.tipo_documento = 'REQ' and b.cod_pac is not null and b.data_mov between '01/01/2016' and '15/10/2016'
and a.tipo_prd in ('MED') and b.cred_deb = 'C'
group by a.descricao, a.cod_apresent, d.descricao, c.quant order by 1
