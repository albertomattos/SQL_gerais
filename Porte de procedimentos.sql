select t.*, t.rowid from preco_porte_ger t where t.tipo_prd in ('END','EXA','FIS','LAB','MEN','PRO','RAD','RAT','REM','TOM','USG','VIS')
and t.validade = '01/04/2017'
and t.fk_apetab in (select u.pk_apetab from faapetab u where u.tabela = '85' and
u.tipo_prd in ('END','EXA','FIS','LAB','MEN','PRO','RAD','RAT','REM','TOM','USG','VIS'))
order by 4
/*
select max(pk_prepger) from preco_porte_ger
select u.* from faapetab u where u.tabela = '94'

select u.*, U.ROWID from faapetab u where u.tabela = '77'

select t.*, t.rowid from preco_porte_ger t where t.tipo_prd in ('LAB')
and t.validade = '01/01/2017'
and t.fk_apetab in (select u.pk_apetab from faapetab u where u.tabela = '77' and
u.tipo_prd in ('LAB'))
--u.tipo_prd in ('PRO','FIS','VIS'))

select * from faapetab where tabela = '52' and tipo_prd in ('END','EXA','LAB','MEN','RAD','RAT','REM','TOM','USG')
select * from faapetab where tabela = '04' and tipo_prd in ('FIS')

/*
select t.*, t.rowid from preco_porte_ger t where t.tipo_prd in ('PRO')
and t.validade = '01/01/2015'
and t.fk_apetab in (select u.pk_apetab from faapetab u where u.tabela = '85'
and u.tipo_prd in ('PRO'))


select max(t.pk_prepger) from preco_porte_ger t where t.tipo_prd = 'PRO' and t.validade = '01/01/2015'

select t.*, t.rowid from preco_porte_ger t where t.tipo_prd = 'PRO' and t.validade = '01/01/2015'
and t.fk_apetab = '3802'
and t.cod_porte = '13C'

select u.* from faapetab u where u.pk_apetab = '3016'

select t.*, t.rowid from preco_porte_ger t order by t.pk_prepger desc
select t.*, t.rowid from preco_porte_ger t  where t.fk_apetab = '3016' order by t.pk_prepger desc
*/
