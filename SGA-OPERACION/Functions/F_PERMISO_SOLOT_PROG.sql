CREATE OR REPLACE FUNCTION OPERACION.F_PERMISO_SOLOT_PROG(
   a_codsolot in number
) RETURN NUMBER
IS
/******************************************************************************
Determina si el usuario puede modificar estado de la SOT en el Programación de Instalaciones
Devuelve 0 No puede
Devuelve 1 Puede modificar
******************************************************************************/

l_cont number;

BEGIN

   select count(*) into l_cont from
   solot where codsolot=a_codsolot
   and tipsrv in('0066', '0060','0059','0058','0055',
   '0053','0052', '0050', '0049','0047','0042','0040',
   '0036', '0032', '0025','0024','0022','0020','0019',
   '0018','0015', '0014','0011', '0010', '0006','0005',
   '0004','0003');

   if l_cont>0 then
    return 1;
   else
    return 0;
   end if;

   EXCEPTION
     WHEN OTHERS THEN
     RETURN 0;

END;
/


