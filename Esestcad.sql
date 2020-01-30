select t.*, t.rowid from esestcad t where --t.em_balanco = 'S'
t.cod_set = '0302' and t.est_atu <> 0
--and t.cod_prd in (select distinct cod_prd from esbalite where documento = '0008289')
and t.cod_prd = '222665'

select t.*, t.rowid from esestcad t where t.cod_prd = '204011' order by 1
t.cod_set = '0302' and t.cod_prd = '137500'

select t.cod_prd, sum(t.est_atu) from esestcad t, faprdcad u
where t.cod_prd = u.codigo and t.cod_prd in ('204006') and t.cod_set = '0015'-- and t.est_atu <> 0
group by t.cod_prd, u.descricao order by u.descricao
