CREATE OR REPLACE FUNCTION OPERACION.F_GET_PRODUCTO_ACTIVA(a_idproducto number) return number
/******************************************************************************
   NOMBRE:      F_GET_PRODUCTO_ACTIVA
   DESCRIPCION:    Valida si existe producto activo.

   REVISIONES:
   Version     Fecha        Autor           Descripcion
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/10/2007  Roy Concepcion
******************************************************************************/
is
   l_return number;
   l_count  number;
   l_codprd productocorpproduct.codprd%type;
begin
      l_count := 0;
      l_return := 0;

      SELECT COUNT(*) into l_count
      FROM PRODUCTO A
      WHERE A.IDPRODUCTO IN (SELECT B.IDPRODUCTO FROM PRODUCTOCORPPRODUCT B WHERE B.ESTADO = 1) AND
            A.IDPRODUCTO = a_idproducto;

      if l_count > 0 then
         select codprd into l_codprd from productocorpproduct where idproducto = a_idproducto and estado = 1;
         l_return := l_codprd;
      else
         l_return := 0;
      end if;

    return l_return;

end;
/


