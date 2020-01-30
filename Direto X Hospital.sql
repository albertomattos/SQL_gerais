--Verifica se existe algum item DES ou MED no banco como Direto:
select * from famovprd
where famovprd.codigo in
    (select faprdcad.codigo from faprdcad
     where (faprdcad.tipo_prd = "DES" or faprdcad.tipo_prd = "MED"))
and tipo_pgto = "D"

--Verifica se fatura XXXXXX possui algum item como pagamento Direto:
select famovdestino.* from famovdestino, famovprd, famovcad
where famovprd.sequencial = famovdestino.sequencial
and famovcad.comanda = famovprd.comanda
--and cod_pac = "E405648"
and cod_fatura = "664940"
--and tipo_pgto = "D"
order by valor
