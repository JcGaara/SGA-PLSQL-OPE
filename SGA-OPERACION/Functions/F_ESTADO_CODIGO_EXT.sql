CREATE OR REPLACE FUNCTION OPERACION.F_ESTADO_CODIGO_EXT(p_idconfigitw in number,p_codsrv in tystabsrv.codsrv%type)
RETURN NUMBER
IS
/********************************************************************************
     NOMBRE: OPERACION.F_ESTADO_CODIGO_EXT

     Creacion
     Ver     Fecha          Autor             Descripcion
    ------  ----------  ----------       --------------------
     1.0     03/08/2009  Hector Huaman  M   REQ-96260: creacion.
 ********************************************************************************/

v_retorno number;
BEGIN
      select count(1) into v_retorno from configxservicio_itw
       where  idconfigitw=p_idconfigitw and codsrv=p_codsrv;


       return v_retorno;
END;
/


