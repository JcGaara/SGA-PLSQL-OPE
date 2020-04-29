CREATE OR REPLACE TRIGGER "OPERACION"."T_OPE_SP_MAT_EQU_CAB_AIUD"
   AFTER INSERT OR UPDATE OR DELETE
   ON OPERACION.OPE_SP_MAT_EQU_CAB
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
  /************************************************************
       REVISIONS:
       Ver        Date        Author           Description
       --------  ----------  --------------  ------------------------
       1.0       16/09/2011  Tommy Arakaki   REQ 159960 - Requisicion Materiels y Equipos
  ***********************************************************/
DECLARE
V_USUARIO_LOG VARCHAR2(100);
V_ACCION CHAR(1);
ID     NUMBER(18);
BEGIN

   SELECT MAX(osuser) INTO V_USUARIO_LOG
      FROM v$session
      WHERE AUDSID = ( SELECT USERENV('SESSIONID') FROM dummy_ope);

   SELECT HISTORICO.SQ_OPE_SP_MAT_EQU_CAB_LOG.NEXTVAL INTO ID FROM dummy_ope; --2.0

   V_USUARIO_LOG := trim(RPAD(USER||'-'||V_USUARIO_LOG,50));

   IF INSERTING THEN
      V_ACCION := 'I';
      INSERT INTO HISTORICO.OPE_SP_MAT_EQU_CAB_LOG(
IDSPCAB,
ESTADO,
RESPONSABLE,
DESCRIPCION,
TEXTO_COMPLEMENTARIO,
SOLICITANTE,
AREA_SOLICITANTE,
USUREG,
FECREG,
USUMOD,
FECMOD,
ACCION
      ) VALUES (
:new.IDSPCAB,
:new.ESTADO,
:new.RESPONSABLE,
:new.DESCRIPCION,
:new.TEXTO_COMPLEMENTARIO,
:new.SOLICITANTE,
:new.AREA_SOLICITANTE,
:new.USUREG,
:new.FECREG,
:new.USUMOD,
:new.FECMOD,
V_ACCION);
   ELSIF UPDATING OR DELETING THEN
      IF UPDATING THEN
         V_ACCION := 'U';
      ELSIF DELETING THEN
         V_ACCION := 'D';
      END IF;
      INSERT INTO HISTORICO.OPE_SP_MAT_EQU_CAB_LOG(
      IDSPCAB,
      ESTADO,
      RESPONSABLE,
      DESCRIPCION,
      TEXTO_COMPLEMENTARIO,
      SOLICITANTE,
      AREA_SOLICITANTE,
      USUREG,
      FECREG,
      USUMOD,
      FECMOD,
      ACCION
            ) 
       VALUES (
      :old.IDSPCAB,
      :old.ESTADO,
      :old.RESPONSABLE,
      :old.DESCRIPCION,
      :old.TEXTO_COMPLEMENTARIO,
      :old.SOLICITANTE,
      :old.AREA_SOLICITANTE,
             user,
             sysdate,
             user,
             sysdate,
      V_ACCION
               );
   END IF;
END;
/
