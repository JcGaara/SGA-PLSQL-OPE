create or replace package operacion.pq_control_sinc_webuni is

  /******************************************************************************
     NAME:       pq_control_sinc_webuni
     Purpose:    --
      Ver        Date        Author            Solicitado por    Description
     ---------  ----------  ---------------   ----------------  --------------------
     1.0        20/11/2011  Kevy Carranza     Guillermo Salcedo REQ-161140 Enviar de errores por correo
     *******************************************************************************/
   --Funcion que procesa correctamente el llenado de un archivo csv.
  FUNCTION F_VUELCA_CSV(p_query     IN VARCHAR2,
                        p_separador IN VARCHAR2 DEFAULT ',',
                        p_nomdir       IN VARCHAR2 ,
                        p_nomarchivo  IN VARCHAR2 ) RETURN NUMBER;

  --Funcion que genera reporte en formato scv y lo envia por email
  PROCEDURE  P_ENVIA_REPORTE;
end ;
/