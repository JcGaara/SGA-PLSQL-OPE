CREATE OR REPLACE TRIGGER OPERACION.T_MOTIVO_TIPTRABAJO_BI
BEFORE INSERT
ON OPERACION.MOTIVO_TIPTRABAJO
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE

BEGIN
  -- Se obtiene el numero de la llave
  IF :new.codmottip is null then
  SELECT OPERACION.SQ_MOTIVO_TIPTRABAJO.NEXTVAL
         INTO :new.codmottip
  FROM DUAL;
  END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20500,
                              'No se pudo insertar el detalle motivo - tipotrabajo - ' ||
                              SQLERRM);
  END;
/



