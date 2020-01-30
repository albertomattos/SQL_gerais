select t.*, t.rowid from faconaut t where cod_con in ('014','015','017','048','058','034','070','007')
--select t.*, t.rowid from faconaut t where cod_con in ('070')
and cod_ala = 'PSPE' and t.cod_prd = '000006'
--update faconaut set cod_prd = '000002' where cod_con in ('010','127','014','015','066','016','019','041') and cod_ala = 'PEDI'

--update faconaut set setor_comanda = "0032" where setor_comanda = "0025"
--select max(chave) from faconaut order by chave
--insert into faconaut values ('127','01','U','013085','URGE','0104','07','100','305','')
/*insert into faconaut values ('127','01','I','007977','POST','0032','','','306','')

select r.*, r.rowid from faconaut r where r.tipo_pac = 'U' order by 1,2
*/
