--Pacientes sem alta:
select cod_pac, nome_pac, leito, fantasia, nome_plano from fapaccad a, faplacad b, faprtcad c, faconcad d where a.cod_pla = b.cod_pla
and a.cod_con = b.cod_con
and a.cod_pla = b.cod_pla
and a.cod_prt = c.cod_prt
and a.cod_con = d.cod_con
and data_ent >= "01/09/2009" and tipo_pac = "I"
and data_alta is null
and nome_plano like "%ENF%"
and leito not like "%-%"
--Pacientes com alta:
select a.cod_pac, nome_pac, e.leito, fantasia, nome_plano, data_alta from fapaccad a, faplacad b, faprtcad c, faconcad d, falehcad e
where a.cod_pla = b.cod_pla
and a.cod_con = b.cod_con
and a.cod_prt = c.cod_prt
and a.cod_con = d.cod_con
and a.cod_pac = e.cod_pac
and data_ent >= "01/09/2009" and tipo_pac = "I"
and nome_plano like "%ENF%"
and e.leito not like "%-%" and e.leito not like "BOX%"
