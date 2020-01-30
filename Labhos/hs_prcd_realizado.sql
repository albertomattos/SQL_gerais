CREATE PROCEDURE  "informix".hs_prcd_realizado(
	p_comanda      char(7), 
	p_tipo_comanda char(4),
	p_codigo       char(6),
	p_acao         char(1))

DEFINE 	p_cod_pac     char(7);
DEFINE 	p_cod_proc    char(8);
DEFINE 	p_cod_prd     char(6);
DEFINE 	p_data_real   date;
DEFINE 	p_hora_real   datetime hour to minute;
DEFINE 	p_cod_pro     char(6);
DEFINE 	p_cod_set     char(4);
DEFINE 	p_principal   char(1);
DEFINE  p_cod_esp     char(5);
DEFINE  nprincipal    INTEGER;


--set debug file to '/home/informix/hs_realizado.txt';
--trace on;


-- Carrega dados do Paciente
select lbmovcad.cod_pac, lbmovcad.data_mov, lbmovcad.hora_mov, lbmovcad.cod_pro, fapaccad.cod_esp
into   p_cod_pac, p_data_real, p_hora_real, p_cod_pro, p_cod_esp
  from lbmovcad, fapaccad
  where  lbmovcad.comanda = p_comanda
  and    lbmovcad.tipo_comanda = p_tipo_comanda
  and    lbmovcad.cod_pac = fapaccad.cod_pac;


-- Carrega Codigo do Procedimento
select cod_amb 
  into p_cod_proc
  from faprdcad 
  where  codigo = p_codigo;

-- Setor
Let p_cod_set = '2510';


-- Se for inclusao de Item
IF (p_acao = 'I') THEN

	-- Principal
	select count(*) 
	  into nprincipal
	  from faprccad
	  where cod_pac   = p_cod_pac
	  and   principal = 'S';

	IF (nprincipal = 0) then
		Let p_principal = 'S';
	ELSE
		Let p_principal = 'N';
	END IF;


	-- Inclui na tabela de Procedimentos Realizados
	insert into faprccad (
		cod_pac, 
		prev_real,
		cod_proc,
		cod_prd,
		data_real,
		hora_real,
		qtd_vias,
		cod_pro,
		cod_set,
		principal,
		cod_esp,
		regiao)
	Values
		(
		p_cod_pac,
		'R',
		p_cod_proc,
		p_codigo,
		p_data_real,
		p_hora_real,
		1,
		p_cod_pro,
		p_cod_set,
		p_principal,
		p_cod_esp,
		''
		);

ELSE

-- Se for exclusao de Item

	-- Exclui o Item da
	DELETE FROM faprccad
		WHERE
		cod_pac   = p_cod_pac
		AND prev_real = 'R'
		AND cod_proc  = p_cod_proc
		AND cod_prd   = p_codigo
		AND data_real = p_data_real
		AND hora_real = p_hora_real
		AND cod_pro   = p_cod_pro
		AND cod_set   = p_cod_set;
END IF;

END PROCEDURE;


 

 

 

