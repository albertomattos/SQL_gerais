update faprocad set cpf =
(select tempprof.cpf from tempprof where
        tempprof.crm = faprocad.crm)

where
crm in (select crm from tempprof)
and uf_crm = "BA"
and cpf = ""

select * from tempprof
where crm not in (select crm from faprocad)

select * from faprocad where nome_pro like "ADILSON PEIXOTO%"

select count(*) from faprocad

update tempprof set cod_pro = "000"||trim(crm) where length(crm) = 3
