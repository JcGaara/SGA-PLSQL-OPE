CREATE OR REPLACE PROCEDURE OPERACION.P_ST_CAMBIAR_CODCLI (A_CODCLI_ANT IN CHAR, A_CODCLI_NUE IN CHAR ) IS

BEGIN

insert into uni_cli ( codcli_old, codcli_new, nomtab, nom_mod )
select a_codcli_ant, a_codcli_nue,'INSSRV', COUNT(*) FROM  INSSRV WHERE CODCLI = A_CODCLI_ANT;

insert into uni_cli ( codcli_old, codcli_new, nomtab, nom_mod )
select a_codcli_ant, a_codcli_nue, 'EF', count(*) FROM EF  WHERE CODCLI = A_CODCLI_ANT;

insert into uni_cli ( codcli_old, codcli_new, nomtab, nom_mod )
select a_codcli_ant, a_codcli_nue, 'SOLOT', count(*) FROM SOLOT  WHERE CODCLI = A_CODCLI_ANT;

insert into uni_cli ( codcli_old, codcli_new, nomtab, nom_mod )
select a_codcli_ant, a_codcli_nue, 'ANARED', count(*) FROM ANARED  WHERE CODCLI = A_CODCLI_ANT;

insert into uni_cli ( codcli_old, codcli_new, nomtab, nom_mod )
select a_codcli_ant, a_codcli_nue, 'ACCESO', count(*) FROM ACCESO WHERE CODCLI = A_CODCLI_ANT;

insert into uni_cli ( codcli_old, codcli_new, nomtab, nom_mod )
select a_codcli_ant, a_codcli_nue, 'CIRCUITO', count(*) FROM CIRCUITO WHERE CODCLI = A_CODCLI_ANT;

insert into uni_cli ( codcli_old, codcli_new, nomtab, nom_mod )
select a_codcli_ant, a_codcli_nue, 'CTRLDOC', count(*) FROM CTRLDOC WHERE CODCLI = A_CODCLI_ANT;

insert into uni_cli ( codcli_old, codcli_new, nomtab, nom_mod )
select a_codcli_ant, a_codcli_nue, 'DOCARCHIVO', count(*) FROM DOCARCHIVO WHERE CODCLI = A_CODCLI_ANT;

insert into uni_cli ( codcli_old, codcli_new, nomtab, nom_mod )
select a_codcli_ant, a_codcli_nue, 'DOCXCLIENTE', count(*) FROM DOCXCLIENTE WHERE CODCLI = A_CODCLI_ANT;


/*

OWNER	TABLE_NAME	COLUMN_NAME	DATA_TYPE	DATA_LENGTH
OPERACION	CTRLDOC	   CODCLI	CHAR	8	 *
OPERACION	DOCARCHIVO	CODCLI	CHAR	8	 *
OPERACION	DOCXCLIENTE	CODCLI	CHAR	8	 *
OPERACION	EF	         CODCLI	CHAR	8	 *
OPERACION	INSSRV	   CODCLI	CHAR	10	 *
OPERACION	SOLOT	      CODCLI	CHAR	8	 *
ENCUESTA	   ANARED	   CODCLI	CHAR	8	 *
METASOLV	   ACCESO	   CODCLI	CHAR	8	 *
METASOLV	   CIRCUITO	   CODCLI	CHAR	8	 *




   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       Null;
     WHEN OTHERS THEN
       Null;

*/


END;
/


