CREATE OR REPLACE PROCEDURE  EXCUSUARIO_USO
  (pUSO_CODIGO        IN CHAR)
AS BEGIN
   DELETE FROM
      USUARIO_USO
   WHERE
     (USO_CODIGO = pUSO_CODIGO);
END;

CREATE OR REPLACE PROCEDURE EXCUSUARIO_USO
  (pUSO_CODIGO        IN CHAR)
AS BEGIN
   RAISE_APPLICATION_ERROR(-20000, 'Nao é permitida a exclusao do usuario: "' || pUSO_CODIGO );
END;
/
-----------------------------------------------------
SET SERVEROUT ON;
EXEC MXMVALIDA_80;
-----------------------------------------------------

