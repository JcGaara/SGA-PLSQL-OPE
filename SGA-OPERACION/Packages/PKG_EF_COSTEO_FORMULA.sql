CREATE OR REPLACE PACKAGE OPERACION.PKG_EF_COSTEO_FORMULA IS

  FUNCTION SGAFUN_002_IMPEXPEDGESMUN(K_PERM_MUNI    PLS_INTEGER,
                                     K_CANALIZA1    NUMBER,
                                     K_CANALIZA2    NUMBER,
                                     K_CAMARA       NUMBER,
                                     K_ZONA_LIMA    PLS_INTEGER)
  RETURN NUMBER;

  FUNCTION SGAFUN_003_PLANSENALDESVIO( K_PERM_MUNI    PLS_INTEGER,
                                       K_CANALIZA1    NUMBER,
                                       K_CANALIZA2    NUMBER,
                                       K_CAMARA       NUMBER)
  RETURN NUMBER;

  FUNCTION SGAFUN_004_POSTEACTIVIDAD(K_POSTEP       NUMBER)
  RETURN NUMBER;
  
  FUNCTION SGAFUN_005_FIBREDAERCANAL(K_TENDIDOA    NUMBER,
                                     K_TENDIDOC    NUMBER)
  RETURN NUMBER;

  FUNCTION SGAFUN_006_CABLEFIBROPTIPROY(K_TENDIDOA    NUMBER,
                                        K_TENDIDOC    NUMBER,
                                        K_INPUT       NUMBER)
  RETURN NUMBER;
  
  FUNCTION SGAFUN_007_OTROSTENDIDO(K_TENDIDOA    NUMBER,
                                   K_TENDIDOC    NUMBER)
  RETURN NUMBER;

  FUNCTION SGAFUN_008_POSTEMATERIAL(K_POSTEP       NUMBER)
  RETURN NUMBER;

  FUNCTION SGAFUN_009_MATPANDUITFUSION(K_PANDUIT    NUMBER)
  RETURN NUMBER;
  
  FUNCTION SGAFUN_010_CABLEFIBROPT96FSM(K_TENDIDOA    NUMBER,
                                        K_TENDIDOC    NUMBER)
  RETURN NUMBER;

  FUNCTION SGAFUN_011_FIBREDAERCANAL96FSM(K_TENDIDOA    NUMBER,
                                          K_TENDIDOC    NUMBER)
  RETURN NUMBER;

  FUNCTION SGAFUN_012_POSTEMPRELECTRICA(K_POSTET    NUMBER)
  RETURN NUMBER;

  FUNCTION SGAFUN_013_MATINPUT(K_INPUT    NUMBER)
  RETURN NUMBER;

  FUNCTION SGAFUN_014_PAGOMINCULTURA(K_PERMIN_CULTURA    NUMBER)
  RETURN NUMBER;

  FUNCTION SGAFUN_015_PAGOGESTPERMISO(K_PERM_MUNI    NUMBER)
  RETURN NUMBER;

  FUNCTION SGAFUN_016_CANAPROY1VIA(K_CANALIZA1    NUMBER)
  RETURN NUMBER;

  FUNCTION SGAFUN_017_CANAPROYMAS1VIA(K_CANALIZA2    NUMBER)
  RETURN NUMBER;
  
  FUNCTION SGAFUN_018_CAMARAPROYECTA(K_CAMARA    NUMBER)
  RETURN NUMBER;
  
  FUNCTION SGAFUN_019_OTROSCANA1VIA(K_CANALIZA1    NUMBER,
                                    K_CANALIZA2    NUMBER)
  RETURN NUMBER;

  FUNCTION SGAFUN_020_OTROSCANAMAS1VIA(K_CANALIZA2    NUMBER)
  RETURN NUMBER;
  
  FUNCTION SGAFUN_021_CANAL_MARCOTAPCAM(K_CAMARA    NUMBER)
  RETURN NUMBER;
  
  FUNCTION SGAFUN_022_LIQUIDAPERMISO(K_PERM_MUNI    PLS_INTEGER, 
                                     K_CANALIZA1    NUMBER,
                                     K_CANALIZA2    NUMBER,
                                     K_TENDIDOA     NUMBER,
                                     K_TENDIDOC     NUMBER)
  RETURN NUMBER;

  FUNCTION SGAFUN_023_FLETE(K_LOCAL     PLS_INTEGER)
  RETURN NUMBER;
  
  FUNCTION SGAFUN_024_PASAJE(K_LOCAL     PLS_INTEGER)
  RETURN NUMBER;
  
  FUNCTION SGAFUN_025_HOSPEDA_ALIMEN(K_LOCAL     PLS_INTEGER)
  RETURN NUMBER;
  
  FUNCTION SGAFUN_026_MATFERINSTFOAEREA(K_TENDIDOA     NUMBER)
  RETURN NUMBER;
  
END PKG_EF_COSTEO_FORMULA;
/