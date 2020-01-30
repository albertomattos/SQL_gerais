select a.data_ent, b.nome_pac, b.cod_prt, a.cod_pac from fapaccad a, faprtcad b
where a.cod_prt = b.cod_prt
and data_ent between "01/01/2007" and "31/08/2008"
and tipo_pac = "I"
order by a.data_ent
