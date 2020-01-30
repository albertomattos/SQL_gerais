select distinct b.cod_pac registro,	b.data_ent entrada, b.cod_ala, a.cod
from fapaccom a, fapaccad b, faprtcad c, faconcad d, faalacad e
where a.cod_pac = b.cod_pac
and b.cod_prt = c.cod_prt
and d.cod_con = b.cod_con and b.cod_ala = e.cod_ala
and cod_pcn = 'HP' and b.tipo_pac = 'E'
and data_ent between '01/03/2012' and '31/03/2012' and b.cod_ala like 'C%' and b.cod_ala <> 'CMED'
order by 3
