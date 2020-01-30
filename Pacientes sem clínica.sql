select a.cod_pac, a.cod_ala, b.cod_set, a.tipo_pac, a.data_ent, a.data_alta
from fapaccad a, fapaccom b where a.cod_pac = b.cod_pac
and a.cod_ala in (select cod_ala from faalacad where ind_inativo = "1")
and b.cod_set is not null
order by a.data_ent desc
order by b.cod_set, a.cod_ala desc

select a.cod_ala, count(a.cod_ala) from fapaccad a, fapaccom b where a.cod_pac = b.cod_pac
and a.cod_ala in (select cod_ala from faalacad where ind_inativo = "1")
and b.cod_set is not null
group by a.cod_ala
order by count(a.cod_ala) desc
