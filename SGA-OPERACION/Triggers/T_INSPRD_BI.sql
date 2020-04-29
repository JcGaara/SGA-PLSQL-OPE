CREATE OR REPLACE TRIGGER OPERACION."T_INSPRD_BI"
BEFORE INSERT
ON OPERACION.insprd
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
/************************************************************
       REVISIONS:
       Ver        Date        Author           Description
       --------  ----------  --------------  ------------------------
       1.0
       2.0       03/08/2011  Widmer Quispe   REQ-160463
  ***********************************************************/
--ini 2.0
declare
  ln_return number;
--fin 2.0
BEGIN

    if :new.pid is null then
	    :new.pid := F_GET_ID_INSPRD;
    end if;

  -- Ini 2.0
  select COUNT(1)
    INTO LN_RETURN
    from his_instancia_prycab_log cab, his_instancia_prydet_log det
   where cab.estado = 1
     and cab.numslc = :new.numslc
     and cab.idprylogcab = det.idprylogcab
     and det.numpto = :new.numpto
     and det.flg_cnr = 1;

    IF LN_RETURN > 0 THEN
       :new.flg_cnr := 1;
    END IF;

    begin
      select det.idconfiguradet
        into :new.id
        from his_instancia_prycab_log cab, his_instancia_prydet_log det
       where cab.estado = 1
         and cab.numslc = :new.numslc
	 and cab.idprylogcab = det.idprylogcab
         and det.iddet = :new.iddet;
    exception
      when others then
        :new.id := null;
    end;

  -- Fin 2.0

END;
/



