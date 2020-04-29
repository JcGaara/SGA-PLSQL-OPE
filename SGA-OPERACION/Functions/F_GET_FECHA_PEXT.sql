CREATE OR REPLACE FUNCTION OPERACION.F_GET_FECHA_PEXT( a_codsolot in number, a_punto in number) RETURN date IS
ls_fecha otpto.fecfin%type;
ln_fecha number;
/*********************************************************************************************
06/07/2004    Se modifico el campo fecfin por fecfinsys         Victor Valqui
11/01/2005     Se agrego la tarea 425                             Carlos Corrales
12/12/2008   No considerar tareas en estado No interviene      Hector Huaman
*********************************************************************************************/

BEGIN
    begin
       select fecfinsys into ls_fecha
        from tareawf, wf
       where tareawf.idwf = wf.idwf and
              tareadef in (316, 323, 376, 425 ) and
             wf.codsolot = a_codsolot and
          tareawf.esttarea<>8 and
          estwf <> 5 and
          rownum = 1;
      exception
          when others then
           null;
  end;
  if ls_fecha is null then
     begin
         select fecfinins into ls_fecha
       from preubi
       where codsolot = a_codsolot and
              punto = a_punto;
        exception
          when others then
            null;
     end;
  end if;

  return ls_fecha;

  exception
      when others then
        return null;
END;
/


