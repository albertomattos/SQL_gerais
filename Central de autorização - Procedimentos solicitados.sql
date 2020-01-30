select avg(to_date(t.dh_inicio_processo,'dd/mm/yyyy') - to_date(t.dh_solicitacao,'dd/mm/yyyy'))
from TB_AUTORIZ_CABEC t 
where t.dh_solicitacao between to_date('01/05/2016', 'dd/mm/yyyy') and to_date('12/05/2016', 'dd/mm/yyyy')+1
      and t.fk_msgaut <> 9
      and t.fk_cod_uni = '0001'
      and t.st_envio in ('1', '2', '3')

select *
from TB_AUTORIZ_CABEC t 
where t.dh_solicitacao between to_date('01/02/2016', 'dd/mm/yyyy') and to_date('29/02/2016', 'dd/mm/yyyy')
      and t.fk_msgaut <> 9
      and t.fk_cod_uni = '0001'
      and t.st_envio in ('1', '2', '3')
