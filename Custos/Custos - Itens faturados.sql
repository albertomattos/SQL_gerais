select distinct a.cod_set, count(a.cod_set) from fafatprd a, fafatcad b
where a.fatura = b.fatura
and b.data_emiss between '01/07/2012' and '31/07/2012'
group by a.cod_set
order by a.cod_set
