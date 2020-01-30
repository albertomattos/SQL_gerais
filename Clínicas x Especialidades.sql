SELECT CLINICA_ESPEC.COD_ESP, FAESPCAD.DESCRICAO FROM   CLINICA_ESPEC, FAESPCAD
WHERE  CLINICA_ESPEC.COD_ESP = FAESPCAD.COD_ESP
AND   CLINICA_ESPEC.COD_ALA = 'PEDI'

select * from clinica_espec where cod_ala = 'PSCA'

select * from clinica_espec where cod_ala = "PEDI"
select * from faespcad where cod_esp = "PEDIA"
update faespcad set cod_esp = "1PEDI" where cod_esp = "PEDIA"

select * from faesppro where cod_esp = "CIPED"
update faesppro set cod_esp = "PEDIC" where cod_esp = "CIPED"

select * from fafatprd
