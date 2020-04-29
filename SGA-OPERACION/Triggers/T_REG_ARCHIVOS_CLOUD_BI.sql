create or replace trigger OPERACION.T_REG_ARCHIVOS_CLOUD_BI
  before insert on OPERACION.REG_ARCHIVOS_CLOUD
  REFERENCING OLD AS OLD NEW AS NEW
  for each row
declare

begin
  if :new.NUMTRANS is null then
  SELECT OPERACION.SQ_REG_CLOUD.NEXTVAL
         INTO :new.NUMTRANS
  FROM DUAL;
  end if;

end T_REG_ARCHIVOS_CLOUD_BI;
/
