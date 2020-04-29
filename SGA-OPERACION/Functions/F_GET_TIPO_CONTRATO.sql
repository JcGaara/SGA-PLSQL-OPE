CREATE OR REPLACE FUNCTION OPERACION.F_GET_TIPO_CONTRATO(a_proyecto in char) RETURN CHAR IS
lc_contrato char(1);
/* Se obtiene si es por contrato o demo */
BEGIN

   select decode(v.ESTPSPCLI,'02','C','05','D',null) into lc_contrato
   from sales.vtampspcli v
   where v.numslc = a_proyecto;

   return lc_contrato;

   EXCEPTION
     WHEN OTHERS THEN
       return null;
END;
/


