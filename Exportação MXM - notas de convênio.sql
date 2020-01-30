SELECT nota_fatura.nota_fiscal,nota_fatura.serie,nota_fatura.fatura,faprdcad.tipo_prd,fafatcad.destino,
fanotcad.valor_tot,fafatcad.valor_guia,
nota_fatura.valor,nota_fatura.valor/fafatcad.valor_tot,
sum(fafatprd.valor_tot - fafatprd.valor_desconto),
sum((fafatprd.valor_tot - fafatprd.valor_desconto) * nota_fatura.valor/fafatcad.valor_tot)
FROM fanotcad, nota_fatura, fafatcad, fafatprd, faprdcad
WHERE nota_fatura.fatura = fafatprd.fatura
AND nota_fatura.fatura = fafatcad.fatura
AND faprdcad.codigo=fafatprd.cod_prd
AND fanotcad.tipo_nota = 'R'
AND fanotcad.cancelada = 'N'
AND fafatprd.tipo_pgto <> 'D'
AND nota_fatura.nota_fiscal=fanotcad.nota_fiscal
AND nota_fatura.serie=fanotcad.serie
AND fanotcad.data_emiss >="16/05/2008"
AND fanotcad.data_emiss <="16/05/2008"
GROUP BY 1,2,3,4,5,6,7,8,9
ORDER BY 1
