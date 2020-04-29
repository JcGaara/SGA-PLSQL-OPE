CREATE OR REPLACE PROCEDURE OPERACION.P_PENDIENTES_INST_PEX IS
tmpVar varchar2(4000);
/******************************************************************************
     1.0    06/10/2010                      REQ.139588 Cambio de Marca
******************************************************************************/

cursor cur_faltan is
select '# OT que vencen dentro de los proximos '||round(feccom - sysdate)||' dias = ' || count(*) mesg from ot where coddpt = '0042' and estot in (1,2)
AND round(feccom - sysdate) BETWEEN 1 AND 5
group by '# OT que vencen dentro de los proximos '||round(feccom - sysdate)||' dias = '
union
select '# OT fuera de fecha = ' || count(*) from ot where coddpt = '0042' and estot in (1,2) AND round(feccom - sysdate) <= 0;

BEGIN
null;
--1.0
/*   tmpvar := '';
   for lc in cur_faltan loop
      tmpvar := tmpvar || chr(13) || lc.mesg ;
   end loop;

   tmpvar := tmpvar || chr(13) || chr(13) || 'Para mayores detalles consulte Modulo de Operaciones\Reportes\Planta Externa\Pendientes de Instalacion';

   P_ENVIA_CORREO_DE_TEXTO_ATT('Pendientes de Instalacion', 'luis.valdivia@telmex.com', tmpvar);*/

/*
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       Null;
     WHEN OTHERS THEN
       Null;
*/
END;
/


