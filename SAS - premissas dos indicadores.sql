select t.info, t.name, t.*, t.rowid from bsc_indicators t where t.family = '0' and t.monitor = '1'
and lower (t.name) like '%%glosa%'
/*
update bsc_indicators set info = 'A Pesquisa de Satisfa��o do paciente � uma amostragem com refer�ncia � percep��o do paciente aos servi�os oferecidos pela institui��o.

� aplicado formul�rio diretamente ao paciente e disponilizado em locais estrat�gicos. Este formulario � recolhido e tabulado semanalmente.

Ao final do m�s � realizado apresenta��o para os gestores com os resultados obtidos solicitando a��es de melhoria.'
where family = '0' and monitor = '1' and lower (name) like 'psc%%'
*/
