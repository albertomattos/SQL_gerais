----- Itens baixados por CC
/*select t.cod_set, count(t.cod_set) from quitacao_produto t where t.data_baixa between '01/07/2012' and '31/07/2012'
and t.cod_fatura in (select fatura from fafatpag where quit_disc = 'S')
group by t.cod_set
order by t.cod_set

----- Faturas baixadas por CC
select distinct b.cod_set, count(b.cod_set) from fafatcad a, fapaccom b
where a.cod_pac = b.cod_pac
and a.fatura in (select fatura from fafatpag where quit_disc = 'N')
and a.data_baixa between '01/07/2012' and '31/07/2012'
group by b.cod_set
*/
select b.* from fafatcad a, fapaccom b
where a.cod_pac = b.cod_pac
and a.fatura in (select fatura from fafatpag where quit_disc = 'N')
and a.data_baixa between '01/07/2012' and '31/07/2012'
and b.cod_set = '0168'
order by b.cod_set
