select t.info, t.name, t.*, t.rowid from bsc_indicators t where t.family = '0' and t.monitor = '1'
and lower (t.name) like '%%glosa%'
/*
update bsc_indicators set info = 'A Pesquisa de Satisfação do paciente é uma amostragem com referência à percepção do paciente aos serviços oferecidos pela instituição.

É aplicado formulário diretamente ao paciente e disponilizado em locais estratégicos. Este formulario é recolhido e tabulado semanalmente.

Ao final do mês é realizado apresentação para os gestores com os resultados obtidos solicitando ações de melhoria.'
where family = '0' and monitor = '1' and lower (name) like 'psc%%'
*/
