select a.*, a.rowid from faccgcad a where a.tipo_prd = 'PRO' and a.cod_con = '051'
select a.cod_con, a.tipo_prd, a.tab_urg, a.rowid from faccgcad a where  a.tipo_prd in ('DES','MED','FNU','GMD','TAX','FIO','KIT') order by 3
select a.cod_con, A.COD_PLA, a.tipo_prd, a.tab_urg, a.rowid from faccgcad a where tipo_prd = 'KIT' and cod_con in ('014','015','017','048','058',
'034','070') order by 1,2

--update faccgcad set tab_int = "C00",tab_ext = "C99",tab_urg = "C99",tab_amb = "C00",acres_amb = 0.0
--where cod_con="121"-- or cod_con="071" or cod_con="073" or cod_con="114")-- or cod_con="063")
--where cod_con="005"-- or cod_con="075" or cod_con="077" or cod_con="105")
where tipo_prd = "TOM"
and cod_con = "360" and cod_pla = "06"-- or cod_con <> "079" or cod_con <> "080"
--or cod_con <> "042" or cod_con <> "044" cod_con <> "045" or cod_con <> "121"
--select * from faccgcad where tipo_prd = "FRI"
--and cod_pla = "20"
--select * from faccgcad where tab_int = "C02"--cod_con = "008"
--and tipo_prd = "FRI"
--select * from faprecad where tabela = "02"-- and codigo = "030336"
select * from faccgcad where cod_con = '073' and tipo_prd = 'PRO'
--select tabela, coef_honor, valor from faprecad where codigo = "006785" and validade = "01/05/2003" order by tabela
--select * from faprdcad

--delete from faprecad where (
--select f.codigo, f.tabela, p.descricao, p.tipo_prd
--from faprecad f, faprdcad p where f.tabela > "21" and f.codigo = p.codigo and p.tipo_prd = "DIA"--)
--order by tabela, codigo
--select * from faapetab--apelido das tabelas
--insert into faapetab values ('23','EXA','SULAM. CH:0,310');
--insert into faapetab values ('23','LAB','SULAM. CH:0,310');
--insert into faapetab values ('23','RAX','SULAM. CH:0,310');
--update faapetab set descricao = "SULAM. CH:0,310"
--where (tipo_prd = "LAB" or tipo_prd = "EXA" or tipo_prd = "RAX") AND TABELA > "23"

