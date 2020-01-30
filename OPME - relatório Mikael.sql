select * from
  ( SELECT distinct ESMOVITE.FK_DOC_PED_CONS, faprtcad.nome_pac, fapaccad.cod_pac, fapaccad.data_ent, fapaccad.data_alta, fafatcad.fatura
  FROM ESMOVITE, ESMOVCAD, FAPACCAD, FAPRTCAD, fafatcad
  WHERE ESMOVITE.DOCUMENTO = ESMOVCAD.DOCUMENTO AND ESMOVITE.TIPO_DOCUMENTO = ESMOVCAD.TIPO_DOCUMENTO
  AND ESMOVCAD.COD_PAC = FAPACCAD.COD_PAC AND FAPACCAD.COD_PRT = FAPRTCAD.COD_PRT and fapaccad.cod_pac = fafatcad.cod_pac
  and (esmovite.fk_doc_ped_cons is not null)
  and esmovcad.data_mov between '01/01/2017' and '30/09/2017' ) a,

  ( select esmovcad.nota, esmovcad.data_emiss, esmovcad.COD_AUX, esforcad.fantasia from esmovcad, esforcad where esmovcad.cod_for = esforcad.cod_for
  and tipo_documento = 'COM' and cod_aux in (
  SELECT ESMOVITE.FK_DOC_PED_CONS
  FROM ESMOVITE, ESMOVCAD, FAPACCAD, FAPRTCAD
  WHERE ESMOVITE.DOCUMENTO = ESMOVCAD.DOCUMENTO AND ESMOVITE.TIPO_DOCUMENTO = ESMOVCAD.TIPO_DOCUMENTO
  AND ESMOVCAD.COD_PAC = FAPACCAD.COD_PAC AND FAPACCAD.COD_PRT = FAPRTCAD.COD_PRT
  and (esmovite.fk_doc_ped_cons is not null)
  and esmovcad.data_mov between '01/01/2017' and '30/09/2017') ) b
  where a.FK_DOC_PED_CONS = b.COD_AUX
