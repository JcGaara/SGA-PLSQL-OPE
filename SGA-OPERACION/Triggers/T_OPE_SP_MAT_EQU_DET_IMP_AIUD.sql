CREATE OR REPLACE TRIGGER OPERACION.T_OPE_SP_MAT_EQU_DET_IMP_AIUD
   AFTER INSERT OR UPDATE OR DELETE
   ON OPERACION.OPE_SP_MAT_EQU_DET_IMP
   REFERENCING OLD AS OLD NEW AS NEW
   FOR EACH ROW
  /************************************************************
       REVISIONS:
       Ver        Date        Author           Description
       --------  ----------  --------------  ------------------------
       1.0       22/11/2011  Roy Concepcion   Creacion, REQ 159960, registro en log
  ***********************************************************/
DECLARE
V_USUARIO_LOG VARCHAR2(100);
V_ACCION CHAR(1);
ID     NUMBER(18);
BEGIN

   IF INSERTING THEN
      V_ACCION := 'I';
      INSERT INTO HISTORICO.OPE_SP_MAT_EQU_DET_IMP_LOG(
IDSPDET,
IDSPCAB,
ele_pep,
cod_cen_costo,
nro_activo,
cuenta_mayor,
concepto_capex,
nro_orden,
cen_costo,
usureg, fecreg, usumod, fecmod,
ACCION
      ) VALUES (
:new.IDSPDET,
:new.IDSPCAB,
:new.ele_pep,
:new.cod_cen_costo,
:new.nro_activo,
:new.cuenta_mayor,
:new.concepto_capex,
:new.nro_orden,
:new.cen_costo,
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
      INSERT INTO HISTORICO.OPE_SP_MAT_EQU_DET_IMP_LOG(
IDSPDET,
IDSPCAB,
ele_pep,
cod_cen_costo,
nro_activo,
cuenta_mayor,
concepto_capex,
nro_orden,
cen_costo,
usureg, fecreg, usumod, fecmod,
ACCION
      ) VALUES (
:old.IDSPDET,
:old.IDSPCAB,
:old.ele_pep,
:old.cod_cen_costo,
:old.nro_activo,
:old.cuenta_mayor,
:old.concepto_capex,
:old.nro_orden,
:old.cen_costo,
       user,
       sysdate,
       user,
       sysdate,
V_ACCION
         );
   END IF;
END;
/
