select distinct to_char(f.data_hora_ini,'HH24:Mi') hora, b.cod_sac, e.nome_pac, e.nascimento, h.natureza convenio, d.leito,
(select nome_reduzido from faprocad where cod_pro = i.cd_profissional and cod_ato = '01') cirurgiao, g.descricao,
c.descricao status
from blciru_realizada a, blstat_ciru_rezd b, blciru_status c, fapaccad d, faprtcad e, blproc_cirurgico f, faprdcad g,
faconcad h, bleqpe_proc_ciru i, faprocad j
where a.cd_ciru_realizada = b.cd_ciru_realizada and b.cd_ciru_status = c.cd_ciru_status
and d.cod_pac = a.cod_pac and d.cod_prt = e.cod_prt and a.cd_ciru_realizada = f.cd_ciru_realizada
and f.cd_proc_cirurgico = g.codigo and d.cod_con = h.cod_con and a.cd_ciru_realizada = i.cd_ciru_realizada
and i.cd_profissional = j.cod_pro and i.cod_ato in ('01') --and b.cod_sac in ('1','2','3','4','5','6') verificar status
and b.dt_stat_ciru_rezd = any
    (select max(dt_stat_ciru_rezd) from blstat_ciru_rezd
            where cd_ciru_realizada = a.cd_ciru_realizada group by cd_ciru_realizada)
and f.data_hora_ini >= to_date('26/04/2016 00:00','dd/mm/yyyy hh24:mi')
and f.data_hora_ini <= to_date('26/04/2016 23:59','dd/mm/yyyy hh24:mi')
order by hora
