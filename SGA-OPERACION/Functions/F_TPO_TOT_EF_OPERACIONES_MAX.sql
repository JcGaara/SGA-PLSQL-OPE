CREATE OR REPLACE FUNCTION OPERACION.F_TPO_TOT_EF_OPERACIONES_MAX (
a_codef in number
)
RETURN NUMBER IS
/***************************************************************************************
Fecha		Descripcion															    Responsable
----------  --------------------------------------------------------------------- --------------
14-03-2005 Se calcula el tiempo total q una ef ha estado en operaciones   		  	CQUILCA
**************************************************************************************/
l_duracion number;
l_duracion_max number;
l_fecini ef.fecusu%type;
l_fecfin ef.fecfin%type;
l_fecha_ant docesthis.fecha%type;
l_fechafin docesthis.fecha%type;

cursor cur_estado is
select ef.codef,
	   docesthis.docid,
	   docesthis.docest,
	   docesthis.fecha,
	   docesthis.docestold
from   ef,
	   docesthis
where  ef.docid = docesthis.docid
	   and ef.codef = a_codef
order by fecha;

BEGIN
 	 l_duracion := 0;
	 l_duracion_max := 0;
	 for l in cur_estado loop
	 	if l.docest in (1,6) and l.docestold is not null then
		   l_duracion := l_duracion + (l.fecha - l_fecha_ant);
		elsif l.docest in (2,4) and l.docestold is not null then
		   l_duracion := l_duracion + (l.fecha - l_fecha_ant);
		   if l_duracion >= l_duracion_max then
		   	  l_duracion_max := l_duracion;
  		   	  l_duracion := 0;
		   end if;
		end if;
		l_fecha_ant := l.fecha;
	 end loop;

	 return l_duracion_max;
END;
/


