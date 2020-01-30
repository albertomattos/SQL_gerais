select * from fapaccad where data_ent between '01/01/2016' and '31/01/2016'
and cod_pac not in (select cod_pac from famovcad) and cod_con in ('001','002')
