select * from faprccad where cod_pac in
(select fafatcad.cod_pac from faremcad, fafatcad where faremcad.remessa = fafatcad.remessa and faremcad.remessa = "048469")

update faprccad set uni_tempo_doenca = NULL where cod_pac = "G085285"
