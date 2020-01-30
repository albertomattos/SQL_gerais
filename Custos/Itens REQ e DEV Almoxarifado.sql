select count(a.quant) from esmovite a, esmovcad b
where a.tipo_documento = b.tipo_documento and a.documento = b.documento
and a.tipo_documento = 'REQ'
and data_mov between '01/01/2013' and '31/01/2013'
and set_est in ('0302','0445')
