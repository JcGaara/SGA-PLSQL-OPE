CREATE OR REPLACE PACKAGE BODY OPERACION.SGA_CONSULTAS is

PROCEDURE SP_CONSULTA_FIJO_WEBPNP(P_LINEA IN VARCHAR2,
                           P_FECINI  IN DATE,
                           P_FECFIN  IN DATE,
                           P_CURSOR OUT CUR_PROCESO) IS
          --V_SQL VARCHAR2(32767);
          BEGIN
          /*/
          V_SQL:=
              'SELECT A.NUMERO, B.NOMCLI, B.NTDIDE DOC_IDENTIDAD, A.FECINI, A.FECFIN, C.DESCRIPCION
              FROM INSSRV A, VTATABCLI B, ESTINSSRV C
              WHERE A.NUMERO LIKE ' || P_LINEA ||
              ' AND A.CODCLI=B.CODCLI AND A.ESTINSSRV=C.ESTINSSRV';

          OPEN P_CURSOR FOR V_SQL;
          */
          OPEN P_CURSOR FOR
          SELECT A.NUMERO, B.NOMCLI, B.NTDIDE DOC_IDENTIDAD, A.FECINI, A.FECFIN, C.DESCRIPCION
          FROM INSSRV A, VTATABCLI B, ESTINSSRV C
          WHERE A.NUMERO LIKE P_LINEA  AND A.CODCLI=B.CODCLI AND A.ESTINSSRV=C.ESTINSSRV
          AND A.FECINI >= P_FECINI AND NVL(A.FECFIN,DECODE(A.FECINI,NULL,A.FECFIN,SYSDATE-1)) <= P_FECFIN;

END SP_CONSULTA_FIJO_WEBPNP;

/*
'****************************************************************************************************************
'* Nombre SP    : CVWSSS_CONSULTA_DATOS
'* Proposito    : Obtiene el cod_cli del proyecto numslc
'* Input        : P_NUMSLC                   -- Numero SLC
'* Output       : P_COD_RESUL                -- Código del resultado
                  P_MSG_RESUL                -- Mensaje del resultado
                  P_CURSOR                   --Cursor que devuelve la información del cliente.
'* Proyecto: PROY-27510 IDEA-35190 - Proyecto Claro video WSHub Bidireccional (Fase3 y 4)
'* Creado por   : HITSS
'* Fec Creacion : 12/04/2017

'****************************************************************************************************************
*/
PROCEDURE CVWSSS_CONSULTA_DATOS(P_NUMSLC IN CHAR,
                                P_CURSOR OUT SYS_REFCURSOR,
                                P_COD_RESUL OUT NUMBER,
                                P_MSG_RESUL OUT VARCHAR2) IS
v_cantReg NUMBER;                 
BEGIN
  
  SELECT COUNT(1) INTO v_cantReg
  FROM SALES.VTATABSLCFAC vta
  WHERE vta.NUMSLC = P_NUMSLC;

  IF v_cantReg = 0 THEN
    P_COD_RESUL := -2;
    P_MSG_RESUL := 'Error OPERACION.SGA_CONSULTAS.CVWSSS_CONSULTA_DATOS, no existe proyecto  de ventas ' || P_NUMSLC;
  ELSE
    OPEN P_CURSOR FOR
    SELECT vta.NUMSLC NUMSLC, 
         vta.CODCLI CODCLI
    FROM SALES.VTATABSLCFAC vta
    WHERE vta.NUMSLC = P_NUMSLC;
  
    P_COD_RESUL := 0;
    P_MSG_RESUL := 'Éxito';
  END IF;
  
  EXCEPTION
    WHEN OTHERS THEN
      BEGIN
        P_COD_RESUL  := -1;
        P_MSG_RESUL  := 'Error OPERACION.SGA_CONSULTAS.CVWSSS_CONSULTA_DATOS: ' || SQLCODE || ' ' || SQLERRM;
      END;
END CVWSSS_CONSULTA_DATOS;

end SGA_CONSULTAS;
/
