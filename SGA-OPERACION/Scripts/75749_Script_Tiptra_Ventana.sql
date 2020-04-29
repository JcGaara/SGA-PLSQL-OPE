insert into operacion.tiptraventana (TIPTRA, IDVENTANA, CONTRATA, TITULO, TIPO, USUREG, FECREG, USUMOD, FECMOD)
values ((select tiptra from operacion.tiptrabajo where descripcion='INSTALACION 3 PLAY INALAMBRICO'), 66, 1, 'Liquidación Equipos v3', 1, user, sysdate, user, sysdate);
insert into operacion.tiptraventana (TIPTRA, IDVENTANA, CONTRATA, TITULO, TIPO, USUREG, FECREG, USUMOD, FECMOD)
values ((select tiptra from operacion.tiptrabajo where descripcion='INSTALACION 3 PLAY INALAMBRICO'), 22, 1, 'Liquidacion Equipos', 1, user, sysdate, user, sysdate);
insert into operacion.tiptraventana (TIPTRA, IDVENTANA, CONTRATA, TITULO, TIPO, USUREG, FECREG, USUMOD, FECMOD)
values ((select tiptra from operacion.tiptrabajo where descripcion='INSTALACION 3 PLAY INALAMBRICO'), 18, 1, 'Consulta Incidencia', 1, user, sysdate, user, sysdate);
insert into operacion.tiptraventana (TIPTRA, IDVENTANA, CONTRATA, TITULO, TIPO, USUREG, FECREG, USUMOD, FECMOD)
values ((select tiptra from operacion.tiptrabajo where descripcion='INSTALACION 3 PLAY INALAMBRICO'), 25, 1, 'Observaciones SOT', 1, user, sysdate, user, sysdate);
insert into operacion.tiptraventana (TIPTRA, IDVENTANA, CONTRATA, TITULO, TIPO, USUREG, FECREG, USUMOD, FECMOD)
values ((select tiptra from operacion.tiptrabajo where descripcion='INSTALACION 3 PLAY INALAMBRICO'), 29, 0, 'Rechazar SOT', 1, user, sysdate, user, sysdate);
insert into operacion.tiptraventana (TIPTRA, IDVENTANA, CONTRATA, TITULO, TIPO, USUREG, FECREG, USUMOD, FECMOD)
values ((select tiptra from operacion.tiptrabajo where descripcion='INSTALACION 3 PLAY INALAMBRICO'), 42, 0, 'Cambio de Estado SOT', 2, user, sysdate, user, sysdate);
commit;