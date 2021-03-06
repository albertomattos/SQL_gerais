select t.monitor, t.meta_tolerance, t.name, t.*, t.rowid from bsc_indicators t where t.family = '0' and t.monitor = '1'
and lower (t.name) like '%recebimento de material%%'

select t.*, t.rowid from bsc_indicators t where t.family <> '0' and t.monitor = '1'
--and t.id = '25062'
and lower (t.name) like '%volume%estoque%'

--where upper(t.name) like 'VALOR TOTAL DE CONS%'
select t.meta_tolerance, t.name, t.restriction, t.rowid from bsc_indicators t where upper(t.name) like '%PRESS�%'  and t.family = '0'
select t.name, t.*, t.rowid from bsc_indicators t where t.ID = '14592'
select t.meta_end_date, t.name, t.*, t.rowid from bsc_indicators t where t.meta_end_date = '31/12/2015' and t.family = '0'

select a.NAME, a.id from bsc_indicators a WHERE a.id In
(select b.ref_indicator from bsc_items b where b.ref_indicator in (select c.id from bsc_indicators c
where upper(c.name) like 'PSC-CENTRO M%' and c.family = '0')
and b.competence >= '201600' AND b.ref_indicator not in ('8842','8843'))

select b.name, b.meta_start_date, b.rowid from bsc_indicators b where b.meta_end_date = '31/12/2017' and b.meta_start_date <> '31/01/2017'
and b.name like 'PSC-Centro%'

select b.*, b.rowid from bsc_indicators b where b.meta_end_date = '31/12/2017' and b.meta_start_date <> '31/01/2017'
and b.name like 'PSC-Inter%'

--Regress�o linear (com: 2995, sem: 947)
select a.name, a.chart_options, a.rowid from bsc_indicators a where a.name like 'PSC%' and a.chart_start_date = '01/01/2017'
update bsc_indicators set chart_options = '947' where name like 'PSC%' and chart_start_date = '01/01/2017' and chart_options = '2995'


