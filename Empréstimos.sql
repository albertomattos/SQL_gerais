select valor_tot from esmovite where tipo_documento = "EMP" and documento in(
	select documento from esmovcad where data_mov between "01/09/2008" and "30/09/2008" and cred_deb = "D")
and cod_prd in (
	select codigo from faprdcad where tipo_prd = "MED" and cod_gcn = "411010007")

select * from esmovcad where tipo_documento = "EMP"

SELECT esmovite.valor_tot
FROM esmovite esmovite, esmovcad esmovcad
     , faprdcad faprdcad
WHERE (esmovcad.documento = esmovite.documento)
       AND (esmovcad.tipo_documento = esmovite.tipo_documento)
       AND (faprdcad.codigo = esmovite.cod_prd)
       AND (
      ( esmovcad.data_mov BETWEEN '01/09/2008' AND '30/09/2008' )
       AND ( esmovite.tipo_documento = 'EMP' )
       AND ( faprdcad.tipo_prd = 'MED' ))

select valor_tot from esmovite, esmovcad where esmovite.documento = esmovcad.documento
and esmovite.tipo_documento = esmovcad.tipo_documento
and esmovite.tipo_documento = "EMP" and esmovcad.data_mov between "01/09/2008" and "30/09/2008"
and cod_prd in (select codigo from faprdcad where tipo_prd = "MED" and cod_gcn = "411010007")
and esmovcad.cred_deb = "D"

