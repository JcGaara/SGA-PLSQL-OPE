CREATE OR REPLACE PROCEDURE OPERACION.p_2 (numslc in number, NUMPTO IN number)  IS
tmpVar NUMBER;
BEGIN
  tmpVar := F_CREAR_INSSRV_CORREGIR(numslc,NUMPTO);
  if tmpvar is null then
    raise_application_error(-20500,'Error');
  end if;
END;
/


