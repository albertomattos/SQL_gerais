select * from fapaccad
where tipo_pac = "U" and data_ent between "27/12/2004" and "02/01/2005"
and (cod_pro = "055555" or cod_pro = "033333" or cod_pro = "022222")
and (cod_con = "078" or cod_con = "079" or cod_con = "080" or cod_con = "042"
or cod_con = "044" or cod_con = "045" or cod_con = "058" or cod_con = "121")
and cod_uni = "DAHER"

