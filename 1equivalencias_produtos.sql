-- Este script cria a tabela de relacionamento EQUIVALENCIA e PRODUTO "faecpcad"
-- A equivalencia é feita com base no campo COD_AMB do cadastro de Produtos e um
-- arquivo de Texto com a relacao AMB e CBHPM
-- PS. Arquivo no formato texto com os campos Cod.AMB e Cod.CBHPM
-- Instrucoes:
-- 1) Alterar o codigo do Convenio Desejado  no item 3:

-- 1. Cria tabela temporaria de Relacao AMB x CBHPM
create temp table tmp_cbhpm (
cod_equ char(11) , cod_amb char(8));

-- 2. Carrega Relacao na tabela temporaria
load from "(Nome do arquivo com o de para da CBHPM x AMBamb92)" delimiter ";"
insert into tmp_cbhpm;

-- 3. Gera equivalencia em tabela temporaria 
select 
-- Substituir Convenio:
"999" as cod_con, 
t2. cod_equ, t1.codigo, "" as tipo_set, "" as tipo_equ
from faprdcad t1, tmp_cbhpm t2 where t1.cod_amb=t2.cod_amb and
t1.codigo not in (select tx.codigo from faecpcad tx where 
-- Substituir Convenio:
tx.cod_con="999" and tx.tipo_equ="")
group by 1,2,3,4,5
into temp tmp_equiv;


-- 4. Seleciona quantidade de Produtos
select codigo, count(*) as quant from tmp_equiv
group by 1 into temp tmp_duplos;

-- 5. Remove os produtos que não estao duplicados da tmp_duplos
delete from tmp_duplos where quant=1;

-- 6. Lista para arquivo os produtos que não serao relacionados (duplos)
unload to "duplos.txt"
select t1.codigo, t1.quant, t2. descricao from tmp_duplos t1, faprdcad t2
where t1.codigo=t2.codigo;

-- 7. Remove os itens duplos da tabela temporaria de atualizacao
delete from tmp_equiv where codigo in (select codigo from tmp_duplos);

-- 8. Carrega equivalencia na tabela definitiva
insert into faecpcad (cod_con, cod_equ, codigo, tipo_set, tipo_equ)
select cod_con, cod_equ, codigo, tipo_set, tipo_equ from tmp_equiv;

-- 9. Lista os produtos (faprdcad) com codigos amb que nao tiveram  relacao cbhpm (Depende de ser rodado o item 1 e 2)
unload to "prd_sem_cbhpm.txt"
select codigo, descricao, cod_amb from faprdcad
where cod_amb not in (select cod_amb from tmp_cbhpm)