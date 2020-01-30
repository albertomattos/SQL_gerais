select decode(t.state,'8','Verifica��o','6','Execu��o (a executar)','7','Execu��o (em andamento)','5','Aprova��o','2',
'An�lise (aceita)','4','An�lise (em an�lise)','1','Cadastro','14','Revis�o') estagio,
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
--9: Arquivada, n�o efetiva
--10: Arquivada, efetiva
--11: Arquivada, ignorada
--12: Arquivada, encerrada
