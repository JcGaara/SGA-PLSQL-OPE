create or replace package operacion.pq_dth_rotacion
/***************************************************************************************************************
  NOMBRE:       OPERACION.PQ_DTH_ROTACION
  DESCRIPCION:  Paquete encargado de las funcionalidades del proceso de Rotacion y Activacion/corte de DTH
                para Claro Perú.

  Ver        Fecha        Autor                 Solicitado por         Descripcion
  ------  ----------  ------------------     ---------------------  ------------------------------------
  1.0     28/08/2014  Justiniano Condori     Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
****************************************************************************************************************/
is
-- Declaracion de Variables
type v_numtarjeta is table of varchar2(1000) index by binary_integer;
type v_ntarjeta is table of varchar2(1000) index by binary_integer;
type v_bouquet is table of number index by binary_integer;
/************************************************************************************************
*Tipo               : Funcion
*Descripción        : Encargado de obtener el valor del campo codigoc de la tabla de parametros
                      operacion.opedd
**************************************************************************************************
Ver        Fecha        Autor                 Solicitado por         Descripcion
------  ----------  ------------------     ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori     Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
function f_obt_parametro_c(abrev_tipop varchar2,abrev varchar2)
  return varchar2;
/************************************************************************************************
*Tipo               : Funcion
*Descripción        : Encargado de obtener el valor del campo descripcion de la tabla de parametros
                      operacion.opedd
**************************************************************************************************
Ver        Fecha        Autor                 Solicitado por         Descripcion
------  ----------  ------------------     ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori     Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
function f_obt_parametro_d(abrev_tipop varchar2,abrev varchar2)
  return varchar2;
/************************************************************************************************
*Tipo               : Funcion
*Descripción        : Encargado de convertir de número a letras el mes
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
function f_conv_mes(mes in varchar2)
return varchar2;
/************************************************************************************************
*Tipo               : Funcion
*Descripción        : Encargado de Validar el codigo de tarjeta
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
function f_val_cod_tarjeta(cod_tarjeta in varchar2)
return char;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de Eliminar un archivo local
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_eliminar_archivo(p_ruta      in varchar2,
                             p_nombre    in varchar2);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de enviar un archivo remoto
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
  procedure p_enviar_archivo_ascii(pHost          in varchar2,
                                   pPuerto        in varchar2,
                                   pUsuario       in varchar2,
                                   pPass          in varchar2,
                                   pDirectorio    in varchar2,
                                   pArchivoLocal  in varchar2,
                                   pArchivoRemoto in varchar2,
                                   respuesta      out varchar2);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de Eliminar un archivo remoto
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_eliminar_archivo_ascii(pHost          in varchar2,
                                   pPuerto        in varchar2,
                                   pUsuario       in varchar2,
                                   pPass          in varchar2,
                                   pArchivoRemoto in varchar2,
                                   respuesta      out varchar2);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de renombrar un archivo
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_ren_archivo_ascii(pHost          in varchar2,
                              pPuerto        in varchar2,
                              pUsuario       in varchar2,
                              pPass          in varchar2,
                              pArchivoLocal  in varchar2,
                              pArchivoRemoto in varchar2,
                              respuesta      out varchar2);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de verificar la existencia de un archivo
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_vrf_archivo_ascii(pHost          in varchar2,
                              pPuerto        in varchar2,
                              pUsuario       in varchar2,
                              pPass          in varchar2,
                              pDirecarch     in varchar2,
                              respuesta      out varchar2);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de registrar la cabecera de la rotacion de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_reg_cab_rotacion(id_proc out number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de insertar los paquetes declarados en la bscs
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_reg_paq_bscs;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de registrar la cabecera de la activacion y corte manual de DTH por
                      Paquete
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_reg_cab_ac_manu_p(descp       in varchar2,
                              tip_proceso in char,
                              paquete     in number,
                              f_ejec      in date,
                              motiv       in varchar2,
                              tip_cliente in char,
                              id_proc     out number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de registrar la cabecera de la activacion y corte manual de DTH por
                      Bouquet
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_reg_cab_ac_manu_b(descp       in varchar2,
                              tip_proceso in char,
                              f_ejec      in date,
                              motiv       in varchar2,
                              tip_cliente in char,
                              id_proc     out number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de registrar el detalle de la activacion y corte manual de DTH por
                      Bouquet
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_reg_det_ac_manu_b(id_proc in number,
                              bqt in v_bouquet);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de registrar el detalle de la activacion y corte manual de DTH por
                      Paquete
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_reg_det_ac_manu(id_proc in number,
                            numtarjeta in v_numtarjeta,
                            total in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de registrar los datos del archivo generado para la rotacion
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_reg_rota_archivo(nom_arch in varchar2,
                             cant_tarj in number,
                             id_proc in number,
                             bqt in number,
                             idarchivo out number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de registrar los codigos de tarjetas que contiene el archivo
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_reg_rota_archivo_det(idarchivo in number,
                                 n_tarjeta  in v_ntarjeta);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de registrar los datos del archivo generado para la activacion/corte
                      manual.
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_reg_ac_manu_archivo(nom_arch in varchar2,
                                cant_tarj in number,
                                id_proc in number,
                                idarchivo out number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de registrar las tarjetas contenidas en el archivo generado para
                      la activacion/corte manual.
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_reg_ac_manu_archivo_det(idarchivo in number,
                                    n_tarjeta  in v_ntarjeta);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de generar el archivo de rotacion de DTH en base a la tabla
                      operacion.rotacion_datos
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_crea_arch_conax_rota(id_proceso in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de generar el archivo de activacion/corte manual de DTH por Paquete
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_crea_arch_conax_manu_p(id_proceso in number,
                                   paquete in number,
                                   tip_proceso in varchar2);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de generar el archivo de activacion/corte manual de DTH por Bouquet
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_crea_arch_conax_manu_b(id_proceso in number,
                                   tip_proceso in varchar2);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de la validacion de codigos de tarjetas del proceso de activacion/corte
                      manual de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_val_det_ac_manu(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de generacion de archivo de rotacion de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_arch_rotacion;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de generacion de archivo de activacion/corte manual de
                      DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_arch_manu;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de activacion/corte manual de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_act_desac_manu;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de cambio de estado de los archivos de activacion/corte
                      manual de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_est_act_desac_manu;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de cambio de estado de los archivos de rotacion de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_est_rotacion;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de envio de informe de error de rotacion
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_inf_err_rotacion(idproceso in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de generacion de datos base para el postpago
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_dat_postpago(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de insercion de datos a la tabla temporal de rotacion_datos
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_tb_postpago(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de eliminar la data de la tabla temporal de postpago
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_trunc_tt_postpago;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de generar los datos de postpago
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_data_postpago(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de generar los datos de Prepago
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_data_prepago_r(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de insertar los datos de tarjetas y bouquets a la tabla de rotacion
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_tb_prepago_r(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de generar los datos de Prepago con Factura sin Emitir
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_data_prepago_rse(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de insertar los datos de tarjetas y bouquets a la
                      tabla de rotacion para los Prepago con Factura sin Emitir
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_tb_prepago_rse(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de generar los datos de Prepago con Recibo Emitidos
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_data_prepago_re(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de validar los datos de Prepago con Recibo Emitidos
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_val_data_prepago_re(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de insertar los datos de tarjetas y bouquets a la
                      tabla de rotacion para los Prepago con Recibo Emitido
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_tb_prepago_re(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de generar los datos de Demo
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_data_demos(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de la Insercion de Tarjetas y Bouquets para demos
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_tb_demos(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de generar los datos de Promociones
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_data_promociones(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de generar los datos de Promociones por Venta/Alta
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_data_prom_va(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de insertar los datos de tarjetas y bouquets a la
                      tabla de rotacion para las Promociones por Venta/Alta
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_tb_prom_va(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de generar los datos de Promociones por Carga de Informacion
                      y Por Pago/Recarga
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_data_prom_cp(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de insertar los datos de tarjetas y bouquets a la
                      tabla de rotacion para las Promociones por Venta/Alta
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_tb_prom_cp(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de generacion de los datos de rotacion
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_gen_data_rotacion;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de eliminacion de los datos de la tabla temporal de
                      rotacion
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_trunc_tt_rotacion;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de eliminacion de los datos de la tabla temporal de
                      rotacion
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_rotacion;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de migracion de datos de la activacion/corte manual
                      de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_migra_act_dsc_manu;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de migracion de datos de la activacion/corte manual
                      de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_det_atc_cort_manu_dth_b(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de migracion de datos de la activacion/corte manual
                      de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_det_atc_cort_manu_dth(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de migracion de datos de la activacion/corte manual
                      de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_cab_atc_cort_archivo(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de migracion de datos de la activacion/corte manual
                      de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_det_atc_cort_archivo(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de migracion de la cabecera de los datos de act/corte
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_migra_cab_atc_cort_manu_dth (id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de migracion de rotacion de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_migra_rotacion;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de migracion de la cabecera de los datos de rotacion
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_migra_cab_rotacion_dth (id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de migracion de los datos de los archivos de rotacion
                      de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_migra_rotacion_datos (id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de migracion de los datos de los archivos de rotacion
                      de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_migra_rotac_auto_archivo (id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado del proceso de migracion de las tarjetas de los archivos de rotacion
                      de DTH
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_migra_rotac_auto_archivo_det (id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Proceso de dejar los tres ultimos procesos de rotacion en la tabla de migracion
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_elim_proc_mtres;
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de la eliminacion del registro de la tabla migracion.cab_rotacion.dth
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_elim_cab_rotac_dth(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de la eliminacion del registro de la tabla migracion.rotacion_datos
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_elim_rotac_datos(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de la eliminacion del registro de la tabla migracion.rotacion_auto_archivo
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_elim_rotac_auto_archivo(id_proc in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de la eliminacion del registro de la tabla migracion.rotacion_auto_archivo_det
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_elim_rotac_auto_arch_det(id_arch in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de la eliminacion del registro de la tabla migracion.rotacion_auto_archivo
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_elim_rotac_auto_arch(id_arch in number);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de la verificación del area del usuario
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_verif_area_usua(cod_usua in varchar2,
                            val      out varchar2);
/************************************************************************************************
*Tipo               : Procedimiento
*Descripción        : Encargado de la verificación del usuario para el Proceso de Act/Desac por Bouquet
**************************************************************************************************
Ver        Fecha        Autor              Solicitado por         Descripcion
------  ----------  ------------------  ---------------------  ------------------------------------
1.0     28/08/2014  Justiniano Condori  Henry Quispe           PQT-208144-TSK-56367 - Rotacion DTH
*************************************************************************************************/
procedure p_verif_usua(cod_usua in varchar2,
                       val      out varchar2);
end;
/