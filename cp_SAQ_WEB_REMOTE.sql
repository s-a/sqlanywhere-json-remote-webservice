ALTER PROCEDURE "DBA"."SAQ_WEB_REMOTE"( )
result("d" xml)
BEGIN
    DECLARE _data xml;
    DECLARE _meta xml;
    DECLARE _sql long varchar;

    // FIXME: post comes with body=sql=data :(
    select http_variable('body') into _sql;
    select first row_value into _sql from sa_split_list(_sql,'sql=') order by line_num desc;  


    select HTTP_DECODE(_sql) into _sql;
    MESSAGE 'SAQ_WEB_REMOTE - "' , _sql, '"' TYPE INFO to console;

	EXECUTE ('select * into _data from ('+_sql+') as root for xml raw');
    select replace(_sql, '''', '''''') into _sql;
    EXECUTE ('select * into _meta from SAQ_DESCRIBE_QUERY(''' + _sql + ''') for xml raw');
    CALL dbo.sa_set_http_header( 'Content-Type', 'text/xml; charset=utf-8'  );
 

    SELECT '<root>'+'<meta>'+_meta+'</meta>'+'<data>'+_data+'</data>'+'</root>';
END