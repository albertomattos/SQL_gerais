select t.usu_st_enderecoip maquina,u.gru_st_nomecompleto Usuario,decode (u.gru_st_nomecompleto,'Meire Jane Assis','Compras',
'Alberto Ramos Costa','Contabilidade','Ana Paula Marques do Santos','Contabilidade','Barbara Obando Costa','TI',
'Elen Cristina Pereira Cassiano','Tesouraria','Ildilene Macedo da Silva','Contas a Pagar','Jaqueline Gama Silva','Contas a Pagar',
'JORGE PINHEIRO DA SILVA JUNIOR','Compras','Luana Soares Barroso','Tesouraria','Madalena','Tesouraria','Sandra de Araujo de Souza',
'Contabilidade','Shany Mendes Cardoso','Contabilidade','Suzanne Lais de Souza','Contas a Receber','Thiago Sales','Contabilidade',
'Andreza Miranda Lemos','Contas a Receber','Mega Sistemas Corporativos','(Integrador)','Dayse Kelly Moura','Contas a Pagar',
'Mikael da Cunha Alves Maia','Contabilidade','Nivea Soares','Contas a Pagar', 'Renata da silva Valente','Tesouraria',
'Roberto Cezar Bentes Arce','Compras','Silvane Cristina Pires Araujo','Contas a Receber','Lizandra da Silva Souza','Compras',
'Andreia Chaves Batista','Custos', 'SILVIO SILVEIRA VASCONCELOS','Compras','Thays Oliveira','Contas a Pagar',
'MARILENE MARTINS','Contas a Receber','ISRAEL VIEIRA DE SOUZA','Compras','Francisco Braz de Pinho Souza','Contratos',
'Amanda Costa','Contas a Receber','Fernanda Oliveira Santana','Contabilidade','Gabryela Magalh�es','Contas a Receber',
'Ediane Batista','Tesouraria','Francileide Vieira de Souza','Contas a Receber','HAYLA ARAUJO DE SOUZA','Contratos',
'Annie Nielsen Rocha Reigo','Contabilidade') Setor
from MGGLO.GLO_LOGACESSOSISTEMA t, mgglo.glo_grupo_usuario u
where USU_DT_LOGOUT is null and to_char(usu_dt_login, 'dd/mm/yyyy') = to_char(sysdate, 'dd/mm/yyyy')
and t.usu_in_codigo = u.gru_in_codigo group by t.usu_st_enderecoip,u.gru_st_nomecompleto order by 3,2
/*
select t.usu_st_enderecoip,t.sis_in_codigo,u.gru_st_nomecompleto,t.usu_dt_ultacesso, t.usu_dt_logout, t.rowid
from MGGLO.GLO_LOGACESSOSISTEMA t, mgglo.glo_grupo_usuario u
where USU_DT_LOGOUT is null --and t.sis_in_codigo <> '1'
  and to_char(usu_dt_login, 'dd/mm/yyyy') = to_char(sysdate, 'dd/mm/yyyy')
and t.usu_in_codigo = u.gru_in_codigo
order by 3
*/
