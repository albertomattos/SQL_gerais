SELECT faprocad.cod_pro, faprocad.nome_pro,
       faprocad.fone_celular,
       faprocad.data_nascimento,
       month(data_nascimento) month_data_nascime,
       day(data_nascimento) day_data_nasciment,
       YEAR(DATA_NASCIMENTO) YEAR_DATA_NASCIMEN
FROM faprocad faprocad
--where month(data_nascimento) = "03" and inativo = "N"
where inativo = "N"
ORDER BY 5, 6, faprocad.nome_pro

