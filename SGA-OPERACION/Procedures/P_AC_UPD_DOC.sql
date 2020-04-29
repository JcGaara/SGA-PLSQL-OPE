CREATE OR REPLACE PROCEDURE OPERACION.P_AC_UPD_DOC (
	a_tipo in number,
	a_codsolot in number,
	a_punto in number,
	a_codeta in number,
   a_iddoc in number,
   a_tipdoc in number,
   a_motobr in char,
   a_disobr in char,
   a_dirobr in char,
   a_texto_a in char,
   a_texto_b in char,
   a_texto_c in char,
   a_texto_d in char
) IS
l_orden number;
l_costo number;
l_cont number;
l_cont_eta number;
BEGIN

if a_tipo = 1 then -- dise?o
	if a_tipdoc is null then
	  	raise_application_error(-20500,'Tipo de documento no puede ser vacio.');
   end if;
	begin
		select 1 into l_costo from pretipdoc where tipdoc = a_tipdoc;
   exception
   	when others then
      	raise_application_error(-20500,'Tipo de documento invalido.');
   end;
   select count(*) into l_cont_eta
	  from solotptoeta
	  where codsolot = a_codsolot and
	  		punto = a_punto and
			codeta = a_codeta;
   if l_cont_eta = 0 then
   	  select nvl(max(orden),0) + 1 into l_orden
  		 from solotptoeta
		 where codsolot = a_codsolot and
	  		   punto = a_punto;

   	  insert into solotptoeta ( codsolot, punto, orden, codeta )
	  	 	 values ( a_codsolot, a_punto, l_orden, a_codeta );
   elsif l_cont_eta = 1 then
   	  select orden into l_orden
  		 from solotptoeta
		 where codsolot = a_codsolot and
	  		   punto = a_punto and
			   codeta = a_codeta;
   else
      raise_application_error(-20500,'Existen etapas duplicadas');
   end if;

   select count(*) into l_cont from predoc
	   where codsolot = a_codsolot and punto = a_punto and codeta = a_codeta and iddoc = a_iddoc;
	if l_cont = 0 then
		insert into predoc  ( codsolot, punto, CODETA, iddoc, TIPDOC, MOTOBR, TEXTO_A, TEXTO_B, TEXTO_C, TEXTO_D, DISOBR, DIROBR  )
   	values ( a_codsolot, a_punto, a_CODETA, a_iddoc, a_TIPDOC, a_MOTOBR, a_TEXTO_A, a_TEXTO_B, a_TEXTO_C, a_TEXTO_D, a_DISOBR, a_DIROBR   );
   else
	  	update predoc  set
	     TIPDOC = a_tipdoc, MOTOBR = a_motobr, TEXTO_A = a_texto_a, TEXTO_B = a_texto_b, TEXTO_C = a_texto_c, TEXTO_D = a_texto_d,
         DISOBR = a_disobr, DIROBR = a_dirobr
	   where codsolot = a_codsolot and punto = a_punto and codeta = a_codeta and iddoc = a_iddoc;
   end if;

else
	null;
end if;

END;
/


