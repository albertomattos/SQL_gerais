select :P_MES, :P_ITEM, d.codigo, count(*) from wpd.famovprd@prod a, wpd.faprdcad@prod b, wpd.famovcad@prod c, usr_nci.vec_ccus d
where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.set_ori = d.cod_cliente
and c.data_mov between :P_DATA_INICIAL and :P_DATA_FINAL
and c.set_ori = '0376'
and b.tipo_prd in ('LAB', 'MEN', 'EXA')
group by d.codigo

select count(*), c.data_mov from wpd.famovprd@prod a, wpd.faprdcad@prod b, wpd.famovcad@prod c, usr_nci.vec_ccus d
where a.codigo = b.codigo
and a.comanda = c.comanda and a.tipo_comanda = c.tipo_comanda
and c.set_ori = d.cod_cliente
and c.data_mov between '01/01/2015' and '31/01/2015'
and c.set_ori = '0376'
and b.tipo_prd in ('LAB', 'MEN')
group by c.data_mov
