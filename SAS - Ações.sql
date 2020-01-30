select v.title plano_de_acao, t.title acao, decode(t.state,0,'Não iniciado',1,'Em andamento',2,'Concluido',3,'Suspenso',4,'Verificado')
status, u.name gestor, t.estim_start_date inicio_estimado, t.estim_end_date fim_estimado, t.real_start_date inicio_real,
t.real_end_date fim_real, t.progress progresso
from bsc_iniciatives t, cmn_users u, bsc_actionplans v
where t.ref_owner = u.id and t.ref_actionplan = v.id
and t.progress <> '100' and t.state <> '3'
--and t.ref_actionplan = '141041'
--select * from bsc_iniciatives
--0 - Não iniciado, 1 - Em andamento, 2 - Concluído, 3 - Suspenso, 4 - Verificado
