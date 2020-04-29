CREATE OR REPLACE PACKAGE OPERACION.Pq_Agenda IS

   -- Author  : ERIKA.TRUJILLO
  -- Created : 15/10/2007 06:01:10 p.m.
  -- Purpose : Realizar toda la funcionalidad de Agendamiento Perú
 /************************************************************

  NOMBRE:     OPERACION.Pq_Agenda
  PROPOSITO:  Realizar toda la funcionalidad de Agendamiento Perú
  PROGRAMADO EN JOB:  NO

  REVISIONES:
  Version      Fecha        Autor           Descripcisn
  ---------  ----------  ---------------  ------------------------
  1.0        15/10/2007  ERIKA.TRUJILLO
  2.0        10/03/2009  Hector Huaman    REQ-85605:Se creo un  procedimento(P_ASIGRESPONSABLE_MASIVO) que permita asignar masivamente al responsable ( contratista ) que atenderá la SOT
  3.0        06/11/2009  Hector Huaman    REQ-92361:consideraciones para TPI; se crearon los procedimientos P_CHG_ESTADO_AGENDA y P_EJECUTAR_AGENDA
  ***********************************************************/

     FUNCTION f_valida_agenda(
                           ln_idzona      CHAR,
                           P_FECHA        VARCHAR2,
                           P_HORA         VARCHAR2,
               P_BLOQUE      NUMBER) RETURN VARCHAR2;

  FUNCTION F_OBTIENE_CONTRATA(P_BLOQUE NUMBER,
                       P_CODUBI CHAR,
                  P_FECHA   VARCHAR2) RETURN NUMBER;

  PROCEDURE P_AGENDA(p_DIRSUC       VARCHAR2,
                     p_codcli       VARCHAR2,
                     P_PROYECTO     VARCHAR2,
                     p_fecha        VARCHAR2,
                     p_hora         VARCHAR2,
                     P_CODUBI       CHAR,
                     P_CODSOLOT     NUMBER,
           P_BLOQUE    NUMBER,
           P_OBSERVACION  VARCHAR2,
           P_REFERENCIA   VARCHAR2);


  PROCEDURE P_AGENDA_TAREAS(P_PROYECTO     VARCHAR2,
                            p_fecha        VARCHAR2,
                            p_hora         VARCHAR2,
                            P_CODSOLOT     NUMBER,
              P_OBSERVACION  VARCHAR2,
              P_REFERENCIA   VARCHAR2);

  PROCEDURE P_ACTUALIZA_FLG_SALTO(P_CONTRATISTA  NUMBER,
                     P_FECHA VARCHAR2);

  FUNCTION F_OBTIENE_CONTRATA_NULL(P_BLOQUE NUMBER,
                       P_CODUBI CHAR,
                  P_FECHA   VARCHAR2) RETURN NUMBER;


  PROCEDURE P_REAGENDA_TAREAS(P_PROYECTO     VARCHAR2,
                            p_fecha        VARCHAR2,
                                  p_hora         VARCHAR2,
                            P_CODSOLOT     NUMBER,
              P_OBSERVACION  VARCHAR2,
              P_REFERENCIA   VARCHAR2);



  FUNCTION f_valida_reagenda(
                           ln_idzona      CHAR,
                           P_FECHA        VARCHAR2,
                           P_HORA         VARCHAR2,
               P_BLOQUE      NUMBER,
               P_CONTRATA    NUMBER) RETURN VARCHAR2;


  PROCEDURE P_REAGENDA(P_FECHA1    VARCHAR2,
               P_HORA1     VARCHAR2,
             P_IDBLOQUE1 NUMBER,
             P_FECHA2    VARCHAR2,
               P_HORA2     VARCHAR2,
             P_IDBLOQUE2 NUMBER,
             P_CODCON    NUMBER,
             P_CODSOLOT  NUMBER,
             P_OBSERVACION VARCHAR2,
             P_REFERENCIA   VARCHAR2,
             P_ZONA CHAR);

  PROCEDURE P_AGENDAMIENTO_MASIVO(l_codsolot    number,
              l_punto solotpto.punto%type,
              l_responsable  solotpto_id.responsable_pi%type,
              l_codcon solotpto_id.codcon%type,
              l_fecestprog solotpto_id.fecestprog%type,
              l_observacion  solotpto_id.observacion%type,
              o_mensaje        in out varchar2 ,
              o_error          in out number
              );

    PROCEDURE P_ASIGRESPONSABLE_MASIVO(l_codsolot    number,
              l_punto solotpto.punto%type,
              l_estado solotpto_id.estado%type,
              l_responsable_pi  solotpto_id.responsable_pi%type,
              l_codcon solotpto_id.codcon%type,
              l_observacion  solotpto_id.observacion%type,
              o_mensaje        in out varchar2 ,
              o_error          in out number
              );

    PROCEDURE P_CHG_ESTADO_AGENDA (
      a_idagenda IN NUMBER,
      a_tipo IN NUMBER,
      a_estagenda IN NUMBER,
      a_estagenda_old IN NUMBER,
      a_observacion IN VARCHAR2 DEFAULT NULL,
      a_codmotot IN NUMBER DEFAULT NULL
    );

    PROCEDURE P_EJECUTAR_AGENDA(
      a_idagenda in number,
      a_estagenda in number,
      a_tipo in number);

END Pq_Agenda;
/


