--data da digitação da NF
select data_dig from esmovcad where cod_aux = '0066878'

--Data da digitação do Pedido de Compra
select data_dig from esmovcad where documento = '0066878' and tipo_documento = 'PED'

--Data do cadastro da cotação:
select min(pk_cotcad), data_cadastro from escotcad where cod_cot = '031832' group by data_cadastro

select a.data_cadastro, b.data_dig from escotcad a, esmovcad b
where a.cod_cot = b.cod_aux and b.documento = '0066878'

select a.data_dig from esmovcad a
where a.cod_aux in (select b.documento from esmovcad b where b.documento = '0066878')
