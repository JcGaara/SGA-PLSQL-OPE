CREATE OR REPLACE TRIGGER OPERACION.t_ope_envio_conax_bi
  BEFORE INSERT ON operacion.ope_envio_conax
  REFERENCING OLD AS OLD NEW AS NEW
  FOR EACH ROW

 /**************************************************************************
   NOMBRE:     operacion.t_ope_envio_conax_bi
   REVISIONES:
   Ver        Fecha        Autor            Descripcion
   ---------  ----------  ---------------   ------------------------
   1.0        23/11/2009  Jos� Robles       Creacion, REQ 106908
   **************************************************************************/
BEGIN

   select operacion.sq_ope_envio_conax_id.nextval
   into   :new.idenvio

   from   DUMMY_OPE;

END;
/



