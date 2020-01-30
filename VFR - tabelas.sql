select t.*, t.rowid from lws_com_amostras t where t.codigo_amostra like '53809152850%'
select t.*, t.rowid from lws_com_amostras t where t.data_hora_coleta >= '20/09/2014 00:00:00'

select t.*, t.rowid from lws_com_solicitacao_exames t where t.id_comunicacao in (
select id_comunicacao from lws_com_amostras where solicitacao = '5362122')
--and t.exame_lis = '051155'

select * from admvfr.lws_com_resultados where id_comunicacao in (
select id_comunicacao from admvfr.lws_com_amostras where solicitacao = '5894986')

select t.*, t.rowid from lws_comunicacao t where t.data_hora >= '20/09/2014 00:00:00' and t.tipo_comunicacao = '1'

update lws_comunicacao set status = 0 where data_hora >= '20/09/2014 00:00:00' and tipo_comunicacao = '1'

 where t.seq_comunicacao = '345225'
where t.tipo_comunicacao = '5' and status = 0

select nome from lws_com_pacientes where id_comunicacao in
( select id_comunicacao from lws_com_amostras where codigo_amostra = '53704480669');
