CREATE OR REPLACE TRIGGER OPERACION.T_transacciones_fco_BI
  before insert on OPERACION.transacciones_fco
  REFERENCING OLD AS OLD NEW AS NEW
  for each row
declare
/********************************************************************************
     Creacion
     Ver     Fecha          Autor             Descripcion
    ------  ----------  ----------       --------------------
     1.0     05/03/2010  Hector Huaman  M   REQ-94683: Creación
 ********************************************************************************/
begin
  if :new.IDTRANSFCO is null then
  SELECT SQ_TRANSACCIONES_FCO.NEXTVAL
         INTO :new.IDTRANSFCO
  FROM OPERACION.DUMMY_OPE;
  end if;

end T_transacciones_fco_BI;
/



