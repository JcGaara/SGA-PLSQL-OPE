CREATE OR REPLACE TRIGGER OPERACION.T_OPE_RESTCONTRATA_AIUD
AFTER INSERT OR UPDATE OR DELETE
ON OPERACION.OPE_RESTCONTRATA REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
 /**************************************************************************
   NOMBRE:     T_OPE_RESTCONTRATA_AIUD
   PROPOSITO:  Genera log de la tabla OPE_RESTCONTRATA

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        17/12/2015  Miriam Mandujano  Se guardará el log de OPE_RESTCONTRATA.
  **************************************************************************/

DECLARE
nSecuencial number;
BEGIN
  SELECT SQ_OPE_RESTCONTRATA_LOG.NEXTVAL  INTO nSecuencial FROM dummy_ope;
  IF INSERTING THEN
     INSERT INTO HISTORICO.OPE_RESTCONTRATA_LOG
       (IDSECLOG,
        AREA,
        USUARIO_ASIG,
        CODUSU,
        FECUSU,
        ESTADO,
        TIPO)
     VALUES
       (nSecuencial,
        :NEW.AREA,
        :NEW.USUARIO_ASIG,
        :NEW.CODUSU,
        :NEW.FECUSU,
        :NEW.ESTADO,
        'I' );
  ELSIF UPDATING THEN
     INSERT INTO HISTORICO.OPE_RESTCONTRATA_LOG
     (IDSECLOG,
        AREA,
        USUARIO_ASIG,
        CODUSU,
        FECUSU,
        ESTADO,
        TIPO)
     VALUES
      (nSecuencial,
        :NEW.AREA,
        :NEW.USUARIO_ASIG,
        :NEW.CODUSU,
        :NEW.FECUSU,
        :NEW.ESTADO,
        'U'     );
  ELSIF DELETING THEN
     INSERT INTO HISTORICO.OPE_RESTCONTRATA_LOG
      (IDSECLOG,
        AREA,
        USUARIO_ASIG,
        CODUSU,
        FECUSU,
        ESTADO,
        TIPO)
     VALUES
      (nSecuencial,
        :NEW.AREA,
        :NEW.USUARIO_ASIG,
        :NEW.CODUSU,
        :NEW.FECUSU,
        :NEW.ESTADO,
        'D'       );
  END IF;
END;
/
