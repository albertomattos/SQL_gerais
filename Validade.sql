--select * from faprdcad
--select * from faprecad where tabela > 22 and validade = "01/05/2003"
select a.*, a.rowid from fatippre a where a.validade = '01/01/2015'
and a.tipo_prd = 'FIS'
--order by validade
--select faprdcad.codigo, faprdcad.descricao, faprdcad.tipo_prd, faprecad.tabela, faprecad.validade, faprecad.valor
select faprecad.*, faprecad.rowid
--delete from faprecad, faprdcad --where tabela > "22" and validade = "01/01/1980"
from faprdcad, faprecad
where faprdcad.codigo = faprecad.codigo and faprecad.tabela = 30 and faprecad.validade = '01/01/2015'
--where faprdcad.codigo = faprecad.codigo and faprdcad.tipo_prd = 'PRO' and faprecad.validade = '01/01/2014'
--order by faprecad.tabela
--select t.*, t.rowid from faprecad t where t.validade = '01/01/2014'
--select t.*, t.rowid from fatippre t where t.tipo_prd = 'DES'
--select t.*, t.rowid from processamento t
--select t.*, t.rowid from preco_porte_ger t where t.validade = '01/01/2015'
