CREATE OR REPLACE TRIGGER OPERACION.T_EFPTO_BU
BEFORE UPDATE 
ON OPERACION.EFPTO
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW 
/******************************************************************************
CAMBIOS

       Fecha        Autor           Descripcion
    ----------  ---------------  ------------------------
1.0  06/03/2013     Lucio Rojas    Proy. 7329  Actualización de dirección

******************************************************************************/  
DECLARE
  lc_codcli ef.codcli%type;
BEGIN
   --<1.0
   -- Se actualiza la tabla de sucursales
   select codcli into lc_codcli from ef where codef = :new.codef;
   --
   IF (updating('COORDX1')    AND :old.COORDX1<>:NEW.COORDX1) OR 
      (updating('COORDY1')    AND :old.COORDY1<>:NEW.COORDY1) OR
      (updating('COORDX2')    AND :old.COORDX2<>:NEW.COORDX2) OR
      (updating('COORDY2')    AND :old.COORDY2<>:NEW.COORDY2) OR 
      (updating('new.codef')  AND :old.codef  <>:NEW.codef  ) OR
      (updating('new.punto')  AND :old.punto  <>:NEW.punto  ) OR
      (updating('new.codsuc') AND :old.codsuc <>:NEW.codsuc ) THEN
   --1.0>   
   update vtasuccli set
      MERABS1 = NVL(:new.COORDX1,MERABS1),
      MERORD1 = NVL(:new.COORDY1,MERORD1),
      MERABS2 = NVL(:new.COORDX2,MERABS2),
      MERORD2 = NVL(:new.COORDY2,MERORD2),
      codef = :new.codef,
      punto = :new.punto
   where codcli = lc_codcli and
         codsuc = :new.codsuc;
   end if ;
END;
/
