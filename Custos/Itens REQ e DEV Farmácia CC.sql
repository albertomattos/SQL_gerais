select :P_MES, :P_ITEM, e.codigo, count(*) from wpd.esmovite@prod a, wpd.esmovcad@prod b, usr_nci.vec_ccus e
where a.tipo_documento = b.tipo_documento and a.documento = b.documento and b.set_con = e.cod_cliente
and a.tipo_documento = 'REQ'
and b.data_mov between :P_DATA_INICIAL and :P_DATA_FINAL
and b.set_est = '0158'
group by e.codigo

select e.codigo, count(*) from wpd.esmovite@prod a, wpd.esmovcad@prod b, usr_nci.vec_ccus e
where a.tipo_documento = b.tipo_documento and a.documento = b.documento and b.set_con = e.cod_cliente
and a.tipo_documento = 'REQ'
and b.data_mov between '01/01/2013' and '31/01/2013'
and b.set_est = '0158'
group by e.codigo
