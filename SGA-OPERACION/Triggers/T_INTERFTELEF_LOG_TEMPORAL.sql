CREATE OR REPLACE TRIGGER OPERACION.t_INTERFTELEF_LOG_TEMPORAL
  before insert on interftelefonialog
  REFERENCING OLD AS OLD NEW AS NEW
  for each row
declare

begin
  if :new.IDLOGTELEFONIA is null then
	   SELECT SEQ_INTerfTELEFoniaLOG.NEXTVAL
            INTO :new.IDLOGTELEFONIA
      FROM DUAL;
  end if;
end t_INTERFTELEF_LOG_TEMPORAL;
/



