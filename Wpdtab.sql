select t.cod_parametro, t.descricao, t.valor, t.sistemas, t.rowid from wpdtab t where upper(descricao) like '%CUSTO%M%'
/*select t.*, t.rowid from wpdtab t where sistemas like '%BLO%'
select t.*, t.rowid from wpdtab t where cod_parametro like '%limite_atu%'
select t.*, t.rowid from fatipcad t
select * from wpdtab order by cod_parametro
select * from fatab*/
--select * from wpdtab where upper(valor) like '%0166%'
/*update wpdtab set valor = 'N' where cod_parametro = 'abrir_mesmo_sist_n_vezes'
update wpdtab set valor = 'S' where cod_parametro = 'usa_limpeza_leito'
update wpdtab set sistemas = 'POS' where cod_parametro = 'intervalo_atualiz_presc'*/

--Altera tipo de produto:
--update wpdtab set valor = 'S' where cod_parametro = 'muda_tipo_produto';
--commit;
--update wpdtab set valor = 'N' where cod_parametro = 'muda_tipo_produto';
--commit;
--select descricao, tipo_prd, bloqueado from faprdcad where descricao like 'TON%'
--update faprdcad set tipo_prd = 'ESC' where descricao like 'TON%' and tipo_prd = 'STI'
--select * from passo_executado
