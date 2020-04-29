CREATE OR REPLACE VIEW OPERACION.V_CONF_AUTO_SERVICIO
AS 
SELECT EQUIPORED.DESCRIPCION equipo, tipequipored.descripcion tipo_equipo
  FROM EQUIPORED, ubired, TIPEQU, tipequipored, ambientered, rackred
 WHERE EQUIPORED.TIPEQU = TIPEQU.TIPEQU(+)
   and equipored.codubired = ubired.codubired(+)
   and equipored.codambiente = ambientered.codambiente(+)
   and tipequipored.codtipo(+) = equipored.tipo
   and equipored.codrack = rackred.codrack(+);


