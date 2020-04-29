CREATE OR REPLACE TRIGGER OPERACION.T_AREAOPE_AIUD
AFTER INSERT OR UPDATE OR DELETE ON operacion.AREAOPE
REFERENCING OLD AS OLD NEW AS NEW
for each ROW
 /**************************************************************************
   NOMBRE:     T_AREAOPE_AIUD
   PROPOSITO:  Genera log de AREAOPE

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        16/10/2014  Lady Curay      Se guardará el log de AREAOPE despues de insertar, actualizar o antes de borrar registro.
   **************************************************************************/

DECLARE
  nSecuencial NUMBER;
  l_action    VARCHAR2(1);
BEGIN
  SELECT HISTORICO.SQ_AREAOPE_Log.NEXTVAL INTO nSecuencial FROM dummy_ope;

  IF INSERTING THEN
    l_action := 'I';
  
    INSERT INTO HISTORICO.AREAOPE_LOG
      (AREA,
       DESCRIPCION,
       FLGDERPRV,
       ESTADO,
       CODDPT,
       CODUSU,
       FECUSU,
       FLGCC,
       DESCABR,
       CADCAMPOS,
       CADCAMPOS1,
       AREA_OF_REQ,
       AREA_OF_OPERA,
       CECO_SAP,
       EMPRESA,
       CONTRATA,
       IDLOG,
       ACCION_LOG
          )
    VALUES
      (:new.area,
       :NEW.DESCRIPCION,
       :new.FLGDERPRV,
       :new.ESTADO,
       :new.CODDPT,
       :new.CODUSU,
       :new.FECUSU,
       :new.FLGCC,
       :new.DESCABR,
       :new.CADCAMPOS,
       :new.CADCAMPOS1,
       :new.AREA_OF_REQ,
       :new.AREA_OF_OPERA,
       :new.CECO_SAP,
       :new.EMPRESA,
       :new.CONTRATA,
       nSecuencial,
       l_action
       );
  
  ELSIF UPDATING THEN
    l_action := 'U';
   INSERT INTO HISTORICO.AREAOPE_LOG
      (AREA,
       DESCRIPCION,
       FLGDERPRV,
       ESTADO,
       CODDPT,
       CODUSU,
       FECUSU,
       FLGCC,
       DESCABR,
       CADCAMPOS,
       CADCAMPOS1,
       AREA_OF_REQ,
       AREA_OF_OPERA,
       CECO_SAP,
       EMPRESA,
       CONTRATA,
       IDLOG,
       ACCION_LOG
          )
    VALUES
      (:new.area,
       :NEW.DESCRIPCION,
       :new.FLGDERPRV,
       :new.ESTADO,
       :new.CODDPT,
       :new.CODUSU,
       :new.FECUSU,
       :new.FLGCC,
       :new.DESCABR,
       :new.CADCAMPOS,
       :new.CADCAMPOS1,
       :new.AREA_OF_REQ,
       :new.AREA_OF_OPERA,
       :new.CECO_SAP,
       :new.EMPRESA,
       :new.CONTRATA,
       nSecuencial,
       l_action
       );
  
  ELSIF DELETING THEN
    l_action := 'D';
    INSERT INTO HISTORICO.AREAOPE_LOG
      (AREA,
       DESCRIPCION,
       FLGDERPRV,
       ESTADO,
       CODDPT,
       CODUSU,
       FECUSU,
       FLGCC,
       DESCABR,
       CADCAMPOS,
       CADCAMPOS1,
       AREA_OF_REQ,
       AREA_OF_OPERA,
       CECO_SAP,
       EMPRESA,
       CONTRATA,
       IDLOG,
       ACCION_LOG
       )
    VALUES
      (:old.area,
       :old.DESCRIPCION,
       :old.FLGDERPRV,
       :old.ESTADO,
       :old.CODDPT,
       :old.CODUSU,
       :old.FECUSU,
       :old.FLGCC,
       :old.DESCABR,
       :old.CADCAMPOS,
       :old.CADCAMPOS1,
       :old.AREA_OF_REQ,
       :old.AREA_OF_OPERA,
       :old.CECO_SAP,
       :old.EMPRESA,
       :old.CONTRATA,
       nSecuencial,
       l_action
       );
  END IF;
END;
/
