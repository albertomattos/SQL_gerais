select faprdcad.tipo_prd, round(sum(esmovite.valor_tot),2)
from faprdcad, esmovcad, esmovite
where esmovcad.documento = esmovite.documento
and esmovcad.tipo_documento = esmovite.tipo_documento
and esmovite.cod_prd = faprdcad.codigo
and esmovcad.tipo_documento = 'REQ'
and esmovcad.cod_pac is not null
and esmovcad.data_mov between '01/10/2016' and '15/10/2016'
and faprdcad.tipo_prd in ('MED')
and esmovcad.cred_deb = 'C'
group by faprdcad.tipo_prd
order by faprdcad.tipo_prd
