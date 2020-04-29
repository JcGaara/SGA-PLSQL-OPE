-- Eliminacion de Detalle 
Delete from operacion.opedd 
 where tipopedd in ( select tipopedd from operacion.tipopedd where abrev ='CONF_IMS' );
commit;

-- Eliminacion de Cabecera
Delete from operacion.tipopedd 
 where abrev ='CONF_IMS';
 commit;