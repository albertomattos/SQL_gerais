--Exames vindos do PS:
select c.data_mov, count(*) qtde from famovprd a, faprdcad b, famovcad c, fapaccad d where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.cod_pac = d.cod_pac
and b.codigo = a.codigo
--and c.data_mov = '02/04/2012'
and c.data_mov between '01/05/2012' and '31/05/2012'
and b.tipo_prd = 'USG'
--and b.tipo_prd in ('RAD', 'REM', 'USG', 'TOM', 'END')
--and b.cod_gru not in ('DENS','MAMO')
and d.tipo_pac = 'U'
group by c.data_mov
order by c.data_mov
