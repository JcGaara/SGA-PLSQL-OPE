CREATE OR REPLACE TRIGGER OPERACION.T_OPE_SRV_RECARGA_CAB_AIUD_LOG
   AFTER INSERT OR UPDATE OR DELETE
   ON OPERACION.OPE_SRV_RECARGA_CAB
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
  /************************************************************
       REVISIONS:
       Ver        Date        Author           Description
       --------  ----------  --------------  ------------------------
       1.0       02/02/2010  Antonio Lagos   Creacion, REQ 106908, registro en log
       2.0       05/05/2010  Antonio Lagos   REQ-119999,se cambia el nombre del trigger
                                             y referencias a tabla recargaproyectocliente_log por nuevo nombre
       3.0       03/08/2011  Ivan Untiveros  REQ-160463 Se agrega nuevo campo
       4.0       09/09/2011  Widmer Quispe   Recaudacion DTH
  ***********************************************************/
DECLARE
V_USUARIO_LOG VARCHAR2(100);
V_ACCION CHAR(1);
ID     NUMBER(18);
BEGIN

   SELECT MAX(osuser) INTO V_USUARIO_LOG
      FROM v$session
      WHERE AUDSID = ( SELECT USERENV('SESSIONID') FROM dummy_ope);

   --SELECT HISTORICO.SQ_RECARGAPROYECTOCLIENTE_LOG.NEXTVAL INTO ID FROM DUAL; --2.0
   SELECT HISTORICO.SQ_OPE_SRV_RECARGA_CAB_LOG.NEXTVAL INTO ID FROM dummy_ope; --2.0

   V_USUARIO_LOG := trim(RPAD(USER||'-'||V_USUARIO_LOG,50));

   IF INSERTING THEN
      V_ACCION := 'I';
      --INSERT INTO HISTORICO.RECARGAPROYECTOCLIENTE_LOG( --2.0
      INSERT INTO HISTORICO.OPE_SRV_RECARGA_CAB_LOG( --2.0
         id,
         numregistro,
         codigo_recarga,
         fecinivig,
         fecfinvig,
         fecalerta,
         feccorte,
         flg_recarga,
         tiporecarga,
         codcli,
         numslc,
         idpaq,
         codsolot,
         estado,
         usulog,
         feclog,
         acclog,
         flg_sc, --3.0
         --<4.0
         flg_trans_int,
         fec_trans_int,
         flg_trans_int_baja,
         fec_trans_int_baja
         --4.0>
      ) VALUES (
         ID,
         :NEW.numregistro,
         :NEW.codigo_recarga,
         :NEW.fecinivig,
         :NEW.fecfinvig,
         :NEW.fecalerta,
         :NEW.feccorte,
         :NEW.flg_recarga,
         :NEW.tiporecarga,
         :NEW.codcli,
         :NEW.numslc,
         :NEW.idpaq,
         :NEW.codsolot,
         :NEW.estado,
         V_USUARIO_LOG,
         SYSDATE,
         V_ACCION,
         :NEW.flg_sc,--3.0
         --<4.0
         :NEW.flg_trans_int,
         :NEW.fec_trans_int,
         :NEW.flg_trans_int_baja,
         :NEW.fec_trans_int_baja
         --4.0>
         );
   ELSIF UPDATING OR DELETING THEN
      IF UPDATING THEN
         V_ACCION := 'U';
      ELSIF DELETING THEN
         V_ACCION := 'D';
      END IF;
      --INSERT INTO HISTORICO.RECARGAPROYECTOCLIENTE_LOG( --2.0
      INSERT INTO HISTORICO.OPE_SRV_RECARGA_CAB_LOG( --2.0
         id,
         numregistro,
         codigo_recarga,
         fecinivig,
         fecfinvig,
         fecalerta,
         feccorte,
         flg_recarga,
         tiporecarga,
         codcli,
         numslc,
         idpaq,
         codsolot,
         estado,
         usulog,
         feclog,
         acclog,
         flg_sc, --3.0
         --<4.0
         flg_trans_int,
         fec_trans_int,
         flg_trans_int_baja,
         fec_trans_int_baja
         --4.0>
      ) VALUES (
         ID,
         :OLD.numregistro,
         :OLD.codigo_recarga,
         :OLD.fecinivig,
         :OLD.fecfinvig,
         :OLD.fecalerta,
         :OLD.feccorte,
         :OLD.flg_recarga,
         :OLD.tiporecarga,
         :OLD.codcli,
         :OLD.numslc,
         :OLD.idpaq,
         :OLD.codsolot,
         :OLD.estado,
         V_USUARIO_LOG,
         SYSDATE,
         V_ACCION,
         :OLD.flg_sc, --3.0
         --<4.0
         :OLD.flg_trans_int,
         :OLD.fec_trans_int,
         :OLD.flg_trans_int_baja,
         :OLD.fec_trans_int_baja
         --4.0>
         );
   END IF;
END;
/



