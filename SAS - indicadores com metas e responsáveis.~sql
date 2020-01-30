--Indicadores com responsáveis e metas
select distinct t.name, t.meta_start, t.meta_end,
       (select distinct b.name from bsc_indicators a, cmn_users b where a.ref_owner = t.ref_owner 
       and a.ref_owner = b.id and a.family = '0') gestor,
       (select distinct b.name from bsc_indicators a, cmn_users b where a.ref_executive = t.ref_executive and a.ref_executive = b.id
       and a.family = '0') gerente,
       (select distinct b.name from bsc_indicators a, cmn_users b where a.ref_director = t.ref_director and a.ref_director = b.id
       and a.family = '0') diretor
from bsc_indicators t, cmn_users u
where t.ref_owner = u.id
and t.family = '0' and t.monitor = '1' --(ativos)
--analysed by 0 - gestor, 1, gerente, 2 - diretor
