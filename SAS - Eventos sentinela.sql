select count(*) from qms_occurrences where qms_occurrences.id in
       (select qms_occurrences.id from qms_occurrences where (qms_occurrences.restriction = 0 or qms_occurrences.restriction in
               (select cmn_restrictions.restriction from cmn_restrictions where cmn_restrictions.type = 0 and cmn_restrictions.ref_source in
                       (select cmn_membership.ref_group from cmn_membership where cmn_membership.ref_user = 51)
                union select cmn_restrictions.restriction from cmn_restrictions where cmn_restrictions.type = 1
--                and cmn_restrictions.ref_source = 51
                union select cmn_restrictions.restriction from cmn_restrictions where cmn_restrictions.type = 2
                and cmn_restrictions.ref_source in
                    (select cmn_employments.ref_unit from cmn_employments where cmn_employments.ref_user = 65 and cmn_employments.state=1)
                    ))
and (qms_occurrences.dt_created >= to_date('2016-12-14','YYYY-MM-DD')and qms_occurrences.dt_created <= to_date('2018-04-30','YYYY-MM-DD'))
and qms_occurrences.ref_type in (14)--Registros de Não Conformidades
and qms_occurrences.state <> 11 )--Ignorado = Sim

--select * from qms_occurrences where serial like 'ID%' order by serial
