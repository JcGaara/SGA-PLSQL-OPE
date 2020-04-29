INSERT INTO sgacrm.inv_ventana
  (idventana, nombre, descripcion, ventana_hfc)
VALUES
  ((SELECT MAX(idventana) + 1 FROM inv_ventana),
   'w_mnt_act_incognito',
   'Ingreso de la SOT para Generacion de Baja, Reserva y Alta.',
   'w_mnt_act_incognito');

INSERT INTO opewf.tareadefventana
  (tareadef, orden, idventana, titulo)
VALUES
  (1020,
   1,
   (SELECT idventana
      FROM sgacrm.inv_ventana
     WHERE nombre = 'w_mnt_act_incognito'
       AND estado = 1),
   'Activacion Incognito');

INSERT INTO operacion.tiptraventana
  (tiptra, idventana, contrata, titulo, tipo)
VALUES
  (695,
   (SELECT idventana
      FROM sgacrm.inv_ventana
     WHERE nombre = 'w_mnt_act_incognito'
       AND estado = 1),
   1,
   'Activacion Incognito',
   1);

COMMIT
/