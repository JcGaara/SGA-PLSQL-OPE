insert into tipopedd ( DESCRIPCION, ABREV)
values ( 'PORTABILIDAD NUMERICA', 'PORTABILIDAD_MSG');
COMMIT;

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, null, 'A la espera de que Receptor envíe Acreditación de Pago de Deuda', '01D05',(Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG')  , null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'A la espera de que el Receptor envíe Acreditación de Pago de Deuda', '01D04', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Finalizado', '04A99',(Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null,null, 'En Proceso', '00A11', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null,null, 'Enviada subsanación por CA', '00A14', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Rechazado por CA', '00A15', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Rechazado por MP', '00A03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'),null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null,null, 'En subsanación de PDV', '00A04',(Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'),null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null,null, 'Emitido', '00A05', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Asignado En MP', '00A06', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Evaluación en MP', '00A07', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente evaluación en MP', '00A08', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Cancelación por Rechazo no subsanable', '00A12', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Anulado', '00A09', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente de venta', '00A10', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'En Proceso de Activacion', '00A16', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'En Proceso de Desactivacion', '00A17', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Proceso terminado', '00A18', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente de reenvío SP', '00A19', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente de reenvío SVP', '00A20', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente de reenvío PP', '00A21', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente de reenvío SR', '00A22', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente de reenvío OCC', '00A23', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente de reenvío SAC', '00A24', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente de reenvío NI-SP', '00A25', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente de reenvío NI-SVP', '00A26', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente de reenvío NI-PP', '00A27', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente de reenvío NI-SR', '00A28', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente de reenvío NI-OCC', '00A29', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente de reenvío NI-SAC', '00A30', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'En Proceso de Envío SP', '00A13', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Proceso finalizado con error detectado por el ABDCP', '00A01', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Proceso exitoso', '00A02', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Enviada solicitud de portabilidad', '01R01', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibida asignación número de solicitud', '01R02', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibido rechazo por ABDCP', '01R03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Enviado mensaje de solicitud de portabilidad subsanada', '01R04', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibido validada por ABDCP', '01R05', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibido Solicitud Portabilidad Cedente', '01D01', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Enviada Objeción del Concesionario cedente', '01D02', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Enviada Solicitud Aceptada por Cedente', '01D03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibida Solicitud Procedente', '01A03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibida Objeción Procedente del Cedente', '01A04', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibida Cancelación por No Programación Fecha', '01A05', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Enviada Programación de Portabilidad', '01R06', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibida Programación para Ejecutar la Portabilidad', '01A06', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibido Fuera del límite para Ejecutar la Portabilidad', '01R07', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Enviada Solicitud de Retorno', '02R01', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibida Denegación Solicitud de Retorno', '02R02', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibida Aceptación de Retorno', '02R03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibida Solicitud Retorno al Cedente', '02D04', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibido mensaje NI', '03A01', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Registrado/Inicial', '00A00', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Instalado en SGA', '00A35', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Envío de Solicitud de Portabilidad Procedente por Expiración del Temporizador', '01A07', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recepción de Consulta Previa del Receptor', '05R01', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Envío de Asignación de Número de Consulta Previa', '05R02', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Envío de Rechazo de Consulta Previa por el ABDCP por Rechazo del ABDCP', '05R03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Envío de Consulta Previa al Cedente', '05D01', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recepción de Consulta Previa Objeción del Concesionario Cedente', '05D02', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recepción de Consulta Previa Aceptada por el Cedente', '05D03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Envío de Consulta Previa Procedente', '05A03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Envío de Rechazo de Consulta Previa por el ABDCP por Rechazo del Cedente', '05A04', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Envío Notificación de Error por Falta de Repuesta del Cedente', '05A05', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'En Proceso de Envío CP', '00A31', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'En Proceso de Acreditación', '00A32', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Finalizado Sin Envío', '00A33', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'En Proceso CP', '00A34', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);


COMMIT;

insert into tipopedd ( DESCRIPCION, ABREV)
values ( 'PORTABILIDAD NUMERICA', 'PORTABILIDAD_MSG_CP');
COMMIT;


insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, null, 'Tipo Servicio especificado no coincide con el Tipo Servicio definido en Plan de Numeración de Perú', 'REC01ABD12',(Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP')  , null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error interno: No se pudo conectar a la base de datos; Favor, contacte al administrador del sistema', 'ERRSOAP001', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'No se encontró ID de usuario en la BD. Por favor, intente con una identificación de usuario válida', 'ERRSOAP002',(Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null,null, 'Contraseña no válida para usuario. Por favor, intente nuevamente con la contraseña correcta', 'ERRSOAP003', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null,null, 'ID de usuario no pertenece al ID del operador remitente del mensaje', 'ERRSOAP004', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Tipo de mensaje no válido en parámetro', 'ERRSOAP005', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en la recuperación del parámetro sender. Parámetro no encontrado', 'ERRSOAP006', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'),null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null,null, 'Error en la recuperación del parámetro receiver. Parámetro no encontrado', 'ERRSOAP007',(Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'),null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null,null, 'Error en la recuperación del parámetro typeMsg. Parámetro no encontrado', 'ERRSOAP008', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Parámetro receiver no válido', 'ERRSOAP009', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Parámetro sender no válido', 'ERRSOAP010', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Parámetro typeMsg no válido', 'ERRSOAP011', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Formato del mensaje no cumple con el esquema XML', 'ERRSOAP012', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'No se han recibido los parámetros sender/receiver/typeMsg necesarios', 'ERRSOAP013', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Mensaje recibido fuera del horario laboral', 'ERRSOAP014', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Ya existe un proceso de portabilidad activo para la numeración solicitada.', 'REC02ABD07', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'WebService de validación: El número no pertenece al operador.', 'REC01ABD02', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Número de teléfono', 'NIN04ABD32', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'WebService de validación: El WebService de validación de usuario del cedente no está disponible.', 'REC01ABD09', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Numero secuencial ya existe en ABDCP', 'NIN04ABD33', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Número de identificador de mensaje ya existe en ABDCP', 'NIN04ABD34', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Fichero resumen adjuntos no encontrado', 'BCH01ABDCP09', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Fallo de réplica del mensaje desde el ABDCP al prestador implicado', 'ERROR00001', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Causas técnicas', 'ERROR00002', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Expiración de temporizadores críticos', 'ERROR00003', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Número de reintentos de reenvío superado', 'ERROR00004', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Solicitud Duplicada. La solicitud contiene numeraciones que ya se encuentran en proceso de cambio', 'REC01ABD01', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'La numeración solicitada ya se encuentra portada al operador receptor', 'REC01ABD03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'La numeración no pertenece al operador cedente.', 'REC01ABD04', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Numeración dentro del plazo mínimo de contratación.', 'REC01ABD05', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'WebService de validación: Numeración no corresponde con la modalidad de pago', 'REC01ABD06', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Numeración no está asignada a ningún operador', 'REC01ABD07', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'WebService de validación: Tipo o Número de documento incorrecto', 'REC01ABD08', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Las numeraciones a retornar no se encuentran portadas al concesionario solicitante', 'REC02ABD01', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Solicitud contiene numeraciones que no se encuentran portadas', 'REC02ABD02', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'No todas las numeraciones solicitadas pertenecen al mismo operador cedente inicial', 'REC02ABD05', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Fecha de ventana de cesión propuesta no válida', 'REC02ABD06', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'El abonado tiene el servicio suspendido', 'REC01PRT01', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'El abonado tiene deuda exigible', 'REC01PRT02', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'El solicitante ya no es abonado postpago', 'REC01PRT03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'El solicitante ya no es abonado prepago', 'REC01PRT04', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Identificador de mensaje', 'NIN04ABD01', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Fecha de creación del mensaje', 'NIN04ABD02', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Número secuencial', 'NIN04ABD03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Remitente', 'NIN04ABD04', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Destinatario', 'NIN04ABD05', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Observaciones', 'NIN04ABD06', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Código del Receptor', 'NIN04ABD07', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Código del Cedente', 'NIN04ABD08', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Número de documento de identidad', 'NIN04ABD09', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Cantidad de Numeraciones', 'NIN04ABD10', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Inicio Rango', 'NIN04ABD11', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Final Rango', 'NIN04ABD12', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Tipo de Portabilidad', 'NIN04ABD13', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Número de adjuntos', 'NIN04ABD14', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Nombre de Adjunto', 'NIN04ABD15', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Nombre contacto', 'NIN04ABD16', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Email contacto', 'NIN04ABD17', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Teléfono contacto', 'NIN04ABD18', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Fax contacto', 'NIN04ABD19', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: Cantidad de numeraciones en la solicitud no coincide con las numeraciones recibidas', 'NIN04ABD20', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: Cantidad de adjuntos en la solicitud no coincide con los adjuntos recibidos', 'NIN04ABD21', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Identificador de solicitud', 'NIN04ABD22', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Causa objeción', 'NIN04ABD23', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Número de teléfono en la objeción', 'NIN04ABD24', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: Cantidad de adjuntos en la objeción no coincide con los adjuntos recibidos', 'NIN04ABD25', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Fecha de ejecución de portabilidad', 'NIN04ABD26', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Código del cedente inicial', 'NIN04ABD27', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Número a retornar', 'NIN04ABD28', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Fecha de ejecución de retorno', 'NIN04ABD29', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Motivo de retorno', 'NIN04ABD30', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Tipo documento de identificación', 'NIN04ABD31', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error al descomprimir el fichero', 'BCH01ABDCP01', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Fecha/Hora de envío del fichero incorrectas', 'BCH01ABDCP02', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Formato del fichero incorrecto', 'BCH01ABDCP03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Fichero no contiene registro de control de inicio', 'BCH01ABDCP04', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Fichero no contiene registro de control de fin', 'BCH01ABDCP05', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Registro de control de inicio con formato incorrecto', 'BCH01ABDCP06', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Número de registros en fichero no coincide con registro de control de inicio', 'BCH01ABDCP07', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Causas técnicas', 'BCH01ABDCP08', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Formato de línea de fichero no corresponde con el tipo de mensaje', 'BCH01ABDCP10', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'El abonado tiene deuda exigible', 'REC01PRT09', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'El número telefónico no pertenece al Concesionario cedente', 'REC01PRT05', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Finalización de Consulta Previa por Falta de Respuesta del Cedente', 'REC00ABD02', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'El número de Consulta Previa indicado no es válido', 'REC01ABD10', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'El Cedente no respondieron a la Consulta Previa', 'REC01ABD11', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'El número telefónico no pertenece al Tipo de Servicio indicado', 'REC01PRT06', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'El telefono no corresponde al doc de ID legal indicado, o la parte solicitante ya no es un abonado', 'REC01PRT07', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'El número telefónico no corresponde a la modalidad indicada (Prepago/Postpago).', 'REC01PRT08', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Mensaje fuera de secuencia', 'REC00ABD01', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Acreditación Pago Deuda rechazada debido a discrepancia en el monto y/o tipo de moneda', 'REC00ABD03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Acreditación Pago Deuda rechazada debido a número de intentos excedidos', 'REC00ABD04', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: El Cedente o Receptor no coincide con un participante válido', 'NIN04ABD35', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: El ID del Cedente y el ID del Receptor no pueden ser iguales', 'NIN04ABD36', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: El Emisor y el Receptor deben ser iguales', 'NIN04ABD37', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: El Número de Teléfono Duplicado ya está en la lista', 'NIN04ABD38', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: Número de Teléfono De debe ser igual a Número de Teléfono A', 'NIN04ABD39', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: El Nombre del Adjunto se utilizó previamente y se considera un duplicado', 'NIN04ABD40', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: El Número Teléfono en el mensaje no coincide con el Número Teléfono en el mensaje original', 'NIN04ABD41', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: Falta de coincidencia del Tip de Cliente.La Cantidad de Números de Teléfono no es mayor a 10', 'NIN04ABD42', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: El monto, la fecha de vencimiento y la moneda son requeridos para este Motivo de Rechazo', 'NIN04ABD43', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: El monto, la fecha de venc y la moneda no deberían ser ingresados para este Motivo de Rechazo', 'NIN04ABD44', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: El Remitente y el Cedente deben ser el mismo', 'NIN04ABD45', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);


COMMIT;