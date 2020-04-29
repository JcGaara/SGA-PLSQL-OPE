CREATE OR REPLACE PROCEDURE OPERACION.P_SAP_LLENA_TMP_SAPSGA_PEP2(L_NUMSCL   CHAR,
                                                                  L_CODSOLOT NUMBER,
                                                                  CFG        VARCHAR) is
BEGIN
  begin
    
    INSERT INTO TMP_INTERFACE_SAPSGA_PEP2
      (A_NUMSCL,
       A_CODSOLOT,
       A_CFG,
       ESTADO,
       USUARIO,
       FECHAREGISTRO,
       FECHAEJECUCION)
    VALUES
      (L_NUMSCL, L_CODSOLOT, CFG, 0, USER, SYSDATE, SYSDATE);

  exception
    when others then
      RAISE_APPLICATION_ERROR(-20500,
                              'No se pudo insertat en la tabla  TMP_INTERFACE_SAPSGA_PEP2- ' ||
                              SQLERRM);
  end;

END;
/


