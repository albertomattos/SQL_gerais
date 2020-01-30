select (sum(a.valor_guia - b.valor_pago))/sum(a.valor_guia)*100 from fafatcad a, fafatpag b
where a.fatura = b.fatura
and b.data_baixa between '01/01/2016' and '31/01/2016' and b.origem <> 'G'
and a.destino <> 'P'
