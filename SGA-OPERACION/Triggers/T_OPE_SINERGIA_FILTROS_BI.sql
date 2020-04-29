CREATE OR REPLACE TRIGGER OPERACION.T_OPE_SINERGIA_FILTROS_BI
 BEFORE INSERT
ON OPERACION.OPE_SINERGIA_FILTROS_TMP  REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
 /**************************************************************************
   NOMBRE:     T_OPE_SINERGIA_FILTROS_AIUD
   PROPOSITO:  Genera log de agendamiento

   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        28/01/2016  Arturo Saaavedra
   **************************************************************************/
BEGIN
   if :new.idvalor is null then
       select sq_agendamiento.nextval into :new.idvalor  from dummy_ope;
   end if;
END;  
/