--update faprtcad set nome_mae = "." where nome_mae like "S/%"
--select * from faprtcad where data_abertu is null
--update faprtcad set data_abertu = "01/01/2008" where data_abertu is null
--where nome_mae like "*%"
--update faprtcad set nome_pai = "" where nome_pai is null
select cid_res, count(cid_res) from faprtcad
group by cid_res order by count(cid_res) DESC

select cid_res, cod_prt from faprtcad
where cid_res like "S%JE%"  and cid_res <> "SALVADOR"  order by cid_res

select cid_res from faprtcad
where cid_res like "%+%" and cid_res <> ""
--and (nome_pai is null or nome_pai like "*%" or nome_pai = "")
--update faprtcad set natural_de = "AMELIA RODRIGUES" where natural_de = "A RODRIGUES"

update faprtcad set cid_res = replace (cid_res,'+','') where cid_res like "%+%"

update faprtcad set cid_res = "STO ANTONIO JESUS"
where cid_res like "S%JE%" and cid_res not in ("SALVADOR")

update faprtcad set est_res = "MG"
where cid_res like "BELO HORIZONTE" and est_res not in ("MG")
