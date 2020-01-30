select u.descricao, t.*, t.rowid from esmovite t, faprdcad u where t.cod_prd = u.codigo
and documento in (
select t.documento from esmovcad t where documento = '0025164' and t.tipo_documento = 'PED')
and t.tipo_documento = 'PED' order by 5

select * from esmovite where documento in (
select documento from esmovcad where tipo_documento = 'COM' and cod_aux = '0025164')
and tipo_documento = 'COM' order by 4
