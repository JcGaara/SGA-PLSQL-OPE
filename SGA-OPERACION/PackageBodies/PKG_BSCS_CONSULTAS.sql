create or replace package body OPERACION.PKG_BSCS_CONSULTAS is

   procedure SGASS_CONSULTA_LINEAS(PI_TIPODOCUMENTO IN VARCHAR2,
                                   PI_DOCUMENTO     IN VARCHAR2,
                                   PO_CURSOR        OUT SYS_REFCURSOR,
                                   PO_CODERROR      OUT NUMBER,
                                   PO_MSJERROR      OUT VARCHAR2) is
   
   begin
   
      OPEN PO_CURSOR FOR
         SELECT A.TIPDIDE,
                A.NTDIDE,
                B.CO_ID,
                B.NUMERO,
                (SELECT MAX(TPSOL.DESCRIPCION)
                   FROM SOLOT S
                  INNER JOIN SOLOTPTO SP
                     ON S.CODSOLOT = SP.CODSOLOT
                  INNER JOIN ESTSOL ESOL
                     ON ESOL.ESTSOL = S.ESTSOL
                  INNER JOIN TIPESTSOL TPSOL
                     ON TPSOL.TIPESTSOL = ESOL.TIPESTSOL
                  WHERE SP.CODINSSRV = B.CODINSSRV) ESTADO
           FROM VTATABCLI A, INSSRV B
          WHERE A.CODCLI = B.CODCLI
            AND EXISTS (SELECT 1 FROM NUMTEL WHERE NUMERO = B.NUMERO)
            AND B.ESTINSSRV IN (1, 2)
            AND A.TIPDIDE = PI_TIPODOCUMENTO --TIDPO DOCUMENTO
            AND A.NTDIDE = PI_DOCUMENTO --NUMERO DOCUMENTO
         UNION
         SELECT A.TIPDIDE, A.NTDIDE, B.CO_ID, B.NUMERO, TPSOL.DESCRIPCION ESTADO
           FROM VTATABCLI A, INSSRV B, SOLOTPTO C, SOLOT D, ESTSOL ESOL, TIPESTSOL TPSOL
          WHERE A.CODCLI = B.CODCLI
            AND C.CODSOLOT = D.CODSOLOT
            AND A.CODCLI = D.CODCLI
            AND B.CODINSSRV = C.CODINSSRV
            AND ESOL.ESTSOL = D.ESTSOL
            AND TPSOL.TIPESTSOL = ESOL.TIPESTSOL
            AND EXISTS (SELECT 1 FROM NUMTEL WHERE NUMERO = B.NUMERO)
            AND B.ESTINSSRV IN (4)
            AND A.TIPDIDE = PI_TIPODOCUMENTO --TIDPO DOCUMENTO
            AND A.NTDIDE = PI_DOCUMENTO; --NUMERO DOCUMENTO
   
      PO_CODERROR := 0;
      PO_MSJERROR := 'Consulta realizada con exito.';
   
   EXCEPTION
      WHEN OTHERS THEN
         PO_CODERROR := -99;
         PO_MSJERROR := UTL_LMS.format_message('Modulo y Linea : %s , Error : %s',
                                               DBMS_UTILITY.format_error_backtrace(),
                                               SQLERRM);
   end SGASS_CONSULTA_LINEAS;

end PKG_BSCS_CONSULTAS;
/