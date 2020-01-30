select distinct p.cod_prt, p.nome_pac, p.fone_res, p.celular, p.data_obito from faprtcad p, fapaccad r
where r.cod_prt = p.cod_prt
and r.data_ent >= '01/11/2014'
and p.data_obito is null
/*
select count(*) from faprtcad p, fapaccad r
where r.cod_prt = p.cod_prt
and r.data_ent >= "01/01/2005"
*/
