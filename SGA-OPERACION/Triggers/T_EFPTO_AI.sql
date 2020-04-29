CREATE OR REPLACE TRIGGER OPERACION.T_EFPTO_AI
AFTER INSERT 
ON OPERACION.EFPTO
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
  lc_codcli ef.codcli%type;
BEGIN

   -- Se actualiza la tabla de sucursales
   select codcli into lc_codcli from ef where codef = :new.codef;

   update vtasuccli set
      MERABS1 = NVL(:new.COORDX1,MERABS1),
      MERORD1 = NVL(:new.COORDY1,MERORD1),
      MERABS2 = NVL(:new.COORDX2,MERABS2),
      MERORD2 = NVL(:new.COORDY2,MERORD2),
	  codef = :new.codef,
	  punto = :new.punto
   where codcli = lc_codcli and
         codsuc = :new.codsuc;

END;
/



