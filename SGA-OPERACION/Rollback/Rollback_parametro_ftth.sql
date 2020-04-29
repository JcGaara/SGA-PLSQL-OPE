delete from operacion.opedd where descripcion='TERMINAL GPON HUAWEI HG8247U' and tipopedd=(select tipopedd from operacion.tipopedd t where t.abrev = 'EMTA_SISACT_SGA');
delete from operacion.opedd where descripcion='FTTH - SISACT INSTALACION PAQUETES TODO CLARO DIGITAL' and tipopedd=506;
delete from operacion.opedd where descripcion='VENTA SISACT FTTH' and tipopedd=(select tipopedd from tipopedd where abrev='TIPTRABAJO');
Commit;