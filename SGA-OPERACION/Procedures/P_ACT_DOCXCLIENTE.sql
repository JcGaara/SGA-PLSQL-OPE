CREATE OR REPLACE PROCEDURE OPERACION.P_ACT_DOCXCLIENTE(a_codcli in char) IS
tmpVar NUMBER;
BEGIN
      select count(*) into tmpvar from ctrldoc where codcli = a_codcli and estdocxcli <> 6;
      if tmpvar = 0 then
          update docxcliente set estdocxcli = 2 where codcli = a_codcli;
      else
          update docxcliente set estdocxcli = 3 where codcli = a_codcli and estdocxcli = 2;
      end if;
END ;
/


