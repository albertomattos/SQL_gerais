select decode(t.state,'8','Verificação','6','Execução (a executar)','7','Execução (em andamento)','5','Aprovação','2',
'Análise (aceita)','4','Análise (em análise)','1','Cadastro','14','Revisão') estagio,
t.title, t.serial, a.name,
case t.state
when 2 then
  case when t.dt_analyse_due < sysdate-1 then 'Atrasado' end
when 4 then
  case when t.dt_analyse_due < sysdate-1 then 'Atrasado' end
when 5 then
  case when t.dt_approve_due < sysdate-1 then 'Atrasado' end
when 6 then
  case when t.dt_execute_due < sysdate-1 then 'Atrasado' end
when 7 then
  case when t.dt_execute_due < sysdate-1 then 'Atrasado' end
end status
from qms_occurrences t, cmn_users a where t.ref_owner = a.id
and t.ref_category in ('1','5') and t.state in ('2','4','5','6','7')
order by 4,3
--1: Cadastro
--9: Arquivada, não efetiva
--10: Arquivada, efetiva
--11: Arquivada, ignorada
--12: Arquivada, encerrada
