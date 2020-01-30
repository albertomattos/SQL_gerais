update faplacad set guia = "S" where cod_con in (select cod_con from faconcad
where num_ans <> "")
