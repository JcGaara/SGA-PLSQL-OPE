CREATE OR REPLACE FUNCTION OPERACION.F_GET_SOLUCION_ACTIVA(a_idsolucion number) return number
/******************************************************************************
   NOMBRE:      F_GET_SOLUCION_ACTIVA
   DESCRIPCION:    Valida si existe solucion activa.

   REVISIONES:
   Version     Fecha        Autor           Descripcion
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/10/2007  Roy Concepcion
******************************************************************************/
is
   l_return number;
   l_count  number;
   l_codprd productocorpsoluc.codprd%type;

begin
      l_count := 0;
      l_return := 0;

      SELECT COUNT(*) into l_count
      FROM SOLUCIONES A
      WHERE A.IDSOLUCION IN (SELECT B.IDSOLUCION FROM PRODUCTOCORPSOLUC B WHERE B.ESTADO = 1) AND
            A.IDSOLUCION = a_idsolucion;

      if l_count > 0 then
         select codprd into l_codprd from productocorpsoluc where idsolucion =  a_idsolucion and estado = 1;
         l_return := l_codprd;
      else
         l_return := 0;
      end if;

    return l_return;

end;
/


