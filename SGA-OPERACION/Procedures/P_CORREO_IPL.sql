CREATE OR REPLACE PROCEDURE OPERACION.P_CORREO_IPL IS
tmpVar NUMBER;
/******************************************************************************
Ejecuta todo el flujo de correos para el IPL

******************************************************************************/
BEGIN

	--  P_ENVIA_CORREO_DE_TEXTO('IPL Nueva Orden de Trabajo '||to_char(:new.codsolot), 'ccorrales@firstcom.com.pe', ls_texto);

--     P_ENVIA_CORREO_DE_TEXTO_ATT('Nueva Orden de Trabajo '||to_char(:new.codot), ls_correo.email, ls_texto);

   tmpVar := 0;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       Null;
     WHEN OTHERS THEN
       Null;
END P_CORREO_IPL;
/


