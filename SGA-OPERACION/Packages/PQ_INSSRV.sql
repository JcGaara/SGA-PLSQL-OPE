CREATE OR REPLACE PACKAGE OPERACION.PQ_INSSRV  IS
/******************************************************************************
   NAME:       PQ_INSSRV
   PURPOSE:    SP para control de INSSRV

   REVISIONS:
   Ver        Date        Author           Solicitado por            Description
   ---------  ----------  ---------------  --------------            ----------------------
   1.0        16/10/2000  Carlos Corrales                            1 version
   2.0        16/10/2002  Carlos Corrales                            Modificaciones Brasil
              01/09/2003  Carlos Corrales                            Se hizo las modificaciones para soportar DEMOs
   3.0        01/09/2008  Victor Valqui                              Cambios por Primesys (idinssla)
   4.0        25/08/2010  Joseph Asencios                            REQ-137046: Se modificó el procedimiento p_valida_est_inssrv
   5.0        31/05/2010  Widmer Quispe    Edilberto Astulle         Req: 123054 y 123052, Asignación de Plataforma
   6.0        10/11/2011  Ivan Untiveros   Guillermo Salcedo         REQ-161199 DTH Postpago RF02
   7.0        04/07/2012  Mauro Zegarra    Hector Huaman             REQ-162820 Sincronización de proceso de ventas HFC (SISACT - SGA) - Etapa 1
******************************************************************************/
   PROCEDURE trs_activacion ( a_codinssrv in number, a_fectrs in date, a_codsrv in char, a_bw in number );
   PROCEDURE trs_upgrade ( a_codinssrv in number, a_fectrs in date, a_codsrv in char, a_bw in number );
   PROCEDURE trs_suspension ( a_codinssrv in number, a_fectrs in date );
   PROCEDURE trs_reconexion ( a_codinssrv in number, a_fectrs in date );
   PROCEDURE trs_cancelacion ( a_codinssrv in number, a_fectrs in date );
   PROCEDURE trs_creacion ( a_codinssrv in number, a_fectrs in date );

procedure p_crear_inssrv(
   a_numslc in char,
   a_numpto in char,
   a_codinssrv out number,
   a_pid out number
);

procedure p_insert_inssrv(
   ar_inssrv  in inssrv%rowtype,
   a_codinssrv out number
)  ;

procedure p_insert_insprd(
   ar_insprd  in insprd%rowtype,
   a_pid out number
) ;

procedure p_valida_est_inssrv(
   a_codinssrv in inssrv.codinssrv%type, a_codmotinssrv in inssrv.codmotinssrv%type
) ;

procedure p_valida_est_inssrv_mst(
   a_codinssrv in inssrv.codinssrv%type, a_codmotinssrv in inssrv.codmotinssrv%type
) ;

procedure p_crear_inssrv_manual(
   a_codcli in char,
   a_estinssrv in number,
   a_tipinssrv in number,
   a_codsrv in char,
   a_codsuc in char,
   a_descripcion in varchar2,
   a_direccion in varchar2,
   a_codubi in char,
   a_codpostal in varchar2,
   a_codinssrv_ori in number,
   a_codinssrv_des in number,
   a_codinssrv out number
) ;

procedure p_crear_inssrv_multi(
   a_codcli in char,
   a_estinssrv in number,
   a_tipinssrv in number,
   a_codsrv in char,
   a_codsuc in char,
   a_descripcion in varchar2,
   a_direccion in varchar2,
   a_codubi in char,
   a_codpostal in varchar2,
   a_codinssrv_ori in number,
   a_codinssrv_des in number,
   a_cantidad in number
) ;

procedure p_set_inssrv_pad(
   a_codinssrv  in inssrv.codinssrv%type,
   a_codinssrv_pad  in inssrv.codinssrv%type
) ;

procedure p_replicar_inssrv_pad(
   a_codinssrv  in inssrv.codinssrv%type
) ;

--INICIO: Cambio 3.0: Cambios por Primesys
procedure p_insert_inssrvsla(
   an_inssrv  in inssrv.codinssrv%type,
   a_idinssla in number
)  ;

procedure p_insert_insprdsla(
   an_pid  in insprd.pid%type,
   a_idinssla in number
)  ;

procedure p_insert_inssrvsla(
   an_inssrv         in inssrv.codinssrv%type,
   a_idsla           in vtatabsla.idsla%type,
   a_reparacion      in vtatabsla.reparacion%type,
   a_disponibilidad  in vtatabsla.disponibilidad%type
)  ;

procedure p_insert_insprdsla(
   an_pid  in insprd.pid%type,
   a_idsla           in vtatabsla.idsla%type,
   a_reparacion      in vtatabsla.reparacion%type,
   a_disponibilidad  in vtatabsla.disponibilidad%type
)  ;

procedure p_act_inssrvsla(
   an_inssrv  in inssrv.codinssrv%type,
   a_idsla in number
)  ;

procedure p_act_insprdsla(
   an_pid  in insprd.pid%type,
   a_idsla in number
)  ;
--FIN: Cambio 3.0: Cambios por Primesys

END;
/