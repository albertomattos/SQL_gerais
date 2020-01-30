--Por logradouro
select nome_log,nome_bairro1_log,cep, tipo_log, nome_loc_log
from facepcad where nome_log like "%92%" order by nome_log

--Por cidade
select nome_log,nome_bairro1_log,cep, tipo_log, nome_loc_log
from facepcad where nome_loc_log like "NOVA VI%" order by nome_log

--Por bairro
select nome_log,nome_bairro1_log,cep,tipo_log, nome_loc_log
from facepcad where nome_bairro1_log like "%ABRANTES%" order by nome_log

--Atualizar CEP cuja cidade possui CEP único:
select * from facepcad where nome_log = "."
update facepcad set nome_bairro1_log = "" where nome_log = ".";
update facepcad set nome_log_red = "" where nome_log = ".";
update facepcad set nome_log = "" where nome_log = ".";

/*select * from facepcad where nome_log like " %" and nome_log <> ""
update facepcad set nome_log = '00'||nome_log where nome_log like " %" and nome_log <> ""
update facepcad set nome_log = replace (nome_log, "00 ", "") where nome_log like "00 %" and nome_log <> ""*/

select faprtcad.cod_prt, cep_res, cid_res, cod_pac, data_ent from fapaccad, faprtcad
where fapaccad.cod_prt = faprtcad.cod_prt
and fapaccad.tipo_pac = "I"
and fapaccad.data_ent >= "20/01/2007"
and cep_res = ""
order by cid_res

/*update facepcad set cod_ibge = "292740" where cod_ibge is null or cod_ibge = "" and nome_loc_log = "SALVADOR";
update faprtcad set cid_res = "SALVADOR" where cid_res = "SSA"
update facepcad set tipo_log = "PRACA" where nome_log like "PRACA%"
update facepcad set nome_log = replace (nome_log,"ESTRADA","") where nome_log like "ESTRADA%" AND tipo_log is null
update facepcad set nome_log = "" where nome_log = ".";
update facepcad set nome_log_red = "" where nome_log_red = ".";
update facepcad set nome_bairro1_log = "" where nome_bairro1_log = ".";
update faprtcad set bai_res = "ENG VELHO BROTAS" where bai_res = "ENG VEL BROTAS"
update facepcad set nome_loc_log = "ILHA DE MARE(SSA)" where nome_loc_log = "ILHA DE MARE (SALVADOR)"
update facepcad set tipo_log = "" where nome_loc_log like "LAURO%"

select distinct nome_loc_log from facepcad*/
