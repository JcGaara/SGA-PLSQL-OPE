CREATE OR REPLACE TRIGGER OPERACION.T_TRSBAMBAF_AIUD
AFTER INSERT OR UPDATE OR DELETE
ON OPERACION.TRSBAMBAF REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
 /**************************************************************************
   NOMBRE:     T_trsbambaf_AIUD
   PROPOSITO:  Genera log de trsbambaf
   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        16/03/2010  Edilberto Astulle PROY-4386 Gestión automática de Cobranza entre los planes BAM y BAF
   **************************************************************************/

DECLARE
nSecuencial number;
BEGIN
  SELECT operacion.SQ_trsbambaf_LOG.NEXTVAL  INTO nSecuencial FROM dummy_ope;
  IF INSERTING THEN
     INSERT INTO HISTORICO.TRSBAMBAF_LOG
      (IDSEQ,
      IDBAM,
      CODINSSRV,
      IDTRANCORTE,
      TIPTRS,
      FECEJE,
      FECPROG,
      EST_ENVIO,
      ID_MENSAJE,
      OBSERV,
      TIPTRA,
      FECUSU,
      CODUSU,
      SEQ_LOTE_BAM,
      CODSOLOT,
      FECACT,
      ID_CONEXION,
      ID_ERROR,
      TIPACTPV,
      N_REINTENTOS,
      AUD_PC,
      AUD_IP,
      EST_BAM_BSCS,
      TIPO_ACC_LOG )
     VALUES
      (nSecuencial,
      :NEW.IDBAM,
      :NEW.CODINSSRV,
      :NEW.IDTRANCORTE,
      :NEW.TIPTRS,
      :NEW.FECEJE,
      :NEW.FECPROG,
      :NEW.EST_ENVIO,
      :NEW.ID_MENSAJE,
      :NEW.OBSERV,
      :NEW.TIPTRA,
      sysdate,
      user,
      :NEW.SEQ_LOTE_BAM,
      :NEW.CODSOLOT,
      :NEW.FECACT,
      :NEW.ID_CONEXION,
      :NEW.ID_ERROR,
      :NEW.TIPACTPV,
      :NEW.N_REINTENTOS,  
      :NEW.AUD_PC,
      :NEW.AUD_IP, 
      :NEW.EST_BAM_BSCS,
      'I' );
  ELSIF UPDATING THEN
     INSERT INTO HISTORICO.TRSBAMBAF_LOG
     (IDSEQ,
      IDBAM,
      CODINSSRV,
      IDTRANCORTE,
      TIPTRS,
      FECEJE,
      FECPROG,
      EST_ENVIO,
      ID_MENSAJE,
      OBSERV,
      TIPTRA,
      FECUSU,
      CODUSU,
      SEQ_LOTE_BAM,
      CODSOLOT,
      FECACT,
      ID_CONEXION,
      ID_ERROR,
      TIPACTPV,
      N_REINTENTOS,   
      AUD_PC,
      AUD_IP,
      EST_BAM_BSCS,
      TIPO_ACC_LOG  )
     VALUES
     (nSecuencial,
      :NEW.IDBAM,
      :NEW.CODINSSRV,
      :NEW.IDTRANCORTE,
      :NEW.TIPTRS,
      :NEW.FECEJE,
      :NEW.FECPROG,
      :NEW.EST_ENVIO,
      :NEW.ID_MENSAJE,
      :NEW.OBSERV,
      :NEW.TIPTRA,
      sysdate,
      user,
      :NEW.SEQ_LOTE_BAM,
      :NEW.CODSOLOT,
      :NEW.FECACT,
      :NEW.ID_CONEXION,
      :NEW.ID_ERROR,
      :NEW.TIPACTPV,
      :NEW.N_REINTENTOS,   
      :NEW.AUD_PC,
      :NEW.AUD_IP,      
      :NEW.EST_BAM_BSCS,
      'U' );
  ELSIF DELETING THEN
     INSERT INTO HISTORICO.TRSBAMBAF_LOG
     (IDSEQ,
      IDBAM,
      CODINSSRV,
      IDTRANCORTE,
      TIPTRS,
      FECEJE,
      FECPROG,
      EST_ENVIO,
      ID_MENSAJE,
      OBSERV,
      TIPTRA,
      FECUSU,
      CODUSU,
      SEQ_LOTE_BAM,
      CODSOLOT,
      FECACT,
      ID_CONEXION,
      ID_ERROR,
      TIPACTPV,
      N_REINTENTOS,
      AUD_PC,
      AUD_IP,
      EST_BAM_BSCS,
      TIPO_ACC_LOG )
     VALUES
      (nSecuencial,
      :NEW.IDBAM,
      :NEW.CODINSSRV,
      :NEW.IDTRANCORTE,
      :NEW.TIPTRS,
      :NEW.FECEJE,
      :NEW.FECPROG,
      :NEW.EST_ENVIO,
      :NEW.ID_MENSAJE,
      :NEW.OBSERV,
      :NEW.TIPTRA,
      sysdate,
      user,
      :NEW.SEQ_LOTE_BAM,
      :NEW.CODSOLOT,
      :NEW.FECACT,
      :NEW.ID_CONEXION,
      :NEW.ID_ERROR,
      :NEW.TIPACTPV,
      :NEW.N_REINTENTOS,  
      :NEW.AUD_PC,
      :NEW.AUD_IP,      
      :OLD.EST_BAM_BSCS,
      'D' );
  END IF;

END;
/
