CREATE OR REPLACE VIEW OPERACION.V_EQUIPOS_RED
AS 
SELECT
  equipored.codequipo codigo_equipo,
  equipored.descripcion nombre_equipo,
  tipequipored.descripcion tipo_equipo,
  pop.DESCRIPCION nombre_POP,
  pop.direccion direccion_POP,
  nodo.DESCRIPCION nombre_nodo,
  nodo.Direccion direccion_nodo,
  equipored.linea linea_nodo,
  ee.descripcion estado_equipo,
  equipored.PLATAFORMA plataforma_equipo,
  tipo_red.descripcion tipo_red_equipo
  FROM
  equipored,
  tipequipored,
  ubired pop,
  ubired nodo,
  V_DD_UBIC_EQUIPORED tipo_red,
  (SELECT CODIGON estado, DESCRIPCION FROM opedd WHERE tipopedd = 36) ee
WHERE
  equipored.codubired = pop.codubired (+) AND
  equipored.codubired = nodo.codubired (+) AND
  equipored.tipo = tipequipored.codtipo (+) AND
  equipored.acceso_red = tipo_red.TIPO (+) AND
  equipored.estado = ee.estado;


