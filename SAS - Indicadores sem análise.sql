--select t.*, t.rowid from bsc_indicators t where t.name like '%Contas a Pagar%'

select t.name, u.name, w.name from bsc_indicators t, cmn_users u, cmn_employments v, cmn_sectors w, ac_events x
where u.id = v.ref_user and v.ref_sector = w.id and x.id = t.ref_acevent
and t.ref_owner = u.id --analysed by = 0
--and t.ref_director = u.id --analysed by = 2
--and t.ref_executive = u.id --analysed by = 1
and t.ref_analysis not in (
select id from ac_records where competence = '201612')
and v.is_default = 1
and t.name not like 'AC%' and t.family = 0 and t.ref_analysis <> 0
--and t.ref_acevent in ('1','11')
and t.monitor = 1
and t.analysed_by = 0
and x.id = '23'
union
select t.name, u.name, w.name from bsc_indicators t, cmn_users u, cmn_employments v, cmn_sectors w
where u.id = v.ref_user and v.ref_sector = w.id
--and t.ref_owner = u.id --analysed by = 0
--and t.ref_director = u.id --analysed by = 2
and t.ref_executive = u.id --analysed by = 1
and t.ref_analysis not in (
select id from ac_records where competence = '201612')
and v.is_default = 1
and t.name not like 'AC%' and t.family = 0 and t.ref_analysis <> 0--Indicadores com an�lise
--and t.ref_acevent in ('1','11')
and t.monitor = 1
and t.analysed_by = 1
union
select t.name, u.name, w.name from bsc_indicators t, cmn_users u, cmn_employments v, cmn_sectors w
where u.id = v.ref_user and v.ref_sector = w.id
--and t.ref_owner = u.id --analysed by = 0
and t.ref_director = u.id --analysed by = 2
--and t.ref_executive = u.id --analysed by = 1
and t.ref_analysis not in (
select id from ac_records where competence = '201612')
and v.is_default = 1
and t.name not like 'AC%' and t.family = 0 and t.ref_analysis <> 0
--and t.ref_acevent in ('1','11')
and t.monitor = 1
and t.analysed_by = 2
