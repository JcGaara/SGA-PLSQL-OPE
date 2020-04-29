CREATE OR REPLACE FUNCTION OPERACION.F_TPO_TOT_EF_OPERACIONES (
a_codef in number
)
RETURN NUMBER IS
/***************************************************************************************
Fecha		Descripcion															    Responsable
----------  --------------------------------------------------------------------- --------------
14-03-2005 Se calcula el tiempo total q una ef ha estado en operaciones   		  	CQUILCA
**************************************************************************************/
l_duracion number;
l_duracion_ef_ope number;
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
	 for l in cur_estado loop
		if l.docest = 3 and l.docestold in (2,4,5) then
		   l_duracion := l_duracion + (l.fecha - l_fecha_ant);
		else
			l_fecha_ant := l.fecha;
		end if;
	 end loop;

     for l1 in cur_estado loop
		if l1.docest = 5 and l1.docestold in (2,4) then
		   l_duracion := l_duracion + (l1.fecha - l_fecha_ant);
		else
			l_fecha_ant := l1.fecha;
		end if;
	 end loop;

	 select fecusu, fecfin into l_fecini, l_fecfin from ef where codef = a_codef;

	 l_duracion_ef_ope := l_fecfin - l_fecini - l_duracion;

/*
l_duracion number;
l_ttotal number;
l_fecini ef.fecusu%type;
l_fecfin ef.fecfin%type;
l_duracion_ef number;
l_duracion_ef_ope number;
l_docid docesthis.docid%type;
l_docest docesthis.docest%type;
l_fecha docesthis.fecha%type;
l_fechafin docesthis.fecha%type;

cursor cur_estado is
select ef.codef,
	   docesthis.docid,
	   docesthis.docest,
	   docesthis.fecha
from   ef,
	   docesthis
where  ef.docid = docesthis.docid
	   and ef.codef = a_codef
	   and docest in (2,4,5)
order by fecha;

BEGIN
 	 l_ttotal := 0;
	 for l in cur_estado loop
	 	l_duracion := 0;
	 	l_docid := l.docid;
		l_docest := l.docest;
	 	l_fecha := l.fecha;

		select min(docesthis.fecha) into l_fechafin
		from   ef,
		 	   docesthis
		where  ef.docid = docesthis.docid
		   	   and ef.codef = a_codef
	   	   	   and docesthis.fecha > (select fecha from docesthis where
		   	   docid = l_docid and docest = l_docest)
	    order by fecha;

		if (l_fechafin is null) then
		   l_duracion := 0;
		else
			l_duracion := l_fechafin - l_fecha;
			l_ttotal := l_ttotal + l_duracion;
	    end if;
	 end loop;

	 select fecusu, fecfin into l_fecini, l_fecfin from ef where codef = a_codef;

	 l_duracion_ef := l_fecfin - l_fecini;
	 l_duracion_ef_ope := l_duracion_ef - l_ttotal;

	 exception
		     when others then
       		 RAISE_APPLICATION_ERROR (-20500,a_codef);

*/   return l_duracion_ef_ope;

--   return l_duracion_ef_ope;

END;
/


