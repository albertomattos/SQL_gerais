'Copia os códigos para uma planilha'
select codigo, cod_cbhpm, tipo_prd from faprdcad t where cod_cbhpm is not null and bloqueado = 'N' order by codigo

'Abre a tabela de apelidos para adicionar a nova tabela'
select t.*, t.rowid from faapetab t where tabela = '15'

'Abre a tabela de preços'
select t.*, t.rowid from faprecad t where tabela = '09' and t.validade = '01/10/2017'
and t.codigo in (select codigo from faprdcad where bloqueado = 'N' and tipo_prd in (
select tipo_prd from fatipcad where pre_class in ('HON','EXA')))

'Insere preço dos portes CBHPM, linkados com a tabela de apelidos'
select t.*, t.rowid from preco_porte_ger t where fk_apetab in (select pk_apetab from faapetab where tabela = '99') order by valor

select t.*, t.rowid from faprecad t where tabela = '15' and t.validade = '23/08/2017' and t.codigo = '005304'
select codigo, tipo_prd from faprdcad where tipo_prd in (select tipo_prd from fatipcad where pre_class = 'DTX')
