--select t.*, t.rowid from fafatprd t where t.fatura = 'C09246' and t.cod_prd = '001673'

select t.fatura, t.cod_prd, t.valor_tot, t.valor_honorario, t.valor_custo_oper, t.valor_pago, t.cod_pac, t.cod_pro,
t.numero_repasse repasse, t.rowid from fafatprd t where t.cod_prd in (select codigo from faprdcad where tipo_prd = 'PRO')
and t.valor_tot <> (round(t.valor_honorario,2)+round(t.valor_custo_oper,2))
and t.numero_repasse is null
