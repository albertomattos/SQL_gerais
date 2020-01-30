select t.*, t.rowid from crt_answers t where t.ref_certification = '9'/* and t.ref_application = '1839'*/
and t.ref_application in (select t.id from crt_applications t where t.ref_certification = '5' and t.ref_occurrence = '41')
--Busca pelo nome do paciente no select abaixo:
select t.ref_application, t.feedback from crt_answers t where t.ref_certification = '9' and t.ref_topic = '263'
and t.feedback like 'MARIA A%'
--Busca a ocorrência correta:
select t.*, t.rowid from crt_occurrences t where t.ref_certification = '9'--(5 é pesquisa, 9 é óbito)
--Coloca a referência da application no select abaixo e muda a competência e o ref_occurrence:
select t.*, t.rowid from crt_applications t where t.ref_certification = '9' t.id = '5456'

select a.*, a.rowid from crt_applications a where a.ref_occurrence = '41'

select t.*, t.rowid from crt_answers t where t.ref_application = '41'
