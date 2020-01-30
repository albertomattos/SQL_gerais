select distinct round(avg((a.total_glosa+a.total_taxa)/b.total_fatura*100),2) pre_glosa from
(select nvl(sum(pg.valor_tot),0) total_glosa, nvl(sum(pgt.valor_tot),0) total_taxa, pg.cod_set setor from pre_glosa_produto pg inner join
(select distinct fprd.fatura fatura from fafatprd fprd inner join fafatcad fcad on fcad.fatura = fprd.fatura
        where fcad.data_emiss between '01/01/2016' and '31/01/2016') f on f.fatura = pg.cod_fatura
        left outer join pre_glosa_taxa pgt on pgt.cod_fatura = f.fatura
group by pg.cod_set)a,
(select distinct sum(fprd.valor_tot) total_fatura, fprd.cod_set setor from fafatprd fprd inner join fafatcad fcad on fcad.fatura = fprd.fatura
        where fcad.data_emiss between '01/01/2016' and '31/01/2016' group by fprd.cod_set) b, fasetcad fset
where fset.cod_set = a.setor and fset.cod_set = b.setor
and a.setor in ('0006','0104','0130','0132','0133','0134','0191','0453')

select distinct fset.descricao, a.total_glosa, a.total_taxa , b.total_fatura, round((a.total_glosa+a.total_taxa)/b.total_fatura,4)*100 pre_glosa from
(select nvl(sum(pg.valor_tot),0) total_glosa, nvl(sum(pgt.valor_tot),0) total_taxa, pg.cod_set setor from pre_glosa_produto pg inner join
(select distinct fprd.fatura fatura from fafatprd fprd inner join fafatcad fcad on fcad.fatura = fprd.fatura
        where fcad.data_emiss between '01/01/2015' and '31/01/2015') f on f.fatura = pg.cod_fatura
        left outer join pre_glosa_taxa pgt on pgt.cod_fatura = f.fatura
group by pg.cod_set)a,
(select distinct sum(fprd.valor_tot) total_fatura, fprd.cod_set setor from fafatprd fprd inner join fafatcad fcad on fcad.fatura = fprd.fatura
        where fcad.data_emiss between '01/01/2015' and '31/01/2015' group by fprd.cod_set) b, fasetcad fset
where fset.cod_set = a.setor and fset.cod_set = b.setor
and a.setor in ('0006','0104','0130','0132','0133','0134','0191','0453')

------
select sum(valor_tot) from fafatprd where fatura in (select fatura from fafatcad where data_emiss between '01/01/2016' and '31/01/2016')
and cod_set = '0124'

select sum(valor_tot) from pre_glosa_produto where cod_fatura in (select fatura from fafatcad where data_emiss between '01/01/2016' and '31/01/2016')
and cod_set = '0124'

select * from pre_glosa_taxa where cod_fatura in (select fatura from fafatcad where data_emiss between '01/01/2016' and '31/01/2016')
and set = '0125'
