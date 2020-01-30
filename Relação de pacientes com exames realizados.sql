SELECT fapaccad.tipo_pac, fapaccad.data_ent,
       faprdcad.descricao,
       fapaccad.hora_ent, fapaccad.data_alta,
       fapaccad.hora_alta, fapaccad.cod_pac,
       faprtcad.nome_pac,
       faprtcad.end_complemento,
       faprtcad.end_numero, faprtcad.celular,
       faprtcad.bai_res, faprtcad.cep_res,
       faprtcad.cid_res, faprtcad.dsc_email,
       faprtcad.end_res, faprtcad.est_res,
       faprtcad.fone_res, faprtcad.pais_res,
       faconcad.fantasia, faprtcad.sexo,
       decode(tipo_pac,'A','mbulatório','I','nterno','E','xterno','U','rgência') decode_tipo_pac
FROM fapaccad fapaccad, faprtcad faprtcad
     , faprdcad faprdcad, imagnexa imagnexa
     , faprocad faprocad, faconcad faconcad
     , faalacad faalacad, faplacad faplacad
WHERE (faprtcad.cod_prt = fapaccad.cod_prt) AND
      (faprocad.cod_pro = fapaccad.cod_pro) AND
      (faconcad.cod_con = fapaccad.cod_con) AND
      (faalacad.cod_ala = fapaccad.cod_ala) AND
      (faplacad.cod_con = fapaccad.cod_con)
       AND (faplacad.cod_pla = fapaccad.cod_pla)
       AND (
      ( fapaccad.data_ent BETWEEN '01/11/2005' AND '01/11/2005' )
       AND ( fapaccad.tipo_pac IN ('A') ))
       AND (fapaccad.cod_pac = imagnexa.cod_pac)
       AND (imagnexa.cod_prd = faprdcad.codigo)
ORDER BY faprtcad.nome_pac, fapaccad.data_ent
