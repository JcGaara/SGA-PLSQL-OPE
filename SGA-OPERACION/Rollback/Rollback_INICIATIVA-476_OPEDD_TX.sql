delete operacion.opedd where tipopedd
in (select tipopedd from operacion.tipopedd where abrev in ('TU_TIPO_ZONA','TU_TIPO_INTERIOR','TU_TIPO_MANZANA','TU_TIPO_PAISES'));
delete operacion.tipopedd where abrev in ('TU_TIPO_ZONA','TU_TIPO_INTERIOR','TU_TIPO_MANZANA','TU_TIPO_PAISES');
commit;
