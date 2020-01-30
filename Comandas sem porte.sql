select t.cod_pac, t.comanda, u.cod_tabela, u.codigo, u.*, u.rowid from famovdestino v, famovprd u, famovcad t
where v.sequencial = u.sequencial and u.comanda = t.comanda and u.tipo_comanda = t.tipo_comanda
--and u.codigo in (select a.codigo from faprdcad a
--where a.tipo_prd = 'EXA') and v.valor_porte = 0 and v.quant_ch <> 0
and t.comanda = '6441116'
--and v.numero_repasse is null and v.destino = 'C' and u.cod_tabela in ('42')
--and t.data_mov >= '01/01/2015'
--and u.codigo = '052034'

select a.*, a.rowid from famovprd a where a.perc_ato = '1' and a.comanda = '6403347'

select t.*, t.rowid from famovprd t where t.comanda = '6441116'
select t.*, t.rowid from famovdestino t where t.sequencial = '17175161'

--
select t.cod_pac, t.comanda, u.cod_tabela, u.codigo, v.*, v.rowid from famovdestino v, famovprd u, famovcad t
where v.sequencial = u.sequencial and u.comanda = t.comanda and u.tipo_comanda = t.tipo_comanda
and u.codigo in (select a.codigo from faprdcad a
where a.tipo_prd = 'EXA')-- and v.valor_porte = 0
--and v.numero_repasse is null and v.destino = 'C'
--and u.cod_tabela in ('42')
and t.comanda = '6403347'
--and t.data_mov >= '01/01/2015'
--and u.codigo = '052034'

--
select t.*, t.rowid from fafatprd t where t.cod_pac in
(select t.cod_pac from famovdestino v, famovprd u, famovcad t
where v.sequencial = u.sequencial and u.comanda = t.comanda and u.tipo_comanda = t.tipo_comanda
and u.codigo in (select a.codigo from faprdcad a
where a.tipo_prd = 'USG') and v.valor_porte = 0
and v.numero_repasse is null and v.destino = 'C' and u.cod_tabela in ('30')
and t.data_mov >= '01/01/2015'
and u.codigo = '052048'
) and t.cod_prd = '052048'

/*select v.*, v.rowid from famovdestino v
where v.sequencial in (select u.sequencial from famovprd u where u.codigo in (select a.codigo from faprdcad a
where a.tipo_prd = 'USG')) and v.valor_porte = 0
*/
