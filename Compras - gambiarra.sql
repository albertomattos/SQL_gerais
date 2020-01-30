--Verificar os produtos referentes ao pedido de compras e somar as quantidades
select t.nota, t.cod_prd, t.quant, t.valor_tot, u.desc_ger_val, t.rowid from esmovite t, esmovcad u where
t.tipo_documento = u.tipo_documento and t.documento = u.documento
and u.tipo_documento = 'COM' and u.cod_aux = '0051726'
order by 1

--O total das quantidades acima, preencher na tabela abaixo
select t.cod_prd, t.qtd_atendida, t.valor_tot, t.rowid from esmovite t
where t.documento = '0051726' and t.tipo_documento = 'PED' order by 1

/*

select t.*, t.rowid from esmovite t where-- t.documento = '0042367'
t.tipo_documento = 'COM' and t.documento in (
select documento from esmovcad where cod_aux = '0042366' and tipo_documento = 'COM')
and t.cod_prd = '213065'
*/
