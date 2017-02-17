create or replace package body pretius_nested_table
is

e_temp EXCEPTION;
e_quryParse EXCEPTION;
e_noColumnConditions exception;
e_temp_msg varchar2(4000);


function getColumnNamesFromQuery(
  p_string in varchar2
) return APEX_APPLICATION_GLOBAL.VC_ARR2 is
  v_count number;
  v_pattern varchar2(50) := '#[a-zA-Z_0-9]+#';
  v_columns APEX_APPLICATION_GLOBAL.VC_ARR2;
begin
  v_count := regexp_count(p_string, v_pattern, 1, 'm');

  for i in 1..v_count loop
    v_columns(i) := upper(trim(both '#' from regexp_substr(p_string, v_pattern, 1, i, 'm') ));
  end loop;  

  return v_columns;
end;

function pretius_row_details (
  p_dynamic_action in apex_plugin.t_dynamic_action,
  p_plugin         in apex_plugin.t_plugin 
) return apex_plugin.t_dynamic_action_render_result
is
  v_result apex_plugin.t_dynamic_action_render_result;
  v_region_id number;
  v_region_type varchar2(100);
  v_app_id number := nv('APP_ID');
  v_coll_name varchar2(200) := p_dynamic_action.id||'_COLUMNS';
  v_columns APEX_APPLICATION_GLOBAL.VC_ARR2;
  v_column_array varchar2(4000);
  v_json varchar2(4000);
  v_queryErrors number := 0;
BEGIN

  v_result.ajax_identifier := APEX_PLUGIN.GET_AJAX_IDENTIFIER();
  v_result.attribute_01 := p_dynamic_action.attribute_01;
  v_result.attribute_02 := NVL(p_dynamic_action.attribute_02, ':');
  v_result.attribute_03 := NVL(p_dynamic_action.attribute_03, ':');
  v_result.attribute_04 := p_dynamic_action.attribute_04;
  v_result.attribute_05 := p_dynamic_action.attribute_05;
  v_result.attribute_06 := p_dynamic_action.attribute_06;
  v_result.attribute_07 := p_dynamic_action.attribute_07;
  v_result.attribute_08 := p_dynamic_action.attribute_08;
  v_result.attribute_09 := p_dynamic_action.attribute_09;
  v_result.attribute_10 := NVL(p_dynamic_action.attribute_10, ':');
  v_result.attribute_11 := p_dynamic_action.attribute_11;

  APEX_PLUGIN_UTIL.DEBUG_DYNAMIC_ACTION (
    p_plugin         => p_plugin,
    p_dynamic_action => p_dynamic_action
  );

  --Mustache library
  if p_plugin.attribute_03 = 'Y' then
    apex_javascript.add_library(
      p_name => 'mustache', 
      p_directory => p_plugin.file_prefix, 
      p_version => null 
    );

  end if;
  

  --pobierz affected v_regionId
  select 
    AFFECTED_REGION,
    AFFECTED_REGION_ID 
  into
    v_region_type, --Interactive report / Classic report
    v_region_id
  from 
    APEX_APPLICATION_PAGE_DA_ACTS 
  where 
    application_id = v_app_id
    and action_id = p_dynamic_action.id;


  APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(v_coll_name);

  v_columns := getColumnNamesFromQuery( p_dynamic_action.attribute_01 );

  --htp.p(v_columns.count);

  if v_columns.count = 0 then
    e_temp_msg := 'W SQL nie znalazl kolumn';
    raise e_noColumnConditions;
  end if;

  --pobierz nazwy kolumn i utworz kolekcje

  APEX_COLLECTION.ADD_MEMBERS (
    p_collection_name => v_coll_name,
    p_c001 =>  v_columns
  );  

  --pobierz informacje o mapowaniu kolumn w przypadku IR
  if v_region_type = 'Interactive report' then

    for i in (
      select
        count(*) over (partition by 1) columns_found,
        coll.c001 given_column,
        rownum as rn,
        COLUMN_ID,
        COLUMN_ALIAS
      from
        APEX_COLLECTIONs coll
      left join
        APEX_APPLICATION_PAGE_IR_COL aappirc
      on
        coll.c001 = aappirc.COLUMN_ALIAS
        and application_id = v_app_id
        and REGION_ID = v_region_id
      where
        collection_name = v_coll_name
    ) loop
      --v_column_array := '{'||APEX_JAVASCRIPT.ADD_ATTRIBUTE('query_column', i.given_column, false, true)||APEX_JAVASCRIPT.ADD_ATTRIBUTE('td_header',    i.COLUMN_ALIAS, false, false)||'}';
      v_column_array := v_column_array||'{"given_column" : "'||i.given_column||'","td_header": "C'||i.COLUMN_ID||'"}';

      if i.COLUMN_ALIAS is null then
        v_queryErrors := v_queryErrors +1;
      end if;

      if i.rn != i.columns_found then
        v_column_array := v_column_array||',';
      end if;

    end loop;
  else

    for i in(
      select 
        coll.c001 given_column,
        COLUMN_ALIAS,
        count(*) over (partition by 1) columns_found,
        rownum as rn
      from
        APEX_COLLECTIONs coll
      left join
        APEX_APPLICATION_PAGE_RPT_COLS aaprc
      on
        coll.c001 = aaprc.COLUMN_ALIAS
        and application_id = v_app_id
        and REGION_ID = v_region_id
      where
        collection_name = v_coll_name
    ) loop
      --v_column_array := v_column_array||'{'||APEX_JAVASCRIPT.ADD_ATTRIBUTE('query_column', i.given_column, false, true)||APEX_JAVASCRIPT.ADD_ATTRIBUTE('td_header',    i.COLUMN_ALIAS, false, false)||'}';
      v_column_array := v_column_array||'{"given_column" : "'||i.given_column||'","td_header": "'||i.COLUMN_ALIAS||'"}';

      if i.COLUMN_ALIAS is null then
        v_queryErrors := v_queryErrors +1;
      end if;

      if i.rn != i.columns_found then
        v_column_array := v_column_array||',';
      end if;

    end loop;

  end if;

  v_column_array := '['||v_column_array||']';


  v_json := '{
    "columnsToQuery": '||v_column_array||',
    "columnsNotMatched": '||v_queryErrors||',
    "regionId": "'||v_region_id||'",
    "regionType": "'||v_region_type||'"
  }';

  v_result.javascript_function := 'function() { pretius_row_details(this, '''||p_plugin.file_prefix||''', '||v_json||', false);}';    




  return v_result;

EXCEPTION
  when e_noColumnConditions then
    v_result.javascript_function := 'function() { pretius_row_details(this, '''||p_plugin.file_prefix||''', {}, true);}';    
    return v_result;
  WHEN OTHERS then
    v_result.javascript_function := 'function() { alert('''||SQLERRM||'''); }';

    APEX_JAVASCRIPT.add_onload_code('
      console.log(''While rendering plugin error ocured: '||SQLERRM||' '');      
    ');  

    return v_result;
end pretius_row_details;

function getColumnTypeString(
  p_col_type in number
) return varchar2 is 
  l_col_type varchar2(50);
begin
  if p_col_type = 1 then
    l_col_type := 'VARCHAR2';

  elsif p_col_type = 2 then
    l_col_type := 'NUMBER';

  elsif p_col_type = 12 then
    l_col_type := 'DATE';
      
  elsif p_col_type in (180,181,231) then
    l_col_type := 'TIMESTAMP';

    if p_col_type = 231 then
        l_col_type := 'TIMESTAMP_LTZ';
    end if;

  elsif p_col_type = 112 then
    l_col_type := 'CLOB';

  elsif p_col_type = 113 then

    l_col_type := 'BLOB';

  elsif p_col_type = 96 then
    l_col_type := 'CHAR';

  else
      l_col_type := 'OTHER';
  end if;

  return l_col_type;

end getColumnTypeString;

function removeEnter(
  p_string in varchar2
) return varchar2 is
begin
  return replace(replace(replace(p_string, chr(10), ' '), chr(13), ' '), '  ', ' ');
end ;

function clean_query( 
  p_query in varchar2 
) return varchar2 is
  l_query varchar2(32767) := p_query;
begin
  loop
    if substr(l_query,-1) in (chr(10),chr(13),';',' ','/') then
      l_query := substr(l_query,1,length(l_query)-1);
    else
      exit;
    end if;
  end loop;

  return l_query;

end clean_query;

function is_valid_query( 
  p_query in varchar2 
) return varchar2 is
  l_source_query  varchar2(32767) := p_query;
  l_source_queryv varchar2(32767);
  l_report_cursor integer;
begin
  if l_source_query is not null then
    if 
      substr(upper(ltrim(l_source_query)),1,6) != 'SELECT'
      and substr(upper(ltrim(l_source_query)),1,4) != 'WITH' 
    then
      return 'Query must begin with SELECT or WITH';
    end if;
    
    l_source_query := clean_query( l_source_query );
    l_source_queryv := sys.dbms_assert.noop( str => l_source_query );
    begin
      l_report_cursor := sys.dbms_sql.open_cursor;
      sys.dbms_sql.parse( l_report_cursor, l_source_queryv, SYS.DBMS_SQL.NATIVE );
      sys.dbms_sql.close_cursor(l_report_cursor);
    exception 
      when others then
        if sys.dbms_sql.is_open( l_report_cursor ) then
          sys.dbms_sql.close_cursor( l_report_cursor );
        end if;
        return sqlerrm;
    end;
  end if;

  return null;
end is_valid_query;

function getQueryDescJSON(
  p_sql in varchar2
) return varchar2 is 
  c sys_refcursor;
  v_report_cursor integer := null;
  v_columnNo number  := 0;
  v_columns sys.dbms_sql.desc_tab2;
  v_json varchar2(4000);
begin
  v_report_cursor := sys.dbms_sql.open_cursor;
  sys.dbms_sql.parse( v_report_cursor, p_sql, SYS.DBMS_SQL.NATIVE );
  sys.dbms_sql.describe_columns2( v_report_cursor, v_columnNo , v_columns);

  for i in 1..v_columnNo loop
    v_json := v_json||'{"COLUMN_NAME": "'||v_columns(i).col_name||'", "COLUMN_TYPE": "'||getColumnTypeString( v_columns(i).col_type )||'"}';

    if i != v_columnNo then
      v_json := v_json||',';
    end if;

  end loop;

  v_json := '['||v_json||']';
  sys.dbms_sql.close_cursor( v_report_cursor );

  return v_json;
end getQueryDescJSON;

procedure split_columns_values(
    p_col_str in varchar2
  , p_val_str in varchar2
  , p_col_arr in out nocopy apex_application_global.vc_arr2
  , p_val_arr in out nocopy apex_application_global.vc_arr2
  , p_delimeter in varchar2 default ':'
)
is
begin
  p_col_arr := apex_util.string_to_table( p_col_str, p_delimeter );
  p_val_arr := apex_util.string_to_table( p_val_str, p_delimeter );
end split_columns_values;


procedure pretius_row_data_ajax (
    p_dynamic_action IN apex_plugin.t_dynamic_action
  , p_col_arr in out nocopy apex_application_global.vc_arr2
  , p_val_arr in out nocopy apex_application_global.vc_arr2
)
is

  v_cursor sys_refcursor;

  l_cursor          pls_integer;
  l_status          number;

  v_coll_row APEX_COLLECTIONs%ROWTYPE;
  v_sql varchar2(4000);
begin
  --pobierz gotowe zapytanie z kolekcji
  select 
    *
  into
    v_coll_row
  from
    APEX_COLLECTIONs
  where
    collection_name = p_dynamic_action.id||'_QUERY';
    -- There should be a single row in the collection now.
    -- and (
    --   c001 = apex_application.g_x01
    --   and c002 = apex_application.g_x02
    --   OR 
    --   c001 is null
    --   and c002 is null
    -- ); 

  v_sql := v_coll_row.c003;

  -- open v_cursor for v_sql;
  l_cursor := dbms_sql.open_cursor;
  dbms_sql.parse (l_cursor, v_sql, dbms_sql.native);
  -- bind all the values
  for i in 1 .. p_col_arr.count loop
    dbms_sql.bind_variable (l_cursor, p_col_arr(i), p_val_arr(i));
  end loop;
  l_status := dbms_sql.execute(l_cursor);
  v_cursor := dbms_sql.to_refcursor(l_cursor);

  apex_json.write( v_cursor );

end pretius_row_data_ajax;



function pretius_row_details_ajax (
  p_dynamic_action in apex_plugin.t_dynamic_action,
  p_plugin         in apex_plugin.t_plugin 
) return apex_plugin.t_dynamic_action_ajax_result
is

  v_columnNames  APEX_APPLICATION_GLOBAL.VC_ARR2;--varchar2(4000) := apex_application.g_x01;
  v_columnValues APEX_APPLICATION_GLOBAL.VC_ARR2;--varchar2(4000) := apex_application.g_x02;

  v_result apex_plugin.t_dynamic_action_ajax_result;
  v_sql varchar2(4000) := p_dynamic_action.attribute_01;
  v_sql_result_json varchar2(4000);
  v_parseResult varchar2(4000);

  v_coll_name varchar2(200) := p_dynamic_action.id||'_QUERY';
begin
  --$$$ zrobić obsługę, że jeśli w kolekcji jest juz wygenerowane query do wywyołania to zwraca to query
  
  split_columns_values(
      p_col_str => apex_application.g_x01
    , p_val_str => apex_application.g_x02
    , p_col_arr => v_columnNames
    , p_val_arr => v_columnValues
  );

  if apex_application.g_x03 = 'getData' then
    pretius_row_data_ajax( p_dynamic_action, v_columnNames, v_columnValues);
    return v_result;
  end if;

  --apex_application.g_x03 = 'getHeaders'


  -- Change columns to bind variables  
  for i in 1..v_columnNames.count loop
    -- if REGEXP_LIKE (v_columnValues(i), '^\d*$') then
    --   v_sql := replace( v_sql, '#'||v_columnNames(i)||'#', v_columnValues(i) );  
    -- else
    --   v_sql := replace( v_sql, '#'||v_columnNames(i)||'#', chr(39)||v_columnValues(i)||chr(39) );
    -- end if;

    v_sql := replace( v_sql, '#'||v_columnNames(i)||'#', ':' || v_columnNames(i) );  
    
  end loop;

  v_parseResult := is_valid_query( v_sql );

  if v_parseResult is not null then
    --$$$ dorobic obsluge exception zeby przerywal AJAX i zwracal stosowny komunikat do JS
    e_temp_msg := v_parseResult;
    raise e_quryParse;
  end if;

  v_sql_result_json := getQueryDescJSON( v_sql );

  begin
    APEX_COLLECTION.DELETE_COLLECTION( v_coll_name );
    APEX_COLLECTION.DELETE_COLLECTION( v_coll_name );

  exception
    when others then
      null;
  end;

  -- We don't need g_x01, g_x02 any more. Remove g_x02?
  APEX_COLLECTION.CREATE_COLLECTION( v_coll_name );
  APEX_COLLECTION.ADD_MEMBER (
    p_collection_name => v_coll_name,
    p_c001 => apex_application.g_x01,
    p_c002 => apex_application.g_x02,
    p_c003 => v_sql,
    p_c004 => v_sql_result_json
  );

  htp.p(v_sql_result_json);

  return v_result;
EXCEPTION
  when e_quryParse then
    htp.p('
      {
        "error": {
          "guiMsg": "There is problem with plugin configuration. Contact your application administrator.",
          "devMsg": "'||APEX_PLUGIN_UTIL.ESCAPE (e_temp_msg, true)||'",
          "target": "developer",
          "SQL": "'||APEX_PLUGIN_UTIL.ESCAPE( removeEnter(v_sql), true ) ||'"
        }
      }
    ');
    return v_result;
  WHEN OTHERS then
    htp.p('AJAX ERROR: '||SQLERRM );
    return v_result;
end pretius_row_details_ajax;

end pretius_nested_table;
/