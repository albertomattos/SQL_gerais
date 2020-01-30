select * from ac_records a, cmn_users b, bsc_indicators c
where c.ref_owner = b.id and a.ref_indicator = c.id
and a.competence = '201610'

select * from bsc_indicators x, cmn_users y
where y.id = x.ref_owner
