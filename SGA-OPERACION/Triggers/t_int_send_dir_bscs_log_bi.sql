CREATE OR REPLACE TRIGGER OPERACION.T_INT_SEND_DIR_BSCS_LOG_BI
BEFORE INSERT ON OPERACION.INT_SEND_DIR_BSCS_LOG
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
/* *************************************************************************************************
    NAME:        SALES.TRAMA_STMT
    REVISIONS:
    Ver          Date         Author          Description
    ---------    ----------  -------------    ------------------------------------------------------
    1.0          14/05/2014  Carlos Chamache  Inicializar registro de envio de dirección a la BSCS
************************************************************************************************* */
DECLARE
  sequence_id NUMBER;

BEGIN
  IF :NEW.id_send IS NULL THEN
    SELECT OPERACION.SQ_INT_SEND_DIR_BSCS_LOG.NEXTVAL
      INTO sequence_id
      FROM dual;
    :NEW.id_send := sequence_id;
  END IF;

  :NEW.Usureg := USER;
  :New.Fecreg := SYSDATE;
END;
/