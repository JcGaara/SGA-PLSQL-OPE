
UPDATE operacion.clrht_trmodelo
SET TRV_MODELO_INC = 'TG862A'
WHERE TRV_MODELO = 'TG862A';

UPDATE operacion.clrht_trmodelo
SET TRV_MODELO_INC = 'TG862G'
WHERE TRV_MODELO = 'TG862G';

UPDATE operacion.clrht_trmodelo
SET TRV_MODELO_INC = 'TG1662G'
WHERE TRV_MODELO = 'TG1662G';

UPDATE  operacion.clrht_trmodelo
SET TRV_MODELO_INC = 'DPC3928'
WHERE TRV_MODELO  = 'DPC3928S';

UPDATE  operacion.clrht_trmodelo
SET TRV_MODELO_INC = 'DPC3928S'
WHERE TRV_MODELO  = 'DPC3928CS';

UPDATE operacion.clrht_trmodelo
SET TRV_GRUPO = 'root.devicetypes.cisco'
WHERE TRV_MODELO in ('DPC3928CS','DPC3928S');

/