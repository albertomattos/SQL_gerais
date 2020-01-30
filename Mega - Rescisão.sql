select distinct t.cres_in_codigo, count(t.cres_in_codigo) from rh_rescisao t
where t.res_dt_rescisao >= '01/01/2013'
group by t.cres_in_codigo

select t.* from rh_rescisao t where t.res_dt_rescisao >= '01/01/2013'
