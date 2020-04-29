--CREAR TAREA
DECLARE
  C_DESCRIPCION CONSTANT tareadef.descripcion%TYPE := 'Actualización información BSCS';
  C_PRE_PROC    CONSTANT tareadef.pre_proc%TYPE := 'OPERACION.PQ_OPE_SIAC_BSCS.ENVIAR_DIRECCION_BSCS';
  l_tareadef tareadef%ROWTYPE;
  /* *********************************/
  FUNCTION get_new_tareadef RETURN tareadef.tareadef%TYPE IS
    l_return tareadef.tareadef%TYPE;
  BEGIN
    SELECT MAX(tareadef) + 1 INTO l_return FROM tareadef;
    RETURN l_return;
  END;
  /* *********************************/
BEGIN

  l_tareadef.tareadef    := get_new_tareadef();
  l_tareadef.tipo        := 0;
  l_tareadef.descripcion := C_DESCRIPCION;
  l_tareadef.pre_proc    := C_PRE_PROC;

  INSERT INTO tareadef VALUES l_tareadef;
  COMMIT;
  
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
