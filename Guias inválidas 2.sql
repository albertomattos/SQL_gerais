select fapaccad.cod_con, fantasia, num_guia, data_ent, hora_ent, tipo_pac, cod_pac, cod_ala, apelido from faconcad, fapaccad, fausucad
where faconcad.cod_con = fapaccad.cod_con
and fapaccad.cod_matricula = fausucad.matricula
and data_ent between "01/08/2008" and "15/10/2008"
and fapaccad.cod_con not in ('005','036','055','060','073','080','082','091','001','004','008','012','014','018','021',
'032','041','281','058','056','079','086','101','108','017','026','027','019','029','001','004','008','010','012','014',
'017','018','019','021','025','026','027','029','030','032','038','039','040','041','045','048','052')
and num_guia not in (select num_guia from fapaccad where cod_con = "056" and num_guia like "056%")
and num_guia not in (select num_guia from fapaccad where cod_con = "058" and num_guia like "05512%")
and num_guia not in (select num_guia from fapaccad where cod_con = "059" and num_guia like "059%")
and num_guia not in (select num_guia from fapaccad where cod_con = "062" and num_guia like "48%")
and num_guia not in (select num_guia from fapaccad where cod_con = "074" and num_guia like "074%")
and num_guia not in (select num_guia from fapaccad where cod_con = "075" and num_guia like "075%")
and num_guia not in (select num_guia from fapaccad where cod_con = "077" and num_guia like "077%")
and num_guia not in (select num_guia from fapaccad where cod_con = "078" and num_guia like "078%")
and num_guia not in (select num_guia from fapaccad where cod_con = "079" and num_guia like "27641%")
and num_guia not in (select num_guia from fapaccad where cod_con = "085" and num_guia like "085%")
and num_guia not in (select num_guia from fapaccad where cod_con = "086" and num_guia like "400%")
and num_guia not in (select num_guia from fapaccad where cod_con = "088" and num_guia like "88%")
and num_guia not in (select num_guia from fapaccad where cod_con = "090" and num_guia like "7351%")
and num_guia not in (select num_guia from fapaccad where cod_con = "101" and num_guia like "101%")
and num_guia not in (select num_guia from fapaccad where cod_con = "107" and num_guia like "731%")
and num_guia not in (select num_guia from fapaccad where cod_con = "108" and num_guia like "108%")
and num_guia not in (select num_guia from fapaccad where cod_con = "110" and num_guia like "110%")
and num_guia not in (select num_guia from fapaccad where cod_con = "113" and num_guia like "7088%")
and num_guia not in (select num_guia from fapaccad where cod_con = "114" and num_guia like "114%")
and num_guia not in (select num_guia from fapaccad where cod_con = "125" and num_guia like "1502%")
and num_guia not in (select num_guia from fapaccad where cod_con = "141" and num_guia like "400%")
and num_guia not in (select num_guia from fapaccad where cod_con = "281" and num_guia like "00040%")
and num_guia not in (select num_guia from fapaccad where cod_con = "111" and num_guia like "32308%")
order by fapaccad.cod_con, num_guia
