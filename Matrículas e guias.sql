select fapaccad.num_guia, fapaccad.matricula, fafatcad.fatura, fafatcad.remessa, fapaccad.cod_pac
from fapaccad, fafatcad
where fapaccad.cod_pac = fafatcad.cod_pac
and fafatcad.remessa = "034143"
order by matricula

update fapaccad set num_guia = "4514974" where cod_pac = "D319107"

update fapaccad set matricula = "00877507007997009" where cod_pac ="D351399"

select * from csremcad where valor = "31515.05"
