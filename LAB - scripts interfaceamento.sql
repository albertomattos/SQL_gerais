select amo.codigo_amostra, com.status, com.data_hora 
from admvfr.lws_comunicacao com join admvfr.lws_com_amostras amo on amo.id_comunicacao = com.id_comunicacao 
where com.tipo_comunicacao = 5 and com.status = 0;

select sequencial, data_inc, hora_inc, data_proc, exportado, comanda from ti_ctr_labhos 
where 1=1 and data_inc >= '23/12/2016' and data_proc is not null order by data_proc desc

select t.*, t.rowid from admvfr.lws_com_amostras t 
where t.data_hora_coleta is not null order by t. data_hora_coleta desc
