call sa_make_object('function', 'SAQ_GET_DOMAIN_LIMIT');
alter function SAQ_GET_DOMAIN_LIMIT($domainName long varchar, $min bit default 1, $width int default 0, $scale int default 0) returns long varchar
begin
    declare _result long varchar;
	case $domainName 
	when 'smallint' then 
        if $min=1 then    
            set _result = '-32768';
        else 
            set _result = '32767';
        end if
	when 'unsigned smallint' then 
        if $min=1 then    
            set _result = '0';
        else 
            set _result = '65535';
        end if
	when 'integer' then 
        if $min=1 then    
            set _result = '-2147483648';
        else 
            set _result = '2147483647';
        end if
	when 'unsigned integer' then 
        if $min=1 then    
            set _result = '0';
        else 
            set _result = '4294967295';
        end if
	when 'int' then 
        if $min=1 then    
            set _result = '-2147483648';
        else 
            set _result = '2147483647';
        end if
	when 'unsigned int' then 
        if $min=1 then    
            set _result = '0';
        else 
            set _result = '4294967295';
        end if
	when 'tinyint' then 
        if $min=1 then    
            set _result = '0';
        else 
            set _result = '255';
        end if
	when 'unsigned tinyint' then 
        if $min=1 then    
            set _result = '0';
        else 
            set _result = '255';
        end if
	when 'bigint' then 
        if $min=1 then    
            set _result = '-9223372036854775808';
        else 
            set _result = '9223372036854775807';
        end if
	when 'unsigned bigint' then 
        if $min=1 then    
            set _result = '0';
        else 
            set _result = '18446744073709551615';
        end if
	when 'bit' then
        if $min=1 then    
            set _result = '0';
        else 
            set _result = '1';
        end if
	when 'decimal' then
        set _result = replace(space($width-$scale),' ','9')||'.'||replace(space($scale),' ','9');
        if $min=1 then    
            set _result = '-'||_result;
        end if
	when 'double' then
        set _result = replace(space($width-$scale),' ','9')||'.'||replace(space($scale),' ','9');
        if $min=1 then    
            set _result = '-'||_result;
        end if
	when 'float' then
        set _result = replace(space($width-$scale),' ','9')||'.'||replace(space($scale),' ','9');
        if $min=1 then    
            set _result = '-'||_result;
        end if
	when 'real' then
        set _result = replace(space($width-$scale),' ','9')||'.'||replace(space($scale),' ','9');
        if $min=1 then    
            set _result = '-'||_result;
        end if
	when 'numeric' then
        set _result = replace(space($width-$scale),' ','9')||'.'||replace(space($scale),' ','9');
        if $min=1 then    
            set _result = '-'||_result;
        end if
    end;
    if right (_result,1)='.' then set _result = replace (_result, '.', '') end if;
    return _result;
end;
