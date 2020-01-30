select distinct to_char(f.data_hora_ini,'hh24:mi') hora_inicial, to_char(f.data_hora_fim,'hh24:mi') hora_fim, b.cod_sac sala,
e.nome_pac paciente, TO_CHAR( (TO_CHAR(SYSDATE,'YYYY')-TO_CHAR( e.nascimento,'YYYY')) ) as IDADE,
h.natureza convenio, d.leito,
(select nome_reduzido from faprocad where cod_pro = i1.cd_profissional and i1.cod_ato = '01') cirurgiao,
(select nome_reduzido from faprocad where cod_pro = i2.cd_profissional and i2.cod_ato = '06') anestesista,
g.descricao procedimento, k.circulante, c.descricao status
from blciru_realizada a, blstat_ciru_rezd b, blciru_status c, fapaccad d, faprtcad e, blproc_cirurgico f, faprdcad g,
faconcad h, bleqpe_proc_ciru i1, bleqpe_proc_ciru i2, faprocad j, blcirculante k, blsaccad l
where a.cd_ciru_realizada = b.cd_ciru_realizada and b.cd_ciru_status = c.cd_ciru_status
and d.cod_pac = a.cod_pac and d.cod_prt = e.cod_prt and a.cd_ciru_realizada = f.cd_ciru_realizada
and f.cd_proc_cirurgico = g.codigo and d.cod_con = h.cod_con and a.cd_ciru_realizada = i1.cd_ciru_realizada
and i1.cd_ciru_realizada = i2.cd_ciru_realizada
and a.cd_ciru_realizada = k.cod_ciru(+)
and b.cod_sac = l.cod_sac
and i1.cd_profissional = j.cod_pro and i1.cod_ato = '01' and i2.cod_ato = '06'
and f.proc_principal = 'S'
and t.tipo_sala = 'CC' and t.cod_sac <> 'PREAG'
and b.dt_stat_ciru_rezd = any
    (select max(dt_stat_ciru_rezd) from blstat_ciru_rezd
            where cd_ciru_realizada = a.cd_ciru_realizada group by cd_ciru_realizada)
--and f.data_hora_ini > to_date('17/11/2013 23:59','dd/mm/yyyy hh24:mi')
and to_char(f.data_hora_ini,'dd/mm/yyyy') = to_date(to_char(SYSDATE,'dd/mm/yyyy'))
 order by hora_inicial
 --select * from blstat_ciru_rezd
