select * from fapaccom where cod_set = "0164"

select distinct tipo_comanda from famovcad where cod_pac in (select cod_pac from fapaccad where cod_ala = "ENDS")
and data_mov >="01/01/2008" and set_ori = "3418"

select * from fapaccad

select distinct usuario from famovcad where cod_pac in (select cod_pac from fapaccom where cod_set = "3418")
and data_mov > "29/03/2008"

update famovcad set set_ori = "0061" where cod_pac in (select cod_pac from fapaccad where cod_ala = "ENDS")
	and set_ori = "3418"

update famovcad set tipo_comanda = "ENDO" where set_ori = "0061" and tipo_comanda = "AMB"

select distinct tipo_comanda from famovcad  where set_ori = "0061"
