CREATE OR REPLACE PACKAGE OPERACION.demo_mail IS

  ----------------------- Customizable Section -----------------------

  -- Customize the SMTP host, port and your domain name below.
--  smtp_host   VARCHAR2(256) := '10.244.2.114';
  --smtp_host   VARCHAR2(256) := '10.244.21.175';
	smtp_host   VARCHAR2(256) := '172.19.3.102';
  smtp_port   PLS_INTEGER := 25;
--  smtp_domain VARCHAR2(256) := 'telmex.com';
	smtp_domain VARCHAR2(256) := 'claro.com.pe';

  -- Customize the signature that will appear in the email's MIME header.
  -- Useful for versioning.
  MAILER_ID CONSTANT VARCHAR2(256) := 'Mailer by Oracle UTL_SMTP';

  --------------------- End Customizable Section ---------------------

  -- A unique string that demarcates boundaries of parts in a multi-part email
  -- The string should not appear inside the body of any part of the email.
  -- Customize this if needed or generate this randomly dynamically.
  BOUNDARY CONSTANT VARCHAR2(256) := '-----7D81B75CCC90D2974F7A1CBD';

  FIRST_BOUNDARY CONSTANT VARCHAR2(256) := '--' || BOUNDARY || utl_tcp.CRLF;
  LAST_BOUNDARY  CONSTANT VARCHAR2(256) := '--' || BOUNDARY || '--' ||
                                           utl_tcp.CRLF;

  -- A MIME type that denotes multi-part email (MIME) messages.
  MULTIPART_MIME_TYPE   CONSTANT VARCHAR2(256) := 'multipart/mixed; boundary="' ||
                                                  BOUNDARY || '"';
  MAX_BASE64_LINE_WIDTH CONSTANT PLS_INTEGER := 76 / 4 * 3;

  -- A simple email API for sending email in plain text in a single call.
  -- The format of an email address is one of these:
  --   someone@some-domain
  --   "Someone at some domain" <someone@some-domain>
  --   Someone at some domain <someone@some-domain>
  -- The recipients is a list of email addresses  separated by
  -- either a "," or a ";"
  PROCEDURE mail(sender     IN VARCHAR2,
                 recipients IN VARCHAR2,
                 subject    IN VARCHAR2,
                 message    IN VARCHAR2);

  -- Extended email API to send email in HTML or plain text with no size limit.
  -- First, begin the email by begin_mail(). Then, call write_text() repeatedly
  -- to send email in ASCII piece-by-piece. Or, call write_mb_text() to send
  -- email in non-ASCII or multi-byte character set. End the email with
  -- end_mail().
  FUNCTION begin_mail(sender     IN VARCHAR2,
                      recipients IN VARCHAR2,
                      subject    IN VARCHAR2,
                      mime_type  IN VARCHAR2 DEFAULT 'text/plain',
                      priority   IN PLS_INTEGER DEFAULT NULL)
    RETURN utl_smtp.connection;

  -- Write email body in ASCII
  PROCEDURE write_text(conn    IN OUT NOCOPY utl_smtp.connection,
                       message IN VARCHAR2);

  -- Write email body in non-ASCII (including multi-byte). The email body
  -- will be sent in the database character set.
  PROCEDURE write_mb_text(conn    IN OUT NOCOPY utl_smtp.connection,
                          message IN VARCHAR2);

  -- Write email body in binary
  PROCEDURE write_raw(conn    IN OUT NOCOPY utl_smtp.connection,
                      message IN RAW);

  -- APIs to send email with attachments. Attachments are sent by sending
  -- emails in "multipart/mixed" MIME format. Specify that MIME format when
  -- beginning an email with begin_mail().

  -- Send a single text attachment.
  PROCEDURE attach_text(conn      IN OUT NOCOPY utl_smtp.connection,
                        data      IN VARCHAR2,
                        mime_type IN VARCHAR2 DEFAULT 'text/plain',
                        inline    IN BOOLEAN DEFAULT TRUE,
                        filename  IN VARCHAR2 DEFAULT NULL,
                        last      IN BOOLEAN DEFAULT FALSE);

  -- Send a binary attachment. The attachment will be encoded in Base-64
  -- encoding format.
  PROCEDURE attach_base64(conn      IN OUT NOCOPY utl_smtp.connection,
                          data      IN RAW,
                          mime_type IN VARCHAR2 DEFAULT 'application/octet',
                          inline    IN BOOLEAN DEFAULT TRUE,
                          filename  IN VARCHAR2 DEFAULT NULL,
                          last      IN BOOLEAN DEFAULT FALSE);

  -- Send an attachment with no size limit. First, begin the attachment
  -- with begin_attachment(). Then, call write_text repeatedly to send
  -- the attachment piece-by-piece. If the attachment is text-based but
  -- in non-ASCII or multi-byte character set, use write_mb_text() instead.
  -- To send binary attachment, the binary content should first be
  -- encoded in Base-64 encoding format using the demo package for 8i,
  -- or the native one in 9i. End the attachment with end_attachment.
  PROCEDURE begin_attachment(conn         IN OUT NOCOPY utl_smtp.connection,
                             mime_type    IN VARCHAR2 DEFAULT 'text/plain',
                             inline       IN BOOLEAN DEFAULT TRUE,
                             filename     IN VARCHAR2 DEFAULT NULL,
                             transfer_enc IN VARCHAR2 DEFAULT NULL);

  -- End the attachment.
  PROCEDURE end_attachment(conn IN OUT NOCOPY utl_smtp.connection,
                           last IN BOOLEAN DEFAULT FALSE);

  -- End the email.
  PROCEDURE end_mail(conn IN OUT NOCOPY utl_smtp.connection);

  -- Extended email API to send multiple emails in a session for better
  -- performance. First, begin an email session with begin_session.
  -- Then, begin each email with a session by calling begin_mail_in_session
  -- instead of begin_mail. End the email with end_mail_in_session instead
  -- of end_mail. End the email session by end_session.
  FUNCTION begin_session RETURN utl_smtp.connection;

  -- Begin an email in a session.
  PROCEDURE begin_mail_in_session(conn       IN OUT NOCOPY utl_smtp.connection,
                                  sender     IN VARCHAR2,
                                  recipients IN VARCHAR2,
                                  subject    IN VARCHAR2,
                                  mime_type  IN VARCHAR2 DEFAULT 'text/plain',
                                  priority   IN PLS_INTEGER DEFAULT NULL);

  -- End an email in a session.
  PROCEDURE end_mail_in_session(conn IN OUT NOCOPY utl_smtp.connection);

  -- End an email session.
  PROCEDURE end_session(conn IN OUT NOCOPY utl_smtp.connection);

END;
/


