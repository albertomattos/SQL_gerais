SELECT distinct ESMOVITE.FK_DOC_PED_CONS, faprtcad.nome_pac, fapaccad.cod_pac, fapaccad.data_ent, fapaccad.data_alta
FROM ESMOVITE, ESMOVCAD, FAPACCAD, FAPRTCAD
WHERE ESMOVITE.DOCUMENTO = ESMOVCAD.DOCUMENTO AND ESMOVITE.TIPO_DOCUMENTO = ESMOVCAD.TIPO_DOCUMENTO
AND ESMOVCAD.COD_PAC = FAPACCAD.COD_PAC AND FAPACCAD.COD_PRT = FAPRTCAD.COD_PRT
and (esmovite.fk_doc_ped_cons is not null)
and esmovcad.data_mov between '06/01/2017' and '06/01/2017'


select * from esmovcad, esforcad where esmovcad.cod_for = esforcad.cod_for
and tipo_documento = 'COM' and cod_aux in (
SELECT ESMOVITE.FK_DOC_PED_CONS
FROM ESMOVITE, ESMOVCAD, FAPACCAD, FAPRTCAD
WHERE ESMOVITE.DOCUMENTO = ESMOVCAD.DOCUMENTO AND ESMOVITE.TIPO_DOCUMENTO = ESMOVCAD.TIPO_DOCUMENTO
AND ESMOVCAD.COD_PAC = FAPACCAD.COD_PAC AND FAPACCAD.COD_PRT = FAPRTCAD.COD_PRT
and (esmovite.fk_doc_ped_cons is not null)
and esmovcad.data_mov between '06/01/2017' and '06/01/2017')
