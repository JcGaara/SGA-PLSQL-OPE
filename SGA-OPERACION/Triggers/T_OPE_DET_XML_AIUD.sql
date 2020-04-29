CREATE OR REPLACE TRIGGER OPERACION.T_OPE_DET_XML_AIUD
AFTER INSERT OR UPDATE OR DELETE
ON OPERACION.OPE_DET_XML REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
 /**************************************************************************
   NOMBRE:     T_OPE_DET_XML_AIUD
   PROPOSITO:  Genera log de detalle de xml

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        03/11/2015  Miriam Mandujano  Se guardará el log de OPE_DET_XML.
  **************************************************************************/

DECLARE
nSecuencial number;
BEGIN
  SELECT SQ_OPE_DET_XML_LOG.NEXTVAL  INTO nSecuencial FROM dummy_ope;
  IF INSERTING THEN
     INSERT INTO HISTORICO.OPE_DET_XML_LOG
       (IDSECLOG,
        IDCAB,
        IDSEQ,
        CAMPO,
        NOMBRECAMPO,
        IPAPP,
        USUARIOAPP,
        FECUSU,
        PCAPP,
        TIPO,
        ESTADO,
        ORDEN,
        DESCRIPCION,
        TIPO_ACCION)
     VALUES
       (nSecuencial,
        :NEW.IDCAB,
        :NEW.IDSEQ,
        :NEW.CAMPO,
        :NEW.NOMBRECAMPO,
        :NEW.IPAPP,
        :NEW.USUARIOAPP,
        :NEW.FECUSU,
        :NEW.PCAPP,
        :NEW.TIPO,
        :NEW.ESTADO,
        :NEW.ORDEN,
        :NEW.DESCRIPCION,
        'I');
  ELSIF UPDATING THEN
     INSERT INTO HISTORICO.OPE_DET_XML_LOG
     (IDSECLOG,
        IDCAB,
        IDSEQ,
        CAMPO,
        NOMBRECAMPO,
        IPAPP,
        USUARIOAPP,
        FECUSU,
        PCAPP,
        TIPO,
        ESTADO,
        ORDEN,
        DESCRIPCION,
        TIPO_ACCION)
     VALUES
     (nSecuencial,
      :NEW.IDCAB,
      :NEW.IDSEQ,
      :NEW.CAMPO,
      :NEW.NOMBRECAMPO,
      :NEW.IPAPP,
      :NEW.USUARIOAPP,
      :NEW.FECUSU,
      :NEW.PCAPP,
      :NEW.TIPO,
      :NEW.ESTADO,
      :NEW.ORDEN,
      :NEW.DESCRIPCION,
      'U');
  ELSIF DELETING THEN
     INSERT INTO HISTORICO.OPE_DET_XML_LOG
       (IDSECLOG,
        IDCAB,
        IDSEQ,
        CAMPO,
        NOMBRECAMPO,
        IPAPP,
        USUARIOAPP,
        FECUSU,
        PCAPP,
        TIPO,
        ESTADO,
        ORDEN,
        DESCRIPCION,
        TIPO_ACCION )
     VALUES
       (nSecuencial,
        :OLD.IDCAB,
        :OLD.IDSEQ,
        :OLD.CAMPO,
        :OLD.NOMBRECAMPO,
        :OLD.IPAPP,
        :OLD.USUARIOAPP,
        :OLD.FECUSU,
        :OLD.PCAPP,
        :OLD.TIPO,
        :OLD.ESTADO,
        :OLD.ORDEN,
        :OLD.DESCRIPCION,
        'D');
  END IF;
END;
/
