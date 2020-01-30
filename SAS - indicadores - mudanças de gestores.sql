select t.ref_director, t.ref_executive, t.ref_owner, t.name, t.rowid from bsc_indicators t where /*t.meta_tolerance <> '7' */ t.family = '0'
and t.ref_director = '59' and t.monitor = '1' order by 4
--and t.name like '%perdas por danos%'
