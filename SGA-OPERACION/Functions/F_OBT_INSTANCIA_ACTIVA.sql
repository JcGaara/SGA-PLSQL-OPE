CREATE OR REPLACE FUNCTION OPERACION.F_OBT_INSTANCIA_ACTIVA(a_objectname in varchar2,
                                                            a_value      in number)
  RETURN number IS
  li_instancetype integer;
  li_count        integer;

  /***********************************************************************************************
    NOMBRE:     OPERACION.F_OBT_INSTANCIA_ACTIVA
    PROPOSITO:  Verificar si una incidencia está bloqueada por alguna instancia activa
    PROGRAMADO EN JOB:  NO
  
    REVISIONES:
    Version      Fecha        Autor             Solicitado Por        Descripcion
    ---------  ----------  -----------------    --------------        ------------------------
    1.0        08/11/2010  Alexander Yong       Marco De La Cruz     Creación - REQ-148249: Error en el flujo de la atención de  incidencias
    2.0        13/07/2011  Alfonso Perez        Elver Ramirez        REQ 159092
  **********************************************************************************************/

BEGIN

  begin
    select codinstancetype
      into li_instancetype
      from instance_type
     where description = upper(a_objectname);
  
    select count(1)  --<2.0>
      into li_count
      from instance_active
     where codinstancetype = li_instancetype
       and value = decode(a_value, 0, value, a_value)
       and active = 1
       and usercode <> user;--<2.0>
    return li_count;
  
  exception
    when no_data_found then
      RETURN - 1;
  end;
END;
/
