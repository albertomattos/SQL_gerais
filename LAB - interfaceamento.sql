select t.*, t.rowid from lws_com_amostras t where t.data_hora_coleta is not null
order by t.data_hora_coleta desc

select t.*, t.rowid from lws_comunicacao t where t.tipo_comunicacao = '1' order by t.data_hora desc
select t.*, t.rowid from lws_comunicacao t order by t.data_hora desc

select t.*, t.rowid from lws_com_amostras t where t.id_comunicacao = '2899482'

select * from wpd.ti_ctr_labhos where 1=1
--and comanda = '5541809';
order by 1 desc
