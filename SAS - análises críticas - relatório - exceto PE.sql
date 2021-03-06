select (select 
case when c.analysed_by = 0 then (select distinct b.name from bsc_indicators a, cmn_users b where a.ref_owner = c.ref_owner 
       and a.ref_owner = b.id and a.family = '0')
       when c.analysed_by = 1 then (select distinct b.name from bsc_indicators a, cmn_users b where a.ref_executive = c.ref_executive
         and a.ref_executive = b.id and a.family = '0' and a.monitor = '1')
       else (select distinct b.name from bsc_indicators a, cmn_users b where a.ref_director = c.ref_director and a.ref_director = b.id
       and a.family = '0') end from bsc_indicators c where c.monitor = '1' and c.family = '0' and t.ref_source = c.id) analista,
x.name analisado_por, decode(t.origin,'0','Analise aberta','1','Gerada pelo sistema','2','Incompleta','3','Completa') status,
t.title titulo, w.meta_start meta_inicial, w.meta_end meta_final,
(select case when n.next_update < '01/08/2017' then 'Desatualizado' else 'Atualizado' end from bsc_indicators n
where n.id = t.ref_source) atualizacao_indicador,
decode(t.classification,'0','N�o classificado','1','�timo','2','Favor�vel','3','Regular','4',
'Desfavor�vel','5','Ruim','6','Cr�tico') Classificacao, t.info_current, t.info_reasons, t.info_tendence
from ac_records t, ac_events u, ac_ocurrencies v, bsc_indicators w, cmn_users x
where t.ref_ocurrency = v.id and u.id = v.ref_acevent and t.ref_indicator = w.id and t.ref_owner = x.id
and v.ref_acevent <> '0'
and w.monitor = '1'
and t.title like 'AC%Agosto 2017%' order by 2,1
--and w.monitor <> '1'
