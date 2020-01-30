select fapaccad.cod_con, fantasia, num_guia, data_ent, hora_ent, tipo_pac, cod_pac, cod_ala, apelido from faconcad, fapaccad, fausucad
where faconcad.cod_con = fapaccad.cod_con
and fapaccad.cod_matricula = fausucad.matricula
and data_ent >= "08/11/2008"
and fapaccad.cod_con = '016'
and tipo_pac = "I"
and num_guia <> "000000000200"
union
select fapaccad.cod_con, fantasia, num_guia, data_ent, hora_ent, tipo_pac, cod_pac, cod_ala, apelido from faconcad, fapaccad, fausucad
where faconcad.cod_con = fapaccad.cod_con
and fapaccad.cod_matricula = fausucad.matricula
and data_ent >= "08/11/2008"
and fapaccad.cod_con = '016'
and tipo_pac = "U"
and num_guia <> "000000000400"
union
select fapaccad.cod_con, fantasia, num_guia, data_ent, hora_ent, tipo_pac, cod_pac, cod_ala, apelido from faconcad, fapaccad, fausucad
where faconcad.cod_con = fapaccad.cod_con
and fapaccad.cod_matricula = fausucad.matricula
and data_ent >= "08/11/2008"
and fapaccad.cod_con = '016'
and tipo_pac = "A"
and num_guia <> "000000000100"
order by tipo_pac
