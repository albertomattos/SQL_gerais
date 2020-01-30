--Trocar o leito e o tipo do leito:
select a.cod_pac, a.leito, a.tipo, a.rowid from fapaccad a where a.cod_pac = 'G224653'
--Trocar o leito, o tipo do leito e o cod_apt (código do apartamento):
select b.*, b.rowid from falehcad b where b.cod_pac = 'G224653'
--Apagar o cod_pac do leito anterior:
select c.*, c.rowid from faleicad c where c.cod_pac = 'G224653'
--Trocar o registro do RN pelo registro da mãe, no leito atual:
select t.*, t.rowid from faleicad t where t.leito = '02'
