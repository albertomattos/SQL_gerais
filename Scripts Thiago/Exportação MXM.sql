select * from exportacao_mxm /*order by datainicial*/where datainicial >= '01/03/2010'
--delete from exportacao_mxm where idexp = '3706'
select * from hs_mxm_temp_exp_fat --Banco Informix

SELECT Exportacao_MXM.*, Usuario.IDUSUARIO, Usuario.Usuario From Exportacao_MXM, Usuario
WHERE Tipo_Exp_MXM='4'
--AND Exportacao_MXM.idUsuario=Usuario.idUsuario
AND datafinal >= '03/05/2009'
AND idexp = '4836'
ORDER BY DataInicial,Usuario.IDUSUARIO

select * from usuario order by idusuario