select t.name, u.name, w.name from bsc_indicators t, cmn_users u, cmn_employments v, cmn_sectors w
where u.id = v.ref_user and v.ref_sector = w.id
and t.ref_owner = u.id
and t.ref_analysis not in (
select id from ac_records where competence = '201603')
and v.is_default = 1
and t.name not like 'AC%' and t.family = 0 and t.ref_analysis <> 0
and t.monitor = 1
and t.analysed_by = 0
union
select t.name, u.name, w.name from bsc_indicators t, cmn_users u, cmn_employments v, cmn_sectors w
where u.id = v.ref_user and v.ref_sector = w.id
and t.ref_executive = u.id
and t.ref_analysis not in (
select id from ac_records where competence = '201603')
and v.is_default = 1
and t.name not like 'AC%' and t.family = 0 and t.ref_analysis <> 0--Indicadores com análise
and t.monitor = 1
and t.analysed_by = 1
union
select t.name, u.name, w.name from bsc_indicators t, cmn_users u, cmn_employments v, cmn_sectors w
where u.id = v.ref_user and v.ref_sector = w.id
and t.ref_director = u.id
and t.ref_analysis not in (
select id from ac_records where competence = '201603')
and v.is_default = 1
and t.name not like 'AC%' and t.family = 0 and t.ref_analysis <> 0
and t.monitor = 1
and t.analysed_by = 2
