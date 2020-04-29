-- Eliminacion de Detalle 
Delete from operacion.opedd 
 where tipopedd in ( select tipopedd from operacion.tipopedd where abrev ='SOFTSWITCH' );

-- Eliminacion de Cabecera
Delete from operacion.tipopedd 
 where abrev ='SOFTSWITCH';
 
-- Eliminacion de constante
Delete from operacion.constante 
 where constante = 'SOFTSWITCH';
 
 commit;