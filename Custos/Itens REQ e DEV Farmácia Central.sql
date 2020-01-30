select :P_MES, :P_ITEM, e.codigo, sum(a.quant) from wpd.esmovite@prod a, wpd.esmovcad@prod b, usr_nci.vec_ccus e
where a.tipo_documento = b.tipo_documento and a.documento = b.documento and b.set_con = e.cod_cliente
and a.tipo_documento = 'REQ'
and b.data_mov between :P_DATA_INICIAL and :P_DATA_FINAL
and b.set_est in ('0302','0445')
group by e.codigo

select e.codigo, count(*) from wpd.esmovite@prod a, wpd.esmovcad@prod b, usr_nci.vec_ccus e
where a.tipo_documento = b.tipo_documento and a.documento = b.documento and b.set_con = e.cod_cliente
and a.tipo_documento = 'REQ'
and b.data_mov between '01/01/2013' and '31/01/2013'
and b.set_est = '0155'
group by e.codigo
