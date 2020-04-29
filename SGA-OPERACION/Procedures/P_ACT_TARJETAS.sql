CREATE OR REPLACE PROCEDURE OPERACION.P_ACT_TARJETAS IS
tmpVar NUMBER;

i number;
j number;
l_tarjeta number;
l_equipo number;

cursor cur_eq is
select codequipo from equipored;

cursor cur_p_e is
select codpuerto, puerto, to_number(substr(puerto, 2, 1)) seq   from puertoxequipo
where codtarjeta is null and puerto like 'e%' and codequipo = l_equipo
order by 3,2;

cursor cur_p_s1 is
select codpuerto, puerto, to_number(substr(puerto, 2, 1)) seq   from puertoxequipo
where codtarjeta is null and puerto like 's%/%' and codequipo = l_equipo
order by 3,2;

cursor cur_p_s2 is
select codpuerto, puerto, to_number(substr(puerto, 2, 2)) seq   from puertoxequipo
where codtarjeta is null and puerto like 's%-%' and codequipo = l_equipo
order by 3,2;


cursor cur_p_cbr is
select codpuerto, puerto, to_number(substr(puerto, 4, instr(puerto,'/')-4)) seq   from puertoxequipo
where codtarjeta is null and puerto like 'cbr%' and codequipo = l_equipo
order by 3,2;

cursor cur_p_f is
select codpuerto, puerto, to_number(substr(puerto, 2, instr(puerto,'/')-2)) seq   from puertoxequipo
where codtarjeta is null and puerto like 'f%' and codequipo = l_equipo
order by 3,2;

cursor cur_p_lre is
select codpuerto, puerto, to_number(substr(puerto, 4, instr(puerto,'/')-4)) seq   from puertoxequipo
where codtarjeta is null and puerto like 'lre%' and codequipo = l_equipo
order by 3,2;

cursor cur_p_ge is
select codpuerto, puerto, to_number(substr(puerto, 3, instr(puerto,'/')-3)) seq   from puertoxequipo
where codtarjeta is null and puerto like 'ge%' and codequipo = l_equipo
order by 3,2;

BEGIN


for l in cur_eq loop
	l_equipo := l.codequipo;

	-- Inicio del orden
   j := 0;
   l_tarjeta := null;

	i := -1;
	for p in cur_p_e loop
   	if i <> p.seq then
      	i := p.seq ;
         j := j + 1;
      	l_tarjeta := l_equipo * 100 + j;
      	insert into tarjetaxequipo (CODTARJETA, CODEQUIPO, DESCRIPCION, TIPO)
         values (l_tarjeta, l_equipo, 'Ethernet '||ltrim(to_char(i,'00')), 'Ethernet' );
      end if;
      UPDATE PUERTOXEQUIPO SET CODTARJETA = L_TARJETA  WHERE CODPUERTO = P.CODPUERTO;
	end loop;

	i := -1;
	for p in cur_p_s1 loop
   	if i <> p.seq then
      	i := p.seq ;
         j := j + 1;
      	l_tarjeta := l_equipo * 100 + J;
      	insert into tarjetaxequipo (CODTARJETA, CODEQUIPO, DESCRIPCION, TIPO)
         values (l_tarjeta, l_equipo, 'Serial '||ltrim(to_char(i,'00')), 'SERIAL' );
      end if;
      UPDATE PUERTOXEQUIPO SET CODTARJETA = L_TARJETA  WHERE CODPUERTO = P.CODPUERTO;
	end loop;

	i := -1;
	for p in cur_p_s2 loop
   	if i <> p.seq then
      	i := p.seq ;
         j := j + 1;
      	l_tarjeta := l_equipo * 100 + J;
      	insert into tarjetaxequipo (CODTARJETA, CODEQUIPO, DESCRIPCION, TIPO)
         values (l_tarjeta, l_equipo, 'SLOT '||ltrim(to_char(i,'00')), 'SLOT' );
      end if;
      UPDATE PUERTOXEQUIPO SET CODTARJETA = L_TARJETA  WHERE CODPUERTO = P.CODPUERTO;
	end loop;

	i := -1;
	for p in cur_p_cbr loop
   	if i <> p.seq then
      	i := p.seq ;
         j := j + 1;
      	l_tarjeta := l_equipo * 100 + J;
      	insert into tarjetaxequipo (CODTARJETA, CODEQUIPO, DESCRIPCION, TIPO)
         values (l_tarjeta, l_equipo, 'CBR '||ltrim(to_char(i,'00')), 'CBR' );
      end if;
      UPDATE PUERTOXEQUIPO SET CODTARJETA = L_TARJETA  WHERE CODPUERTO = P.CODPUERTO;
	end loop;

	i := -1;
	for p in cur_p_f loop
   	if i <> p.seq then
      	i := p.seq ;
         j := j + 1;
      	l_tarjeta := l_equipo * 100 + j;
      	insert into tarjetaxequipo (CODTARJETA, CODEQUIPO, DESCRIPCION, TIPO)
         values (l_tarjeta, l_equipo, 'Fast Ethernet '||ltrim(to_char(i,'00')), 'FAST Ethernet' );
      end if;
      UPDATE PUERTOXEQUIPO SET CODTARJETA = L_TARJETA  WHERE CODPUERTO = P.CODPUERTO;
	end loop;

	i := -1;
	for p in cur_p_lre loop
   	if i <> p.seq then
      	i := p.seq ;
         j := j + 1;
      	l_tarjeta := l_equipo * 100 + j;
      	insert into tarjetaxequipo (CODTARJETA, CODEQUIPO, DESCRIPCION, TIPO)
         values (l_tarjeta, l_equipo, 'Long Reach Ethernet '||ltrim(to_char(i,'00')), 'Long Reach Ethernet' );
      end if;
      UPDATE PUERTOXEQUIPO SET CODTARJETA = L_TARJETA  WHERE CODPUERTO = P.CODPUERTO;
	end loop;

	i := -1;
	for p in cur_p_ge loop
   	if i <> p.seq then
      	i := p.seq ;
         j := j + 1;
      	l_tarjeta := l_equipo * 100 + j;
      	insert into tarjetaxequipo (CODTARJETA, CODEQUIPO, DESCRIPCION, TIPO)
         values (l_tarjeta, l_equipo, 'Gigabit Ethernet '||ltrim(to_char(i,'00')), 'Gigabit Ethernet' );
      end if;
      UPDATE PUERTOXEQUIPO SET CODTARJETA = L_TARJETA  WHERE CODPUERTO = P.CODPUERTO;
	end loop;

   -- Para los que faltan
   select count(*) into tmpvar  from puertoxequipo
	where codtarjeta is null and codequipo = l_equipo;
   if tmpvar > 0 then
	   j := j + 1;
    	l_tarjeta := l_equipo * 100 + j;
	 	insert into tarjetaxequipo (CODTARJETA, CODEQUIPO, DESCRIPCION, TIPO)
         values (l_tarjeta, l_equipo, 'Sin Definir', 'SIN DEFINIR' );
      UPDATE PUERTOXEQUIPO SET CODTARJETA = L_TARJETA  WHERE codtarjeta is null and codequipo = l_equipo;
   end if;

end loop;

END;
/


