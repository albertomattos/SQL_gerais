--Por item
select a.cod_pro, b.nome_pro, c.descricao, f.cod_con, f.fantasia, a.codigo, e.descricao,
a.perc_hosp, a.perc_hosp_hon, a.perc_hosp_fil, a.perc_hosp_cop, a.perc_hosp_ext, a.perc_hosp_hon_ext, a.perc_hosp_fil_ext,
a.perc_hosp_cop_ext, a.perc_hosp_urg, a.perc_hosp_hon_urg, a.perc_hosp_fil_urg, a.perc_hosp_cop_urg, a.perc_hosp_amb,
a.perc_hosp_hon_amb, a.perc_hosp_fil_amb, a.perc_hosp_cop_amb
from farpicad a, faprocad b, faespcad c, faesppro d, faprdcad e, faconcad f
where a.cod_pro = b.cod_pro and b.cod_pro = d.cod_pro and d.cod_esp = c.cod_esp and a.codigo = e.codigo and a.cod_con = f.cod_con(+)
and d.sn_principal = 'S'

--geral
select a.cod_pro, b.nome_pro, c.descricao, f.cod_con, f.fantasia, a.tipo_prd, a.cod_uni_atend,
a.perc_hosp, a.perc_hosp_hon, a.perc_hosp_fil, a.perc_hosp_cop, a.perc_hosp_ext, a.perc_hosp_hon_ext, a.perc_hosp_fil_ext,
a.perc_hosp_cop_ext, a.perc_hosp_urg, a.perc_hosp_hon_urg, a.perc_hosp_fil_urg, a.perc_hosp_cop_urg, a.perc_hosp_amb,
a.perc_hosp_hon_amb, a.perc_hosp_fil_amb, a.perc_hosp_cop_amb
from farptcad a, faprocad b, faespcad c, faesppro d, faconcad f
where a.cod_pro = b.cod_pro and b.cod_pro = d.cod_pro and d.cod_esp = c.cod_esp and a.cod_con = f.cod_con(+)
and d.sn_principal = 'S'

--update farptcad set cod_uni_atend = ' ' where cod_uni_atend = '0001' and grupo <> 'NEUR'

select a.cod_pro, b.nome_pro, c.descricao, g.descricao grupo_produtos, f.cod_con, f.fantasia, a.cod_uni_atend,
a.perc_hosp, a.perc_hosp_hon, a.perc_hosp_fil, a.perc_hosp_cop, a.perc_hosp_ext, a.perc_hosp_hon_ext, a.perc_hosp_fil_ext,
a.perc_hosp_cop_ext, a.perc_hosp_urg, a.perc_hosp_hon_urg, a.perc_hosp_fil_urg, a.perc_hosp_cop_urg, a.perc_hosp_amb,
a.perc_hosp_hon_amb, a.perc_hosp_fil_amb, a.perc_hosp_cop_amb
from farepasse_grupo a, faprocad b, faespcad c, faesppro d, faconcad f, faprgcad g
where a.cod_pro = b.cod_pro and b.cod_pro = d.cod_pro and d.cod_esp = c.cod_esp and a.cod_con = f.cod_con(+) and a.cod_gru = g.cod_prg
and d.sn_principal = 'S'
