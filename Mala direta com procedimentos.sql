select fapaccad.cod_pac,fapaccad.cod_prt,data_ent,nome_pac,faprdcad.descricao,end_res,end_numero,end_complemento,
bai_res,cid_res,est_res,cep_res,fone_res,celular,dsc_email,cpf
from faprtcad, faprccad, fapaccad, faprdcad
where fapaccad.cod_prt = faprtcad.cod_prt
and faprccad.cod_pac = fapaccad.cod_pac
and faprccad.cod_proc = faprdcad.cod_amb
and faprccad.cod_prd = faprdcad.codigo
and data_obito is null
and data_ent >= "01/05/2005"
--and nome_pac like "Z%"
and (end_res <> "" and end_res <> "/" and end_res <> "," and end_res <> "_" and end_res <> "-" and end_res <> "="
and end_res <> "." and end_res <> "*" and end_res <> "\" and end_res <> "+" and end_res <> "@" and end_res <> "#"
and end_res <> "$" and end_res <> "%" and end_res <> "&" and end_res <> "A" and end_res <> "B" and end_res <> "C"
and end_res <> "D" and end_res <> "E" and end_res <> "F" and end_res <> "G" and end_res <> "H" and end_res <> "I"
and end_res <> "J" and end_res <> "K" and end_res <> "L" and end_res <> "M" and end_res <> "N" and end_res <> "O"
and end_res <> "P" and end_res <> "Q" and end_res <> "R" and end_res <> "S" and end_res <> "T" and end_res <> "U"
and end_res <> "V" and end_res <> "W" and end_res <> "X" and end_res <> "Y" and end_res <> "Z" and end_res <> "Ç"
and end_res <> "1" and end_res <> "2" and end_res <> "3" and end_res <> "4" and end_res <> "5" and end_res <> "6"
and end_res <> "7" and end_res <> "8" and end_res <> "9" and end_res <> "0")
order by nome_pac
