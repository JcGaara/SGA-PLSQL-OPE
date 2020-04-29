CREATE OR REPLACE TRIGGER OPERACION.T_ESTTRANSFCO_BI
  before insert on OPERACION.ESTTRANSFCO
  REFERENCING OLD AS OLD NEW AS NEW
  for each row
/********************************************************************************
     Creacion
     Ver     Fecha          Autor             Descripcion
    ------  ----------  ----------       --------------------
     1.0     05/03/2010  Hector Huaman  M   REQ-94683: Creación
 ********************************************************************************/
declare
begin
  if :new.ESTTRANSFCO is null then
      SELECT SQ_ESTTRANSFCO.NEXTVAL
             INTO :new.ESTTRANSFCO
      FROM OPERACION.DUMMY_OPE;
  end if;
end T_ESTTRANSFCO_BI;
/



