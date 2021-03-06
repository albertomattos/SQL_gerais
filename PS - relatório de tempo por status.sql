select registro, prontuario, sum(total), nv_alerta from (
 select distinct
 evo.cod_pac||' - '|| prt.nome_pac registro,
 prt.cod_prt as prontuario, 
 nvl(nome_rsp,trim(co_fila)||nu_senha) as nome,
 fasetcad.descricao as setor,
 ((nvl(dh_mudanca_fim,sysdate) - dh_mudanca)*24/86400*3600 + (nvl(dh_mudanca_fim,sysdate) - dh_mudanca)/24 +(nvl(dh_mudanca_fim,sysdate) - dh_mudanca)/24/60+(nvl(dh_mudanca_fim,sysdate) - dh_mudanca)/24/60/60) total,
 (select min(dh_mudanca) from tb_hist_stat_atend a where a.fk_fa_pac = tb_hist_stat_atend.fk_fa_pac) as entrada,
 (select max(dh_mudanca) from tb_hist_stat_atend a where a.fk_fa_pac = tb_hist_stat_atend.fk_fa_pac) as saida,
 na.dsc_nivel_alerta nv_alerta
 
 
 from tb_hist_stat_atend left join fapaccad on  cod_pac = fk_fa_pac    
                         inner join faprtcad prt on prt.cod_prt = fapaccad.cod_prt
                         inner join tb_status_atendpac on tb_status_atendpac.pk_staten  = tb_hist_stat_atend.fk_staten    
                         inner join tb_sel_senha_fila  on tb_sel_senha_fila.pk_selsen   = tb_hist_stat_atend.fk_selsen    
                         inner join tb_triagem_fila on tb_triagem_fila.pk_trifil     = tb_sel_senha_fila.fk_trifil    
                         left join fasetcad on tb_triagem_fila.fk_cod_set   = fasetcad.cod_set
                         left  join tb_alerta_status   on tb_status_atendpac.pk_staten  = tb_hist_stat_atend.fk_staten    
                         inner join tb_alerta_atend    on tb_alerta_atend.pk_aleate     = tb_alerta_status.fk_aleate    
                         left  join tb_item_mat_status on tb_hist_stat_atend.fk_acstat = tb_item_mat_status.fk_acstat
                         left outer join EVOLUCAO_CLINICA evo on evo.cod_pac = fapaccad.cod_pac
                         left outer join nivel_alerta na on na.cod_nivel_alerta = evo.cod_nivel_alerta
                         

 where nvl(tb_hist_stat_atend.dh_mudanca_fim, sysdate) > tb_hist_stat_atend.dh_mudanca   
       and  tb_alerta_status.qt_tempo_alerta = decode((select min(tb_alerta_status.qt_tempo_alerta)
                                                       from tb_alerta_status where tb_alerta_status.qt_tempo_alerta >= trunc((((nvl(tb_hist_stat_atend.dh_mudanca_fim,sysdate)-tb_hist_stat_atend.dh_mudanca)*24))*60) 
                                                       and tb_alerta_status.fk_staten = tb_hist_stat_atend.fk_staten),null, (select max(tb_alerta_status.qt_tempo_alerta) 
                                                       from tb_alerta_status where tb_alerta_status.fk_staten = tb_hist_stat_atend.fk_staten),(select min(tb_alerta_status.qt_tempo_alerta) 
                                                       from tb_alerta_status where tb_alerta_status.qt_tempo_alerta >= trunc((((nvl(tb_hist_stat_atend.dh_mudanca_fim,sysdate)-tb_hist_stat_atend.dh_mudanca)*24))*60) 
                                                       and tb_alerta_status.fk_staten = tb_hist_stat_atend.fk_staten))      

 and tb_sel_senha_fila.dh_retirada between to_date('13/12/2016 00:00:00', 'dd/mm/yyyy HH24:Mi:ss') and to_date('13/12/2016 23:59:59', 'dd/mm/yyyy HH24:Mi:ss')
 and fapaccad.tipo_pac in ('U') 
 and fasetcad.cod_set  in ('0118')  and (fk_matriz  = 21 or tb_hist_stat_atend.fk_acstat = 99 ) 

) group by registro, prontuario, nv_alerta
