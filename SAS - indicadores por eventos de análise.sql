select distinct t.name, u.name from bsc_indicators t, cmn_users u, cmn_employments v, ac_events x
where u.id = v.ref_user and x.id = t.ref_acevent
and t.ref_owner = u.id
and x.id <> '31'
and t.name not like 'AC %'
order by 1
