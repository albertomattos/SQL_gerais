select t.name, u.name, w.name, t.ref_acevent from bsc_indicators t, cmn_users u, cmn_employments v, cmn_sectors w, ac_events x
where u.id = v.ref_user and v.ref_sector = w.id and x.id = t.ref_acevent
and t.ref_owner = u.id
and t.ref_analysis not in (
select id from ac_records where competence = '201705')
and v.is_default = 1
and t.name not like 'AC%' and t.family = 0 and t.ref_analysis <> 0
and t.monitor = 1
and t.analysed_by = 0
and x.id = '23'

select * from bsc_indicators Where upper(name) like '%CUSTOS TI%' order by 3 desc
select * from ac_records order by competence desc

***********
select id, family, ref_acevent, name, dt_future from bsc_indicators Where family = '0'
and name not in (select replace(replace(name,'AC ',''),'| Maio 2017','')
from bsc_indicators where family = '1' and dt_future = '01/08/2017')
and ref_acevent in ('6','18','19','20','21')

select * from bsc_indicators where family = '1' and dt_future = '01/06/2017'

***********
select id, family, ref_acevent, name, dt_future from bsc_indicators Where family = '0'
and name not in (select name
from bsc_indicators where family = '1' and dt_future = '01/04/2017' and name like '%Abril 2017')
and ref_acevent in ('6','18','19','20','21')
