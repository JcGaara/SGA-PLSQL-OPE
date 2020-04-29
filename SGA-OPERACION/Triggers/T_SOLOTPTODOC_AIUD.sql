CREATE OR REPLACE TRIGGER OPERACION.T_solotptodoc_AIUD
AFTER INSERT OR UPDATE OR DELETE
ON OPERACION.solotptodoc REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
 /**************************************************************************
   NOMBRE:     T_solotptodoc_AIUD
   PROPOSITO:  Genera log de documentos

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        16/03/2014  Edilberto Astulle PROY-13360 IDEA-17126 - Modificacion funcionalidad planta externa
   **************************************************************************/

DECLARE
nSecuencial number;
BEGIN

  SELECT OPERACION.SQ_SOLOTPTODOC_LOG.NEXTVAL  INTO nSecuencial FROM dummy_ope;
  IF INSERTING THEN
     INSERT INTO HISTORICO.SOLOTPTODOC_LOG
       (IDSEQ,
        TIPO_ACC_LOG,
        CODSOLOT,
        PUNTO,
        ORDEN,
        CODINSSRV,
        TIPDOC,
        ESTADO,
        DESCRIPCION,
        OBSERVACION,
        FLGFASE,
        CODCON,
        MONTOTOTAL,
        ORDEN_SOT)
     VALUES
       (nSecuencial,
        'I',
        :new.CODSOLOT,
        :new.PUNTO,
        :new.ORDEN,
        :new.CODINSSRV,
        :new.TIPDOC,
        :new.ESTADO,
        :new.DESCRIPCION,
        :new.OBSERVACION,
        :new.FLGFASE,
        :new.CODCON,
        :new.MONTOTOTAL,
        :new.ORDEN_SOT);
  ELSIF UPDATING THEN
     INSERT INTO HISTORICO.SOLOTPTODOC_LOG
     (IDSEQ,
      TIPO_ACC_LOG,
      CODSOLOT,
      PUNTO,
      ORDEN,
      CODINSSRV,
      TIPDOC,
      ESTADO,
      DESCRIPCION,
      OBSERVACION,
      FLGFASE,
      CODCON,
      MONTOTOTAL,
      ORDEN_SOT )
     VALUES
     (nSecuencial,
      'U',
      :new.CODSOLOT,
      :new.PUNTO,
      :new.ORDEN,
      :new.CODINSSRV,
      :new.TIPDOC,
      :new.ESTADO,
      :new.DESCRIPCION,
      :new.OBSERVACION,
      :new.FLGFASE,
      :new.CODCON,
      :new.MONTOTOTAL,
      :new.ORDEN_SOT      );
  ELSIF DELETING THEN
     INSERT INTO HISTORICO.SOLOTPTODOC_LOG
       (IDSEQ,
        TIPO_ACC_LOG,
        CODSOLOT,
        PUNTO,
        ORDEN,
        CODINSSRV,
        TIPDOC,
        ESTADO,
        DESCRIPCION,
        OBSERVACION,
        FLGFASE,
        CODCON,
        MONTOTOTAL,
        ORDEN_SOT)
     VALUES
       (nSecuencial,
        'D',
        :old.CODSOLOT,
        :old.PUNTO,
        :old.ORDEN,
        :old.CODINSSRV,
        :old.TIPDOC,
        :old.ESTADO,
        :old.DESCRIPCION,
        :old.OBSERVACION,
        :old.FLGFASE,
        :old.CODCON,
        :old.MONTOTOTAL,
        :old.ORDEN_SOT);
  END IF;
END;
/