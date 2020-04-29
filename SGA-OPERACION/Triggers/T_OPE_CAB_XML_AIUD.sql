CREATE OR REPLACE TRIGGER OPERACION.T_OPE_CAB_XML_AIUD
AFTER INSERT OR UPDATE OR DELETE
ON OPERACION.OPE_CAB_XML REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
 /**************************************************************************
   NOMBRE:     T_OPE_CAB_XML_AIUD
   PROPOSITO:  Genera log de detalle de xml

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        03/11/2015  Miriam Mandujano  Se guardará el log de OPE_CAB_XML.
  **************************************************************************/

DECLARE
nSecuencial number;
BEGIN
  SELECT SQ_OPE_CAB_XML_LOG.NEXTVAL  INTO nSecuencial FROM dummy_ope;
  IF INSERTING THEN
     INSERT INTO HISTORICO.OPE_CAB_XML_LOG  
       (IDSECLOG,
        IDCAB,
        PROGRAMA,
        NOMBREXML,
        TITULO,
        RFC,
        METODO,
        DESCRIPCION,
        XML,
        TARGET_URL,
        IPAPP,
        USUARIOAPP,
        FECUSU,
        PCAPP,
        XMLCLOB,
        TIPO)
     VALUES
       (nSecuencial,
        :NEW.IDCAB,
        :NEW.PROGRAMA,
        :NEW.NOMBREXML,
        :NEW.TITULO,
        :NEW.RFC,
        :NEW.METODO,
        :NEW.DESCRIPCION,
        :NEW.XML,
        :NEW.TARGET_URL,
        :NEW.IPAPP,
        :NEW.USUARIOAPP,
        :NEW.FECUSU,
        :NEW.PCAPP,
        :NEW.XMLCLOB,
        'I');
  ELSIF UPDATING THEN
     INSERT INTO HISTORICO.OPE_CAB_XML_LOG
     (IDSECLOG,
        IDCAB,
        PROGRAMA,
        NOMBREXML,
        TITULO,
        RFC,
        METODO,
        DESCRIPCION,
        XML,
        TARGET_URL,
        IPAPP,
        USUARIOAPP,
        FECUSU,
        PCAPP,
        XMLCLOB,
        TIPO)
     VALUES
     (nSecuencial,
      :NEW.IDCAB,
      :NEW.PROGRAMA,
      :NEW.NOMBREXML,
      :NEW.TITULO,
      :NEW.RFC,
      :NEW.METODO,
      :NEW.DESCRIPCION,
      :NEW.XML,
      :NEW.TARGET_URL,
      :NEW.IPAPP,
      :NEW.USUARIOAPP,
      :NEW.FECUSU,
      :NEW.PCAPP,
      :NEW.XMLCLOB,
      'U');
  ELSIF DELETING THEN
     INSERT INTO HISTORICO.OPE_CAB_XML_LOG
       (IDSECLOG,
        IDCAB,
        PROGRAMA,
        NOMBREXML,
        TITULO,
        RFC,
        METODO,
        DESCRIPCION,
        XML,
        TARGET_URL,
        IPAPP,
        USUARIOAPP,
        FECUSU,
        PCAPP,
        XMLCLOB,
        TIPO)
     VALUES
       (nSecuencial,
        :OLD.IDCAB,
        :OLD.PROGRAMA,
        :OLD.NOMBREXML,
        :OLD.TITULO,
        :OLD.RFC,
        :OLD.METODO,
        :OLD.DESCRIPCION,
        :OLD.XML,
        :OLD.TARGET_URL,
        :OLD.IPAPP,
        :OLD.USUARIOAPP,
        :OLD.FECUSU,
        :OLD.PCAPP,
        :OLD.XMLCLOB,
        'D');
  END IF;
END;
/
