CREATE OR REPLACE PACKAGE BODY OPERACION.PKG_COMP_ELECTRON_SGA IS

  /*'****************************************************************
  '* Nombre SP : SGASS_LISTADO_TRAMA
  '* Propósito :  Procedimiento que valida las tramas rechazadas por las validaciones de paperless en IPCT_MDCCONCN0752.
  
  '* Input :   -
    
  '* Output : 
                 <K_CURSOR> - Cursor
                <K_CODIGO> - Código respuesta 
                <K_MENSAJE> - Mensaje respuesta      
  '* Creado por : José Minguillo 
  '* Fec Creación : 06/01/2020
  '* Fec Actualización : 06/01/2020
  '*****************************************************************/

  PROCEDURE SGASS_LISTADO_TRAMA(K_CURSOR  OUT SYS_REFCURSOR,
                                K_CODIGO  OUT PLS_INTEGER,
                                K_MENSAJE OUT VARCHAR2) IS
  
    PRAGMA AUTONOMOUS_TRANSACTION;
  
  BEGIN
  
    OPEN K_CURSOR FOR
      SELECT A.TIPDOC,
             A.CODCLI,
             A.MENSAJE_XML_VERIFICACION,
             A.ESTADO,
             A.ESTREC,
             A.FECUSU,
             A.FECMOD,
             A.CODUSU
        FROM BILLCOLPER.FE_CXCBILL_SUNAT A
       WHERE A.ESTREC IN ('1', '2', '3')
         AND TRUNC(A.FECMOD) = TRUNC(SYSDATE - 1); -- TRAMAS ERROR
  
    K_CODIGO  := '0';
    K_MENSAJE := 'PROCESO EXITOSO';
  
  EXCEPTION
    WHEN OTHERS THEN
      K_CODIGO  := 1;
      K_MENSAJE := 'SGASS_LISTADO_TRAMA. SQLCODE: ' || TO_CHAR(SQLCODE) ||
                   ' - SQLERRM: ' || SQLERRM;
  END;

END PKG_COMP_ELECTRON_SGA;

/