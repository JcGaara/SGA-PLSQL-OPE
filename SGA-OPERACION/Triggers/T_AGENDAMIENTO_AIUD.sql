CREATE OR REPLACE TRIGGER OPERACION.T_AGENDAMIENTO_AIUD
AFTER INSERT OR UPDATE OR DELETE
ON OPERACION.AGENDAMIENTO REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
 /**************************************************************************
   NOMBRE:     T_AGENDAMIENTO_AIUD
   PROPOSITO:  Genera log de agendamiento

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        16/03/2010  Marcos Echevarria REQ. 107706: Se guardará el log de agendamiento despues de insertar, actualizar o borrar registro.
   2.0        16/12/2010  Antonio Lagos     REQ. 134845: se agrega campo area
   3.0        16/01/2012  Edilberto Astulle PROY-1332 Motivos de SOT por Tipo de Trabajo
   4.0        26/01/2012  Edilberto Astulle PROY-1875 Mejorar el proceso de Bajas HFC a nivel de Intraway
   5.0        16/06/2012  Edilberto Astulle PROY_3433_AgendamientoenLineaOperaciones
   6.0        29/06/2012  Edilberto Astulle IDEA-4694  Gestion Instalacion/PostVenta IM DTH
   7.0        13/02/2012  Edilberto Astulle PROY-6885_Modificaciones en SGA Operaciones y Sistema Tecnico
   8.0        02/05/2014  Edilberto Astulle SD_1063609
   **************************************************************************/

DECLARE
nSecuencial number;
BEGIN
  SELECT SQ_AGENDAMIENTO_LOG.NEXTVAL  INTO nSecuencial FROM dummy_ope;
  IF INSERTING THEN
     INSERT INTO OPERACION.AGENDAMIENTO_LOG
       (IDSEQ,
        IDAGENDA,
        CODCON,
        CODCLI,
        FECPROG,
        FECAGENDA,
        CODINCIDENCE,
        ESTAGE,
        OBSERVACION,
        ACTA_INSTALACION,
        --ini 2.0
        AREA,
        --fin 2.0
        --ini 3.0
        CID,
        CODINSSRV,
        NUMERO,
        --fin 3.0
        --ini 4.0
        MOTSOL_INT ,
        MOTSOL_INTCAB ,
        MOTSOL_INTTEL  ,
        MOTSOL_INTTELCAB ,
        MOTSOL_CAB ,
        MOTSOL_CABINT ,
        MOTSOL_TEL ,
        MOTSOL_PEXT ,
        PRIORIZADO ,
        --fin 4.0
        TIPO_ACC_LOG,
        CODCUADRILLA, NUMVECES,TIPO,instalador2)--8.0
     VALUES
       (nSecuencial,
        :NEW.IDAGENDA,
        :NEW.CODCON,
        :NEW.CODCLI,
        :NEW.FECPROG,
        :NEW.FECAGENDA,--6.0
        :NEW.CODINCIDENCE,
        :NEW.ESTAGE,
        :NEW.OBSERVACION,
        :NEW.ACTA_INSTALACION,
        --ini 2.0
        :NEW.AREA,
        --fin 2.0
        --ini 3.0
        :NEW.CID,
        :NEW.CODINSSRV,
        :NEW.NUMERO,
        --fin 3.0
        --ini 4.0
        :NEW.MOTSOL_INT ,
        :NEW.MOTSOL_INTCAB  ,
        :NEW.MOTSOL_INTTEL  ,
        :NEW.MOTSOL_INTTELCAB ,
        :NEW.MOTSOL_CAB ,
        :NEW.MOTSOL_CABINT ,
        :NEW.MOTSOL_TEL ,
        :NEW.MOTSOL_PEXT ,
        :NEW.PRIORIZADO ,
        --fin 4.0
        'I',
        :NEW.CODCUADRILLA,:NEW.NUMVECES,:NEW.TIPO,:NEW.instalador2);--8.0
  ELSIF UPDATING THEN
     INSERT INTO OPERACION.AGENDAMIENTO_LOG
     (IDSEQ,
      IDAGENDA,
      CODCON,
      CODCLI,
      FECPROG,
      FECAGENDA,
      CODINCIDENCE,
      ESTAGE,
      OBSERVACION,
      --ini 2.0
      AREA,
      --fin 2.0
      ACTA_INSTALACION,
        --ini 3.0
        CID,
        CODINSSRV,
        NUMERO,
        --fin 3.0
        --ini 4.0
        MOTSOL_INT ,
        MOTSOL_INTCAB ,
        MOTSOL_INTTEL  ,
        MOTSOL_INTTELCAB ,
        MOTSOL_CAB ,
        MOTSOL_CABINT ,
        MOTSOL_TEL ,
        MOTSOL_PEXT ,
        PRIORIZADO ,
        --fin 4.0
      TIPO_ACC_LOG,
      CODCUADRILLA,NUMVECES,TIPO,instalador2)--8.0
     VALUES
     (nSecuencial,
      :NEW.IDAGENDA,
      :NEW.CODCON,
      :NEW.CODCLI,
      :NEW.FECPROG,
      :NEW.FECAGENDA,--6.0
      :NEW.CODINCIDENCE,
      :NEW.ESTAGE,
      :NEW.OBSERVACION,
      --ini 2.0
      :NEW.AREA,
      --fin 2.0
      :NEW.ACTA_INSTALACION,
        --ini 3.0
      :NEW.CID,
      :NEW.CODINSSRV,
      :NEW.NUMERO,
        --fin 3.0
        --ini 4.0
        :NEW.MOTSOL_INT ,
        :NEW.MOTSOL_INTCAB  ,
        :NEW.MOTSOL_INTTEL  ,
        :NEW.MOTSOL_INTTELCAB ,
        :NEW.MOTSOL_CAB ,
        :NEW.MOTSOL_CABINT ,
        :NEW.MOTSOL_TEL ,
        :NEW.MOTSOL_PEXT ,
        :NEW.PRIORIZADO,
        --fin 4.0
      'U',
         :NEW.CODCUADRILLA,:NEW.NUMVECES,:NEW.TIPO,:NEW.instalador2);--8.0
  ELSIF DELETING THEN
     INSERT INTO OPERACION.AGENDAMIENTO_LOG
       (IDSEQ,
        IDAGENDA,
        CODCON,
        CODCLI,
        FECPROG,
        FECAGENDA,
        CODINCIDENCE,
        ESTAGE,
        OBSERVACION,
        ACTA_INSTALACION,
        --ini 2.0
        AREA,
        --fin 2.0
        --ini 3.0
        CID,
        CODINSSRV,
        NUMERO,
        --fin 3.0
        --ini 4.0
        MOTSOL_INT ,
        MOTSOL_INTCAB ,
        MOTSOL_INTTEL  ,
        MOTSOL_INTTELCAB ,
        MOTSOL_CAB ,
        MOTSOL_CABINT ,
        MOTSOL_TEL ,
        MOTSOL_PEXT ,
        PRIORIZADO ,
        --fin 4.0
        TIPO_ACC_LOG,
        CODCUADRILLA,NUMVECES,TIPO,instalador2)--8.0
     VALUES
       (nSecuencial,
        :OLD.IDAGENDA,
        :OLD.CODCON,
        :OLD.CODCLI,
        :OLD.FECPROG,
        :OLD.FECAGENDA,--6.0
        :OLD.CODINCIDENCE,
        :OLD.ESTAGE,
        :OLD.OBSERVACION,
        :OLD.ACTA_INSTALACION,
        --ini 2.0
        :OLD.AREA,
      --fin 2.0
        --ini 3.0
        :OLD.CID,
        :OLD.CODINSSRV,
        :OLD.NUMERO,
        --fin 3.0
        --ini 4.0
        :OLD.MOTSOL_INT ,
        :OLD.MOTSOL_INTCAB  ,
        :OLD.MOTSOL_INTTEL  ,
        :OLD.MOTSOL_INTTELCAB ,
        :OLD.MOTSOL_CAB ,
        :OLD.MOTSOL_CABINT ,
        :OLD.MOTSOL_TEL ,
        :OLD.MOTSOL_PEXT ,
        :OLD.PRIORIZADO ,
        --fin 4.0
        'D',
        :OLD.CODCUADRILLA,:OLD.NUMVECES,:NEW.TIPO,:NEW.instalador2);--8.0
  END IF;
END;
/