select num_guia, data_ent, tipo_pac, cod_pac from fapaccad where cod_pac in (
select cod_pac from fafatcad, faremcad where fafatcad.remessa = faremcad.remessa
and fafatcad.cod_con = "056" and fafatcad.data_emiss > "31/05/2007" and fafatcad.nota_fiscal is null
and destino = "C" and grd_sulame is null) and length(num_guia) = "12"

update fapaccad set num_guia = {fn right (num_guia,10)} where cod_pac in(
select cod_pac from fafatcad, faremcad where fafatcad.remessa = faremcad.remessa
and fafatcad.cod_con = "056" and fafatcad.data_emiss > "31/05/2007" and fafatcad.nota_fiscal is null
and destino = "C" and grd_sulame is null)
and length(num_guia) = "12"

update faguicad set num_guia = {fn right (num_guia,9)} where cod_pac in(
select cod_pac from fapaccad
where cod_con = "056" and data_ent >= "31/05/2007")
and length(num_guia) = "12"


select faguicad.cod_pac from faguicad, fafatcad
where faguicad.cod_pac = fafatcad.cod_pac
and remessa = "" and fafatcad.cod_con = "056" and data_emiss > "31/05/2007" and nota_fiscal is null
and destino = "C") and length(num_guia) = "12"

select * from faremcad where cod_con = "056" and grd_sulame is null
