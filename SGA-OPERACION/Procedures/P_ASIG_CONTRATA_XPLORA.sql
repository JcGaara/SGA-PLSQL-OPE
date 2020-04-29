CREATE OR REPLACE PROCEDURE OPERACION.p_asig_contrata_xplora (
an_codsolot in number,
an_codcon in number) IS
/****************************************************************************************************
    NOMBRE:     OPERACION.p_asig_contrata_xplora
    PROPOSITO:  Agendamiento masivo de contratas desde Programación de Instalaciones
    PROGRAMADO EN JOB:  NO

    REVISIONES:
    Version      Fecha        Autor             Solicitado Por        Descripcion
    ---------  ----------  -----------------    --------------        ------------------------
    1.0        20/12/2010  Alexander Yong       Edilberto Astulle     REQ-144154: Creación
    2.0        01/20/2014  Edilberto Astulle     			PQT-173741-TSK-38339

**************************************************************************************************/
BEGIN
   update solotpto_id set codcon = an_codcon,fecasig_pi =sysdate
    where codsolot = an_codsolot and flg_pi = 1;

END;
/


