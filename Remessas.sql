select * from faremcad where remessa = "043398"
update faremcad set nota_fis = "" where remessa = "043844"
update faremcad set nota_fis = "00016990" where remessa = "043844"
update faremcad set remessa_fechada = "N" where remessa = "043398"
select * from fafatcad where fatura = "741401"
update fafatcad set nota_fiscal = "" where fatura = "741401"

select * from fafatcad where cod_pac = "E686729"

select faremcad.* from faremcad, fafatcad
where faremcad.remessa = fafatcad.remessa
and fafatcad.cod_pac = "E686729"

select famovprd.* from famovcad, famovprd
where famovcad.comanda = famovprd.comanda
and famovcad.cod_pac = "E686729"
and famovprd.cod_pro = "000106" "10643"

update famovprd set cod_pro = "010643" where cod_pro = "000106" and comanda in (select comanda from famovcad
where cod_pac = "E686729")

