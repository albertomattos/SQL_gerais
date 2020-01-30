update fapaccad set num_guia = replace(num_guia,"D0","0")/*(nome,procura,troca)*/
/*where cod_con = "079"*/
/*and length(senha) = "17"*/
/*where senha like "%-%" and senha <> ""*/
where num_guia like "%D0%"
