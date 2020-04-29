CREATE OR REPLACE TRIGGER OPERACION.t_ope_envio_conax_bu
  BEFORE UPDATE ON operacion.ope_envio_conax
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW

 /**************************************************************************
   NOMBRE:     operacion.t_ope_envio_conax_bi
   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        23/11/2009  José Robles       Creacion, REQ 106908
   **************************************************************************/
BEGIN

   :new.fecmod := sysdate;
   :new.usumod := user;

END;
/



