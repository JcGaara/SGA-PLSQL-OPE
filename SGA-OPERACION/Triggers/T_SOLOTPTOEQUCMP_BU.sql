CREATE OR REPLACE TRIGGER OPERACION.T_SOLOTPTOEQUCMP_BU
BEFORE UPDATE
ON OPERACION.SOLOTPTOEQUCMP
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
DECLARE
lc_cod_sap varchar2(18);

BEGIN
 If :old.numserie <> :new.numserie then
   Select c.cod_sap Into lc_cod_sap from tipequ b, almtabmat c Where b.codtipequ = c.codmat and b.tipequ = :new.tipequ;
   If :old.numserie is not null then
      Update operacion.equiposerie Set estado = 0, usuario = USER, fecha_actualizacion = sysdate
             Where cod_sap = lc_cod_sap and Trim(numserie) = Trim(:old.numserie) ;
   End if;
   Update operacion.equiposerie Set codsolot = :new.codsolot, estado = 1, punto = :new.punto,
          orden = :new.orden, usuario = USER, fecha_actualizacion = sysdate
          Where cod_sap = lc_cod_sap and Trim(numserie) = Trim(:new.numserie) ;
 End If;
END;
/



