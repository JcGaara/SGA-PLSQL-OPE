CREATE OR REPLACE PROCEDURE OPERACION.P_verificar_ef_de_sol (
a_codef IN NUMBER, as_return out varchar2
)
IS
/******************************************************************************
Funcion que verifica si los detalles de proyecto y ef son iguales
Fecha        Autor           Descripcion
----------  ---------------  ------------------------
21/06/2004 Edilberto Astulle
03/08/2004 Carlos Corrales	 Correccion de servicio y bw en caso de nullo.
27/04/2005 Victor Valqui	 Correccion de descripcion y suc en caso de ser nullo.
******************************************************************************/
--Query de los puntos principales del proyecto
ln_count number(10);
cursor c_proyectos is
SELECT a_codef codef, TO_NUMBER (numpto) numpto, descpto descripcion,
   dirpto direccion, codsuc, ubipto codubi,
   codsrv, banwid bw, tiptra
FROM vtadetptoenl
WHERE crepto = '1'
AND numslc = LPAD (a_codef, 10, '0')
AND (   (codequcom IS NULL)
    OR (codequcom IS NOT NULL AND numpto = numpto_prin));
BEGIN
   --Comparar solo los siguientes campos entre detalle de EF y Proyecto
   --codef, punto, descripcion, direccion, codsuc, codubi, codsrv,bw, codinssrv, tiptra
   as_return := null;
   FOR r_cursor IN c_proyectos loop
   	   select count(*) into ln_count from efpto where
	   codef = r_cursor.codef and punto = r_cursor.numpto and
--	   descripcion = r_cursor.descripcion and direccion = r_cursor.direccion and
	   nvl(descripcion,'-1') = nvl(r_cursor.descripcion,'-1') and direccion = r_cursor.direccion and
--   	   codsuc = r_cursor.codsuc and codubi = r_cursor.codubi and
	   nvl(codsuc,-1)= nvl(r_cursor.codsuc,-1) and nvl(codubi,-1) = nvl(r_cursor.codubi,-1) and
	   nvl(codsrv,' ') = nvl(r_cursor.codsrv,' ') and
       nvl(bw,0) = nvl(r_cursor.bw,0) and
	   nvl(tiptra,-1) = nvl(r_cursor.tiptra,-1);
	   --Si el registro detalle de proyecto y de estudio de factibilidad
	   --no coincide entonces hay problemas
	   if ln_count = 0 then
		  as_return := 'No coinciden el detalle de proyecto con el estudio de factibilidad, debe actualizar datos';
		  exit;
	   end if;
   END LOOP;
END;
/


