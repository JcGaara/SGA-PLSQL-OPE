CREATE OR REPLACE FUNCTION OPERACION.f_proyecto_hijos (an_numslc in solot.numslc%type, an_codinssrv in inssrv.codinssrv%type) return varchar is
n_tmpvar varchar(4000);
n_tmpvar1 varchar(4000);

cursor cur_proyecto is
   select numslc, numpto, numslcpad, numptopad, numckt
   from vtadetptoenl
   where flgupg = 1
   		 and numslcpad = an_numslc
		 and numckt = an_codinssrv;

BEGIN
	n_tmpvar := '';
   	for lcur_proyecto in cur_proyecto loop
	  begin
	  	n_tmpvar := n_tmpvar || lcur_proyecto.numslc || ' - ' || f_proyecto_hijos (lcur_proyecto.numslc, lcur_proyecto.numckt);
		exception
		when others then
		n_tmpvar := '';
		return n_tmpvar;
	  end;
    end loop;
	return n_tmpvar;
END;
/


