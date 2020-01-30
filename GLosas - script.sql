select (sum(distinct a.valor_guia - b.valor_pago))/sum(distinct a.valor_guia)*100 from fafatcad a, fafatpag b, famovcad c
where a.fatura = b.fatura and a.cod_pac = c.cod_pac and b.data_baixa >= '01/01/2018' and b.data_baixa <= '31/01/2018'
and b.origem <> 'G' and a.destino <> 'P'
and c.set_ori in ('0039','0067','0120','0149','0190','0258','0290','0291','0294','0295','0296','0305','0322','0343','0397')


select * from fafatprd where valor_pago <> 0

select t.*, t.rowid from fafatrea t
