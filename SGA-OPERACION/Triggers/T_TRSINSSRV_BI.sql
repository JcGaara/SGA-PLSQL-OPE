CREATE OR REPLACE TRIGGER OPERACION.T_TRSINSSRV_BI
BEFORE INSERT
ON OPERACION.TRSINSSRV
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
   /* comentado por CC 31/10/2002
      Este Trigger ya no es necesario

   if :new.codtrs is null then
      :new.codtrs := f_get_clave_trs;
   end if;
   :new.codusu := user;
   :new.fecusu := sysdate;
   If :new.esttrs in (2,3) then -- Ejecutado o anulado
      :new.feceje := sysdate;
	  if :new.fectrs is null then
	     :new.fectrs := :new.feceje;
	  end if;
   end if;
   if :new.estinssrv is null then
      -- Se obtiene el nuevo estado del SID dependiendo del tipo
   	  select estinssrv into :new.estinssrv from tiptrs where tiptrs = :new.tiptrs;
   end if;
   if :new.codsrvant is null or :new.estinssrvant is null then
      select codsrv, estinssrv, bw into :new.codsrvant, :new.estinssrvant, :new.bwant from inssrv
	     where codinssrv = :new.codinssrv;
   end if;

   */
   null;
END;
/



