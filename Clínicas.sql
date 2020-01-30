/*select a.cod_pac, a.cod_ala, b.cod_set, a.tipo_pac, a.data_ent, a.data_alta
from fapaccad a, fapaccom b where a.cod_pac = b.cod_pac
and a.tipo_pac = "I" and a.data_alta is null order by b.cod_set, a.data_ent desc*/
--and a.cod_ala = "OBST" order by b.cod_set, a.data_ent desc

update fapaccom set cod_set = "7028" where cod_set = "3418" and cod_pac in (
select cod_pac from fapaccad where cod_ala = "REMO")

update fapaccad set cod_ala = "CCIR" where cod_pac in( --cod_ala = "PEDI" and
select cod_pac from fapaccom where cod_set = "0025") and tipo_pac = "U"

--update fapaccad set cod_ala = "GINE" where cod_ala = "OBST" and tipo_pac = "I"

--update fapaccad set cod_ala = "UA4" where cod_pac in ('G364266','G363960','G364069','G358990')

select * from fapaccom where cod_pac = "E347316"
