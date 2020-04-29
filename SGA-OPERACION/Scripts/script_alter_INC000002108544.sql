/* ******************** ******************** ******************** ******************** ******************** *
INSERT CONFIGURACION 
/* ******************** ******************** ******************** ******************** ******************** */
--atccorp.atcparameter
ALTER TABLE atccorp.atcparameter modify value VARCHAR2(250);
/

insert into atccorp.atcparameter
  (codparameter, description, value, active, observation)
values
  ('MSJSGA8',
   'Mensaje de Actualizacion de SGA',
   'Estimado usuario, le comunicamos que la versi�n 8 del SGA ya no se encuentra disponible, la nueva versi�n es la: SGA PERU V2 (SGA 2017). Por favor validar que cuente con el �cono de acceso directo o contactar a ATU para su instalaci�n, gracias.',
   1,
   'Actualizacion SGA 2017');
commit;
/