call sa_make_object('service', 'saq-remote');
alter SERVICE "saq-remote" TYPE 'RAW' USER "DBA" URL ELEMENTS AS select * from SAQ_WEB_REMOTE();
