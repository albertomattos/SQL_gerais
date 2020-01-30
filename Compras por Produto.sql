select distinct v.descricao,
(case  when t.data_emiss >= '01/01/2013' and t.data_emiss <= '31/01/2013' then '201301'
       when t.data_emiss >= '01/02/2013' and t.data_emiss <= '28/02/2013' then '201302'
       when t.data_emiss >= '01/03/2013' and t.data_emiss <= '31/03/2013' then '201303'
       when t.data_emiss >= '01/04/2013' and t.data_emiss <= '30/04/2013' then '201304'
       when t.data_emiss >= '01/05/2013' and t.data_emiss <= '31/05/2013' then '201305'
       when t.data_emiss >= '01/06/2013' and t.data_emiss <= '30/06/2013' then '201306'
       when t.data_emiss >= '01/07/2013' and t.data_emiss <= '31/07/2013' then '201307'
       when t.data_emiss >= '01/08/2013' and t.data_emiss <= '31/08/2013' then '201308'
       when t.data_emiss >= '01/09/2013' and t.data_emiss <= '30/09/2013' then '201309'
       when t.data_emiss >= '01/10/2013' and t.data_emiss <= '31/10/2013' then '201310'
 end) ano_mes,
sum (u.quant), round(sum(u.valor_tot),2) from esmovcad t, esmovite u, faprdcad v
where t.tipo_documento = u.tipo_documento and t.documento = u.documento
and u.cod_prd = v.codigo
and t.data_emiss between '01/08/2014' and '31/08/2014'
and u.tipo_documento = 'COM'
and v.codigo in ('215383','219455','135926','044642','214990','204030','216581','009132','001561','202521','205446','001560')
group by v.descricao, t.data_emiss
order by 1,2

