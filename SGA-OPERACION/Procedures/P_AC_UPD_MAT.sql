CREATE OR REPLACE PROCEDURE OPERACION.P_AC_UPD_MAT (
	a_tipo in number,
	a_codsolot in number,
	a_punto in number,
	a_codeta in number,
   a_idmat in number,
   a_codmat in char,
   a_observacion in varchar2,
   a_candis in number default 0,
   A_CANLIQ  in number default NULL,
   A_CONTRATA IN NUMBER DEFAULT 0,
   A_CANINS_DEV IN NUMBER DEFAULT NULL
) IS

l_cont number;
l_cont_eta number;
l_costo matope.costo%type;
l_moneda matope.moneda_id%type;
l_codmat char(15);
l_orden number;

BEGIN

if a_tipo in ( 1, 2) then -- dise?o y liq
   if a_codmat is null then
	  	raise_application_error(-20500,'Codigo de material no puede ser vacio.');
   end if;

   l_codmat := rpad(a_codmat,15);

   begin
      	select costo, moneda_id into l_costo, l_moneda from matope where codmat = l_codmat;
   exception
   	when others then
      	raise_application_error(-20500,'Material '||l_codmat||' no valido.');
   end;
end if;

if a_tipo in ( 1 ) then -- dise?o

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

   select count(*) into l_cont
	  from solotptoetamat
	  where codsolot = a_codsolot and
	  		punto = a_punto and
			orden = l_orden and
			idmat = a_idmat;

	if l_cont = 0 then

	   insert into solotptoetamat ( codsolot, punto, orden, idmat, moneda_id, codmat, candis, cosdis, observacion)
	   		values ( a_codsolot, a_punto, l_orden, a_idmat, l_moneda, l_codmat, a_candis, l_costo, a_observacion);
    else
	   update solotptoetamat
   		  set codmat = l_codmat, candis = a_candis, cosdis = l_costo, moneda_id = l_moneda
	   	  where codsolot = a_codsolot and
		  		punto = a_punto and
				orden = l_orden and
				idmat = a_idmat;
   end if;

else -- Liq
   select nvl(count(*),0) into l_cont_eta
	  from solotptoeta
	  where codsolot = a_codsolot and
	  		punto = a_punto and
			codeta = a_codeta;

   if l_cont_eta = 0 then
   	  raise_application_error(-20500,'Etapa no valida');
   elsif l_cont_eta = 1 then
   	  select orden into l_orden
  		 from solotptoeta
		 where codsolot = a_codsolot and
	  		   punto = a_punto and
			   codeta = a_codeta;
   else
      raise_application_error(-20500,'Existen etapas duplicadas');
   end if;

   select nvl(count(*),0) into l_cont
	  from solotptoetamat
	  where codsolot = a_codsolot and
	  		punto = a_punto and
			orden = l_orden and
			idmat = a_idmat;

	if l_cont = 0 then
	   insert into solotptoetamat ( codsolot, punto, orden, idmat, moneda_id, codmat, candis, cosdis, observacion, canliq, contrata, canins_dev)
   	   	  values ( a_codsolot, a_punto, l_orden, a_idmat, l_moneda, l_codmat, 0, 0, a_observacion, a_canliq, a_contrata, a_canins_dev);
    else
	   update solotptoetamat
   		  set codmat = l_codmat, canliq = a_canliq, contrata = a_contrata, canins_dev = a_canins_dev, moneda_id = l_moneda
	   	  where codsolot = a_codsolot and punto = a_punto and orden = l_orden and idmat = a_idmat;
   end if;
end if;

END;
/


