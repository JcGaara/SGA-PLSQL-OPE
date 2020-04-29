update operacion.tiptrabajo 
set descripcion='WLL/SIAC - INST/DESINSTALACION DECO ADICIONAL' 
  where tiptra = (select tiptra from operacion.tiptrabajo where descripcion='WLL/SIAC - CAMBIO DE DECOS')

/

commit;
