CREATE OR REPLACE FUNCTION OPERACION.F_GET_OUTPUT RETURN varchar2 IS
tmpVar NUMBER;
ls_line varchar2(2000);
li_status number;
BEGIN

   SYS.DBMS_OUTPUT.GET_LINE(ls_line, li_status) ;
   if li_status = 1 then
   	return null;
   else
   	return ls_line;
   end if;

END;
/


