UPDATE OPERACION.SOLOTPTOEQU SET PEP = decode(SUBSTR(PEP_PE05,1,2),'40','41')||(SUBSTR(PEP_PE05,3,LENGTH(PEP_PE05))), PEP_LEASING = decode(SUBSTR(PEPLEASING_PE05,1,2),'40','41')||(SUBSTR(PEPLEASING_PE05,3,LENGTH(PEPLEASING_PE05))), CENTROSAP = (DECODE(SUBSTR(CENTROSAP_PE05,1,1),'W','V',DECODE(SUBSTR(CENTROSAP_PE05,1,1),'M','N')))||SUBSTR(CENTROSAP_PE05,2,3);
UPDATE OPERACION.SOLOTPTOEQUCMP SET PEP = decode(SUBSTR(PEP_PE05,1,2),'40','41')||(SUBSTR(PEP_PE05,3,LENGTH(PEP_PE05))), PEP_LEASING = decode(SUBSTR(PEPLEASING_PE05,1,2),'40','41')||(SUBSTR(PEPLEASING_PE05,3,LENGTH(PEPLEASING_PE05)));
UPDATE OPERACION.SOLOTPTOETAACT SET PEP = decode(SUBSTR(PEP_PE05,1,2),'40','41')||(SUBSTR(PEP_PE05,3,LENGTH(PEP_PE05)));
UPDATE OPERACION.SOLOTPTOETAMAT SET PEP_INVERSION = decode(SUBSTR(PEPINVERSION_PE05,1,2),'40','41')||(SUBSTR(PEPINVERSION_PE05,3,LENGTH(PEPINVERSION_PE05))) where PEP_INVERSION is not null or not PEP_INVERSION =' ';
UPDATE OPERACION.DESPACHO_MASIVO SET PEP = decode(SUBSTR(PEP_PE05,1,2),'40','41')||(SUBSTR(PEP_PE05,3,LENGTH(PEP_PE05))), PEP_LEASING = decode(SUBSTR(PEPLEASING_PE05,1,2),'40','41')||(SUBSTR(PEPLEASING_PE05,3,LENGTH(PEPLEASING_PE05))), CENTROSAP = (DECODE(SUBSTR(CENTROSAP_PE05,1,1),'W','V',DECODE(SUBSTR(CENTROSAP_PE05,1,1),'M','N')))||SUBSTR(CENTROSAP_PE05,2,3);
UPDATE OPERACION.SOLOT_PEP_ANTERIOR SET ELEMENTO_PEP = decode(SUBSTR(ELEMENTOPEP_PE05,1,2),'40','41')||(SUBSTR(ELEMENTOPEP_PE05,3,LENGTH(ELEMENTOPEP_PE05)));
update OPERACION.DESPACHO_MASIVO set centrosap = 'PEVA';
commit;
