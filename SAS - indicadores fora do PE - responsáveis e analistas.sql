--Indicadores com metas, responsáveis e analistas
select t.name, 
       case when t.ref_analysis = 0 then '' else
       case when t.analysed_by = 0 then (select distinct b.name from bsc_indicators a, cmn_users b where a.ref_owner = t.ref_owner 
       and a.ref_owner = b.id and a.family = '0')
       when t.analysed_by = 1 then (select distinct b.name from bsc_indicators a, cmn_users b where a.ref_executive = t.ref_executive and a.ref_executive = b.id
       and a.family = '0')
       else (select distinct b.name from bsc_indicators a, cmn_users b where a.ref_director = t.ref_director and a.ref_director = b.id
       and a.family = '0') end end analista
from bsc_indicators t, cmn_users u
where t.ref_owner = u.id
and t.family = '0' and t.monitor = '1' --(ativos)
and t.ref_acevent in ('6','24','29')
order by 2
