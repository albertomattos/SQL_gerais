select * from immovcad where cod_pac = "H165515"
update immovcad set cod_pro_solic = "008133" where cod_pac = "H165515"


select * from famovdestino where sequencial in (select sequencial from famovcad where cod_pac = "H165515")

