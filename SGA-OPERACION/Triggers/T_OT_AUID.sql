CREATE OR REPLACE TRIGGER OPERACION.T_OT_AUID
  after update or insert or delete on OPERACION.OT
  REFERENCING OLD AS OLD NEW AS NEW
  for each row
  /********************************************************************
     REVISIONS:
     Ver        Date        Author           Description
     --------  ----------  --------------  ------------------------
     1.0       03/12/2010  Alexander Yong   REQ 150513: Creación
  *********************************************************************/
declare
  ls_accion varchar2(3);
begin
  IF updating THEN
     ls_accion := 'UPD';
  Insert into HISTORICO.OPE_OT_LOG
  values
    (:old.CODOT,
     :old.CODMOTOT,
     :old.CODSOLOT,
     :old.TIPTRA,
     :old.ESTOT,
     :old.DOCID,
     :old.FECINI,
     :old.FECFIN,
     :old.FECCLI,
     :old.LUGAR,
     :old.OBSERVACION,
     :old.CODDPT,
     :old.FECULTEST,
     :old.FECCOM,
     :old.COSMO,
     :old.COSMAT,
     :old.COSMATCLI,
     :old.COSMOCLI,
     :old.COSEQU,
     user,
     sysdate,
     :old.CODOTPADRE,
     :old.COSMO_S,
     :old.COSMAT_S,
     :old.ORIGEN,
     :old.RESPONSABLE,
     :old.APRTRS,
     :old.AREA,
     :old.TIPO,
     :old.FLAGEJE,
     ls_accion);

  ELSIF inserting THEN
     ls_accion := 'INS';
  Insert into HISTORICO.OPE_OT_LOG
  values
    (:new.CODOT,
     :new.CODMOTOT,
     :new.CODSOLOT,
     :new.TIPTRA,
     :new.ESTOT,
     :new.DOCID,
     :new.FECINI,
     :new.FECFIN,
     :new.FECCLI,
     :new.LUGAR,
     :new.OBSERVACION,
     :new.CODDPT,
     :new.FECULTEST,
     :new.FECCOM,
     :new.COSMO,
     :new.COSMAT,
     :new.COSMATCLI,
     :new.COSMOCLI,
     :new.COSEQU,
     user,
     sysdate,
     :new.CODOTPADRE,
     :new.COSMO_S,
     :new.COSMAT_S,
     :new.ORIGEN,
     :new.RESPONSABLE,
     :new.APRTRS,
     :new.AREA,
     :new.TIPO,
     :new.FLAGEJE,
     ls_accion);

  ELSIF deleting THEN
  ls_accion := 'DEL';
  Insert into HISTORICO.OPE_OT_LOG
  values
    (:old.CODOT,
     :old.CODMOTOT,
     :old.CODSOLOT,
     :old.TIPTRA,
     :old.ESTOT,
     :old.DOCID,
     :old.FECINI,
     :old.FECFIN,
     :old.FECCLI,
     :old.LUGAR,
     :old.OBSERVACION,
     :old.CODDPT,
     :old.FECULTEST,
     :old.FECCOM,
     :old.COSMO,
     :old.COSMAT,
     :old.COSMATCLI,
     :old.COSMOCLI,
     :old.COSEQU,
     user,
     sysdate,
     :old.CODOTPADRE,
     :old.COSMO_S,
     :old.COSMAT_S,
     :old.ORIGEN,
     :old.RESPONSABLE,
     :old.APRTRS,
     :old.AREA,
     :old.TIPO,
     :old.FLAGEJE,
     ls_accion);

  END IF;

end;
/



