/*select t.*, t.rowid from esprod_set_lote t where t.cod_prd in (select distinct cod_prd from esbalite where documento = '0008075')
and t.cod_set = '0302'*/
--select t.*, t.rowid from esprod_set_lote t where t.cod_prd in (select cod_prd from esmovite where documento = '2017897')

--Verificar quais produtos não foram inventariados:
/*select a.codigo, a.descricao from faprdcad a where a.codigo not in (
select u.cod_prd, t.descricao from faprdcad t, esprod_set_lote u where t.codigo = u.cod_prd
and t.tipo_prd = 'MED' and t.bloqueado = 'N' and u.cod_set = '0155' order by 1)
and a.tipo_prd = 'MED' order by a.descricao
select codigo, descricao from faprdcad where tipo_prd = 'MED' and bloqueado = 'N' order by 1*/

--select t.*, t.rowid from esprod_set_lote t where t.cod_prd = '204050'
--select t.*, t.rowid from esprod_set_lote t where t.cod_set = '0015'

select t.*, t.rowid from esprod_set_lote t where --t.data_hora_inc between '01/05/2014' and '02/05/2014'
t.cod_set = '0020' and t.cod_prd  in ('208226')
