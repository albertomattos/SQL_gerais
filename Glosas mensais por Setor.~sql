select (sum(distinct a.valor_guia - b.valor_pago))/sum(distinct a.valor_guia)*100 from fafatcad a, fafatpag b, famovcad c
where a.fatura = b.fatura and a.cod_pac = c.cod_pac
and b.data_baixa between '01/03/2017' and '31/03/2017' and b.origem <> 'G'
and a.destino <> 'P'
and c.set_ori = '0124'

select distinct a.fatura, b.data_baixa, a.valor_guia, b.valor_pago from fafatcad a, fafatpag b, famovcad c
where a.fatura = b.fatura and a.cod_pac = c.cod_pac
and b.data_baixa between '01/01/2016' and '30/04/2017' and b.origem <> 'G'
and a.destino <> 'P'
and c.set_ori = '0124'

---------Pré-glosa
/*select distinct round((a.total_glosa+a.total_taxa)/b.total_fatura,4)*100 pre_glosa from
(select nvl(sum(pg.valor_tot),0) total_glosa, nvl(sum(pgt.valor_tot),0) total_taxa, pg.cod_set setor from pre_glosa_produto pg inner join
(select distinct fprd.fatura fatura from fafatprd fprd inner join fafatcad fcad on fcad.fatura = fprd.fatura
where fcad.data_emiss >= '01/01/2017' and fcad.data_emiss <= '31/01/2017') f on f.fatura = pg.cod_fatura
        left outer join pre_glosa_taxa pgt on pgt.cod_fatura = f.fatura
group by pg.cod_set)a,
(select distinct sum(fprd.valor_tot) total_fatura, fprd.cod_set setor from fafatprd fprd inner join fafatcad fcad on fcad.fatura = fprd.fatura
        where fcad.data_emiss >= '01/01/2017' and fcad.data_emiss <= '31/01/2017' group by fprd.cod_set) b, fasetcad fset
where fset.cod_set = a.setor and fset.cod_set = b.setor
and a.setor = '0135'
*/
