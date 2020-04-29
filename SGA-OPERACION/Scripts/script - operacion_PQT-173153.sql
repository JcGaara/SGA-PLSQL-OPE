Begin

  insert into ope_parametros_globales_aux
    (NOMBRE_PARAMETRO,
     VALORPARAMETRO,
     DESCRIPCION,
     USUREG,
     FECREG,
     USUMOD,
     FECMOD)
  values
    ('cortesyreconexiones.cantidad_series_x_archivo',
     null,                                               -- Valor insertado a criterio del usuario. 
     'cantidad de series por archivo',
     User,
     sysdate,
     User,
     sysdate);
  commit;
end;