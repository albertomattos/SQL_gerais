select * from fafatprd where fatura in (
select fatura from fafatcad where cod_pac = 'B925770')


select famovprd.comanda, famovprd.valor_tot, famovprd.numero_repasse, famovprd.valor_repasse, famovcad.fat_pac
from famovprd, famovcad where famovcad.comanda = famovprd.comanda
and famovcad.cod_pac = 'B925770' and numero_repasse is not null
order by numero_repasse

select * from faprdcad where codigo in(select codigo from famovprd where sequencial in(select sequencial from famovdestino where numero_repasse = 1461))


select * from fatipcad
select a.* from famovprd a where a.comanda in (select comanda from famovcad where cod_pac = 'B925770') where numero_repasse = 1461

select numero_repasse from fafatprd where fatura = '760756' and numero_repasse is not null
select * from fafatprd where numero_repasse = 1461

select * from famovcad


select * from nota_fatura where fatura = "934833"

delete from nota_fatura  where fatura = "934833"

/*update faremcad set nota_fis = "" where remessa = "045941"--00017762
select * from faremcad where remessa = "045941"
update faremcad set nota_fis = "00017762" where remessa = "045922"--00017762
update fafatcad set nota_fiscal = "" where fatura = "773985"*/

