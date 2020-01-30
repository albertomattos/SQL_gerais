SELECT protocolo.DAT_REMESSA, to_date(sysdate,'DD/MM/YY'), fadocumentos.DOCUMENTO, fafatcad.VALOR_TOT, faconcad.FANTASIA,
       fasetcad.DESCRICAO, protocolo.COD_PROTOCOLO, protocolo.COD_SETOR_DESTINO, item_protocolo.DAT_RECEBIMENTO,
       fapaccad.DATA_ALTA, fasetcad2.descricao
       
FROM PROTOCOLO protocolo, ITEM_PROTOCOLO item_protocolo, FADOCUMENTOS fadocumentos, FAFATCAD fafatcad, FACONCAD faconcad,
     FASETCAD fasetcad, FAPACCAD fapaccad, fasetcad fasetcad2

WHERE     item_protocolo.COD_PROTOCOLO = protocolo.COD_PROTOCOLO
      AND fadocumentos.SEQUENCIAL = item_protocolo.SEQUENCIAL
      AND fafatcad.FATURA = fadocumentos.DOCUMENTO
      AND faconcad.COD_CON = fafatcad.COD_CON
      AND fasetcad.COD_SET = protocolo.COD_SETOR_REMESA
      and protocolo.COD_SETOR_DESTINO = fasetcad2.cod_set
      AND fapaccad.COD_PAC = FAFATCAD.COD_PAC
      AND fafatcad.REMESSA IS NULL
      AND fapaccad.TIPO_PAC <> 'I'
and faconcad.cod_con not in ('001','002','083')
      AND item_protocolo.DAT_RECEBIMENTO IS NOT NULL
      and fapaccad.data_alta between '01/01/2015' and '18/11/2015'
      and protocolo.DAT_REMESSA = (SELECT distinct(max (protocolo2.DAT_REMESSA))
       
                                    FROM PROTOCOLO protocolo2, ITEM_PROTOCOLO item_protocolo2, FADOCUMENTOS fadocumentos2, FAFATCAD fafatcad2, FACONCAD faconcad2,
                                         FASETCAD fasetcad2, FAPACCAD fapaccad2

                                    WHERE     

                                          protocolo2.cod_protocolo = item_protocolo2.cod_protocolo
                                          and item_protocolo2.sequencial = fadocumentos2.sequencial
                                          and fafatcad2.FATURA = fadocumentos2.DOCUMENTO
                                          and fapaccad2.COD_PAC = FAFATCAD2.COD_PAC
                                          and fafatcad2.REMESSA IS NULL
                                          and fapaccad2.TIPO_PAC <> 'I'
                                          and item_protocolo2.DAT_RECEBIMENTO IS NOT NULL
                                          and fadocumentos2.DOCUMENTO = fadocumentos.DOCUMENTO
                                        ) 
      
ORDER BY fasetcad2.descricao, faconcad.FANTASIA, fadocumentos.DOCUMENTO, protocolo.DAT_REMESSA
