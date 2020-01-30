select t.*, t.rowid from eslote_validade t where t.cod_prd = '001789'
/*--select t.*, t.rowid from eslote_validade t where t.cod_barra_int = '000025741'
where t.cod_prd in (select distinct cod_prd from esbalite where documento = '0008077')/* and t.cod_barra_int in (
--where t.cod_prd in ('212860') and t.cod_barra_int in (
select u.cod_barra_int from esestcad u ) where u.em_balanco = 'S'
and u.cod_set = '0302') --and u.cod_prd in
--(select distinct cod_prd from esbalite where documento = '0008026'))
select distinct cod_prd, lote, validade, sum(quantidade), cod_fabricante from esbalite where documento = '0008077' and concluido = 'S'
group by cod_prd, lote, validade, cod_fabricante
*/
--select t.cod_parametro, t.descricao, t.valor, t.sistemas, t.rowid from wpdtab t where upper(descricao) like '%LOTE%'
