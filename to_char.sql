select to_char(hora_inicial,'HH24:Mi') hora, to_date(sysdate,'DD/MM/YY') data_atual,
to_char(to_date(sysdate,'DD/MM/YY HH24:Mi'),'HH24:MI') hora_atual, sysdate data_hora_atual from rcrsvcad t
where t.data_inicial = to_date(sysdate,'DD/MM/YY')
--and t.hora_inicial = to_date(sysdate,'HH24:Mi',-3)
