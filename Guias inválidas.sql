select fapaccad.cod_con, fantasia, num_guia, data_ent, hora_ent, tipo_pac, cod_pac, cod_ala, apelido from faconcad, fapaccad, fausucad
where faconcad.cod_con = fapaccad.cod_con
and fapaccad.cod_matricula = fausucad.matricula
and data_ent between "01/01/2009" and "29/12/2009"
and fapaccad.cod_con not in ('003','005','006','007','009','011','013','015','020','022','023','028','031','033','034',
'035','037','042','043','044','046','047','049','050','051','053','054','055','057','060','061','063','064','065','066',
'067','068','069','070','071','072','076','083','084','089','091','098','100','111','115','134','162','283','284','285',
'300','036','073','080','082','282','002','024','058','059','062','074','075','077','078','079','085','086','088','090',
'101','107','108','110','113','114','125','141','281','016','056','081')
and num_guia not in (select num_guia from fapaccad where cod_con = "001" and num_guia like "05512%")
and num_guia not in (select num_guia from fapaccad where cod_con = "004" and num_guia like "05512%")
and num_guia not in (select num_guia from fapaccad where cod_con = "008" and num_guia like "00800%")
and num_guia not in (select num_guia from fapaccad where cod_con = "010" and num_guia like "0000010%")
and num_guia not in (select num_guia from fapaccad where cod_con = "012" and num_guia like "012%")
and num_guia not in (select num_guia from fapaccad where cod_con = "014" and num_guia like "014%")
and num_guia not in (select num_guia from fapaccad where cod_con = "017" and num_guia like "026%")
and num_guia not in (select num_guia from fapaccad where cod_con = "018" and num_guia like "54672%")
and num_guia not in (select num_guia from fapaccad where cod_con = "019" and num_guia like "32557%")
and num_guia not in (select num_guia from fapaccad where cod_con = "021" and num_guia like "29337%")
and num_guia not in (select num_guia from fapaccad where cod_con = "025" and num_guia like "025%")
and num_guia not in (select num_guia from fapaccad where cod_con = "026" and num_guia like "026%")
and num_guia not in (select num_guia from fapaccad where cod_con = "027" and num_guia like "027%")
and num_guia not in (select num_guia from fapaccad where cod_con = "029" and num_guia like "551289%")
and num_guia not in (select num_guia from fapaccad where cod_con = "030" and num_guia like "6000%")
and num_guia not in (select num_guia from fapaccad where cod_con = "032" and num_guia like "32%")
and num_guia not in (select num_guia from fapaccad where cod_con = "038" and num_guia like "618%")
and num_guia not in (select num_guia from fapaccad where cod_con = "039" and num_guia like "039%")
and num_guia not in (select num_guia from fapaccad where cod_con = "040" and num_guia like "040%")
and num_guia not in (select num_guia from fapaccad where cod_con = "041" and num_guia like "00042%")
and num_guia not in (select num_guia from fapaccad where cod_con = "045" and num_guia like "045%")
and num_guia not in (select num_guia from fapaccad where cod_con = "048" and num_guia like "048%")
and num_guia not in (select num_guia from fapaccad where cod_con = "052" and num_guia like "400%")
order by fapaccad.cod_con, num_guia
