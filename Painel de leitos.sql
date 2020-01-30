select a.leito, e.nome_pac, c.nome_pro, d.natureza, e.nascimento, b.tip_atend
from falehcad a, fapaccad b, faprocad c, faconcad d, faprtcad e, faleicad f
where a.cod_pac = b.cod_pac and b.cod_pro_sa = c.cod_pro and b.cod_con = d.cod_con and b.cod_prt = e.cod_prt and a.leito = f.leito
and f.cod_set = '0134' and b.data_alta is null and f.extra = 'N'
order by a.leito

--select * from falehcad where leito = '301-1'
select * from fapaccom
