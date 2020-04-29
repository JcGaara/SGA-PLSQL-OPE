insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado,idtrancorte) values(1,'Suspension por Morosidad',1,1,2);
insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado,idtrancorte) values(2,'Reconexion de Suspension por Morosidad',1,1,6);
insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado,idtrancorte) values(3,'Corte por Morosidad',1,1,3);
insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado,idtrancorte) values(4,'Reconexion de Corte por Morosidad',1,1,7);
insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado,idtrancorte) values(5,'Baja por Morosidad',1,1,4);
insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado) values(6,'Suspensión Temporal Total a Solicitud del Cliente',2,1);
insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado) values(7,'Suspensión Temporal sólo del BAF a Solicitud del Cliente',2,1);
insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado) values(8,'Suspensión Temporal sólo del BAM a Solicitud del Cliente',3,1);
insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado) values(9,'Re conexión del BAF + BAM a Solicitud del Cliente',2,1);
insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado) values(10,'Re conexión sólo del BAF a Solicitud del Cliente',2,1);
insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado) values(11,'Re conexión sólo del BAM a Solicitud del Cliente',3,1);
insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado) values(12,'Baja Total del Servicio a solicitud del cliente',2,1);
insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado) values(13,'Baja sólo del BAF a solicitud del cliente',2,1);
insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado) values(14,'Baja sólo del BAM a solicitud del cliente',3,1);
insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado) values(15,'Cambio de plan en el BAF',2,1);
insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado) values(16,'Cambio de Plan en BAM a Facturable',2,1);
insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado) values(17,'Cambio de plan en BAM a No Facturable',2,1);
insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado) values(18,'Cambio de plan en BAM pero mantiene el plan en BAF',2,1);
insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado) values(19,'Traslado interno o externo del BAF',2,1);
insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado) values(20,'Bloqueo por robo del BAM',3,1);
insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado) values(21,'Desbloqueo por robo del BAM',3,1);
insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado) values(22,'Alta por cambio de titularidad',2,1);
insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado) values(23,'Baja por cambio de titularidad',2,1);
insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado) values(24,'Alta por cambio de número.',2,1);
insert into OPERACION.TIPACCIONPV(idaccpv,desaccpv,origen,estado) values(25,'Baja por cambio de número.',2,1);


COMMIT;

grant execute on OPERACION.PQ_BAM to USREAISGA;
