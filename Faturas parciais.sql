SELECT * FROM hs_parcialpacientes
WHERE cod_con not in ('001','004')
AND diasfat >=4
or (cod_con in ('001','004') AND diasfat >=6)
or (today-data_ent=3 AND hora_ent < '06:00')
ORDER BY cod_set, nome_pac


SELECT cod_pac, NVL (data_alta, 'Sem Alta') AS alta
   FROM fapaccad where data_ent = "17/06/2008"
