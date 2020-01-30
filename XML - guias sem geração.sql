select g.fantasia, a.cod_pac,
DECODE(a.tipo_pac,'I','Interno','E','Externo','U','Urgencia','A','Ambulatorio') Tipo_pac,
d.nome_pac, a.num_guia, c.remessa, f.descricao, b.valor_guia
from fapaccad a, fafatcad b, faremcad c, faprtcad d, fapaccom e, fasetcad f, faconcad g
where a.cod_pac = b.cod_pac and b.remessa = c.remessa and a.cod_pac = e.cod_pac and e.cod_set = f.cod_set
and a.cod_con = g.cod_con and a.cod_prt = d.cod_prt and a.num_guia not in (
SELECT DISTINCT VW_GUIAVALIDA.NUM_GUIA
FROM VW_GUIAVALIDA, FAPACCAD, FAPRTCAD, FATGUCAD, TIPO_GUIA_TISS, GUIATISS, TRANSTISS, XMLTISS, TPTRANTISS
WHERE FAPACCAD.COD_PAC = VW_GUIAVALIDA.COD_PAC AND FAPACCAD.COD_PRT = FAPRTCAD.COD_PRT AND VW_GUIAVALIDA.TIPO_GUIA = FATGUCAD.TIPO_GUIA 
  AND FATGUCAD.COD_TPGUIA_TISS = TIPO_GUIA_TISS.COD_TIPO_GUIA AND VW_GUIAVALIDA.COD_GUIA = GUIATISS.COD_GUIA 
  AND GUIATISS.ID_TRANSTISS = TRANSTISS.ID_TRANSTISS AND GUIATISS.ID_XMLTISS = XMLTISS.ID_XMLTISS 
  AND TRANSTISS.SIT_TRANSTISS in ('0','1','2','3','4','5')
  AND TPTRANTISS.ID_TPTRANTISS = TRANSTISS.ID_TPTRANTISS AND TPTRANTISS.ID_ER_TPTRANTISS = 'E' /*AND FAPACCAD.COD_CON = '014'*/ 
  AND FAPACCAD.COD_UNI = '0001') ---- Tirar de 2013
  --and a.cod_con = '014'
  and c.data_emiss between '21/06/2014' and '30/06/2014'
  order by 1
