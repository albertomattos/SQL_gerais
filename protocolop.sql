SELECT c.cod_protocolo, c.dat_remessa, b.documento, b.cod_tipo_documento, b.cod_pac, g.nome_pac, a.dsc_complemento, d.descricao,
 e.nome, a.dat_recebimento
FROM item_protocolo a, fadocumentos b, protocolo c, fasetcad d, fausucad e, fapaccad f, faprtcad g
WHERE b.sequencial = a.sequencial
AND c.cod_protocolo = a.cod_protocolo AND d.cod_set = c.cod_setor_remesa AND e.matricula = a.cod_usuario_receb
AND f.cod_pac = b.cod_pac AND g.cod_prt = f.cod_prt AND d.cod_set = c.cod_setor_destino
AND e.matricula = c.nom_usuario_remet AND c.DAT_REMESSA BETWEEN '20/02/2012' AND '28/02/2012'
AND c.COD_SETOR_REMESA = '0174'
ORDER BY c.dat_remessa
select * from fadocumentos
select * from item_protocolo
