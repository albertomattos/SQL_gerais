update ocorrencias set data_encerramento = '2012-11-30 23:59:59',
data_atendimento = '2012-11-30 23:59:59',
status = 4 where sistemas = 3 and status <> 4 and data_encerramento is null
