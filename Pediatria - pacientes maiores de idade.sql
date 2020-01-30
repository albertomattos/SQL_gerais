select b.tip_atend, a.nascimento, b.cod_pac, b.cod_esp, e.descricao, b.data_ent, b.tipo_pac, f.apelido, b.cod_mot_alta
from faprtcad a, fapaccad b, faprocad c, faesppro d, faespcad e, fausucad f
where a.cod_prt = b.cod_prt
and b.cod_pro = c.cod_pro
and c.cod_pro = d.cod_pro
and d.cod_esp = e.cod_esp
and b.cod_matricula = f.matricula
and b.cod_ala = "PEDI"
and a.nascimento <= "31/12/1991"
and b.data_ent >= "01/01/2008"
order by b.data_ent desc, b.cod_esp, e.descricao

select set_ori, cod_pac from famovcad
where cod_pac in
(select cod_pac from fapaccad
	where cod_ala = "CGER" and tipo_pac = "A" and data_ent >= "01/01/2007")

update fapaccad set cod_ala = "CDHS" where cod_ala = "CGER" and tipo_pac = "A"
and cod_pac in (select  cod_pac from famovcad where set_ori = "3418")

 and cod_esp not in
('GINEC','OBST') AND tip_atend <> "M"

select * from famovcad where cod_pac = "E759940"cod_ala = "CGER" and tipo_pac = "A" and data_ent >= "01/01/2007"
