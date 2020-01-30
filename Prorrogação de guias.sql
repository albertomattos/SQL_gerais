select * from faguhcad where cod_pac = "F049237"

update faguhcad set num_guia = {fn right (num_guia,10)} where cod_pac in(
select cod_pac from fapaccad
where cod_con = "056" and data_ent >= "31/05/2007")
and length(num_guia) = "12"

