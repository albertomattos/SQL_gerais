select cod_pac, leito, data_ent, faprtcad.nome_pac from fapaccad, faprtcad
where fapaccad.cod_prt = faprtcad.cod_prt
and data_ent >= '01/07/2010' and tipo_pac = 'I'
and leito in (select leito from faleicad where tipo = 'HP') and data_alta is null
order by data_ent



select * from famovcad where cod_pac in (
select cod_pac from fapaccad, faprtcad
where fapaccad.cod_prt = faprtcad.cod_prt
and data_ent >= '01/07/2010' and tipo_pac = 'I'
and leito in (select leito from faleicad where tipo = 'HP') and data_alta is null)
