select t.cod_tabela, t.rowid from famovprd t, famovdestino u, fafatcad v
where t.sequencial = u.sequencial
and u.cod_fatura = v.fatura
and t.comanda in (select comanda from famovcad where cod_pac = '8064433')
--and v.remessa in ('018216')
