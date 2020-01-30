select b.descricao, count(b.descricao)
from fapaccad a, faalacad b
where a.cod_ala = b.cod_ala
and a.tipo_pac = 'E'
and a.data_ent between '01/07/2013' and '31/07/2013'
group by b.descricao
order by 1
