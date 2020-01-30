select t.*, t.rowid from ac_records t, ac_events u, ac_ocurrencies v, bsc_indicators w
where t.ref_ocurrency = v.id
and u.id = v.ref_acevent
and t.ref_indicator = w.id
and upper(t.title) like 'AC%TAX%ADE%PT%2018%'
--and w.ref_analysis <> 0
--and v.dt_period_start = '01/03/2016' order by t.title
--Origin: 3- Completa; 1- Análise gerada pelo sistema; 0- Análise aberta; 2- Análise incompleta.

--Eventos de análise crítica
select * from ac_events

--Indicadores cujas análises não foram realizadas pelo gestor:
select w.* from bsc_indicators w
where w.id in (select t.ref_indicator from ac_records t) and UPPER (w.name) like 'AC %'
and w.ref_analysis <> 0 and w.dt_future = '01/08/2017'

select w.*,w.rowid from bsc_indicators w where w.id = '19342'
--and v.dt_period_start = '01/03/2015'
select w.*,w.rowid from bsc_indicators w where w.name like '%CUSTOS%'
where w.id in (
select t.id from ac_records t where UPPER (t.title) like '%CUSTOS TI%')

select t.* from ac_records t where t.id in ('19342')


select t.*, t.rowid from ac_records t where t.title like '%Cirurgias iniciadas com atraso (acima de 20 minutos)%'
select a.*, a.rowid from bsc_indicators a where a.name like 'AC%Consumo%UCO%'

select count(*) from ac_records t, ac_events u, ac_ocurrencies v, bsc_indicators w
where t.ref_ocurrency = v.id
and u.id = v.ref_acevent
and t.ref_indicator = w.id
and v.dt_period_start = '01/03/2016' order by t.title
