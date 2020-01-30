drop procedure hs_exc_prcd_real;
CREATE PROCEDURE  "informix".hs_exc_prcd_real(
	p_comanda      char(7),
	p_tipo_comanda char(4),
      p_cod_pac      char(7), 
	p_data_real    date, 
	p_hora_real    datetime hour to minute, 
	p_cod_pro      char(6))

DEFINE      p_codigo      char(6);
DEFINE 	p_cod_set     char(4);

-- Setor
Let p_cod_set = '2510';

FOREACH
SELECT codigo
  into p_codigo
  from lbmovprd
  where comanda    = p_comanda
  and tipo_comanda = p_tipo_comanda

  DELETE FROM faprccad
	WHERE	cod_pac   = p_cod_pac
	AND prev_real = 'R'
	AND cod_prd   = p_codigo
	AND data_real = p_data_real
	AND hora_real = p_hora_real
	AND cod_pro   = p_cod_pro
	AND cod_set   = p_cod_set;

  END FOREACH;

END PROCEDURE;


 

 

 

