CREATE OR REPLACE TRIGGER OPERACION.T_BOUQUETXREGINSDTH_BU
BEFORE UPDATE
ON OPERACION.BOUQUETXREGINSDTH
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
begin
:new.usumod := user;
:new.fecmod := sysdate;
end T_BOUQUETXREGINSDTH_BU;
/



