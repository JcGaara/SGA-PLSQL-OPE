delete operacion.ope_cab_xml c where c.programa in 
('Valida_Numero_C',
'actualizarAfiliacion',
'RegistrarAfiliacion',
'actualizarEstadoAfiliacion');
commit;