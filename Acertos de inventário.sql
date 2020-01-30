select t.cod_prd, t.quant, u.cred_deb from esmovite t, esmovcad u where t.tipo_documento = u.tipo_documento
and t.documento = u.documento
and t.tipo_documento = 'ACE'
and u.cod_mot = '100'
order by cod_prd
