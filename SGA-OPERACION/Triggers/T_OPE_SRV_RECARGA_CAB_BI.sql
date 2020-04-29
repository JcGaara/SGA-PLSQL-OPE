CREATE OR REPLACE TRIGGER OPERACION."T_OPE_SRV_RECARGA_CAB_BI"
  BEFORE INSERT ON operacion.OPE_SRV_RECARGA_CAB
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW
  /************************************************************
       REVISIONS:
       Ver        Date        Author           Description
       --------  ----------  --------------  ------------------------
       1.0       02/02/2010  Antonio Lagos   Creacion, REQ 106908, asignacion de id
       2.0       05/05/2010  Antonio Lagos   REQ-119999,se cambia el nombre del trigger
                                             y referencias a tabla recargaproyectocliente por nuevo nombre.
       3.0       03/08/2011  Widmer Quispe   REQ-160463
  ***********************************************************/
DECLARE


BEGIN
  if :new.NUMREGISTRO is null then
      SELECT PQ_DTH.F_GET_CLAVE_DTH() INTO :NEW.NUMREGISTRO FROM DUMMY_OPE;
  end if;

  --<3.0
  select v.flg_sc into :new.flg_sc
    from vtatabslcfac v
   where v.numslc = :new.numslc;
  --3.0>
END;
/



