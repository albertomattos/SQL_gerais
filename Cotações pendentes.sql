--Cotações sem OC associada

select a.*, a.rowid from escotite a where a.cod_cot in (
--select t.cod_cot from escotcad t where t.cod_cot not in (
select t.*, t.rowid from escotcad t where t.cod_cot not in (
select distinct cod_cot from escotcad where cod_cot in (
--select cod_aux from esmovcad where tipo_documento = 'PED'))) order by 1
select cod_aux from esmovcad where tipo_documento = 'PED')) order by 1

--select * from esmovcad where tipo_documento = 'PED' and cod_aux not in (select cod_cot from escotcad)
--Cotações a excluir:
select a.*, a.rowid from escotcad a where a.cod_cot in (select cod_cot from cota)
select * from escotite where fk_cotcad = '181185'
