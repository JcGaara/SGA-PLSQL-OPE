CREATE OR REPLACE TRIGGER OPERACION.T_trssolot_BI
BEFORE INSERT
ON OPERACION.trssolot
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
BEGIN
   if :new.codtrs is null then
      :new.codtrs := f_get_clave_trssolot;
   end if;
   :new.codusu := user;
   :new.fecusu := sysdate;

   /* Comentado por CC 30/10/02 por que ya no es necesario
   if :new.codsrvant is null or :new.estinssrvant is null then
      begin
         select codsrv, estinssrv, bw into :new.codsrvant, :new.estinssrvant, :new.bwant from inssrv
	     where codinssrv = :new.codinssrv;
      exception
   	     when others then
	  	   null;
      end;
   end if;
   */
END;
/



