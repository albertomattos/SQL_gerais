--Indicadores com metas, respons�veis e analistas select name, analysed_by from bsc_indicators where family = '0'
select t.name, t.meta_start, t.meta_end,
(select case when n.next_update < '01/06/2018' then 'Desatualizado' else 'Atualizado' end from bsc_indicators n
where n.id = t.id) atualizacao_indicador,
       (select distinct b.name from bsc_indicators a, cmn_users b where a.ref_owner = t.ref_owner 
       and a.ref_owner = b.id and a.family = '0') gestor,
       (select distinct b.name from bsc_indicators a, cmn_users b where a.ref_executive = t.ref_executive and a.ref_executive = b.id
       and a.family = '0') gerente,
       (select distinct b.name from bsc_indicators a, cmn_users b where a.ref_director = t.ref_director and a.ref_director = b.id
       and a.family = '0') diretor, case when t.ref_analysis = 0 then '' else
       case when t.analysed_by = 0 then (select distinct b.name from bsc_indicators a, cmn_users b where a.ref_owner = t.ref_owner 
       and a.ref_owner = b.id and a.family = '0')
       when t.analysed_by = 1 then (select distinct b.name from bsc_indicators a, cmn_users b where a.ref_executive = t.ref_executive and a.ref_executive = b.id
       and a.family = '0')
       else (select distinct b.name from bsc_indicators a, cmn_users b where a.ref_director = t.ref_director and a.ref_director = b.id
       and a.family = '0') end end analista
from bsc_indicators t, cmn_users u
where t.ref_owner = u.id
and t.family = '0'
--and t.meta_semaphore <> '3' --(3 para monitoramento)
and t.monitor = '1' --(ativos)
--and t.ref_acevent <> '31' --(31 para o PE)
order by 4,1
