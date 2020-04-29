CREATE OR REPLACE FUNCTION OPERACION.f_valida_serie_equipo(p_tipequ number, p_numserie varchar2)
return number
is
equipo_disp number;
begin

 /* select count( distinct m.COD_SAP) into equipo_disp
  from tipequ t, almtabmat a, OPERACION.MAESTRO_SERIES_EQU m
  where t.tipequ = p_tipequ
  and t.codtipequ = a.codmat
  and trim(a.cod_sap) = trim(m.COD_SAP)
  and trim(m.nroserie) = trim(p_numserie)
  and m.DISPONIBLE = 0;

  if equipo_disp > 0 then
     equipo_disp := 1;
  end if;


  return equipo_disp;*/
  return 1;
end;
/


