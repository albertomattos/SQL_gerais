/*select cod_ala, data_ent, count(*) qtde from fapaccad t where tipo_pac = 'U'
and data_ent = &data_ent
--and data_ent between &data_ent and &data_ent
group by data_ent, cod_ala
order by data_ent, cod_ala*/

select cod_ala,
       case cod_ala when 'PSCM' then count(*)
                    when 'PSGO' then count(*)
                    when 'PSOR' then count(*)
                    when 'PSPE' then count(*)
       else count(*) END "qtde"
from fapaccad where tipo_pac = 'U'
and data_ent = &data_ent
group by data_ent, cod_ala
order by cod_ala;

select cod_ala,
       decode(cod_ala, 'PSCM', count(*),
                       'PSGO', count(*),
                       'PSOR', count(*),
                       'PSPE', count(*),
                       count(*)) "QTDE"
from fapaccad where tipo_pac = 'U'
and data_ent = &data_ent
group by data_ent, cod_ala
order by cod_ala
