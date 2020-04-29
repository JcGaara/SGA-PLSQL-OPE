CREATE OR REPLACE PROCEDURE OPERACION.P_REP_INCONSISTENCIA_PRY ( a_numslc in char )IS
tmpVar NUMBER;
tmpVar2 NUMBER;
l_ef number;
l_txt varchar2(4000);

cursor cur_p is
select
e.codsrv codsrv_e, e.bw     bw_e, e.NROLINEAS NROLINEAS_e,
p.codsrv codsrv_p, p.banwid bw_p, p.NROLINEAS NROLINEAS_p,
e.punto punto, DESCPTO descrip
from efpto e, vtadetptoenl p where e.codef = l_ef and p.numslc = a_numslc
and to_number(p.numpto) = e.punto;


BEGIN

	l_ef := to_number(a_numslc);
	DBMS_OUTPUT.PUT_LINE('Proyecto: '||to_char(l_ef));
	l_txt := 'No se detecto ningun error';

   -- Primero se valida el # de puntos
	select count(*) into tmpvar from vtadetptoenl where numslc = a_numslc;
	select count(*) into tmpvar2 from efpto where codef = l_ef;
   if tmpvar <> tmpvar2 then
   	l_txt := 'El # de puntos en el Proyecto es diferente al # puntos en el EF';
		DBMS_OUTPUT.PUT_LINE(l_txt);
   end if;

/*
desc efpto
DESCRIPCION, CODINSSRV, CODSUC, CODUBI, DIRECCION, CODSRV,  BW,      TIPTRA, NROLINEAS, NROFACREC, NROHUNG, NROIGUAL, NROCANAL, TIPTRAEF

desc produccion.vtadetptoenl
DESCPTO,     NUMCKT,    CODSUC, UBIPTO, DIRPTO,     CODSRV, BANWID,  TIPTRA, NROLINEAS, NROFACREC, NROHUNG, NROIGUAL, NROCANAL, TIPTRAEF
*/

	for l in cur_p loop
   	if l.codsrv_e <> l.codsrv_p then
	   	l_txt := l.punto||' '||l.descrip||': Los servicio son diferentes.';
			DBMS_OUTPUT.PUT_LINE(l_txt);
      end if;
   	if l.bw_e <> l.bw_p then
	   	l_txt := l.punto||' '||l.descrip||': Los BW son diferentes.';
			DBMS_OUTPUT.PUT_LINE(l_txt);
      end if;
   	if l.NROLINEAS_e <> l.NROLINEAS_p then
	   	l_txt := l.punto||' '||l.descrip||': Los # de Lineas son diferentes.';
			DBMS_OUTPUT.PUT_LINE(l_txt);
      end if;
   end loop;

   if l_txt = 'No se detecto ningun error' then
		DBMS_OUTPUT.PUT_LINE(l_txt);
   end if;


END;
/


