DECLARE lv_pwd VARCHAR2(20);
BEGIN
        lv_pwd :='&CONTRASENA';
        UPDATE constante 
               SET valor = utl_i18n.string_to_raw (lv_pwd)
               WHERE constante = 'OPTHFCPWD';
        COMMIT;
END;
/