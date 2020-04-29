CREATE OR REPLACE TRIGGER OPERACION.T_SOLOT_BI
BEFORE INSERT
ON OPERACION.SOLOT
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
  tmpVar     NUMBER;
  l_cad      VARCHAR2(10);
  maxsolot   number;
  logcosolot number;
BEGIN
  -- Se obtiene el numero de la llave
  IF :NEW.CODSOLOT IS NULL THEN
    SELECT F_Get_Clave_Solot() INTO :NEW.codsolot FROM DUAL;
  ELSE
    select SQ_SOLOT.Currval into maxsolot from dual;
    while (:new.codsolot > maxsolot) loop
      maxsolot := f_get_clave_solot;
      select SQ_CODSOLOT_LOG.nextval into logcosolot from dual;
      select SQ_SOLOT.Currval into maxsolot from dual;
    end loop;
  END IF;

  :NEW.fecusu    := SYSDATE;
  :NEW.derivado  := 0;
  :NEW.codusu    := USER;
  :NEW.fecultest := :NEW.fecusu;

  IF :NEW.codcli IS NULL THEN
    RAISE_APPLICATION_ERROR(-20500, 'No se especifico el cliente.');
  END IF;

  -- Informacion del Proyecto
  IF :NEW.numslc IS NOT NULL THEN
    BEGIN
      SELECT codcli
        INTO :NEW.codcli
        FROM vtatabslcfac
       WHERE numslc = :NEW.numslc;
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20500, 'Numero de proyecto invalido.');
    END;
  END IF;

  -- El area del solicitante
  IF :NEW.areasol IS NULL THEN
    SELECT F_Get_Area_Usuario() INTO :NEW.areasol FROM dual;
  END IF;

  -- Si se inserta ya aprobado
  IF :NEW.estsol = 11 THEN
    :NEW.fecapr    := :NEW.fecultest;
    :NEW.estsolope := 1; -- solot como En ejecucion
  END IF;

  --El Preciario por Default
  l_cad := Pq_Constantes.f_get_cfg;
  IF l_cad IN ('PER') THEN
    IF :NEW.codprec IS NULL THEN
      BEGIN
        SELECT codprec
          INTO :NEW.codprec
          FROM PRECIARIO
         WHERE flg_default = '1';
      EXCEPTION
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20500, 'Codigo de PRECIARIO invalido.');
      END;
    END IF;
  END IF;
  -- Se crea la solicitud como un Documento
  BEGIN
    tmpVar := 0;
    SELECT DOCID.NEXTVAL INTO tmpVar FROM dual;
    INSERT INTO DOC (docid, doctipid) VALUES (tmpVar, 2); -- inserta en la tabla documentos como tipo solicitud de OT
    :NEW.docid := tmpVar;
    INSERT INTO SOLOTCHGEST
      (codsolot, tipo, estado, fecha)
    VALUES
      (:NEW.codsolot, 1, :NEW.ESTSOL, SYSDATE);

  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20500,
                              'No se pudo insertar el correspondiente documento - ' ||
                              SQLERRM);
  END;
END;
/



