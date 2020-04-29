CREATE OR REPLACE PROCEDURE OPERACION.p_rechazar_efxarea(an_codef in number) IS
/****************************************************************
En caso un EF sea rechazado por el �rea responsable, los estados de las demas �reas deben pasar
a "no interviene" si es que se encuentran en estado actualizar datos, derivado o generado.

   Fecha       Autor            Descripci�n
   ----------  ---------------  ---------------------------------
   03/01/2006  V�ctor Hugo      Creaci�n
*****************************************************************/

BEGIN
	 update solefxarea
	 set 	estsolef = 3
	 where	codef = an_codef
	 and	esresponsable = 0
	 and	estsolef <> 2;

	 exception
 	 		  when others then
			  	   RAISE_APPLICATION_ERROR (-20900, sqlcode || 'No se pudo rechazar el ef ' || to_char(an_codef));
END P_RECHAZAR_EFXAREA;
/


