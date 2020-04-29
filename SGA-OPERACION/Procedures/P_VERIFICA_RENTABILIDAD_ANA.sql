CREATE OR REPLACE PROCEDURE OPERACION.P_VERIFICA_RENTABILIDAD_ANA (A_CODEF IN NUMBER, A_FLG OUT number ) IS
/******************************************************************************
Este proc rechazara los proyectos de:
Telefonia Analogica, cuando cumplan algunos de los siguientes

******************************************************************************/

l_numslc char(10);

/* anlaogicas */
l_ana number;
l_monto_pex number;
l_dur_contrato number;
l_monto_ini_12 number := 79.63;
l_incxlinea_12 number := 112.29;
l_monto_ini_24 number := 190.31;
l_incxlinea_24 number := 246.43;
l_monto_ini number;
l_incxlinea number;
l_limite number;
tmpVar NUMBER;
ls_texto varchar2(1000);
l_cont number;

BEGIN

	L_NUMSLC := LTRIM(TO_CHAR(A_CODEF, '0000000000' ));

	select count(*) into l_ana from vtadetptoenl where numslc = l_numslc and codsrv in ('0814');
	if l_ana = 0 then -- proyecto de analogicas
   	a_flg := 0;
   	return;
   end if;

   /* SI TIENE oc */
   SELECT  COUNT(*) INTO L_CONT FROM VTATABPSPCLI WHERE  NUMSLC = L_NUMSLC ;
   IF L_CONT = 0 THEN
   	a_flg := 0;
   	return;
   else
   	select durcon into l_dur_contrato from VTATABPSPCLI WHERE  NUMSLC = L_NUMSLC and
      	idopc = (select max(idopc) from VTATABPSPCLI WHERE  NUMSLC = L_NUMSLC);
   END IF;

  	/* Se calcula el total de planta Externa en dolares */

	if l_dur_contrato < 24 then
		l_monto_ini := l_monto_ini_12;
		l_incxlinea := l_incxlinea_12;
    elsif l_dur_contrato >= 24  then
			l_monto_ini := l_monto_ini_24;
			l_incxlinea := l_incxlinea_24;
    else -- No es valido
   	a_flg := 0;
   	return;
    end if;

	 l_monto_pex := f_get_monto_pex(a_codef);

	 l_limite := l_monto_ini + (l_incxlinea * l_ana);


    ls_texto :=
    'Analisis de rentabilidad generado automaticamente'||chr(13)||
    'Monto PEX: '||round(l_monto_pex,2)||chr(13)||
    'Limite: '||round(l_limite,2)||chr(13)||
    'Duracion del contrato: '||l_dur_contrato||chr(13);


    if l_monto_pex > l_limite then
         ls_texto := ls_texto || 'Proyecto No Rentable';

		   select count(*) into tmpVar from ar where codef = a_codef ;
		   if tmpvar = 0 then
		      select frr into tmpVar from ef where  codef = a_codef ;
		      insert into ar ( CODEF, ESTAR, FRR,   RENTABLE, FECAPR, OBSERVACION)
		      values          ( a_codef, 3 , tmpVar, 0 ,      sysdate, ls_texto  );
         else
         	update ar set estar = 3, frr = tmpvar, rentable = 0 , fecapr = sysdate, observacion = ls_texto
            where codef = a_codef;
		   end if;
		   update ef set req_ar = 1 where codef = a_codef ;
	 else
         ls_texto := ls_texto || 'Proyecto Rentable';

		   select count(*) into tmpVar from ar where codef = a_codef ;
		   if tmpvar = 0 then
		      select frr into tmpVar from ef where  codef = a_codef ;
		      insert into ar ( CODEF, ESTAR, FRR,   RENTABLE, FECAPR, OBSERVACION)
		      values          ( a_codef, 3 , tmpVar, 1 ,      sysdate, ls_texto  );
         else
         	update ar set estar = 3, frr = tmpvar, rentable = 1 , fecapr = sysdate, observacion = ls_texto
            where codef = a_codef;
		   end if;
		   update ef set req_ar = 1 where codef = a_codef ;

    end if;

    a_flg := 1;


END;
/


