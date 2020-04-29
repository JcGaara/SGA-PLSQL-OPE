CREATE OR REPLACE FUNCTION OPERACION.F_VALIDA_RECHAZO(a_codsolot in number, a_tiptra in number, a_estado in number) RETURN number IS
ls_estado_tarea varchar(30);
li_count number;
li_tipestado number;
CURSOR cur_tareas IS      -- Cursor: Tareas ingresadas en el Configurable
SELECT O.CODIGON
    FROM OPERACION.TIPOPEDD T, OPERACION.OPEDD O
     WHERE T.TIPOPEDD = O.TIPOPEDD
     AND T.ABREV = 'TIPTRA_TAREAS'
     AND O.ABREVIACION = TO_CHAR(a_tiptra)
     AND O.CODIGON_AUX = 1;

BEGIN

  select tipestsol
  into li_tipestado
  from estsol e
  where e.estsol = a_estado;

  if (li_tipestado <> 7) then
    return 0;
  end if;

  SELECT COUNT(*)
  INTO li_count
    FROM OPERACION.TIPOPEDD T, OPERACION.OPEDD O
     WHERE T.TIPOPEDD = O.TIPOPEDD
     AND T.ABREV = 'TIPTRA_TAREAS'
     AND O.ABREVIACION = TO_CHAR(a_tiptra)
     AND O.CODIGON_AUX = 1;

  if (li_count = 0) then
    return 0;
  end if;

  FOR c_1 IN cur_tareas LOOP
     BEGIN
     select t.descripcion
     into ls_estado_tarea
     from wf w
        , tareawf f
        , tareadef e
        , esttarea t
        , solot s
      where w.idwf = f.idwf
        and f.tareadef = e.tareadef
        and f.esttarea = t.esttarea
        and w.valido = 1
        and w.codsolot = s.codsolot
        and s.codsolot = a_codsolot
        and e.tareadef = c_1.CODIGON;
     EXCEPTION
       WHEN OTHERS THEN
         return 0;
     END;

     IF (ls_estado_tarea <> 'Cerrada') THEN
       RETURN 0;
     END IF;
  END LOOP;

  RETURN 1;

EXCEPTION
   WHEN OTHERS THEN
   return 0;
END F_VALIDA_RECHAZO;

/
