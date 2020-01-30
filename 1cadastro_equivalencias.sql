-- Este script carrega o cadastro de equivalencias da "faequcad" da tabela CBHPM
-- É removido do cadastro de equivalencias os códigos CBHPM ja cadastrados para não ocorrer erros na importacao
-- Instrucoes:
-- 1) Alterar o codigo do Convenio Desejado nos itens 3 e 4:

-- 1. Cria tabela temporaria para carga do Cadastro
select * from faequcad
where 1<>1 into temp t1;

-- 2. Carrega arquivo da CBHPM na tabela temporaria
delete from t1 where 1=1;
load from "(nome do arquivo contendo código e descrição CBHPM)" delimiter ";"
insert into t1;

-- 3. Lista os itens que serão excluído da Equivalencia
unload to "equv_excluida.txt"
select * from faequcad
where cod_equ in (select cod_equ from t1)
-- Substituir o Convenio:
and cod_con="999";

-- 4. Exclui os itens ja cadastrados em Equivalencia
delete from faequcad
where cod_equ in (select cod_equ from t1)
-- Substituir o Convenio:
and cod_con="999";

-- 5. Atualiza descricao para Maiusculo
update t1 set descricao = upper (descricao) where 1=1;

-- 6. Carrega Cadastro na Tabela faequcad
insert into faequcad select * from t1;