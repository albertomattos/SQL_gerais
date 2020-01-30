--select t.*, t.rowid from esestcad t where cod_set = '0155' and t.cod_prd in (select codigo from faprdcad where tipo_prd = 'MAT')
--and t.cod_barra_int <> ' '
--order by t.cod_prd, t.cod_barra_int

select t.*, t.rowid from esestcad t where cod_set = '0302' and cod_prd = '009537'
--update esestcad set est_bloq = '0,000' where cod_set = '0155'
--and cod_prd = '211123'
--194020; 212841; 218906; 214937; 217081
