/*update suaihcad set tipo_alta =
(select cod_mot_alta from fapaccad where tipo_pac = "I" and data_alta is not null and suaihcad.cod_pac = fapaccad.cod_pac)
	where cod_pac in (select cod_pac from fapaccad where tipo_pac = "I" and data_alta between "01/01/2006" and "30/11/2006")
    and tipo_alta = "";*/

/*update fapaccad set senha = "" where cod_con = "018" and senha in ('11111111','00000000','15151515','22222222','12121212',
'55555555','33333333');*/
/*update fapaccad set senha = "" where cod_con = "018" and senha <> ""
and tipo_pac = "U"
and data_ent >= "01/10/2007"*/

select * from suaihcad where cod_pac in (select cod_pac from fapaccad where data_alta between "01/01/2006" and "30/11/2006")
