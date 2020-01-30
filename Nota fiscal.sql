update fanotcad set nota_fiscal = "00010633" where data_emiss = "30/11/2006" and nota_fiscal = ""
select * from fanotcad where data_emiss = "30/11/2006"

select * from fanotavl where nota_fiscal = "00002660"

update fanotavl set ind_status = "A" where nota_fiscal = "00002660"

select * from nota_fatura where nota_fiscal = "00002660"
