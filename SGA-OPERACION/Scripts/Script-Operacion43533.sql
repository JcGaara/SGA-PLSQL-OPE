insert into tipopedd ( DESCRIPCION, ABREV)
values ( 'PORTABILIDAD NUMERICA', 'PORTABILIDAD_MSG');
COMMIT;

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, null, 'A la espera de que Receptor env�e Acreditaci�n de Pago de Deuda', '01D05',(Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG')  , null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'A la espera de que el Receptor env�e Acreditaci�n de Pago de Deuda', '01D04', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Finalizado', '04A99',(Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null,null, 'En Proceso', '00A11', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null,null, 'Enviada subsanaci�n por CA', '00A14', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Rechazado por CA', '00A15', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Rechazado por MP', '00A03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'),null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null,null, 'En subsanaci�n de PDV', '00A04',(Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'),null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null,null, 'Emitido', '00A05', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Asignado En MP', '00A06', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Evaluaci�n en MP', '00A07', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente evaluaci�n en MP', '00A08', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Cancelaci�n por Rechazo no subsanable', '00A12', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

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
values (null,null, 'Pendiente de reenv�o SP', '00A19', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente de reenv�o SVP', '00A20', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente de reenv�o PP', '00A21', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente de reenv�o SR', '00A22', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente de reenv�o OCC', '00A23', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente de reenv�o SAC', '00A24', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente de reenv�o NI-SP', '00A25', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente de reenv�o NI-SVP', '00A26', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente de reenv�o NI-PP', '00A27', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente de reenv�o NI-SR', '00A28', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente de reenv�o NI-OCC', '00A29', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Pendiente de reenv�o NI-SAC', '00A30', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'En Proceso de Env�o SP', '00A13', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Proceso finalizado con error detectado por el ABDCP', '00A01', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Proceso exitoso', '00A02', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Enviada solicitud de portabilidad', '01R01', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibida asignaci�n n�mero de solicitud', '01R02', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibido rechazo por ABDCP', '01R03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Enviado mensaje de solicitud de portabilidad subsanada', '01R04', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibido validada por ABDCP', '01R05', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibido Solicitud Portabilidad Cedente', '01D01', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Enviada Objeci�n del Concesionario cedente', '01D02', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Enviada Solicitud Aceptada por Cedente', '01D03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibida Solicitud Procedente', '01A03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibida Objeci�n Procedente del Cedente', '01A04', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibida Cancelaci�n por No Programaci�n Fecha', '01A05', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Enviada Programaci�n de Portabilidad', '01R06', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibida Programaci�n para Ejecutar la Portabilidad', '01A06', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibido Fuera del l�mite para Ejecutar la Portabilidad', '01R07', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Enviada Solicitud de Retorno', '02R01', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibida Denegaci�n Solicitud de Retorno', '02R02', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibida Aceptaci�n de Retorno', '02R03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibida Solicitud Retorno al Cedente', '02D04', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recibido mensaje NI', '03A01', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Registrado/Inicial', '00A00', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Instalado en SGA', '00A35', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Env�o de Solicitud de Portabilidad Procedente por Expiraci�n del Temporizador', '01A07', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recepci�n de Consulta Previa del Receptor', '05R01', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Env�o de Asignaci�n de N�mero de Consulta Previa', '05R02', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Env�o de Rechazo de Consulta Previa por el ABDCP por Rechazo del ABDCP', '05R03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Env�o de Consulta Previa al Cedente', '05D01', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recepci�n de Consulta Previa Objeci�n del Concesionario Cedente', '05D02', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Recepci�n de Consulta Previa Aceptada por el Cedente', '05D03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Env�o de Consulta Previa Procedente', '05A03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Env�o de Rechazo de Consulta Previa por el ABDCP por Rechazo del Cedente', '05A04', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Env�o Notificaci�n de Error por Falta de Repuesta del Cedente', '05A05', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'En Proceso de Env�o CP', '00A31', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'En Proceso de Acreditaci�n', '00A32', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Finalizado Sin Env�o', '00A33', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'En Proceso CP', '00A34', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG'), null);


COMMIT;

insert into tipopedd ( DESCRIPCION, ABREV)
values ( 'PORTABILIDAD NUMERICA', 'PORTABILIDAD_MSG_CP');
COMMIT;


insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null, null, 'Tipo Servicio especificado no coincide con el Tipo Servicio definido en Plan de Numeraci�n de Per�', 'REC01ABD12',(Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP')  , null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error interno: No se pudo conectar a la base de datos; Favor, contacte al administrador del sistema', 'ERRSOAP001', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'No se encontr� ID de usuario en la BD. Por favor, intente con una identificaci�n de usuario v�lida', 'ERRSOAP002',(Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null,null, 'Contrase�a no v�lida para usuario. Por favor, intente nuevamente con la contrase�a correcta', 'ERRSOAP003', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null,null, 'ID de usuario no pertenece al ID del operador remitente del mensaje', 'ERRSOAP004', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Tipo de mensaje no v�lido en par�metro', 'ERRSOAP005', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en la recuperaci�n del par�metro sender. Par�metro no encontrado', 'ERRSOAP006', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'),null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null,null, 'Error en la recuperaci�n del par�metro receiver. Par�metro no encontrado', 'ERRSOAP007',(Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'),null);

insert into opedd ( CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values ( null,null, 'Error en la recuperaci�n del par�metro typeMsg. Par�metro no encontrado', 'ERRSOAP008', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Par�metro receiver no v�lido', 'ERRSOAP009', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Par�metro sender no v�lido', 'ERRSOAP010', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Par�metro typeMsg no v�lido', 'ERRSOAP011', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Formato del mensaje no cumple con el esquema XML', 'ERRSOAP012', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'No se han recibido los par�metros sender/receiver/typeMsg necesarios', 'ERRSOAP013', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Mensaje recibido fuera del horario laboral', 'ERRSOAP014', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Ya existe un proceso de portabilidad activo para la numeraci�n solicitada.', 'REC02ABD07', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'WebService de validaci�n: El n�mero no pertenece al operador.', 'REC01ABD02', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: N�mero de tel�fono', 'NIN04ABD32', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'WebService de validaci�n: El WebService de validaci�n de usuario del cedente no est� disponible.', 'REC01ABD09', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Numero secuencial ya existe en ABDCP', 'NIN04ABD33', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'N�mero de identificador de mensaje ya existe en ABDCP', 'NIN04ABD34', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Fichero resumen adjuntos no encontrado', 'BCH01ABDCP09', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Fallo de r�plica del mensaje desde el ABDCP al prestador implicado', 'ERROR00001', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Causas t�cnicas', 'ERROR00002', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Expiraci�n de temporizadores cr�ticos', 'ERROR00003', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'N�mero de reintentos de reenv�o superado', 'ERROR00004', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Solicitud Duplicada. La solicitud contiene numeraciones que ya se encuentran en proceso de cambio', 'REC01ABD01', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'La numeraci�n solicitada ya se encuentra portada al operador receptor', 'REC01ABD03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'La numeraci�n no pertenece al operador cedente.', 'REC01ABD04', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Numeraci�n dentro del plazo m�nimo de contrataci�n.', 'REC01ABD05', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'WebService de validaci�n: Numeraci�n no corresponde con la modalidad de pago', 'REC01ABD06', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Numeraci�n no est� asignada a ning�n operador', 'REC01ABD07', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'WebService de validaci�n: Tipo o N�mero de documento incorrecto', 'REC01ABD08', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Las numeraciones a retornar no se encuentran portadas al concesionario solicitante', 'REC02ABD01', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Solicitud contiene numeraciones que no se encuentran portadas', 'REC02ABD02', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'No todas las numeraciones solicitadas pertenecen al mismo operador cedente inicial', 'REC02ABD05', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Fecha de ventana de cesi�n propuesta no v�lida', 'REC02ABD06', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

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
values (null,null, 'Error en formato: Fecha de creaci�n del mensaje', 'NIN04ABD02', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: N�mero secuencial', 'NIN04ABD03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Remitente', 'NIN04ABD04', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Destinatario', 'NIN04ABD05', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Observaciones', 'NIN04ABD06', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: C�digo del Receptor', 'NIN04ABD07', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: C�digo del Cedente', 'NIN04ABD08', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: N�mero de documento de identidad', 'NIN04ABD09', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Cantidad de Numeraciones', 'NIN04ABD10', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Inicio Rango', 'NIN04ABD11', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Final Rango', 'NIN04ABD12', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Tipo de Portabilidad', 'NIN04ABD13', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: N�mero de adjuntos', 'NIN04ABD14', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Nombre de Adjunto', 'NIN04ABD15', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Nombre contacto', 'NIN04ABD16', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Email contacto', 'NIN04ABD17', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Tel�fono contacto', 'NIN04ABD18', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Fax contacto', 'NIN04ABD19', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: Cantidad de numeraciones en la solicitud no coincide con las numeraciones recibidas', 'NIN04ABD20', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: Cantidad de adjuntos en la solicitud no coincide con los adjuntos recibidos', 'NIN04ABD21', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Identificador de solicitud', 'NIN04ABD22', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Causa objeci�n', 'NIN04ABD23', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: N�mero de tel�fono en la objeci�n', 'NIN04ABD24', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: Cantidad de adjuntos en la objeci�n no coincide con los adjuntos recibidos', 'NIN04ABD25', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Fecha de ejecuci�n de portabilidad', 'NIN04ABD26', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: C�digo del cedente inicial', 'NIN04ABD27', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: N�mero a retornar', 'NIN04ABD28', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Fecha de ejecuci�n de retorno', 'NIN04ABD29', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Motivo de retorno', 'NIN04ABD30', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error en formato: Tipo documento de identificaci�n', 'NIN04ABD31', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error al descomprimir el fichero', 'BCH01ABDCP01', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Fecha/Hora de env�o del fichero incorrectas', 'BCH01ABDCP02', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Formato del fichero incorrecto', 'BCH01ABDCP03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Fichero no contiene registro de control de inicio', 'BCH01ABDCP04', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Fichero no contiene registro de control de fin', 'BCH01ABDCP05', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Registro de control de inicio con formato incorrecto', 'BCH01ABDCP06', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'N�mero de registros en fichero no coincide con registro de control de inicio', 'BCH01ABDCP07', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Causas t�cnicas', 'BCH01ABDCP08', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Formato de l�nea de fichero no corresponde con el tipo de mensaje', 'BCH01ABDCP10', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'El abonado tiene deuda exigible', 'REC01PRT09', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'El n�mero telef�nico no pertenece al Concesionario cedente', 'REC01PRT05', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Finalizaci�n de Consulta Previa por Falta de Respuesta del Cedente', 'REC00ABD02', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'El n�mero de Consulta Previa indicado no es v�lido', 'REC01ABD10', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'El Cedente no respondieron a la Consulta Previa', 'REC01ABD11', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'El n�mero telef�nico no pertenece al Tipo de Servicio indicado', 'REC01PRT06', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'El telefono no corresponde al doc de ID legal indicado, o la parte solicitante ya no es un abonado', 'REC01PRT07', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'El n�mero telef�nico no corresponde a la modalidad indicada (Prepago/Postpago).', 'REC01PRT08', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Mensaje fuera de secuencia', 'REC00ABD01', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Acreditaci�n Pago Deuda rechazada debido a discrepancia en el monto y/o tipo de moneda', 'REC00ABD03', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Acreditaci�n Pago Deuda rechazada debido a n�mero de intentos excedidos', 'REC00ABD04', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: El Cedente o Receptor no coincide con un participante v�lido', 'NIN04ABD35', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: El ID del Cedente y el ID del Receptor no pueden ser iguales', 'NIN04ABD36', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: El Emisor y el Receptor deben ser iguales', 'NIN04ABD37', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: El N�mero de Tel�fono Duplicado ya est� en la lista', 'NIN04ABD38', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: N�mero de Tel�fono De debe ser igual a N�mero de Tel�fono A', 'NIN04ABD39', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: El Nombre del Adjunto se utiliz� previamente y se considera un duplicado', 'NIN04ABD40', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: El N�mero Tel�fono en el mensaje no coincide con el N�mero Tel�fono en el mensaje original', 'NIN04ABD41', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: Falta de coincidencia del Tip de Cliente.La Cantidad de N�meros de Tel�fono no es mayor a 10', 'NIN04ABD42', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: El monto, la fecha de vencimiento y la moneda son requeridos para este Motivo de Rechazo', 'NIN04ABD43', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: El monto, la fecha de venc y la moneda no deber�an ser ingresados para este Motivo de Rechazo', 'NIN04ABD44', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);

insert into opedd (CODIGOC, CODIGON, DESCRIPCION, ABREVIACION, TIPOPEDD, CODIGON_AUX)
values (null,null, 'Error: El Remitente y el Cedente deben ser el mismo', 'NIN04ABD45', (Select tipopedd from tipopedd where abrev= 'PORTABILIDAD_MSG_CP'), null);


COMMIT;