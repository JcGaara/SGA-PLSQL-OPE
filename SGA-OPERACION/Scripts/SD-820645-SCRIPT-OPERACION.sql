ALTER TABLE OPERACION.INVENTARIO_ENV_ADC ADD  flg_del VARCHAR2(1) default '0';

comment on column OPERACION.INVENTARIO_ENV_ADC.flg_del
is 'Flag para indicar la eliminacion logica del registro';


INSERT INTO operacion.parametro_cab_adc (descripcion, abreviatura, estado) VALUES ('CARGA_INVENTARIO_USUARIOS', 'CARG_INV_USUARIOS', '1');
          
      INSERT INTO operacion.parametro_det_adc (id_parametro, codigoc, codigon, descripcion, abreviatura, estado) 
      VALUES ((SELECT a.id_parametro FROM operacion.parametro_cab_adc a WHERE a.abreviatura = 'CARG_INV_USUARIOS'),'C14733',  NULL, 'USUARIO ADMINISTRADOR', 'A', '0');
      
      INSERT INTO operacion.parametro_det_adc (id_parametro, codigoc, codigon, descripcion, abreviatura, estado) 
      VALUES ((SELECT a.id_parametro FROM operacion.parametro_cab_adc a WHERE a.abreviatura = 'CARG_INV_USUARIOS'),'C14290',  NULL, 'USUARIO ADMINISTRADOR', 'A', '0');
      
 
INSERT INTO operacion.parametro_cab_adc (descripcion, abreviatura, estado) VALUES ('CARGA_INVENTARIO_ACCIONES', 'PARAMETROS', '1');
          
      INSERT INTO operacion.parametro_det_adc (id_parametro, codigoc, codigon, descripcion, abreviatura, estado) 
      VALUES ((SELECT a.id_parametro FROM operacion.parametro_cab_adc a WHERE a.abreviatura = 'PARAMETROS'),'delete_inventory',  NULL, 'ELIMINA', 'D', '1');

      INSERT INTO operacion.parametro_det_adc (id_parametro, codigoc, codigon, descripcion, abreviatura, estado) 
      VALUES ((SELECT a.id_parametro FROM operacion.parametro_cab_adc a WHERE a.abreviatura = 'PARAMETROS'),'update_inventory',  NULL, 'ACTUALIZA', 'U', '1');           
commit;
/
