CREATE OR REPLACE VIEW OPERACION.V_POP_VENTAS
AS 
SELECT ubired.codubired,
         ubired.descripcion,
         ubired.direccion,
         ubired.codubi,
         ubired.codpostal,
         v_ubicaciones.distrito_desc,
         (SELECT opedd.DESCRIPCION fROM opedd WHERE ubired.TIPO=opedd.CODIGON(+) and opedd.TIPOPEDD=11) tipo_desc,
         ubired.descripcion ||' ('|| ubired.direccion ||' CP:'||ubired.codpostal ||' '||
         v_ubicaciones.distrito_desc ||')' desc_completa
    FROM ubired,
         v_ubicaciones
   WHERE ( ubired.codubi = v_ubicaciones.codubi (+))
   and  ubired.tipo in (1,2,3);


