select a.cod_pac, c.nome_pac, d.descricao, d.tipo_prd from faprccad a, fapaccad b, faprtcad c, faprdcad d
where a.cod_pac = b.cod_pac
and b.cod_prt = c.cod_prt
and a.cod_prd = d.codigo
and tipo_prd in ("HON","EXA","CAR","HMD")
and data_real between "01/06/2008" and "30/06/2008" and prev_real = "R"
and cod_set = "3314"
and b.cod_uni <> "BARRA"
order by d.tipo_prd, c.nome_pac
