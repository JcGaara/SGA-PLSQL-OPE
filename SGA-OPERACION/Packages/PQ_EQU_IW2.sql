CREATE OR REPLACE PACKAGE OPERACION.PQ_EQU_IW2 IS
  /*******************************************************************************************************
   NOMBRE:       OPERACION.PQ_EQU_IW2
   PROPOSITO:    Paquete de objetos necesarios para la regularizacion de equipos - contratos  BSCS-SGA
   REVISIONES:
   Version    Fecha       Autor            Solicitado por    Descripcion
   ---------  ----------  ---------------  --------------    -----------------------------------------
    1.0       12/07/2015  Edilberto Astulle SD-335259 - Paquete creado para regularizacion de contratos generados por contingencia. -
    2.0       22/10/2019  Edilberto Astulle Descarga Materiales
    3.0       27/11/2019  Edilberto Astulle Descarga Materiales
  *******************************************************************************************************/
procedure p_carga_equ_iw(a_idtareawf in number,
                      a_idwf      in number,
                      a_tarea     in number,
                      a_tareadef  in number);

procedure p_carga_equ_iwv2(a_idtareawf in number,
                      a_idwf      in number,
                      a_tarea     in number,
                      a_tareadef  in number);

PROCEDURE p_consulta_equ_iw(a_codsolot in solot.codsolot%type,
                          a_seq_equ_iw out number,
                          an_error   out integer,
                          av_error   out varchar2);

procedure p_carga_equ_iwv3(a_idtareawf in number,
                      a_idwf      in number,
                      a_tarea     in number,
                      a_tareadef  in number);

--INI 3.0
procedure sp_consulta_equ_inc(a_idwf in number, a_idtareawf in number);
--FIN 3.0

END PQ_EQU_IW2;
/