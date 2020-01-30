SELECT d.data_hora_ini, decode(a.Fk_Carater_Atend,'1','Eletiva','2','Urgência/Emergência') carater_atend, f.nome_pro profissional,
h.descricao especialidade, j.cod_pac, k.nome_pac, l.fantasia convenio
FROM BLCIRU_REALIZADA a, BLSTAT_CIRU_REZD b, BLCIRU_STATUS c, BLPROC_CIRURGICO d, FAPRDCAD e, FAPROCAD f, BLEQPE_PROC_CIRU g,
faespcad h, faesppro i, fapaccad j, faprtcad k, faconcad l
WHERE  a.CD_CIRU_REALIZADA = b.CD_CIRU_REALIZADA AND b.CD_CIRU_STATUS = c.CD_CIRU_STATUS
AND  a.CD_CIRU_REALIZADA   = d.CD_CIRU_REALIZADA AND d.CD_PROC_CIRURGICO = e.CODIGO
AND  d.CD_PROC_CIRURGICO   = g.CD_PROC_CIRURGICO AND d.CD_CIRU_REALIZADA = g.CD_CIRU_REALIZADA
AND  d.REGIAO = g.REGIAO AND g.CD_PROFISSIONAL = f.COD_PRO and f.cod_pro = i.cod_pro and h.cod_esp = i.cod_esp
and a.cod_pac = j.cod_pac and j.cod_prt = k.cod_prt and j.cod_con = l.cod_con
and i.sn_principal = 'S' AND  g.COD_ATO IN ('01') AND  c.CD_CIRU_STATUS = 'E'
AND d.DATA_HORA_INI >= '01/01/2017' AND d.DATA_HORA_INI <= '29/11/2017'
and j.cod_pac = 'M649000'
--ORDER BY f.nome_pro
group by a.cod_pac, d.data_hora_ini, a.Fk_Carater_Atend, f.nome_pro, h.descricao, j.cod_pac, k.nome_pac, l.fantasia
