select b.tipo_prd, sum(a.valor_tot) from fafatprd a, faprdcad b where a.cod_prd = b.codigo
and a.fatura = '166028' AND COD_SET = '0124'
group by b.tipo_prd
order by b.tipo_prd
