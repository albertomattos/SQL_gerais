SELECT b.local, a.data_abertura, a.data_fechamento, timestampdiff(minute,a.data_abertura, a.data_fechamento),
timestampdiff(second,a.data_abertura, a.data_fechamento),sec_to_time(timestampdiff(second,a.data_abertura, a.data_fechamento))
FROM ocorrencias a, localizacao b WHERE a.local = b.loc_id
and a.data_abertura between '2012-08-01 00:00:00' and '2012-08-31 23:59:59' and a.sistema = '3'
order by b.local
