select t.*, t.rowid from qms_occurrences t where t.serial like '252891%'/*
select t.*, t.rowid from qms_events t where t.ref_occurrence = '242281'

select t.state, t.archived, t.title, t.serial, t.*, t.rowid from qms_occurrences t where t.state in ('11','12')--Arquivadas
select t.state, t.archived, t.title, t.serial, t.*, t.rowid from qms_occurrences t where t.ref_category <> '9' and t.state = '8' --Verificação
select t.state, t.archived, t.title, t.serial, t.*, t.rowid from qms_occurrences t where t.ref_category <> '9' and t.state in ('6','7') --Execução
select t.state, t.archived, t.title, t.serial, t.*, t.rowid from qms_occurrences t where t.ref_category <> '9' and t.state in ('5') --Aprovação
select t.state, t.archived, t.title, t.serial, t.*, t.rowid from qms_occurrences t where t.ref_category <> '9' and t.state in ('2','4') --Análise
select t.state, t.archived, t.title, t.serial, t.*, t.rowid from qms_occurrences t where t.ref_category <> '9' and t.state in ('1') --Cadastro
select t.state, t.archived, t.title, t.serial, t.*, t.rowid from qms_occurrences t where t.ref_category <> '9' and t.state in ('14') --Revisão
select t.state, t.archived, t.title, t.serial, t.*, t.rowid from qms_occurrences t where t.ref_category = '9'--TI
*/
