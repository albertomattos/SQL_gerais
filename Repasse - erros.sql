--Desabilitar FK na tabela de quitação (quitacao_produto). FK_FATPRD_QUIPRD
select t.*, t.rowid from quitacao_produto t where t.cod_fatura in (
       select u.fatura from fafatprd u where u.cod_set = '0291' and u.cod_pac in (
              select v.cod_pac from famovcad v where v.set_ori <> '0291')
       and u.cod_prd in (select w.codigo from faprdcad w where w.tipo_prd = 'USG'))

--
select t.*, t.rowid from fafatprd t where cod_set = '0022' and cod_pro = '005280' and numero_repasse is null

select * from fafatcad where fatura = '517606'

select t.cod_pac, t.fatura, t.cod_pro, t.numero_repasse, t.valor_repasse, t.cod_set, t.rowid from fafatprd t
where fatura = '515365'

--select * from famovprd where comanda in (select comanda from famovcad where cod_pac = '6877519')

select t.*, t.rowid from famovdestino t where sequencial in (
select sequencial from famovprd t where comanda in (select * from famovcad t where cod_pac = '7420038'))

--Update: (utilizar este para corrigir)
update famovdestino set numero_repasse = (
select distinct a.numero_repasse
from fafatprd a, famovcad b, famovprd c, famovdestino d, quitacao_produto e
where a.fatura = d.cod_fatura and a.cod_pac = b.cod_pac and b.comanda = c.comanda and b.tipo_comanda = c.tipo_comanda
and a.fatura = e.cod_fatura and a.cod_prd = c.codigo and c.sequencial = d.sequencial and a.cod_prd = e.cod_produto
and a.cod_prd in (select codigo from faprdcad where tipo_prd in ('PRO','CON'))
and a.fatura = '317719' and a.cod_pro = '000104')
where cod_fatura = '317719' and sequencial in (select sequencial from famovprd where cod_pro = '000104')

select d.*
from fafatprd a, famovcad b, famovprd c, famovdestino d, quitacao_produto e
where a.fatura = d.cod_fatura and a.cod_pac = b.cod_pac and b.comanda = c.comanda and b.tipo_comanda = c.tipo_comanda
and a.fatura = e.cod_fatura and a.cod_prd = c.codigo and c.sequencial = d.sequencial and a.cod_prd = e.cod_produto
and a.cod_prd in (select codigo from faprdcad where tipo_prd in ('PRO','CON'))
and d.numero_repasse is null
and a.fatura = '317719' and a.cod_pro = '000104'
--and cod_fatura = '317719' and sequencial in (select sequencial from famovprd where cod_pro = '000104')

-- Script:
select t.cod_fatura, u.fatura, t.numero_repasse, t.valor_repasse, u.numero_repasse, t.rowid from famovdestino t, fafatprd u
where t.cod_fatura = u.fatura
and t.numero_repasse is null
and u.numero_repasse is not null and u.cod_pro = '000788'

select u.numero_repasse, t.numero_repasse, t.cod_fatura, t.rowid from famovdestino t, famovprd v, fafatprd u
where t.sequencial = v.sequencial and t.cod_fatura = u.fatura
and t.numero_repasse is null and v.cod_pro = '000206'
and u.numero_repasse is not null and u.cod_pro = '000206'
--
select * from famovdestino where cod_fatura = '516004'

select u.fatura, u.numero_repasse, u.rowid from fafatprd u where u.numero_repasse is not null and u.cod_pro = '000128'
and u.fatura in (select t.cod_fatura from famovdestino t where t.numero_repasse is null)

select * from famovdestino t, fafatprd u
where t.cod_fatura = u.fatura
and t.numero_repasse is not null
and u.numero_repasse is null and u.cod_pro = '000206' and t.cod_fatura = '516004'


-------------
/*update famovdestino set numero_repasse = (
select distinct a.numero_repasse
from fafatprd a, famovcad b, famovprd c, famovdestino d, quitacao_produto e
where a.fatura = d.cod_fatura and a.cod_pac = b.cod_pac and b.comanda = c.comanda and b.tipo_comanda = c.tipo_comanda
and a.fatura = e.cod_fatura and a.cod_prd = c.codigo and c.sequencial = d.sequencial and a.cod_prd = e.cod_produto
and a.cod_prd in (select codigo from faprdcad where tipo_prd in ('PRO','CON'))
and a.fatura = '317719' and a.cod_pro = '000104')
where cod_fatura = '317719' and sequencial in (select sequencial from famovprd where cod_pro = '000104')
*/
select b.*, b.rowid
from fafatprd a, famovcad b, famovprd c, famovdestino d--, quitacao_produto e
where a.fatura = d.cod_fatura and a.cod_pac = b.cod_pac and b.comanda = c.comanda and b.tipo_comanda = c.tipo_comanda
/*and a.fatura = e.cod_fatura*/ and a.cod_prd = c.codigo and c.sequencial = d.sequencial-- and a.cod_prd = e.cod_produto
/*and a.cod_pro = e.cod_pro*/ and a.cod_pro = c.cod_pro and a.cod_prd = c.codigo
and a.cod_prd in (select codigo from faprdcad where tipo_prd in ('USG'))
and d.numero_repasse is null
and a.fatura = '516004' and a.cod_pro = '000206'
order by a.cod_prd

----------------
update famovdestino set numero_repasse = (

select distinct a.numero_repasse
from fafatprd a, famovcad b, famovprd c, famovdestino d, quitacao_produto e
where a.fatura = d.cod_fatura and a.cod_pac = b.cod_pac and b.comanda = c.comanda and b.tipo_comanda = c.tipo_comanda
and a.fatura = e.cod_fatura and a.cod_prd = c.codigo and c.sequencial = d.sequencial and a.cod_prd = e.cod_produto
and a.cod_prd in (select codigo from faprdcad where tipo_prd in ('PRO','CON'))
and a.fatura = '387386' and a.cod_pro = '000788')

where cod_fatura = '317719' and sequencial in (select sequencial from famovprd where cod_pro = '000104')

select t.*, t.rowid from famovdestino t where numero_repasse is null
and cod_fatura = '317719'

--USG - utilizar:
select t.*, t.rowid from quitacao_produto t where cod_fatura in(

select t.fatura from fafatprd t where cod_set = '0149'
and t.cod_pac in (
select cod_pac from famovcad where set_ori = '0291' and cod_pro = '000206')
and t.cod_prd in (select codigo from faprdcad where tipo_prd = 'USG')
)

select t.*, t.rowid from quitacao_produto t where cod_fatura in(
select u.fatura from fafatprd u where u.cod_set = 0289)
and t.cod_set <> '0289'
and t.cod_pro = '001145'
and t.cod_produto in (select codigo from faprdcad where tipo_prd = 'USG')

select * from quitacao_produto where cod_fatura = '516004'

--


-- Este update corrige as comandas que estão erradas, para USG
update famovcad set set_ori = '0149' where comanda in (
       select u.comanda from fafatprd t, famovcad u where t.cod_pac = u.cod_pac
       and t.cod_set = '0149'
       and u.set_ori = '0291' and t.cod_pro = '000206'
       and t.cod_prd in (select codigo from faprdcad where tipo_prd = 'USG')
       )

select t.*, t.rowid from famovcad t where t.cod_pac = '6313750'
