CREATE OR REPLACE TRIGGER OPERACION.T_EF_BU_LOG_PE
   BEFORE UPDATE ON OPERACION.EF
   FOR EACH ROW
DECLARE
/****************************************************************
Log de Auditoria sobre campos basicos

   Fecha       Autor            Descripcion
   ----------  ---------------  ---------------------------------
   22/12/2004  Carlos Corrales    Creacion
*****************************************************************/
   L_USUARIO_LOG VARCHAR2(100);
BEGIN
   IF UPDATING('CODCLI') OR UPDATING('COSMO') OR UPDATING('COSMAT') OR
      UPDATING('COSEQU') OR UPDATING('COSMO_S') OR UPDATING('COSMAT_S') OR UPDATING('NUMDIAPLA') OR UPDATING('CODPREC') THEN
      SELECT MAX(osuser) INTO L_USUARIO_LOG FROM v$session
         WHERE AUDSID = ( SELECT USERENV('SESSIONID') FROM dual);
      L_USUARIO_LOG := trim(RPAD(USER||'-'||L_USUARIO_LOG,50));

       INSERT INTO OPERACION.EF_LOG (
          CODEF, CODCLI, COSMO,
          COSMAT, COSEQU, COSMO_S,
          COSMAT_S, NUMDIAPLA, CODPREC,
          USUREG, FECREG)
       VALUES ( :OLD.CODEF, :OLD.CODCLI, :OLD.COSMO,
          :OLD.COSMAT, :OLD.COSEQU, :OLD.COSMO_S,
          :OLD.COSMAT_S, :OLD.NUMDIAPLA, :OLD.CODPREC,
          L_USUARIO_LOG, SYSDATE );
   END IF;
END;
/



