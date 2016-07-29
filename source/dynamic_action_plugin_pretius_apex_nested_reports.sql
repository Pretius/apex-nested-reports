set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050000 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2013.01.01'
,p_release=>'5.0.2.00.07'
,p_default_workspace_id=>2909324000710197
,p_default_application_id=>105
,p_default_owner=>'APEX_PRETIUS_WWW'
);
end;
/
prompt --application/ui_types
begin
null;
end;
/
prompt --application/shared_components/plugins/dynamic_action/pretius_apex_nested_reports
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(471258000703755090)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'PRETIUS_APEX_NESTED_REPORTS'
,p_display_name=>'Pretius APEX Nested Reports'
,p_category=>'EXECUTE'
,p_supported_ui_types=>'DESKTOP'
,p_javascript_file_urls=>'#PLUGIN_FILES#pretius_row_details.js'
,p_css_file_urls=>'#PLUGIN_FILES#pretius_row_details_styles.css'
,p_plsql_code=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'e_temp EXCEPTION;',
'e_quryParse EXCEPTION;',
'e_noColumnConditions exception;',
'e_temp_msg varchar2(4000);',
'',
'',
'function getColumnNamesFromQuery(',
'  p_string in varchar2',
') return APEX_APPLICATION_GLOBAL.VC_ARR2 is',
'  v_count number;',
'  v_pattern varchar2(50) := ''#[a-zA-Z_0-9]+#'';',
'  v_columns APEX_APPLICATION_GLOBAL.VC_ARR2;',
'begin',
'  v_count := regexp_count(p_string, v_pattern, 1, ''m'');',
'',
'  for i in 1..v_count loop',
'    v_columns(i) := upper(trim(both ''#'' from regexp_substr(p_string, v_pattern, 1, i, ''m'') ));',
'  end loop;  ',
'',
'  return v_columns;',
'end;',
'',
'function pretius_row_details (',
'  p_dynamic_action in apex_plugin.t_dynamic_action,',
'  p_plugin         in apex_plugin.t_plugin ',
') return apex_plugin.t_dynamic_action_render_result',
'is',
'  v_result apex_plugin.t_dynamic_action_render_result;',
'  v_region_id number;',
'  v_region_type varchar2(100);',
'  v_app_id number := :APP_ID;',
'  v_coll_name varchar2(200) := p_dynamic_action.id||''_COLUMNS'';',
'  v_columns APEX_APPLICATION_GLOBAL.VC_ARR2;',
'  v_column_array varchar2(4000);',
'  v_json varchar2(4000);',
'  v_queryErrors number := 0;',
'BEGIN',
'',
'  v_result.ajax_identifier := APEX_PLUGIN.GET_AJAX_IDENTifIER();',
'  v_result.attribute_01 := p_dynamic_action.attribute_01;',
'  v_result.attribute_02 := NVL(p_dynamic_action.attribute_02, '':'');',
'  v_result.attribute_03 := NVL(p_dynamic_action.attribute_03, '':'');',
'  v_result.attribute_04 := p_dynamic_action.attribute_04;',
'  v_result.attribute_05 := p_dynamic_action.attribute_05;',
'  v_result.attribute_06 := p_dynamic_action.attribute_06;',
'  v_result.attribute_07 := p_dynamic_action.attribute_07;',
'  v_result.attribute_08 := p_dynamic_action.attribute_08;',
'  v_result.attribute_09 := p_dynamic_action.attribute_09;',
'  v_result.attribute_10 := NVL(p_dynamic_action.attribute_10, '':'');',
'  v_result.attribute_11 := p_dynamic_action.attribute_11;',
'',
'  APEX_PLUGIN_UTIL.DEBUG_DYNAMIC_ACTION (',
'    p_plugin         => p_plugin,',
'    p_dynamic_action => p_dynamic_action',
'  );',
'/*',
'  apex_css.add_file (  ',
'    p_name => ''pretius_row_details'',',
'    p_directory => p_plugin.file_prefix, ',
'    p_version => null',
'  );',
'',
'  apex_javascript.add_library(',
'    p_name      => ''pretius_row_details'',',
'    p_directory => p_plugin.file_prefix,',
'    p_version   => NULL ',
'  );',
'  */',
'',
'  if instr('':''||p_plugin.attribute_02||'':'', '':MUSTACHE:'') > 0 then',
'    apex_javascript.add_library(',
'      p_name => ''mustache'', ',
'      p_directory => p_plugin.file_prefix, ',
'      p_version => null ',
'    );',
'',
'  end if;',
'  ',
'',
'  --pobierz affected v_regionId',
'  select ',
'    AFFECTED_REGION,',
'    AFFECTED_REGION_ID ',
'  into',
'    v_region_type, --Interactive report / Classic report',
'    v_region_id',
'  from ',
'    APEX_APPLICATION_PAGE_DA_ACTS ',
'  where ',
'    application_id = v_app_id',
'    and action_id = p_dynamic_action.id;',
'',
'',
'  APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION(v_coll_name);',
'',
'  v_columns := getColumnNamesFromQuery( p_dynamic_action.attribute_01 );',
'',
'  --htp.p(v_columns.count);',
'',
'  if v_columns.count = 0 then',
'    e_temp_msg := ''W SQL nie znalazl kolumn'';',
'    raise e_noColumnConditions;',
'  end if;',
'',
'  --pobierz nazwy kolumn i utworz kolekcje',
'',
'  APEX_COLLECTION.ADD_MEMBERS (',
'    p_collection_name => v_coll_name,',
'    p_c001 =>  v_columns',
'  );  ',
'',
'  --pobierz informacje o mapowaniu kolumn w przypadku IR',
'  if v_region_type = ''Interactive report'' then',
'',
'    for i in (',
'      select',
'        count(*) over (partition by 1) columns_found,',
'        coll.c001 given_column,',
'        rownum as rn,',
'        COLUMN_ID,',
'        COLUMN_ALIAS',
'      from',
'        APEX_COLLECTIONs coll',
'      left join',
'        APEX_APPLICATION_PAGE_IR_COL aappirc',
'      on',
'        coll.c001 = aappirc.COLUMN_ALIAS',
'        and application_id = v_app_id',
'        and REGION_ID = v_region_id',
'      where',
'        collection_name = v_coll_name',
'    ) loop',
'      --v_column_array := ''{''||APEX_JAVASCRIPT.ADD_ATTRIBUTE(''query_column'', i.given_column, false, true)||APEX_JAVASCRIPT.ADD_ATTRIBUTE(''td_header'',    i.COLUMN_ALIAS, false, false)||''}'';',
'      v_column_array := v_column_array||''{"given_column" : "''||i.given_column||''","td_header": "C''||i.COLUMN_ID||''"}'';',
'',
'      if i.COLUMN_ALIAS is null then',
'        v_queryErrors := v_queryErrors +1;',
'      end if;',
'',
'      if i.rn != i.columns_found then',
'        v_column_array := v_column_array||'','';',
'      end if;',
'',
'    end loop;',
'  else',
'',
'    for i in(',
'      select ',
'        coll.c001 given_column,',
'        COLUMN_ALIAS,',
'        count(*) over (partition by 1) columns_found,',
'        rownum as rn',
'      from',
'        APEX_COLLECTIONs coll',
'      left join',
'        APEX_APPLICATION_PAGE_RPT_COLS aaprc',
'      on',
'        coll.c001 = aaprc.COLUMN_ALIAS',
'        and application_id = v_app_id',
'        and REGION_ID = v_region_id',
'      where',
'        collection_name = v_coll_name',
'    ) loop',
'      --v_column_array := v_column_array||''{''||APEX_JAVASCRIPT.ADD_ATTRIBUTE(''query_column'', i.given_column, false, true)||APEX_JAVASCRIPT.ADD_ATTRIBUTE(''td_header'',    i.COLUMN_ALIAS, false, false)||''}'';',
'      v_column_array := v_column_array||''{"given_column" : "''||i.given_column||''","td_header": "''||i.COLUMN_ALIAS||''"}'';',
'',
'      if i.COLUMN_ALIAS is null then',
'        v_queryErrors := v_queryErrors +1;',
'      end if;',
'',
'      if i.rn != i.columns_found then',
'        v_column_array := v_column_array||'','';',
'      end if;',
'',
'    end loop;',
'',
'  end if;',
'',
'  v_column_array := ''[''||v_column_array||'']'';',
'',
'',
'  v_json := ''{',
'    "columnsToQuery": ''||v_column_array||'',',
'    "columnsNotMatched": ''||v_queryErrors||'',',
'    "regionId": "''||v_region_id||''",',
'    "regionType": "''||v_region_type||''"',
'  }'';',
'',
'  v_result.javascript_function := ''function() { pretius_row_details(this, ''''''||p_plugin.file_prefix||'''''', ''||v_json||'', false);}'';    ',
'',
'',
'',
'',
'  return v_result;',
'',
'EXCEPTION',
'  when e_noColumnConditions then',
'    v_result.javascript_function := ''function() { pretius_row_details(this, ''''''||p_plugin.file_prefix||'''''', {}, true);}'';    ',
'    return v_result;',
'  WHEN OTHERS then',
'    v_result.javascript_function := ''function() { alert(''''''||SQLERRM||''''''); }'';',
'',
'    APEX_JAVASCRIPT.add_onload_code(''',
'      console.log(''''While rendering plugin error ocured: ''||SQLERRM||'' '''');      ',
'    '');  ',
'',
'    return v_result;',
'end pretius_row_details;',
'',
'function getColumnTypeString(',
'  p_col_type in number',
') return varchar2 is ',
'  l_col_type varchar2(50);',
'begin',
'  if p_col_type = 1 then',
'    l_col_type := ''VARCHAR2'';',
'',
'  elsif p_col_type = 2 then',
'    l_col_type := ''NUMBER'';',
'',
'  elsif p_col_type = 12 then',
'    l_col_type := ''DATE'';',
'      ',
'  elsif p_col_type in (180,181,231) then',
'    l_col_type := ''TIMESTAMP'';',
'',
'    if p_col_type = 231 then',
'        l_col_type := ''TIMESTAMP_LTZ'';',
'    end if;',
'',
'  elsif p_col_type = 112 then',
'    l_col_type := ''CLOB'';',
'',
'  elsif p_col_type = 113 then',
'',
'    l_col_type := ''BLOB'';',
'',
'  elsif p_col_type = 96 then',
'    l_col_type := ''CHAR'';',
'',
'  else',
'      l_col_type := ''OTHER'';',
'  end if;',
'',
'  return l_col_type;',
'',
'end getColumnTypeString;',
'',
'function removeEnter(',
'  p_string in varchar2',
') return varchar2 is',
'begin',
'  return replace(replace(replace(p_string, chr(10), '' ''), chr(13), '' ''), ''  '', '' '');',
'end ;',
'',
'function clean_query( ',
'  p_query in varchar2 ',
') return varchar2 is',
'  l_query varchar2(32767) := p_query;',
'begin',
'  loop',
'    if substr(l_query,-1) in (chr(10),chr(13),'';'','' '',''/'') then',
'      l_query := substr(l_query,1,length(l_query)-1);',
'    else',
'      exit;',
'    end if;',
'  end loop;',
'',
'  return l_query;',
'',
'end clean_query;',
'',
'function is_valid_query( ',
'  p_query in varchar2 ',
') return varchar2 is',
'  l_source_query  varchar2(32767) := p_query;',
'  l_source_queryv varchar2(32767);',
'  l_report_cursor integer;',
'begin',
'  if l_source_query is not null then',
'    if ',
'      substr(upper(ltrim(l_source_query)),1,6) != ''SELECT''',
'      and substr(upper(ltrim(l_source_query)),1,4) != ''WITH'' ',
'    then',
'      return ''Query must begin with SELECT or WITH'';',
'    end if;',
'    ',
'    l_source_query := clean_query( l_source_query );',
'    l_source_queryv := sys.dbms_assert.noop( str => l_source_query );',
'    begin',
'      l_report_cursor := sys.dbms_sql.open_cursor;',
'      sys.dbms_sql.parse( l_report_cursor, l_source_queryv, SYS.DBMS_SQL.NATIVE );',
'      sys.dbms_sql.close_cursor(l_report_cursor);',
'    exception ',
'      when others then',
'        if sys.dbms_sql.is_open( l_report_cursor ) then',
'          sys.dbms_sql.close_cursor( l_report_cursor );',
'        end if;',
'        return sqlerrm;',
'    end;',
'  end if;',
'',
'  return null;',
'end is_valid_query;',
'',
'function getQueryDescJSON(',
'  p_sql in varchar2',
') return varchar2 is ',
'  c sys_refcursor;',
'  v_report_cursor integer := null;',
'  v_columnNo number  := 0;',
'  v_columns sys.dbms_sql.desc_tab2;',
'  v_json varchar2(4000);',
'begin',
'  v_report_cursor := sys.dbms_sql.open_cursor;',
'  sys.dbms_sql.parse( v_report_cursor, p_sql, SYS.DBMS_SQL.NATIVE );',
'  sys.dbms_sql.describe_columns2( v_report_cursor, v_columnNo , v_columns);',
'',
'  for i in 1..v_columnNo loop',
'    v_json := v_json||''{"COLUMN_NAME": "''||v_columns(i).col_name||''", "COLUMN_TYPE": "''||getColumnTypeString( v_columns(i).col_type )||''"}'';',
'',
'    if i != v_columnNo then',
'      v_json := v_json||'','';',
'    end if;',
'',
'  end loop;',
'',
'  v_json := ''[''||v_json||'']'';',
'  sys.dbms_sql.close_cursor( v_report_cursor );',
'',
'  return v_json;',
'end getQueryDescJSON;',
'',
'procedure pretius_row_data_ajax (',
'  p_dynamic_action IN apex_plugin.t_dynamic_action',
')',
'is',
'  v_cursor sys_refcursor;',
'  v_coll_row APEX_COLLECTIONs%ROWTYPE;',
'  v_sql varchar2(4000);',
'begin',
'  --pobierz gotowe zapytanie z kolekcji',
'  select ',
'    *',
'  into',
'    v_coll_row',
'  from',
'    APEX_COLLECTIONs',
'  where',
'    collection_name = p_dynamic_action.id||''_QUERY''',
'    and (',
'      c001 = apex_application.g_x01',
'      and c002 = apex_application.g_x02',
'      OR ',
'      c001 is null',
'      and c002 is null',
'    ); ',
'',
'  v_sql := v_coll_row.c003;',
'',
'  open v_cursor for v_sql;',
'  apex_json.write( v_cursor );  ',
'end;',
'',
'',
'function pretius_row_details_ajax (',
'  p_dynamic_action in apex_plugin.t_dynamic_action,',
'  p_plugin         in apex_plugin.t_plugin ',
') return apex_plugin.t_dynamic_action_ajax_result',
'is',
'',
'  v_columnNames  APEX_APPLICATION_GLOBAL.VC_ARR2;--varchar2(4000) := apex_application.g_x01;',
'  v_columnValues APEX_APPLICATION_GLOBAL.VC_ARR2;--varchar2(4000) := apex_application.g_x02;',
'',
'  v_result apex_plugin.t_dynamic_action_ajax_result;',
'  v_sql varchar2(4000) := p_dynamic_action.attribute_01;',
'  v_sql_result_json varchar2(4000);',
'  v_parseResult varchar2(4000);',
'  v_cursor sys_refcursor;',
'',
'  v_coll_name varchar2(200) := p_dynamic_action.id||''_QUERY'';',
'begin',
'  --$$$ zrobić obsługę, że jeśli w kolekcji jest juz wygenerowane query do wywyołania to zwraca to query',
'  ',
'',
'  if apex_application.g_x03 = ''getData'' then',
'    pretius_row_data_ajax( p_dynamic_action );',
'    return v_result;',
'  end if;',
'',
'  --apex_application.g_x03 = ''getHeaders''',
'',
'',
'  v_columnNames := APEX_UTIL.STRING_TO_TABLE( apex_application.g_x01 );',
'  v_columnValues := APEX_UTIL.STRING_TO_TABLE( apex_application.g_x02 );',
'',
'  ',
'  for i in 1..v_columnNames.count loop',
'    if REGEXP_LIKE (v_columnValues(i), ''^\d*$'') then',
'      v_sql := replace( v_sql, ''#''||v_columnNames(i)||''#'', v_columnValues(i) );  ',
'    else',
'      v_sql := replace( v_sql, ''#''||v_columnNames(i)||''#'', chr(39)||v_columnValues(i)||chr(39) );',
'    end if;',
'    ',
'  end loop;',
'',
'  v_parseResult := is_valid_query( v_sql );',
'',
'  if v_parseResult is not null then',
'    --$$$ dorobic obsluge exception zeby przerywal AJAX i zwracal stosowny komunikat do JS',
'    e_temp_msg := v_parseResult;',
'    raise e_quryParse;',
'  end if;',
'',
'  v_sql_result_json := getQueryDescJSON( v_sql );',
'',
'  begin',
'    APEX_COLLECTION.DELETE_COLLECTION( v_coll_name );',
'    APEX_COLLECTION.DELETE_COLLECTION( v_coll_name );',
'',
'  exception',
'    when others then',
'      null;',
'  end;',
'',
'  APEX_COLLECTION.CREATE_COLLECTION( v_coll_name );',
'  APEX_COLLECTION.ADD_MEMBER (',
'    p_collection_name => v_coll_name,',
'    p_c001 => apex_application.g_x01,',
'    p_c002 => apex_application.g_x02,',
'    p_c003 => v_sql,',
'    p_c004 => v_sql_result_json',
'  );',
'',
'  htp.p(v_sql_result_json);',
'',
'  return v_result;',
'EXCEPTION',
'  when e_quryParse then',
'    htp.p(''',
'      {',
'        "error": {',
'          "guiMsg": "There is problem with plugin configuration. Contact your application administrator.",',
'          "devMsg": "''||APEX_PLUGIN_UTIL.ESCAPE (e_temp_msg, true)||''",',
'          "target": "developer",',
'          "SQL": "''||APEX_PLUGIN_UTIL.ESCAPE( removeEnter(v_sql), true ) ||''"',
'        }',
'      }',
'    '');',
'    return v_result;',
'  WHEN OTHERS then',
'    htp.p(''AJAX ERROR: ''||SQLERRM );',
'    return v_result;',
'end pretius_row_details_ajax;'))
,p_render_function=>'pretius_row_details'
,p_ajax_function=>'pretius_row_details_ajax'
,p_standard_attributes=>'REGION:JQUERY_SELECTOR:REQUIRED'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
,p_files_version=>76
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(477322881433529320)
,p_plugin_id=>wwv_flow_api.id(471258000703755090)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Attach files'
,p_attribute_type=>'CHECKBOXES'
,p_is_required=>false
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(477327008267531073)
,p_plugin_attribute_id=>wwv_flow_api.id(477322881433529320)
,p_display_sequence=>10
,p_display_value=>'Mustache.js'
,p_return_value=>'MUSTACHE'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(471259256806759520)
,p_plugin_id=>wwv_flow_api.id(471258000703755090)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Details query'
,p_attribute_type=>'SQL'
,p_is_required=>true
,p_is_translatable=>false
,p_examples=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<h4>',
'  Referencing affected report column',
'</h4>',
'<p>',
'  Affected report query (Classic report)',
'</p>  ',
'<pre>',
'select',
'  ORDER_ID,',
'  CUSTOMER_ID as CUST_ID,',
'  ORDER_TOTAL,',
'  TAGS',
'from',
'  DEMO_ORDERS',
'</pre>',
'<p>',
'  Details query might look like  ',
'</p>  ',
'<pre>',
'select',
'  CUSTOMER_ID,',
'  CUST_FIRST_NAME as "First name",',
'  CUST_LAST_NAME,',
'  PHONE_NUMBER1,',
'  CREDIT_LIMIT',
'from',
'  DEMO_CUSTOMERS',
'where',
'  customer_id = #CUST_ID#',
'</pre>',
'<p>',
'  The plugin will replace #CUST_ID# with value of the column CUST_ID within affected report.',
'</p>  ',
'',
'<h4>',
'  Referencing not visible columns',
'</h4>',
'<p>',
'  When column in report has "Type" = "Hidden" it is not rendered in report and can''t be referenced by the plugin. To reference such column, its value has to be provided within visible column.',
'</p>',
'<p>',
'  In Classic report are defined columns',
'</p>',
'<ul>',
'  <li>column CUSTOMER_ID, Type = "Hidden"</li>',
'  <li>column CUSTOMER, Type = "Plain Text"</li>',
'</ul>',
'<p>',
'  Column CUSTOMER is visible and can contain CUSTOMER_ID value. To do so go to section Column Formatting > HTML Expression and enter HTML:',
'</p>',
'<pre>',
'<span class="CUSTOMER_ID" style="display:none">#CUSTOMER_ID#</span>#CUSTOMER#  ',
'</pre>'))
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>',
'  Enter valid SQL query that returns at least one row. Returned records are rendered in default (or custom) template.',
'</p>',
'<h4>',
'  Narrowing results',
'</h4>',
'<p>',
'  Condition value(s) should be column(s) name(s) from parent region enclosed by # characters.',
'</p>',
'<pre>',
'...',
'where',
'  COLUMN_ID = #COLUMN_ID#',
'</pre>',
'<h4>',
'  How does it work?',
'</h4>',
'<p>',
'  When column name is enclosed by # characters in the details query attribute, the plugin looks for DOM element (within report row) matching following jQuery selectors:',
'</p>',
'<pre>',
'td[headers=COLUMN_NAME]',
'</pre>',
'<p>',
'  or',
'</p>',
'<pre>',
'.COLUMN_NAME  ',
'</pre>',
'<p>',
'  It means that the plugin looks for',
'</p>',
'<ul>',
'  <li>TD element with header attribute set to COLUMN_NAME or</li>',
'  <li>any element having class COLUMN_NAME</li>',
'</ul>',
'<p>',
'  The text value from matched element is used to replace #COLUMN_NAME# in details row attribute.',
'</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(473867685307439255)
,p_plugin_id=>wwv_flow_api.id(471258000703755090)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>55
,p_prompt=>'Settings'
,p_attribute_type=>'CHECKBOXES'
,p_is_required=>false
,p_default_value=>'CE:AA:LI:CR'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(474715735145482106)
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'DTDC,CTDC'
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>',
'  Default callback attribute allows you to add extra efects to rendered data.',
'</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(477393882484784271)
,p_plugin_attribute_id=>wwv_flow_api.id(473867685307439255)
,p_display_sequence=>5
,p_display_value=>'Cache results'
,p_return_value=>'CR'
,p_help_text=>'If checked the result of the SQL query is retrieved only once for the specified table cell or jQuery selector.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(473874251339447107)
,p_plugin_attribute_id=>wwv_flow_api.id(473867685307439255)
,p_display_sequence=>10
,p_display_value=>'Collapse expanded'
,p_return_value=>'CE'
,p_help_text=>'If checked every expanded row will be collapsed each time new row is presented.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(473916170129542982)
,p_plugin_attribute_id=>wwv_flow_api.id(473867685307439255)
,p_display_sequence=>20
,p_display_value=>'Set max height'
,p_return_value=>'SMH'
,p_help_text=>'If checked max-height property is added to expanded row. Value must be provided in Set max height attribute.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(474037914715909325)
,p_plugin_attribute_id=>wwv_flow_api.id(473867685307439255)
,p_display_sequence=>30
,p_display_value=>'Add animation'
,p_return_value=>'AA'
,p_help_text=>'If checked slideDown and slideUp animation is added while expanding / collapsing row.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(477596167991322488)
,p_plugin_attribute_id=>wwv_flow_api.id(473867685307439255)
,p_display_sequence=>40
,p_display_value=>'Loading indicator'
,p_return_value=>'LI'
,p_help_text=>'If checked the loading indicator is displayed whenever the ajax call occurs.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(474715735145482106)
,p_plugin_id=>wwv_flow_api.id(471258000703755090)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>5
,p_prompt=>'Mode'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'DTDC'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>'Picked option defines the plugin customization level.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(474719613646482730)
,p_plugin_attribute_id=>wwv_flow_api.id(474715735145482106)
,p_display_sequence=>10
,p_display_value=>'Default template & default callback'
,p_return_value=>'DTDC'
,p_help_text=>'Default plugin behaviour. Resulting rows of data are rendered in default template (table of data) along with default callback settings.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(474719993187483572)
,p_plugin_attribute_id=>wwv_flow_api.id(474715735145482106)
,p_display_sequence=>20
,p_display_value=>'Default template & custom callback'
,p_return_value=>'DTCC'
,p_help_text=>'When this option is selected, resulting rows of data are rendered with template provided in custom template attribute.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(474720398700484202)
,p_plugin_attribute_id=>wwv_flow_api.id(474715735145482106)
,p_display_sequence=>30
,p_display_value=>'Custom template & default callback'
,p_return_value=>'CTDC'
,p_help_text=>'When this option is selected, resulting rows of data are rendered with default template and custom JS callback function defined in custom callback attribute.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(474720813952485045)
,p_plugin_attribute_id=>wwv_flow_api.id(474715735145482106)
,p_display_sequence=>40
,p_display_value=>'Custom template & custom callback'
,p_return_value=>'CTCC'
,p_help_text=>'When this option is selected, developer decides how template for resulting rows of data is build and how results should be displayed after receiving rows from database.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(473571423266940909)
,p_plugin_id=>wwv_flow_api.id(471258000703755090)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>105
,p_prompt=>'Custom template'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(474715735145482106)
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'CTDC,CTCC'
,p_examples=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>',
'  Assuming your details query is defined as below:',
'</p>',
'<pre>',
'select',
'  CUSTOMER_ID,',
'  CUST_FIRST_NAME as "First name",',
'  CUST_LAST_NAME,',
'  PHONE_NUMBER1,',
'  CREDIT_LIMIT',
'from',
'  DEMO_CUSTOMERS',
'where',
'  customer_id = #CUSTOMER_ID#',
'</pre>',
'<p>',
'  Your custom template might look like:',
'</p>',
'<pre>',
'<table>',
'  <tr>',
'    <th>Column name</th>',
'    <th>Column type</th>',
'  </tr>',
'  {{#headers}}',
'  <tr>',
'    <td>{{COLUMN_NAME}}</td>',
'    <td>{{COLUMN_TYPE}}</td>',
'  </tr>',
'  {{/headers}}',
'</table>',
'{{#data}}',
'<div class="customRow">',
'  <div>',
'    <span class="label">',
'      Customer name',
'    </span>',
'    <span class="value">',
'      <span class="fa fa-user"></span> {{First name}} {{CUST_LAST_NAME}}',
'    </span>',
'  </div>',
'  <div>',
'    <span class="label">',
'      Customer phone number',
'    </span>',
'    <span class="value">',
'      <span class="fa fa-phone"></span> {{PHONE_NUMBER1}}',
'    </span>',
'  </div>',
'  <div>',
'    <span class="label">',
'      Customer credit limit',
'    </span>',
'    <span class="value">',
'      <span class="fa fa-credit-card"></span> {{CREDIT_LIMIT}}',
'    </span>',
'  </div>',
'</div>',
'{{/data}}  ',
'</pre>',
'<p>',
'column CUST_FIRST_NAME is referenced by its alias {{First name}} defined in details query. Others columns are referenced by their names.',
'</p>',
'<p>',
'  List of columns are presented in table with two columns and rows of data are rendered in div blocks.',
'</p>',
'<h4>Example CSS</h4>',
'<pre>',
'.customRow > div {',
'  display: inline-block;',
'  margin-right: 10px;',
'}',
' ',
'.customRow > div:last-child {',
'  margin-right: 0px;',
'}',
' ',
'.customRow span.label {',
'  font-weight: bold;',
'  display: block;',
'}',
'.customRow span.value {',
'  font-size: 120%;',
'  padding: 5px;',
'  display: block;',
'}  ',
'</pre>'))
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>',
'  Templates are rendered by Mustache JavaScript library. To read more about Mustache API vistit https://github.com/janl/mustache.js#usage.',
'</p>',
'<p>',
'  Template is rendered from JSON object with two attributes: data and headers. Data attribute reference array of rows and headers attribute reference array of columns description.',
'</p>',
'',
'<h4>',
'  Headers template',
'</h4>',
'<p>',
'  Use {{#headers}} and {{/headers}} tags to mark beginning and ending of header section. To render column name use {{COLUMN_NAME}} and to display column type use {{COLUMN_TYPE}}.',
'</p>',
'',
'<h4>',
'  Data template',
'</h4>',
'<p>',
'  Use {{#data}} and {{/data}} to mark beginning and ending of single row template. To render column value use {{COLUMN_NAME}} or {{Column alias}}. "COLUMN_NAME" is column name without alias in details query attribute, and "Column alias" is column ali'
||'as in details query attribute.',
'</p>',
'<p>',
'  See examples below to learn how custom template might look like.',
'</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(473573290452943876)
,p_plugin_id=>wwv_flow_api.id(471258000703755090)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>110
,p_prompt=>'Custom callback'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(474715735145482106)
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'DTCC,CTCC'
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>',
'  Custom JavaScript code is used to steer how rendered template is embedded within affected report. JavaScript code is executed each time the plugin retrieves details query records.',
'</p>',
'<p>',
'  This code has access to the following plugin attributes:',
'</p>',
'<dl>',
'  <dt>this.callback.triggeringElement</dt>',
'  <dd>A reference to the jQuery object of the element that triggered the dynamic action.</dd>',
'',
'  <dt>this.callback.affactedReport</dt>',
'  <dd>A reference to the jQuery object containg master report pointed in Affected Elements.</dd>',
'',
'',
'  <dt>this.callback.renderedTemplate</dt>',
'  <dd>The rendered default/custom template based on results from details query attribute.</dd>',
'',
'  <dt>this.callback.browserEvent</dt>',
'  <dd>The event object of event that triggered the plugin.</dd>',
'',
'</dl>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(473592575256036256)
,p_plugin_id=>wwv_flow_api.id(471258000703755090)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Background color'
,p_attribute_type=>'COLOR'
,p_is_required=>true
,p_default_value=>'#EBEBEB'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(474715735145482106)
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'DTDC,CTDC'
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>Pick HEX color to be applied as background color for retrieved rows.</p>',
'<dl>',
'  <dt>Default value</dt>',
'  <dd>#EBEBEB</dd>',
'</dl>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(473596273183055864)
,p_plugin_id=>wwv_flow_api.id(471258000703755090)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>100
,p_prompt=>'Set max height'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'300'
,p_unit=>'px'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(473867685307439255)
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'SMH'
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>',
'  Set max-height property for container with retrieved rows of data.',
'</p>',
'',
'<dl>',
'  <dt>Default value</dt>',
'  <dd>300</dd>',
'</dl>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(473648787156001562)
,p_plugin_id=>wwv_flow_api.id(471258000703755090)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Border color'
,p_attribute_type=>'COLOR'
,p_is_required=>true
,p_default_value=>'#c5c5c5'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(474715735145482106)
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'DTDC,CTDC'
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>',
'  Pick HEX color to be applied as border color for retrieved rows.',
'</p>',
'',
'<dl>',
'  <dt>Default value</dt>',
'  <dd>#C5C5C5</dd>',
'</dl>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(473753878491498425)
,p_plugin_id=>wwv_flow_api.id(471258000703755090)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Highlight row color'
,p_attribute_type=>'COLOR'
,p_is_required=>true
,p_default_value=>'#F2F2F2'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(474715735145482106)
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'DTDC,CTDC'
,p_help_text=>wwv_flow_utilities.join(wwv_flow_t_varchar2(
'<p>',
'  Pick HEX color to be applied as border color for retrieved rows.',
'</p>',
'',
'<dl>',
'  <dt>Default value</dt>',
'  <dd>#F2F2F2</dd>',
'</dl>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(477290657054750763)
,p_plugin_id=>wwv_flow_api.id(471258000703755090)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>55
,p_prompt=>'Settings '
,p_attribute_type=>'CHECKBOXES'
,p_is_required=>false
,p_default_value=>'CR:LI'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(474715735145482106)
,p_depending_on_condition_type=>'NOT_IN_LIST'
,p_depending_on_expression=>'DTDC,CTDC'
,p_lov_type=>'STATIC'
,p_help_text=>'Custom callback attribute allows you to add extra efects to rendered data.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(477294819408751708)
,p_plugin_attribute_id=>wwv_flow_api.id(477290657054750763)
,p_display_sequence=>10
,p_display_value=>'Cache results'
,p_return_value=>'CR'
,p_help_text=>'If checked the result of the SQL query is retrieved only once for the specified table cell or jQuery selector.'
);
end;
/
begin
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(477600343911323831)
,p_plugin_attribute_id=>wwv_flow_api.id(477290657054750763)
,p_display_sequence=>20
,p_display_value=>'Loading indicator'
,p_return_value=>'LI'
,p_help_text=>'If checked the loading indicator is displayed whenever the ajax call occurs.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(477426326814813872)
,p_plugin_id=>wwv_flow_api.id(471258000703755090)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>50
,p_prompt=>'When no data found'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>false
,p_default_value=>'No data found'
,p_max_length=>4000
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(474715735145482106)
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'DTDC,CTDC'
,p_help_text=>'Enter text or HTML to be displayed when details query returns 0 rows.'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '66756E6374696F6E20707265746975735F726F775F64657461696C7328206F626A2C2066696C655F7072656669782C20706C7567696E4A534F4E2C2070446F6E74436F6C6C656374436F6C756D6E732029207B0D0A20207661720D0A2020202076616C75';
wwv_flow_api.g_varchar2_table(2) := '6573203D205B5D2C0D0A20202020636F6C756D6E73203D205B5D2C200D0A2020202064657369726564436F6C756D6E5370616E2C200D0A2020202064657369726564436F6C756D6E54642C200D0A2020202064657369726564436F6C756D6E203D207B7D';
wwv_flow_api.g_varchar2_table(3) := '2C200D0A20202020636F6C756D6E4172726179546F50757368203D205B5D2C200D0A202020207868722C20786872322C0D0A2020202074726967676572696E67456C656D656E74506172656E74203D2024286F626A2E74726967676572696E67456C656D';
wwv_flow_api.g_varchar2_table(4) := '656E74292E636C6F7365737428272E707265746975735F706C7567696E5F726F7727292C0D0A20202020706172656E745472203D202428206F626A2E74726967676572696E67456C656D656E7420292E6973282774722729203F202428206F626A2E7472';
wwv_flow_api.g_varchar2_table(5) := '6967676572696E67456C656D656E742029203A202428206F626A2E74726967676572696E67456C656D656E7420292E636C6F736573742827747227292C0D0A20202020706172656E745464203D202428206F626A2E74726967676572696E67456C656D65';
wwv_flow_api.g_varchar2_table(6) := '6E7420292E6973282774642729203F202428206F626A2E74726967676572696E67456C656D656E742029203A202428206F626A2E74726967676572696E67456C656D656E7420292E636C6F736573742827746427292C0D0A20202020726567696F6E203D';
wwv_flow_api.g_varchar2_table(7) := '206F626A2E6166666563746564456C656D656E74732C0D0A2020202063757272656E74457870616E646564526F77733B0D0A0D0A202020206F626A2E706C7567696E4A534F4E203D20706C7567696E4A534F4E3B0D0A0D0A20202020242E657874656E64';
wwv_flow_api.g_varchar2_table(8) := '286F626A2E706C7567696E4A534F4E2C207B0D0A20202020202027706172656E745472273A20706172656E7454722C0D0A20202020202027706172656E745464273A20706172656E7454642C0D0A20202020202027666F6C64696E6750726F70273A207B';
wwv_flow_api.g_varchar2_table(9) := '0D0A202020202020202027686569676874273A20302C0D0A20202020202020202770616464696E67546F70273A20302C0D0A20202020202020202770616464696E67426F74746F6D273A20302C0D0A2020202020202020276F706163697479273A20302E';
wwv_flow_api.g_varchar2_table(10) := '320D0A2020202020207D2C0D0A202020202020276361636865526573756C7473273A206F626A2E616374696F6E2E61747472696275746531302E696E6465784F66282743522729203E202D31207C7C206F626A2E616374696F6E2E617474726962757465';
wwv_flow_api.g_varchar2_table(11) := '30322E696E6465784F66282743522729203E202D31203F2074727565203A2066616C73652C0D0A0D0A202020202020276E6F44617461466F756E64273A206F626A2E616374696F6E2E61747472696275746531312C0D0A20202020202027616E696D6174';
wwv_flow_api.g_varchar2_table(12) := '696F6E4475726174696F6E273A203530302C0D0A20202020202027637573746F6D43616C6C6261636B273A207B0D0A2020202020202020276C6F6164696E67496E64696361746F72273A206F626A2E616374696F6E2E61747472696275746531302E696E';
wwv_flow_api.g_varchar2_table(13) := '6465784F6628274C492729203E202D31203F2074727565203A2066616C73652C0D0A2020202020202020276A617661736372697074273A206F626A2E616374696F6E2E61747472696275746530350D0A2020202020207D2C0D0A20202020202027646566';
wwv_flow_api.g_varchar2_table(14) := '61756C7443616C6C6261636B273A207B0D0A2020202020202020276D6178486569676874273A207061727365496E74286F626A2E616374696F6E2E6174747269627574653037292C0D0A202020202020202027626F72646572436F6C6F72273A206F626A';
wwv_flow_api.g_varchar2_table(15) := '2E616374696F6E2E61747472696275746530382C0D0A2020202020202020276261636B67726F756E64436F6C6F72273A206F626A2E616374696F6E2E61747472696275746530362C0D0A20202020202020202768696768746C696768744267436F6C6F72';
wwv_flow_api.g_varchar2_table(16) := '273A206F626A2E616374696F6E2E61747472696275746530392C0D0A2020202020202020276C6F6164696E67496E64696361746F72273A206F626A2E616374696F6E2E61747472696275746530322E696E6465784F6628274C492729203E202D31203F20';
wwv_flow_api.g_varchar2_table(17) := '74727565203A2066616C73652C0D0A20202020202020202769735365744D6178486569676874273A206F626A2E616374696F6E2E61747472696275746530322E696E6465784F66282027534D48272029203E202D31203F2074727565203A2066616C7365';
wwv_flow_api.g_varchar2_table(18) := '2C0D0A2020202020202020276973436F6C6C61707365457861706E646564273A206F626A2E616374696F6E2E61747472696275746530322E696E6465784F662820274345272029203E202D31203F2074727565203A2066616C73652C0D0A202020202020';
wwv_flow_api.g_varchar2_table(19) := '2020276973416464416E696D6174696F6E273A206F626A2E616374696F6E2E61747472696275746530322E696E6465784F662820274141272029203E202D31203F2074727565203A2066616C73650D0A0D0A2020202020207D2C0D0A2020202020202774';
wwv_flow_api.g_varchar2_table(20) := '7269676765724F626A656374273A207B0D0A202020202020202027747269676572696E67456C656D656E74273A206F626A2E74726967676572696E67456C656D656E742C0D0A20202020202020202761666665637465645265706F7274273A206F626A2E';
wwv_flow_api.g_varchar2_table(21) := '6166666563746564456C656D656E74732C0D0A202020202020202027706172656E745472273A20706172656E7454722C0D0A202020202020202027706172656E745464273A20706172656E7454640D0A2020202020207D2C0D0A20202020202027706C75';
wwv_flow_api.g_varchar2_table(22) := '67696E53657474696E6773273A207B0D0A2020202020202020276973437573746F6D43616C6C6261636B273A206F626A2E616374696F6E2E61747472696275746530332E696E6465784F66282743432729203E202D31203F2074727565203A2066616C73';
wwv_flow_api.g_varchar2_table(23) := '652C0D0A2020202020202020276973437573746F6D54656D706C617465273A206F626A2E616374696F6E2E61747472696275746530332E696E6465784F66282743542729203E202D31203F2074727565203A2066616C73652C0D0A202020202020202027';
wwv_flow_api.g_varchar2_table(24) := '697344656661756C7443616C6C6261636B273A206F626A2E616374696F6E2E61747472696275746530332E696E6465784F66282744432729203E202D31203F2074727565203A2066616C73652C0D0A202020202020202027697344656661756C7454656D';
wwv_flow_api.g_varchar2_table(25) := '706C617465273A206F626A2E616374696F6E2E61747472696275746530332E696E6465784F66282744542729203E202D31203F2074727565203A2066616C73650D0A2020202020207D2C0D0A20202020202027637573746F6D54656D706C617465273A20';
wwv_flow_api.g_varchar2_table(26) := '6F626A2E616374696F6E2E61747472696275746530340D0A0D0A202020207D293B0D0A0D0A202020202F2F636F6E736F6C652E6C6F67286F626A293B0D0A0D0A20206966202820706C7567696E4A534F4E2E636F6C756D6E734E6F744D61746368656420';
wwv_flow_api.g_varchar2_table(27) := '3E20302029207B0D0A2020202073686F77416C65727428206F626A20293B0D0A202020207468726F772027436F6C756D6E28732920696E20776865726520636C61757365206F66202244657461696C732071756572792220617474726962757465206861';
wwv_flow_api.g_varchar2_table(28) := '73206E6F74206265656E206D617463686564207769746820746172676574207265706F72742E273B0D0A2020202072657475726E20766F69642830293B0D0A20207D0D0A0D0A2020696620282074726967676572696E67456C656D656E74506172656E74';
wwv_flow_api.g_varchar2_table(29) := '2E73697A652829203E20302029207B0D0A202020202F2F64756E6E6F0D0A202020206F626A2E62726F777365724576656E742E73746F70496D6D65646961746550726F7061676174696F6E28293B0D0A202020206F626A2E62726F777365724576656E74';
wwv_flow_api.g_varchar2_table(30) := '2E70726576656E7444656661756C7428293B0D0A2020202072657475726E20766F69642830293B0D0A20207D0D0A0D0A2020696620282021242E636F6E7461696E73282024286F626A2E6166666563746564456C656D656E7473292E6765742830292C20';
wwv_flow_api.g_varchar2_table(31) := '6F626A2E74726967676572696E67456C656D656E74292029207B0D0A202020202F2F7768656E2074726967676572696E67456C656D656E7420697320696E20646966666572656E7420726567696F6E2C2062757420686173207468652073616D65207365';
wwv_flow_api.g_varchar2_table(32) := '6C6563746F720D0A20202020636F6E736F6C652E6C6F672831293B0D0A202020206F626A2E62726F777365724576656E742E73746F70496D6D65646961746550726F7061676174696F6E28293B0D0A202020206F626A2E62726F777365724576656E742E';
wwv_flow_api.g_varchar2_table(33) := '70726576656E7444656661756C7428293B202020200D0A2020202072657475726E20766F69642830293B0D0A20207D0D0A0D0A20202F2F6A65736C69206A657374206A757A206F7477617274790D0A2020696620282024286F626A2E7472696767657269';
wwv_flow_api.g_varchar2_table(34) := '6E67456C656D656E74292E69732820272E666F63757365642720292029207B0D0A202020202F2F676479206D612062796320616E696D61636A6120646C612064616E65676F20656C656D656E74750D0A2020202069662028206F626A2E706C7567696E4A';
wwv_flow_api.g_varchar2_table(35) := '534F4E2E64656661756C7443616C6C6261636B2E6973416464416E696D6174696F6E2029207B0D0A202020202020706172656E7454722E6E65787428292E66696E6428272E726F7744657461696C73436F6E7461696E657227292E616E696D617465280D';
wwv_flow_api.g_varchar2_table(36) := '0A20202020202020206F626A2E706C7567696E4A534F4E2E666F6C64696E6750726F702C200D0A20202020202020207B0D0A202020202020202020206475726174696F6E3A206F626A2E706C7567696E4A534F4E2E616E696D6174696F6E447572617469';
wwv_flow_api.g_varchar2_table(37) := '6F6E2C0D0A20202020202020202020636F6D706C6574653A2066756E6374696F6E28297B0D0A202020202020202020202020242874686973292E636C6F7365737428272E707265746975735F706C7567696E5F726F7727292E72656D6F766528293B200D';
wwv_flow_api.g_varchar2_table(38) := '0A20202020202020202020202072656D6F76655374796C6550726F706572747928706172656E7454722C20272E7374796C6550726F70657274794368616E6765642C202E74726967676572696E67456C656D656E7427293B2020202020200D0A20202020';
wwv_flow_api.g_varchar2_table(39) := '2020202020202020617065782E6576656E742E7472696767657228646F63756D656E742C2027726F77436F6C6C6170736564272C206F626A2E706C7567696E4A534F4E2E747269676765724F626A656374293B0D0A202020202020202020207D202F2F63';
wwv_flow_api.g_varchar2_table(40) := '6F6D706C6574650D0A20202020202020207D202F2F6F7074696F6E0D0A202020202020293B202F2F616E696D6174650D0A202020207D0D0A202020202F2F676479206E6965206D612062796320616E696D61636A6120646C612064616E65676F20656C65';
wwv_flow_api.g_varchar2_table(41) := '6D656E74750D0A20202020656C7365207B0D0A20202020202072656D6F76655374796C6550726F706572747928706172656E7454722C20272E7374796C6550726F70657274794368616E6765642C202E74726967676572696E67456C656D656E7427293B';
wwv_flow_api.g_varchar2_table(42) := '0D0A202020202020706172656E7454722E6E65787428272E707265746975735F706C7567696E5F726F7727292E72656D6F766528293B0D0A202020202020617065782E6576656E742E7472696767657228646F63756D656E742C2027726F77436F6C6C61';
wwv_flow_api.g_varchar2_table(43) := '70736564272C206F626A2E706C7567696E4A534F4E2E747269676765724F626A656374293B0D0A202020207D0D0A2020202072657475726E20766F69642830293B0D0A20207D202F2F6A65736C69206E6965206A657374206A65737A637A65206F747761';
wwv_flow_api.g_varchar2_table(44) := '7274790D0A2020656C7365207B0D0A202020202F2F74656E206D75736920627963206E6120706F637A61746B7520626F206E616A70696572772074727A656261207573756E6163206973746E69656A6163650D0A2020202069662028206F626A2E706C75';
wwv_flow_api.g_varchar2_table(45) := '67696E4A534F4E2E64656661756C7443616C6C6261636B2E6973436F6C6C61707365457861706E6465642029207B0D0A2020202020202F2F63757272656E74457870616E646564526F77732E72656D6F766528293B0D0A20202020202063757272656E74';
wwv_flow_api.g_varchar2_table(46) := '457870616E646564526F7773203D202428272E707265746975735F706C7567696E5F726F77272C20726567696F6E290D0A20202020202063757272656E74457870616E646564526F77732E656163682866756E6374696F6E28297B0D0A20202020202020';
wwv_flow_api.g_varchar2_table(47) := '207661720D0A2020202020202020202073656C66203D20242874686973292C0D0A2020202020202020202070726576203D2073656C662E7072657628293B0D0A20202020202020200D0A2020202020202020747269676765724F626A65637432203D207B';
wwv_flow_api.g_varchar2_table(48) := '0D0A20202020202020202020747269676572696E67456C656D656E743A20707265762E66696E6428272E74726967676572696E67456C656D656E7427292C0D0A2020202020202020202061666665637465645265706F72743A20726567696F6E2C0D0A20';
wwv_flow_api.g_varchar2_table(49) := '202020202020202020706172656E7454723A20707265762C0D0A20202020202020202020706172656E7454643A20707265762E66696E64282774642E666F637573656427290D0A20202020202020207D3B0D0A0D0A202020202020202069662028207365';
wwv_flow_api.g_varchar2_table(50) := '6C662E697328272E616E696D6174656427292029207B0D0A2020202020202020202072656D6F76655374796C6550726F706572747928707265762C20272E7374796C6550726F70657274794368616E6765642C202E74726967676572696E67456C656D65';
wwv_flow_api.g_varchar2_table(51) := '6E7427293B0D0A2020202020202020202073656C662E66696E6428272E726F7744657461696C73436F6E7461696E657227292E616E696D617465280D0A2020202020202020202020206F626A2E706C7567696E4A534F4E2E666F6C64696E6750726F702C';
wwv_flow_api.g_varchar2_table(52) := '200D0A2020202020202020202020207B0D0A20202020202020202020202020206475726174696F6E3A206F626A2E706C7567696E4A534F4E2E616E696D6174696F6E4475726174696F6E2C0D0A2020202020202020202020202020636F6D706C6574653A';
wwv_flow_api.g_varchar2_table(53) := '2066756E6374696F6E28297B0D0A20202020202020202020202020202020242874686973292E636C6F7365737428272E707265746975735F706C7567696E5F726F7727292E72656D6F766528293B200D0A202020202020202020202020202020200D0A20';
wwv_flow_api.g_varchar2_table(54) := '202020202020202020202020202020617065782E6576656E742E7472696767657228646F63756D656E742C2027726F77436F6C6C6170736564272C20747269676765724F626A65637432293B0D0A20202020202020202020202020207D202F2F636F6D70';
wwv_flow_api.g_varchar2_table(55) := '6C6574650D0A2020202020202020202020207D202F2F6F7074696F6E730D0A20202020202020202020293B202F2F616E696D6174650D0A20202020202020207D0D0A2020202020202020656C7365207B0D0A2020202020202020202073656C662E72656D';
wwv_flow_api.g_varchar2_table(56) := '6F766528293B0D0A20202020202020202020617065782E6576656E742E7472696767657228646F63756D656E742C2027726F77436F6C6C6170736564272C20747269676765724F626A65637432293B0D0A2020202020202020202072656D6F7665537479';
wwv_flow_api.g_varchar2_table(57) := '6C6550726F706572747928726567696F6E2C20272E7374796C6550726F70657274794368616E67656427293B0D0A20202020202020207D0D0A2020202020207D293B0D0A202020200D0A202020207D0D0A20202020656C7365207B0D0A2020202020202F';
wwv_flow_api.g_varchar2_table(58) := '2F777977616C2074796C6B6F206A757A206973746E69656A61637920656C656D656E7420646C612064616E65676F2077696572737A610D0A202020202020706172656E7454722E6E65787428272E707265746975735F706C7567696E5F726F7727292E72';
wwv_flow_api.g_varchar2_table(59) := '656D6F766528293B0D0A2020202020202F2F7370727761647A20637A7920772064616E796D2077696572737A75206973746E69656A65206A757A206B6C696B6E6965747920656C656D656E742069206A65736C692074616B20746F207573756E206D7520';
wwv_flow_api.g_varchar2_table(60) := '7374796C650D0A2020202020206966202820706172656E7454722E66696E64282774642E666F637573656427292E73697A652829203E20302029207B0D0A202020202020202072656D6F76655374796C6550726F706572747928706172656E7454722C20';
wwv_flow_api.g_varchar2_table(61) := '272E666F637573656427293B0D0A2020202020207D0D0A202020207D0D0A20207D0D0A0D0A0D0A0D0A0D0A202069662028202170446F6E74436F6C6C656374436F6C756D6E732029207B0D0A20202020666F722028766172206920696E20706C7567696E';
wwv_flow_api.g_varchar2_table(62) := '4A534F4E2E636F6C756D6E73546F517565727929207B0D0A20202020202064657369726564436F6C756D6E203D207B7D0D0A20202020202064657369726564436F6C756D6E5464203D20756E646566696E65643B0D0A2020202020206465736972656443';
wwv_flow_api.g_varchar2_table(63) := '6F6C756D6E5370616E203D20756E646566696E65643B0D0A20202020202064657369726564436F6C756D6E2E76616C7565203D20756E646566696E65643B0D0A0D0A2020202020206966202820706C7567696E4A534F4E2E726567696F6E54797065203D';
wwv_flow_api.g_varchar2_table(64) := '3D2022496E746572616374697665207265706F72742229207B0D0A202020202020202064657369726564436F6C756D6E2E6E616D65203D20706C7567696E4A534F4E2E636F6C756D6E73546F51756572795B695D2E676976656E5F636F6C756D6E3B2020';
wwv_flow_api.g_varchar2_table(65) := '0D0A2020202020207D0D0A202020202020656C7365207B0D0A202020202020202064657369726564436F6C756D6E2E6E616D65203D20706C7567696E4A534F4E2E636F6C756D6E73546F51756572795B695D2E74645F6865616465723B2020200D0A2020';
wwv_flow_api.g_varchar2_table(66) := '202020207D0D0A2020202020200D0A20202020202064657369726564436F6C756D6E5464203D20706172656E7454722E66696E6428275B686561646572733D272B20706C7567696E4A534F4E2E636F6C756D6E73546F51756572795B695D2E74645F6865';
wwv_flow_api.g_varchar2_table(67) := '61646572202B275D27292E666972737428293B0D0A0D0A202020202020696620282064657369726564436F6C756D6E54642E73697A652829203D3D20302029207B0D0A202020202020202064657369726564436F6C756D6E5370616E203D20706172656E';
wwv_flow_api.g_varchar2_table(68) := '7454722E66696E6428275B636C6173733D272B20706C7567696E4A534F4E2E636F6C756D6E73546F51756572795B695D2E74645F686561646572202B275D27292E666972737428293B0D0A0D0A2020202020202020696620282064657369726564436F6C';
wwv_flow_api.g_varchar2_table(69) := '756D6E5370616E2E73697A652829203D3D20302029207B0D0A2020202020202020202073686F77416C65727428206F626A20293B0D0A202020202020202020207468726F772022436F6C756D6E20222B64657369726564436F6C756D6E2E6E616D652B22';
wwv_flow_api.g_varchar2_table(70) := '206E6F7420666F756E6420696E207265706F72742120436F6C756D6E2073686F756C642062652070726573656E7420696E207265706F7274206F72203C7370616E20636C6173733D5C22222B64657369726564436F6C756D6E2E6E616D652B225C223E23';
wwv_flow_api.g_varchar2_table(71) := '222B64657369726564436F6C756D6E2E6E616D652B22233C2F7370616E3E2073686F756C6420626520616464656420696E204150455820636F6C756D6E2048544D4C206578706F72657373696F6E2E223B0D0A20202020202020207D0D0A202020202020';
wwv_flow_api.g_varchar2_table(72) := '202064657369726564436F6C756D6E2E76616C7565203D2064657369726564436F6C756D6E5370616E2E7465787428293B0D0A2020202020207D200D0A202020202020656C7365207B0D0A202020202020202064657369726564436F6C756D6E2E76616C';
wwv_flow_api.g_varchar2_table(73) := '7565203D2064657369726564436F6C756D6E54642E7465787428293B0D0A2020202020207D0D0A0D0A202020202020636F6C756D6E4172726179546F507573682E70757368282064657369726564436F6C756D6E20293B0D0A202020207D0D0A0D0A2020';
wwv_flow_api.g_varchar2_table(74) := '2020636F6C756D6E73203D206A51756572792E6D61702820636F6C756D6E4172726179546F507573682C2066756E6374696F6E28656C656D2C20696E646578297B2072657475726E20656C656D2E6E616D653B207D20292E6A6F696E28273A27293B0D0A';
wwv_flow_api.g_varchar2_table(75) := '2020202076616C75657320203D206A51756572792E6D61702820636F6C756D6E4172726179546F507573682C2066756E6374696F6E28656C656D2C20696E646578297B2072657475726E20656C656D2E76616C75653B207D20292E6A6F696E28273A2729';
wwv_flow_api.g_varchar2_table(76) := '3B0D0A20207D0D0A2020656C7365207B0D0A20202020636F6C756D6E73203D206E756C6C3B0D0A2020202076616C756573203D206E756C6C3B0D0A20207D0D0A0D0A20202F2F637A79206A657374207573746177696F6E792063616368650D0A20206966';
wwv_flow_api.g_varchar2_table(77) := '2028206F626A2E706C7567696E4A534F4E2E6361636865526573756C74732029207B0D0A20202020696620282024286F626A2E74726967676572696E67456C656D656E74292E64617461282768656164657273272920213D20756E646566696E65642029';
wwv_flow_api.g_varchar2_table(78) := '207B0D0A202020202020707265746975735F726F775F647261775F6461746128206F626A2C2024286F626A2E74726967676572696E67456C656D656E74292E6461746128276865616465727327292C2024286F626A2E74726967676572696E67456C656D';
wwv_flow_api.g_varchar2_table(79) := '656E74292E64617461282764617461272920290D0A202020207D0D0A20202020656C7365207B0D0A20202020202067657444617461414A415828206F626A2C20636F6C756D6E732C2076616C75657320293B202020200D0A202020207D0D0A20207D0D0A';
wwv_flow_api.g_varchar2_table(80) := '2020656C7365207B0D0A2020202069662028206F626A2E706C7567696E4A534F4E2E706C7567696E53657474696E67732E6973437573746F6D43616C6C6261636B2029207B0D0A202020202020696620282024286F626A2E74726967676572696E67456C';
wwv_flow_api.g_varchar2_table(81) := '656D656E74292E697328272E64657461696C7353686F776E27292029207B0D0A2020202020202020707265746975735F726F775F647261775F6461746128206F626A2C206E756C6C2C206E756C6C293B0D0A2020202020207D0D0A202020202020656C73';
wwv_flow_api.g_varchar2_table(82) := '65207B0D0A202020202020202067657444617461414A415828206F626A2C20636F6C756D6E732C2076616C75657320293B20200D0A2020202020207D0D0A202020207D0D0A20202020656C7365207B0D0A20202020202067657444617461414A41582820';
wwv_flow_api.g_varchar2_table(83) := '6F626A2C20636F6C756D6E732C2076616C75657320293B0D0A202020207D0D0A20207D0D0A7D202F2F707265746975735F726F775F64657461696C730D0A0D0A66756E6374696F6E20707265746975735F64656661756C745F74656D706C617465282070';
wwv_flow_api.g_varchar2_table(84) := '6C7567696E4F626A6563742C206D75737461636865436F6E74656E742C2069734E6F44617461466F756E642029207B0D0A2020766172200D0A20202020726567696F6E203D20706C7567696E4F626A6563742E6166666563746564456C656D656E74732C';
wwv_flow_api.g_varchar2_table(85) := '0D0A20202020706172656E745472203D20706C7567696E4F626A6563742E706C7567696E4A534F4E2E706172656E7454722C0D0A20202020706172656E745464203D20706C7567696E4F626A6563742E706C7567696E4A534F4E2E706172656E7454642C';
wwv_flow_api.g_varchar2_table(86) := '0D0A202020207464436F756E64203D20706172656E7454722E66696E642827746427292E73697A6528292C0D0A202020206E65775472203D202428273C747220636C6173733D22707265746975735F706C7567696E5F726F77223E3C2F74723E27292C0D';
wwv_flow_api.g_varchar2_table(87) := '0A202020206E657754725464203D202428273C74643E3C2F74643E27292C0D0A202020206E657754725464436C617373203D20706C7567696E4F626A6563742E706C7567696E4A534F4E2E726567696F6E54797065203D3D2027436C6173736963207265';
wwv_flow_api.g_varchar2_table(88) := '706F727427203F2027742D5265706F72742D63656C6C27203A2027752D7452272C0D0A202020206E657754725464446976203D206E657754722E66696E64282764697627292C0D0A20202020636F6E7461696E696E674469762C0D0A20202020616E696D';
wwv_flow_api.g_varchar2_table(89) := '61746564436C6173732C0D0A202020206E6F44617461466F756E64436F6E7461696E6572203D20273C64697620636C6173733D22726F7744657461696C73436F6E7461696E6572223E3C64697620636C6173733D226E6F44617461466F756E64223E272B';
wwv_flow_api.g_varchar2_table(90) := '706C7567696E4F626A6563742E706C7567696E4A534F4E2E6E6F44617461466F756E642B273C2F6469763E3C2F6469763E272C0D0A20202020747269676765724F626A656374203D20706C7567696E4F626A6563742E706C7567696E4A534F4E2E747269';
wwv_flow_api.g_varchar2_table(91) := '676765724F626A6563743B0D0A0D0A0D0A2020696E6C696E65486967686C696768744373732820726567696F6E2E617474722827696427292C20706C7567696E4F626A6563742E706C7567696E4A534F4E2E64656661756C7443616C6C6261636B20293B';
wwv_flow_api.g_varchar2_table(92) := '0D0A0D0A0D0A0D0A20202F2F646F64616A65206B6C617365207A676F646E61207A20726567696F6E2077206B746F72796D206265647A696520646F646177616E79207472207A2074640D0A2020616E696D61746564436C617373203D20706C7567696E4F';
wwv_flow_api.g_varchar2_table(93) := '626A6563742E706C7567696E4A534F4E2E64656661756C7443616C6C6261636B2E6973416464416E696D6174696F6E203F2027616E696D6174656427203A2027273B0D0A0D0A20206E657754722E616464436C6173732820616E696D61746564436C6173';
wwv_flow_api.g_varchar2_table(94) := '7320293B0D0A20206E6577547254642E616464436C61737328206E657754725464436C61737320292E617474722827636F6C7370616E272C207464436F756E64292E637373287B0D0A20202020276D61785769647468273A20706172656E7454722E6F75';
wwv_flow_api.g_varchar2_table(95) := '746572576964746828292D32302C0D0A20202020276261636B67726F756E64436F6C6F72273A20706C7567696E4F626A6563742E706C7567696E4A534F4E2E64656661756C7443616C6C6261636B2E6261636B67726F756E64436F6C6F722C0D0A202020';
wwv_flow_api.g_varchar2_table(96) := '2027626F72646572436F6C6F72273A20706C7567696E4F626A6563742E706C7567696E4A534F4E2E64656661756C7443616C6C6261636B2E626F72646572436F6C6F720D0A20207D292E617070656E64282069734E6F44617461466F756E64203F206E6F';
wwv_flow_api.g_varchar2_table(97) := '44617461466F756E64436F6E7461696E6572203A206D75737461636865436F6E74656E7420292E686F7665722866756E6374696F6E28297B20706172656E7454722E616464436C6173732827686F766572656427293B207D2C2066756E6374696F6E2829';
wwv_flow_api.g_varchar2_table(98) := '7B20706172656E7454722E72656D6F7665436C6173732827686F766572656427293B207D293B0D0A20200D0A20200D0A20206E657754722E617070656E6428206E65775472546420293B0D0A0D0A20206966202820706172656E7454722E6E6578742829';
wwv_flow_api.g_varchar2_table(99) := '2E697328272E707265746975735F706C7567696E5F726F772027292029207B0D0A202020206E65775472203D206E657754722E696E7365727441667465722820706172656E7454722E6E657874282920293B20200D0A20207D0D0A2020656C7365207B0D';
wwv_flow_api.g_varchar2_table(100) := '0A202020206E65775472203D206E657754722E696E7365727441667465722820706172656E74547220293B20200D0A20207D0D0A20200D0A0D0A2020636F6E7461696E696E67446976203D206E657754722E66696E6428276469762E726F774465746169';
wwv_flow_api.g_varchar2_table(101) := '6C73436F6E7461696E657227293B0D0A0D0A20206966202820706C7567696E4F626A6563742E706C7567696E4A534F4E2E64656661756C7443616C6C6261636B2E69735365744D61784865696768742029207B0D0A20202020636F6E7461696E696E6744';
wwv_flow_api.g_varchar2_table(102) := '69762E66696E6428272E6F766572666C6F7727292E637373287B0D0A2020202020206D61784865696768743A20706C7567696E4F626A6563742E706C7567696E4A534F4E2E64656661756C7443616C6C6261636B2E6D61784865696768740D0A20202020';
wwv_flow_api.g_varchar2_table(103) := '7D293B0D0A20207D0D0A0D0A20202F2F446F64616A6520616E696D61636A652077207472616B63696520646F646177616E69610D0A20206966202820706C7567696E4F626A6563742E706C7567696E4A534F4E2E64656661756C7443616C6C6261636B2E';
wwv_flow_api.g_varchar2_table(104) := '6973416464416E696D6174696F6E2029207B0D0A20202020636F6E7461696E696E674469762E6373732827646973706C6179272C20276E6F6E6527292E736C696465446F776E280D0A202020202020706C7567696E4F626A6563742E706C7567696E4A53';
wwv_flow_api.g_varchar2_table(105) := '4F4E2E616E696D6174696F6E4475726174696F6E2C200D0A20202020202066756E6374696F6E28297B200D0A2020202020202020242874686973292E616464436C6173732827657870616E64656427293B0D0A20202020202020202F2F747574616A2077';
wwv_flow_api.g_varchar2_table(106) := '79776F6C616A20747269676765720D0A2020202020202020617065782E6576656E742E7472696767657228646F63756D656E742C2027726F77457870616E646564272C20706C7567696E4F626A6563742E706C7567696E4A534F4E2E747269676765724F';
wwv_flow_api.g_varchar2_table(107) := '626A656374293B0D0A2020202020207D202F2F636F6D706C6574650D0A20202020293B202F2F736C696465446F776E0D0A20207D0D0A2020656C7365207B0D0A20202020636F6E7461696E696E674469762E616464436C6173732827657870616E646564';
wwv_flow_api.g_varchar2_table(108) := '27293B0D0A20202020617065782E6576656E742E7472696767657228646F63756D656E742C2027726F77457870616E646564272C20706C7567696E4F626A6563742E706C7567696E4A534F4E2E747269676765724F626A656374293B0D0A202020202F2F';
wwv_flow_api.g_varchar2_table(109) := '747574616A207779776F6C616A20747269676765720D0A20207D0D0A0D0A20206166666563746564526F77536574436C61737365732820706C7567696E4F626A65637420293B0D0A7D202F2F707265746975735F64656661756C745F74656D706C617465';
wwv_flow_api.g_varchar2_table(110) := '0D0A0D0A66756E6374696F6E2073686F77416C6572742820706C7567696E4F626A6563742029207B0D0A2020766172200D0A20202020726567696F6E4964203D20706C7567696E4F626A6563742E6166666563746564456C656D656E74732E6174747228';
wwv_flow_api.g_varchar2_table(111) := '27696427292C0D0A20202020626F647957726170203D2024282723272B726567696F6E4964292E66696E6428272E742D5265706F72742D7461626C655772617027292C0D0A20202020616C657274203D202428273C64697620636C6173733D22616C6572';
wwv_flow_api.g_varchar2_table(112) := '74506C7567696E22207374796C653D22746F703A20272B2828626F6479577261702E6F757465724865696768742829202D20363029202F2032292B2770783B6C6566743A20272B28626F6479577261702E6F7574657257696474682829202D2036302920';
wwv_flow_api.g_varchar2_table(113) := '2F20322B27707822203E3C7370616E20636C6173733D2266612066612D6578636C616D6174696F6E2D747269616E676C65223E3C2F7370616E3E3C2F6469763E27290D0A0D0A20206966202820706C7567696E4F626A6563742E7370696E6E657220213D';
wwv_flow_api.g_varchar2_table(114) := '20756E646566696E65642029207B0D0A20202020706C7567696E4F626A6563742E7370696E6E65722E72656D6F766528293B0D0A20207D0D0A20200D0A202072657475726E20616C6572742E696E7365727441667465722820626F64795772617020292E';
wwv_flow_api.g_varchar2_table(115) := '666164654F757428203530302C2066756E6374696F6E28297B20242874686973292E72656D6F76652829207D20293B0D0A7D0D0A0D0A66756E6374696F6E20696E6C696E65486967686C6967687443737328726567696F6E49642C2064656661756C7443';
wwv_flow_api.g_varchar2_table(116) := '616C6C6261636B297B0D0A2020766172207374796C654964203D2027726567696F6E5374796C65735F272B726567696F6E49643B0D0A20200D0A202024282723272B7374796C654964292E72656D6F766528293B0D0A0D0A0D0A2020766172207374796C';
wwv_flow_api.g_varchar2_table(117) := '65203D20273C7374796C652069643D22272B7374796C6549642B27223E272B0D0A202020202723272B726567696F6E49642B272074722E707265746975735F706C7567696E5F726F773A686F766572203E2074642C272B0D0A202020202723272B726567';
wwv_flow_api.g_varchar2_table(118) := '696F6E49642B272074722E707265746975735F706C7567696E5F726F772E686F7665726564203E207464207B272B0D0A202020202020276261636B67726F756E642D636F6C6F723A20272B64656661756C7443616C6C6261636B2E68696768746C696768';
wwv_flow_api.g_varchar2_table(119) := '744267436F6C6F722B272021696D706F7274616E743B272B0D0A20202020277D272B0D0A202020202723272B726567696F6E49642B272074722E666F63757365642E666F63757365644F6E54643A686F766572203E2074642E74726967676572696E6745';
wwv_flow_api.g_varchar2_table(120) := '6C656D656E743A686F7665722C272B0D0A202020202F2F67647920706F6473776965746C6F6E792077696572737A20737A637A65676F6C6F7720746F20706F6473776965746C69205444207720737A637A65676F6C6163682020202020200D0A20202020';
wwv_flow_api.g_varchar2_table(121) := '2F2F676479206F727967696E616C6E792077696572737A20706F6473776965746C6F6E7920746F20706F6473776965746C69205444206B746F72792062796C207472693D6967676572656D0D0A202020202F2F2723272B726567696F6E49642B27207472';
wwv_flow_api.g_varchar2_table(122) := '2E666F63757365642E666F63757365644F6E436C6173733A686F766572203E2074642E666F63757365642C272B0D0A202020202723272B726567696F6E49642B272074722E666F63757365642E666F63757365644F6E436C6173732E686F766572656420';
wwv_flow_api.g_varchar2_table(123) := '3E2074642E666F63757365642C272B0D0A202020202F2F676479206F727967696E616C6E792077696572737A20706F6473776965746C6F6E7920746F20706F6473776965746C692077737A7973746B696520544420626F205452206A6573742074726967';
wwv_flow_api.g_varchar2_table(124) := '676572656D0D0A202020202723272B726567696F6E49642B272074722E666F63757365642E74726967676572696E67456C656D656E743A686F766572203E2074642C272B0D0A202020202723272B726567696F6E49642B272074722E666F63757365642E';
wwv_flow_api.g_varchar2_table(125) := '74726967676572696E67456C656D656E742E686F7665726564203E2074642C272B0D0A202020202F2F676479206E616A656368616E792077696572737A2054522C206B746F7279206A65737420726F7A77696E696574790D0A202020202723272B726567';
wwv_flow_api.g_varchar2_table(126) := '696F6E49642B272074722E666F63757365642E666F63757365644F6E54642E686F7665726564203E2074642E666F6375736564207B272B0D0A202020202F2F2723272B726567696F6E49642B272074722E666F63757365642E666F63757365644F6E5464';
wwv_flow_api.g_varchar2_table(127) := '3A686F766572203E2074642E666F6375736564207B272B0D0A202020202020276261636B67726F756E642D636F6C6F723A20272B64656661756C7443616C6C6261636B2E68696768746C696768744267436F6C6F722B272021696D706F7274616E743B27';
wwv_flow_api.g_varchar2_table(128) := '2B0D0A20202020202027626F726465722D626F74746F6D2D636F6C6F723A20272B64656661756C7443616C6C6261636B2E68696768746C696768744267436F6C6F722B272021696D706F7274616E743B272B0D0A20202020277D272B0D0A202020202F2F';
wwv_flow_api.g_varchar2_table(129) := '66697820646C6120666F6375736564206F6E20636C6173730D0A202020202723272B726567696F6E49642B272074722E666F63757365642E666F63757365644F6E54643A686F766572203E2074642E74726967676572696E67456C656D656E743A686F76';
wwv_flow_api.g_varchar2_table(130) := '6572202C272B0D0A202020202723272B726567696F6E49642B272074722E666F63757365642E666F63757365644F6E436C6173733A686F766572203E2074642E666F63757365643A686F766572207B272B0D0A202020202020276261636B67726F756E64';
wwv_flow_api.g_varchar2_table(131) := '2D636F6C6F723A20272B64656661756C7443616C6C6261636B2E68696768746C696768744267436F6C6F722B272021696D706F7274616E743B272B0D0A20202020202027626F726465722D626F74746F6D2D636F6C6F723A20272B64656661756C744361';
wwv_flow_api.g_varchar2_table(132) := '6C6C6261636B2E68696768746C696768744267436F6C6F722B272021696D706F7274616E743B272B0D0A20202020277D272B0D0A202020202F2F0D0A202020202723272B726567696F6E49642B272074722E666F63757365642E666F63757365644F6E54';
wwv_flow_api.g_varchar2_table(133) := '643A686F766572203E2074642E74726967676572696E67456C656D656E74202C272B0D0A202020202723272B726567696F6E49642B272074722E666F63757365642E666F63757365644F6E436C6173733A686F766572203E2074642E666F637573656420';
wwv_flow_api.g_varchar2_table(134) := '7B272B0D0A202020202020276261636B67726F756E642D636F6C6F723A20272B64656661756C7443616C6C6261636B2E68696768746C696768744267436F6C6F722B272021696D706F7274616E743B272B0D0A20202020202027626F726465722D626F74';
wwv_flow_api.g_varchar2_table(135) := '746F6D2D636F6C6F723A20272B64656661756C7443616C6C6261636B2E68696768746C696768744267436F6C6F722B272021696D706F7274616E743B272B0D0A20202020277D272B0D0A200D0A2020273C2F7374796C653E273B0D0A0D0A202024282762';
wwv_flow_api.g_varchar2_table(136) := '6F647927292E617070656E6428207374796C6520293B0D0A7D202F2F696E6C696E65486967686C696768744373730D0A0D0A66756E6374696F6E20736574426F72646572436F6C6F722820636F6E746578742C20656C656D53656C6563746F722C20636F';
wwv_flow_api.g_varchar2_table(137) := '6C6F722029207B0D0A202076617220656C656D203D20636F6E746578742E66696E642820656C656D53656C6563746F7220293B0D0A2020656C656D2E6373732827626F726465722D636F6C6F72272C20636F6C6F72293B0D0A2020656C656D2E61646443';
wwv_flow_api.g_varchar2_table(138) := '6C61737328277374796C6550726F70657274794368616E67656427293B0D0A7D202F2F736574426F72646572436F6C6F720D0A0D0A66756E6374696F6E20736574426F7264657273436F6C6F722820636F6E746578742C20656C656D53656C6563746F72';
wwv_flow_api.g_varchar2_table(139) := '2C20626F72646572732C20626F72646572436F6C6F722C206267436F6C6F722029207B0D0A2020766172200D0A20202020616C6C426F7264657273203D205B27746F70272C20276C656674272C20277269676874272C2027626F74746F6D275D2C0D0A20';
wwv_flow_api.g_varchar2_table(140) := '202020656C656D203D20636F6E746578742E66696E642820656C656D53656C6563746F7220292C0D0A20202020626F7264657273203D20626F72646572732E73706C697428272027292C0D0A2020202072656D61696E696E67426F7264657273203D2024';
wwv_flow_api.g_varchar2_table(141) := '2E6772657028616C6C426F72646572732C2066756E6374696F6E28656C29207B2072657475726E20242E696E41727261792820656C2C20626F72646572732029203D3D202D313B207D293B0D0A20200D0A2020666F7220287661722069203D20303B2069';
wwv_flow_api.g_varchar2_table(142) := '203C20626F72646572732E6C656E6774683B20692B2B29207B0D0A20202020656C656D2E6373732827626F726465722D272B626F72646572735B695D2B272D636F6C6F72272C20626F72646572436F6C6F72293B0D0A20202020656C656D2E6373732827';
wwv_flow_api.g_varchar2_table(143) := '626F726465722D272B626F72646572735B695D2B272D7374796C65272C2027736F6C696427293B0D0A20202020656C656D2E6373732827626F726465722D272B626F72646572735B695D2B272D7769647468272C202731707827293B0D0A20207D0D0A0D';
wwv_flow_api.g_varchar2_table(144) := '0A202069662028206267436F6C6F7220213D206E756C6C2029207B0D0A20202020666F7220287661722069203D20303B2069203C2072656D61696E696E67426F72646572732E6C656E6774683B20692B2B29207B0D0A202020202020656C656D2E637373';
wwv_flow_api.g_varchar2_table(145) := '2827626F726465722D272B72656D61696E696E67426F72646572735B695D2B272D636F6C6F72272C206267436F6C6F72293B0D0A202020202020656C656D2E6373732827626F726465722D272B72656D61696E696E67426F72646572735B695D2B272D73';
wwv_flow_api.g_varchar2_table(146) := '74796C65272C2027736F6C696427293B0D0A202020202020656C656D2E6373732827626F726465722D272B72656D61696E696E67426F72646572735B695D2B272D7769647468272C202731707827293B0D0A202020207D0D0A20207D0D0A0D0A2020656C';
wwv_flow_api.g_varchar2_table(147) := '656D2E616464436C61737328277374796C6550726F70657274794368616E67656427293B0D0A7D202F2F736574426F7264657273436F6C6F720D0A0D0A66756E6374696F6E2072656D6F76655374796C6550726F70657274792820636F6E746578742C20';
wwv_flow_api.g_varchar2_table(148) := '73656C6563746F7220297B0D0A2020766172200D0A20202020656C656D203D20636F6E746578742E66696E64282073656C6563746F7220292C0D0A20202020616C6C426F7264657273203D205B27746F70272C20276C656674272C20277269676874272C';
wwv_flow_api.g_varchar2_table(149) := '2027626F74746F6D275D3B0D0A0D0A2020656C656D2E63737328276261636B67726F756E642D636F6C6F72272C202727292E72656D6F7665436C6173732827666F63757365642074726967676572696E67456C656D656E74207374796C6550726F706572';
wwv_flow_api.g_varchar2_table(150) := '74794368616E6765642027293B0D0A0D0A2020666F7220287661722069203D20303B2069203C20616C6C426F72646572732E6C656E6774683B20692B2B29207B0D0A20202020656C656D2E6373732827626F726465722D272B616C6C426F72646572735B';
wwv_flow_api.g_varchar2_table(151) := '695D2B272D636F6C6F72272C202727293B0D0A20202020656C656D2E6373732827626F726465722D272B616C6C426F72646572735B695D2B272D7374796C65272C202727293B0D0A20202020656C656D2E6373732827626F726465722D272B616C6C426F';
wwv_flow_api.g_varchar2_table(152) := '72646572735B695D2B272D7769647468272C202727293B0D0A20207D0D0A0D0A2020656C656D2E636C6F736573742827747227292E72656D6F7665436C6173732827666F637573656420666F63757365644F6E546420666F63757365644F6E436C617373';
wwv_flow_api.g_varchar2_table(153) := '2074726967676572696E67456C656D656E7427293B20200D0A2020656C656D2E756E62696E6428276D6F757365656E746572206D6F7573656C6561766527293B0D0A7D202F2F72656D6F76655374796C6550726F70657274790D0A0D0A0D0A66756E6374';
wwv_flow_api.g_varchar2_table(154) := '696F6E207265706C61636551756F74652820737472696E672029207B0D0A202072657475726E20737472696E672E7265706C616365282F2671756F743B2F672C272227293B0D0A7D0D0A0D0A0D0A66756E6374696F6E20707265746975735F6D75737461';
wwv_flow_api.g_varchar2_table(155) := '6368655F64656661756C742820646174614F626A6563742029207B0D0A20202F2A0D0A202066756E6374696F6E207265706C616365436861726163746572732820696E70757420297B0D0A2020202076617220636861724C697374203D205B2223222C20';
wwv_flow_api.g_varchar2_table(156) := '225C2E225D3B0D0A0D0A20202020666F72202876617220693D303B2069203C20636861724C6973742E6C656E6774683B20692B2B29207B0D0A202020202020696E707574203D20696E7075742E7265706C616365282F2F290D0A202020207D0D0A0D0A20';
wwv_flow_api.g_varchar2_table(157) := '20202072657475726E20696E7075742E7265706C616365282F2F67290D0A20207D0D0A2A2F0D0A2020766172200D0A2020202074685F726F775F74656D706C617465203D2027272C0D0A2020202074645F726F775F74656D706C617465203D2027272C0D';
wwv_flow_api.g_varchar2_table(158) := '0A202020207461626C655F626F64793B0D0A0D0A2020666F722028207661722069203D20303B2069203C20646174614F626A6563742E686561646572732E6C656E6774683B20692B2B2029207B0D0A2020202074685F726F775F74656D706C617465202B';
wwv_flow_api.g_varchar2_table(159) := '3D20273C746820636C6173733D22742D5265706F72742D636F6C4865616420272B646174614F626A6563742E686561646572735B695D2E434F4C554D4E5F545950452B27223E272B20646174614F626A6563742E686561646572735B695D2E434F4C554D';
wwv_flow_api.g_varchar2_table(160) := '4E5F4E414D45202B273C2F74683E273B0D0A2020202074645F726F775F74656D706C617465202B3D20273C746420636C6173733D22742D5265706F72742D63656C6C20272B646174614F626A6563742E686561646572735B695D2E434F4C554D4E5F5459';
wwv_flow_api.g_varchar2_table(161) := '50452B27223E7B7B272B20646174614F626A6563742E686561646572735B695D2E434F4C554D4E5F4E414D45202B277D7D3C2F74643E273B0D0A20207D0D0A0D0A202074685F726F775F74656D706C617465203D20273C74723E272B74685F726F775F74';
wwv_flow_api.g_varchar2_table(162) := '656D706C6174652B273C2F74723E273B0D0A202074645F726F775F74656D706C617465203D20277B7B23646174617D7D3C74723E272B74645F726F775F74656D706C6174652B273C2F74723E7B7B2F646174617D7D270D0A0D0A20207461626C655F626F';
wwv_flow_api.g_varchar2_table(163) := '6479203D204D757374616368652E72656E6465722874645F726F775F74656D706C6174652C20646174614F626A656374293B0D0A20200D0A202072657475726E20273C64697620636C6173733D22726F7744657461696C73436F6E7461696E6572223E27';
wwv_flow_api.g_varchar2_table(164) := '2B0D0A202020202020273C64697620636C6173733D226F766572666C6F77223E27202B0D0A2020202020202020273C7461626C6520636C6173733D22742D5265706F72742D7265706F7274223E3C74686561643E272B74685F726F775F74656D706C6174';
wwv_flow_api.g_varchar2_table(165) := '652B273C2F74686561643E3C74626F64793E272B207461626C655F626F6479202B273C2F74626F64793E3C2F7461626C653E272B0D0A202020202020273C2F6469763E27202B0D0A20202020273C2F6469763E273B0D0A7D202F2F707265746975735F6D';
wwv_flow_api.g_varchar2_table(166) := '757374616368655F64656661756C740D0A0D0A0D0A0D0A66756E6374696F6E20616464486F766572282070456C656D2C2070506172656E7454722029207B0D0A202070456C656D2E686F7665722866756E6374696F6E28297B0D0A202020207050617265';
wwv_flow_api.g_varchar2_table(167) := '6E7454722E6E65787428272E707265746975735F706C7567696E5F726F7727292E616464436C6173732827686F766572656427293B0D0A20207D2C2066756E6374696F6E28297B0D0A2020202070506172656E7454722E6E65787428272E707265746975';
wwv_flow_api.g_varchar2_table(168) := '735F706C7567696E5F726F7727292E72656D6F7665436C6173732827686F766572656427293B0D0A20207D290D0A7D202F2F616464486F7665720D0A0D0A66756E6374696F6E206166666563746564526F77536574436C61737365732820706C7567696E';
wwv_flow_api.g_varchar2_table(169) := '4F626A6563742029207B0D0A202070506172656E745464203D20706C7567696E4F626A6563742E706C7567696E4A534F4E2E706172656E7454643B0D0A202070506172656E745472203D20706C7567696E4F626A6563742E706C7567696E4A534F4E2E70';
wwv_flow_api.g_varchar2_table(170) := '6172656E7454723B0D0A20207054726967676572696E67456C656D656E74203D20706C7567696E4F626A6563742E74726967676572696E67456C656D656E743B0D0A202064656661756C7443616C6C6261636B203D20706C7567696E4F626A6563742E70';
wwv_flow_api.g_varchar2_table(171) := '6C7567696E4A534F4E2E64656661756C7443616C6C6261636B3B0D0A0D0A202070506172656E7454642E63737328276261636B67726F756E64436F6C6F72272C2064656661756C7443616C6C6261636B2E6261636B67726F756E64436F6C6F72293B0D0A';
wwv_flow_api.g_varchar2_table(172) := '20202F2F2D2D2D2D2D2D2D2D2D2D2D2D2D54520D0A2020696620282024287054726967676572696E67456C656D656E74292E69732827747227292029207B0D0A2020202070506172656E7454722E616464436C6173732827666F63757365642074726967';
wwv_flow_api.g_varchar2_table(173) := '676572696E67456C656D656E7427293B0D0A2020202070506172656E7454642E616464436C6173732827666F637573656427292E63737328276261636B67726F756E64436F6C6F72272C2064656661756C7443616C6C6261636B2E6261636B67726F756E';
wwv_flow_api.g_varchar2_table(174) := '64436F6C6F72293B0D0A20202020736574426F72646572436F6C6F72282070506172656E7454722C20277464272C2064656661756C7443616C6C6261636B2E626F72646572436F6C6F7220293B0D0A20202020616464486F7665722870506172656E7454';
wwv_flow_api.g_varchar2_table(175) := '722C2070506172656E745472293B0D0A20207D0D0A20202F2F2D2D2D2D2D2D2D2D2D2D2D2D2D54440D0A2020656C736520696620282024287054726967676572696E67456C656D656E74292E69732827746427292029207B0D0A2020202070506172656E';
wwv_flow_api.g_varchar2_table(176) := '7454642E616464436C6173732827666F63757365642074726967676572696E67456C656D656E7427293B0D0A2020202070506172656E7454722E616464436C6173732827666F637573656420666F63757365644F6E546427293B0D0A2020202073657442';
wwv_flow_api.g_varchar2_table(177) := '6F7264657273436F6C6F722870506172656E7454722C20277464272C2027626F74746F6D272C2064656661756C7443616C6C6261636B2E626F72646572436F6C6F72293B0D0A20202020736574426F7264657273436F6C6F722870506172656E7454722C';
wwv_flow_api.g_varchar2_table(178) := '202774642E666F63757365642E74726967676572696E67456C656D656E74272C2027746F70206C656674207269676874272C2064656661756C7443616C6C6261636B2E626F72646572436F6C6F722C2064656661756C7443616C6C6261636B2E6261636B';
wwv_flow_api.g_varchar2_table(179) := '67726F756E64436F6C6F72293B0D0A20202020616464486F7665722870506172656E7454642C2070506172656E745472293B0D0A20207D0D0A20202F2F2D2D2D2D2D2D2D2D2D2D2D2D2D435553544F4D20436C6173730D0A2020656C7365207B0D0A2020';
wwv_flow_api.g_varchar2_table(180) := '202024287054726967676572696E67456C656D656E74292E616464436C6173732827666F63757365642074726967676572696E67456C656D656E7427293B0D0A2020202070506172656E7454642E616464436C6173732827666F637573656427293B0D0A';
wwv_flow_api.g_varchar2_table(181) := '2020202070506172656E7454722E616464436C6173732827666F637573656420666F63757365644F6E436C61737327293B0D0A20202020736574426F7264657273436F6C6F722870506172656E7454722C20277464272C2027626F74746F6D272C206465';
wwv_flow_api.g_varchar2_table(182) := '6661756C7443616C6C6261636B2E626F72646572436F6C6F72293B0D0A20202020736574426F7264657273436F6C6F722870506172656E7454722C202774642E666F6375736564272C2027746F70206C656674207269676874272C2064656661756C7443';
wwv_flow_api.g_varchar2_table(183) := '616C6C6261636B2E626F72646572436F6C6F722C2064656661756C7443616C6C6261636B2E6261636B67726F756E64436F6C6F72293B0D0A20202020616464486F7665722870506172656E7454642C2070506172656E745472293B0D0A20207D20200D0A';
wwv_flow_api.g_varchar2_table(184) := '7D202F2F6166666563746564526F77536574436C61737365730D0A0D0A0D0A66756E6374696F6E20707265746975735F6D757374616368655F637573746F6D2820646174612C2074656D706C6174652029207B0D0A202072657475726E204D7573746163';
wwv_flow_api.g_varchar2_table(185) := '68652E72656E646572282074656D706C6174652C2064617461293B0D0A7D202F2F707265746975735F6D757374616368655F637573746F6D0D0A0D0A0D0A0D0A66756E6374696F6E20707265746975735F637573746F6D5F63616C6C6261636B2820706C';
wwv_flow_api.g_varchar2_table(186) := '7567696E4F626A6563742C20636F6E74656E742C2070446174614F626A6563742029207B0D0A202076617220637573746F6D43616C6C6261636B46756E63203D2022222B0D0A20202020222866756E6374696F6E282074656D706C617465436F6E74656E';
wwv_flow_api.g_varchar2_table(187) := '742C20706C7567696E4F626A6563742C20646174614F626A65637420297B20222B200D0A20202020202027746869732E63616C6C6261636B203D207B27202B0D0A20202020202027202073716C526573756C744F626A3A20646174614F626A6563742C27';
wwv_flow_api.g_varchar2_table(188) := '202B0D0A20202020202027202074726967676572696E67456C656D656E743A202428706C7567696E4F626A6563742E74726967676572696E67456C656D656E74292C27202B0D0A20202020202027202061666661637465645265706F72743A202428706C';
wwv_flow_api.g_varchar2_table(189) := '7567696E4F626A6563742E6166666563746564456C656D656E74735B305D292C27202B0D0A20202020202027202072656E646572656454656D706C6174653A2074656D706C617465436F6E74656E742C27202B0D0A20202020202027202062726F777365';
wwv_flow_api.g_varchar2_table(190) := '724576656E743A20706C7567696E4F626A6563742E62726F777365724576656E7427202B0D0A202020202020277D3B27202B0D0A2020202020202020706C7567696E4F626A6563742E706C7567696E4A534F4E2E637573746F6D43616C6C6261636B2E6A';
wwv_flow_api.g_varchar2_table(191) := '617661736372697074202B0D0A2020202022207D29202820636F6E74656E742C20706C7567696E4F626A6563742C2070446174614F626A6563742029223B0D0A2020747279207B0D0A202020206576616C2820637573746F6D43616C6C6261636B46756E';
wwv_flow_api.g_varchar2_table(192) := '6320293B20200D0A20207D20636174636828206572726F722029207B0D0A2020202073686F77416C6572742820706C7567696E4F626A65637420293B0D0A202020207468726F7720275768696C6520706572666F726D696E6720637573746F6D2063616C';
wwv_flow_api.g_varchar2_table(193) := '6C6261636B206572726F72206F63637572656420696E204A533A20272B6572726F723B0D0A20207D0D0A20200D0A7D202F2F707265746975735F637573746F6D5F63616C6C6261636B0D0A0D0A66756E6374696F6E20707265746975735F726F775F6472';
wwv_flow_api.g_varchar2_table(194) := '61775F646174612820706C7567696E4F626A6563742C20726573756C74486561646572732C20726573756C744461746120297B0D0A2020766172200D0A20202020646174614F626A6563742C0D0A20202020636F6E74656E743B0D0A0D0A202064617461';
wwv_flow_api.g_varchar2_table(195) := '4F626A656374203D207B0D0A202020202768656164657273273A20726573756C74486561646572732C0D0A202020202764617461273A20726573756C74446174610D0A20207D3B0D0A0D0A20202F2F67656E65726174652074656D706C6174650D0A2020';
wwv_flow_api.g_varchar2_table(196) := '2F2F6966202820242E696E41727261792820706C7567696E4F626A6563742E706C7567696E4A534F4E2E706C7567696E53657474696E67732C205B2743544443272C202743544343275D2029203E202D312029207B0D0A20206966202820706C7567696E';
wwv_flow_api.g_varchar2_table(197) := '4F626A6563742E706C7567696E4A534F4E2E706C7567696E53657474696E67732E6973437573746F6D54656D706C6174652029207B0D0A20202020636F6E74656E74203D20707265746975735F6D757374616368655F637573746F6D2820646174614F62';
wwv_flow_api.g_varchar2_table(198) := '6A6563742C20706C7567696E4F626A6563742E706C7567696E4A534F4E2E637573746F6D54656D706C61746520293B0D0A0D0A202020202F2F6966202820706C7567696E4F626A6563742E706C7567696E4A534F4E2E706C7567696E53657474696E6773';
wwv_flow_api.g_varchar2_table(199) := '203D3D202743544443272029207B0D0A202020206966202820706C7567696E4F626A6563742E706C7567696E4A534F4E2E706C7567696E53657474696E67732E697344656661756C7443616C6C6261636B2029207B0D0A202020202020636F6E74656E74';
wwv_flow_api.g_varchar2_table(200) := '203D20273C64697620636C6173733D22726F7744657461696C73436F6E7461696E6572223E3C64697620636C6173733D226F766572666C6F77223E272B636F6E74656E742B273C2F6469763E3C2F6469763E273B0D0A202020207D0D0A20207D0D0A2020';
wwv_flow_api.g_varchar2_table(201) := '656C7365207B0D0A20202020636F6E74656E74203D20707265746975735F6D757374616368655F64656661756C742820646174614F626A65637420293B20200D0A20207D0D0A20200D0A20202F2F6D616E6167652063616C6C6261636B0D0A20202F2F69';
wwv_flow_api.g_varchar2_table(202) := '66202820242E696E41727261792820706C7567696E4F626A6563742E706C7567696E4A534F4E2E706C7567696E53657474696E67732C205B2744544343272C202743544343275D2029203E202D312029207B0D0A20206966202820706C7567696E4F626A';
wwv_flow_api.g_varchar2_table(203) := '6563742E706C7567696E4A534F4E2E706C7567696E53657474696E67732E6973437573746F6D43616C6C6261636B2029207B0D0A20202020707265746975735F637573746F6D5F63616C6C6261636B2820706C7567696E4F626A6563742C20636F6E7465';
wwv_flow_api.g_varchar2_table(204) := '6E742C20646174614F626A656374293B0D0A20207D0D0A2020656C7365207B0D0A20202020707265746975735F64656661756C745F74656D706C6174652820706C7567696E4F626A6563742C20636F6E74656E742C20646174614F626A6563742E646174';
wwv_flow_api.g_varchar2_table(205) := '612E6C656E677468203D3D2030203F2074727565203A2066616C736520293B0D0A20207D0D0A7D202F2F707265746975735F726F775F647261775F646174610D0A0D0A0D0A66756E6374696F6E2073686F775370696E6E65722820726567696F6E496420';
wwv_flow_api.g_varchar2_table(206) := '29207B0D0A202072657475726E20617065782E7574696C2E73686F775370696E6E657228202428726567696F6E4964292E66696E6428272E742D5265706F72742D7461626C6557726170272920293B0D0A7D0D0A0D0A66756E6374696F6E206869646553';
wwv_flow_api.g_varchar2_table(207) := '70696E6E657228207370696E6E65722029207B0D0A202069662028207370696E6E6572203D3D206E756C6C2029207B0D0A2020202072657475726E20766F69642830293B0D0A20207D0D0A0D0A20207370696E6E65722E666164654F7574283530302C20';
wwv_flow_api.g_varchar2_table(208) := '66756E6374696F6E28297B0D0A20202020242874686973292E72656D6F766528293B0D0A20207D290D0A7D0D0A0D0A66756E6374696F6E2067657444617461414A415828206F626A2C20636F6C756D6E732C2076616C7565732029207B0D0A2020766172';
wwv_flow_api.g_varchar2_table(209) := '20616A61785370696E6E6572203D206E756C6C3B0D0A0D0A202069662028200D0A202020206F626A2E706C7567696E4A534F4E2E706C7567696E53657474696E67732E697344656661756C7443616C6C6261636B202626206F626A2E706C7567696E4A53';
wwv_flow_api.g_varchar2_table(210) := '4F4E2E64656661756C7443616C6C6261636B2E6C6F6164696E67496E64696361746F72200D0A202020207C7C206F626A2E706C7567696E4A534F4E2E706C7567696E53657474696E67732E6973437573746F6D43616C6C6261636B202626206F626A2E70';
wwv_flow_api.g_varchar2_table(211) := '6C7567696E4A534F4E2E637573746F6D43616C6C6261636B2E6C6F6164696E67496E64696361746F72200D0A202029207B0D0A20202020616A61785370696E6E6572203D2073686F775370696E6E657228206F626A2E6166666563746564456C656D656E';
wwv_flow_api.g_varchar2_table(212) := '74732E73656C6563746F7220293B202F2F617065782E7574696C2E73686F775370696E6E657228202428206F626A2E6166666563746564456C656D656E74732E73656C6563746F72202920293B0D0A202020206F626A2E7370696E6E6572203D20616A61';
wwv_flow_api.g_varchar2_table(213) := '785370696E6E65723B0D0A20207D0D0A20200D0A0D0A2020786872203D20242E616A6178287B0D0A2020202075726C3A277777765F666C6F772E73686F77272C0D0A20202020747970653A27706F7374272C0D0A2020202064617461547970653A276A73';
wwv_flow_api.g_varchar2_table(214) := '6F6E272C0D0A20202020747261646974696F6E616C3A20747275652C0D0A20202020646174613A207B0D0A202020202020705F726571756573743A20224E41544956453D222B206F626A2E616374696F6E2E616A61784964656E7469666965722C0D0A20';
wwv_flow_api.g_varchar2_table(215) := '2020202020705F666C6F775F69643A202476282770466C6F77496427292C0D0A202020202020705F666C6F775F737465705F69643A202476282770466C6F7753746570496427292C0D0A202020202020705F696E7374616E63653A202476282770496E73';
wwv_flow_api.g_varchar2_table(216) := '74616E636527292C0D0A2020202020202F2F705F6172675F6E616D65733A205B206974656D5F6964205D2C0D0A2020202020202F2F705F6172675F76616C7565733A205B206974656D56616C7565205D2C0D0A2020202020207830313A20636F6C756D6E';
wwv_flow_api.g_varchar2_table(217) := '732C0D0A2020202020207830323A2076616C7565732C0D0A2020202020207830333A202767657448656164657273270D0A202020207D2C0D0A202020200D0A20202020737563636573733A2066756E6374696F6E2820726573756C74486561646572732C';
wwv_flow_api.g_varchar2_table(218) := '20746578745374617475732C20616A61784F626A20297B202F2F547970653A2046756E6374696F6E2820416E797468696E6720646174612C20537472696E6720746578745374617475732C206A71584852206A7158485220290D0A0D0A20202020202069';
wwv_flow_api.g_varchar2_table(219) := '66202820726573756C74486561646572732E6572726F7220213D20756E646566696E65642029207B0D0A2020202020202020616C65727428207265706C61636551756F746528726573756C74486561646572732E6572726F722E6775694D7367292B225C';
wwv_flow_api.g_varchar2_table(220) := '6E5C6E222B7265706C61636551756F746528726573756C74486561646572732E6572726F722E6465764D73672920293B0D0A2020202020202020686964655370696E6E65722820616A61785370696E6E657220293B0D0A20202020202020207265747572';
wwv_flow_api.g_varchar2_table(221) := '6E20766F69642830293B0D0A2020202020207D0D0A0D0A0D0A2020202020202F2F6F637A656B756A656D79207461626C6963790D0A2020202020202F2F7A6D70777520616A6178207A6562792070626F7261632074796D2072617A656D2064616E650D0A';
wwv_flow_api.g_varchar2_table(222) := '2020202020202F2F67657420646174612D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(223) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A20202020202078687232203D20242E616A6178287B0D0A202020202020202075726C3A277777765F666C6F772E73686F77272C0D0A2020202020202020747970653A27706F73';
wwv_flow_api.g_varchar2_table(224) := '74272C0D0A202020202020202064617461547970653A276A736F6E272C0D0A20202020202020202F2F64617461547970653A2768746D6C272C0D0A2020202020202020747261646974696F6E616C3A20747275652C0D0A2020202020202020646174613A';
wwv_flow_api.g_varchar2_table(225) := '207B0D0A20202020202020202020705F726571756573743A20224E41544956453D222B206F626A2E616374696F6E2E616A61784964656E7469666965722C0D0A20202020202020202020705F666C6F775F69643A202476282770466C6F77496427292C0D';
wwv_flow_api.g_varchar2_table(226) := '0A20202020202020202020705F666C6F775F737465705F69643A202476282770466C6F7753746570496427292C0D0A20202020202020202020705F696E7374616E63653A202476282770496E7374616E636527292C0D0A202020202020202020202F2F70';
wwv_flow_api.g_varchar2_table(227) := '5F6172675F6E616D65733A205B206974656D5F6964205D2C0D0A202020202020202020202F2F705F6172675F76616C7565733A205B206974656D56616C7565205D2C0D0A202020202020202020207830313A20636F6C756D6E732C0D0A20202020202020';
wwv_flow_api.g_varchar2_table(228) := '2020207830323A2076616C7565732C0D0A202020202020202020207830333A202767657444617461270D0A20202020202020207D2C0D0A20202020202020200D0A2020202020202020737563636573733A2066756E6374696F6E2820726573756C744461';
wwv_flow_api.g_varchar2_table(229) := '74612C20746578745374617475732C20616A61784F626A20297B202F2F547970653A2046756E6374696F6E2820416E797468696E6720646174612C20537472696E6720746578745374617475732C206A71584852206A7158485220290D0A202020202020';
wwv_flow_api.g_varchar2_table(230) := '202020206966202820726573756C74446174612E6572726F7220213D20756E646566696E65642029207B0D0A202020202020202020202020616C65727428207265706C61636551756F746528726573756C74446174612E6572726F722E6775694D736729';
wwv_flow_api.g_varchar2_table(231) := '2B225C6E5C6E222B7265706C61636551756F746528726573756C74446174612E6572726F722E6465764D73672920293B0D0A20202020202020202020202072657475726E20766F69642830293B0D0A202020202020202020207D20202020202020202020';
wwv_flow_api.g_varchar2_table(232) := '0D0A0D0A2020202020202020202024286F626A2E74726967676572696E67456C656D656E74292E64617461287B0D0A2020202020202020202020202768656164657273273A20726573756C74486561646572732C0D0A2020202020202020202020202764';
wwv_flow_api.g_varchar2_table(233) := '617461273A20726573756C74446174610D0A202020202020202020207D293B0D0A0D0A20202020202020202020707265746975735F726F775F647261775F6461746128206F626A2C20726573756C74486561646572732C20726573756C74446174612029';
wwv_flow_api.g_varchar2_table(234) := '3B0D0A20202020202020202020686964655370696E6E65722820616A61785370696E6E657220293B0D0A20202020202020207D2C0D0A20202020202020200D0A20202020202020206572726F723A2066756E6374696F6E286A715848522C207465787453';
wwv_flow_api.g_varchar2_table(235) := '74617475732C206572726F725468726F776E297B202F2F6A71584852206A715848522C20537472696E6720746578745374617475732C20537472696E67206572726F725468726F776E0D0A20202020202020202020616C65727428274572726F72206F63';
wwv_flow_api.g_varchar2_table(236) := '6375726564207768696C652072657472696576696E6720414A415820646174613A20272B746578745374617475732B225C6E222B6572726F725468726F776E293B0D0A20202020202020202020686964655370696E6E65722820616A61785370696E6E65';
wwv_flow_api.g_varchar2_table(237) := '7220293B0D0A20202020202020207D0D0A2020202020207D293B202020200D0A2020202020202F2F67657420646174612D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D';
wwv_flow_api.g_varchar2_table(238) := '2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D0D0A202020207D2C0D0A202020200D0A202020206572726F723A2066756E6374696F6E286A715848';
wwv_flow_api.g_varchar2_table(239) := '522C20746578745374617475732C206572726F725468726F776E297B202F2F6A71584852206A715848522C20537472696E6720746578745374617475732C20537472696E67206572726F725468726F776E0D0A202020202020616C65727428274572726F';
wwv_flow_api.g_varchar2_table(240) := '72206F636375726564207768696C652072657472696576696E6720414A415820686561646572733A20272B746578745374617475732B225C6E222B6572726F725468726F776E293B0D0A202020207D0D0A20207D293B202020200D0A0D0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(44204726467527367)
,p_plugin_id=>wwv_flow_api.id(471258000703755090)
,p_file_name=>'pretius_row_details.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2E64657461696C656444617461207B0D0A2020637572736F723A20706F696E7465723B0D0A7D0D0A0D0A2F2A206764792074726967676572656D206A657374205452202A2F0D0A74722E666F63757365642E74726967676572696E67456C656D656E7420';
wwv_flow_api.g_varchar2_table(2) := '3E2074643A66697273742D6368696C64207B0D0A2020626F726465722D72696768743A206E6F6E652021696D706F7274616E743B0D0A2020626F726465722D6C6566743A2031707820736F6C69643B0D0A7D0D0A0D0A74722E666F63757365642E747269';
wwv_flow_api.g_varchar2_table(3) := '67676572696E67456C656D656E74203E2074643A6E74682D6368696C64283229207B0D0A2020626F726465722D6C6566743A206E6F6E652021696D706F7274616E743B0D0A7D0D0A74722E666F63757365642E74726967676572696E67456C656D656E74';
wwv_flow_api.g_varchar2_table(4) := '203E2074643A6E74682D6C6173742D6368696C64283229207B0D0A2020626F726465722D72696768743A206E6F6E652021696D706F7274616E743B200D0A7D0D0A0D0A74722E666F63757365642E74726967676572696E67456C656D656E74203E207464';
wwv_flow_api.g_varchar2_table(5) := '207B0D0A2020626F726465722D6C6566743A206E6F6E653B200D0A2020626F726465722D72696768743A206E6F6E653B200D0A7D0D0A0D0A0D0A74722E666F63757365642E74726967676572696E67456C656D656E74203E2074643A6C6173742D636869';
wwv_flow_api.g_varchar2_table(6) := '6C64207B0D0A2020626F726465722D6C6566743A206E6F6E652021696D706F7274616E743B0D0A2020626F726465722D72696768743A2031707820736F6C69643B0D0A7D0D0A0D0A2F2A20646C6120726F7A77696E69657465676F2077696572737A612A';
wwv_flow_api.g_varchar2_table(7) := '2F0D0A2E707265746975735F706C7567696E5F726F77207461626C65207B0D0A20206261636B67726F756E643A2072676261283235352C203235352C203235352C20302E35293B0D0A7D0D0A0D0A2E707265746975735F706C7567696E5F726F77203E20';
wwv_flow_api.g_varchar2_table(8) := '7464203E206469762E726F7744657461696C73436F6E7461696E6572207B0D0A202070616464696E673A203870783B0D0A20206D617267696E3A203270783B0D0A2020746578742D616C69676E3A206C6566743B0D0A7D0D0A0D0A2E707265746975735F';
wwv_flow_api.g_varchar2_table(9) := '706C7567696E5F726F77203E207464203E206469762E726F7744657461696C73436F6E7461696E6572203E206469762E6F766572666C6F77207B0D0A20206F766572666C6F773A206175746F3B0D0A7D0D0A0D0A2E707265746975735F706C7567696E5F';
wwv_flow_api.g_varchar2_table(10) := '726F77203E207464207B0D0A202070616464696E673A203070783B0D0A2020626F726465722D7374796C653A20736F6C69642021696D706F7274616E743B0D0A2020626F726465722D77696474683A203170782021696D706F7274616E743B0D0A202062';
wwv_flow_api.g_varchar2_table(11) := '6F726465722D746F703A20696E697469616C2021696D706F7274616E743B0D0A7D0D0A0D0A2F2A2A2F0D0A0D0A6469762E726F7744657461696C73436F6E7461696E6572207468207B0D0A20206F7061636974793A20302E373B0D0A7D0D0A0D0A2E5641';
wwv_flow_api.g_varchar2_table(12) := '524348415232207B0D0A2020746578742D616C69676E3A206C6566743B0D0A7D0D0A0D0A2E4E554D4245522C0D0A2E44415445207B0D0A2020746578742D616C69676E3A2072696768743B0D0A7D0D0A0D0A0D0A0D0A2F2A2067647920706F6473776965';
wwv_flow_api.g_varchar2_table(13) := '746C6F6E792077696572737A20737A637A65676F6C6F77202A2F0D0A74722E707265746975735F706C7567696E5F726F773A686F766572202E742D5265706F72742D7265706F72742074723A6E74682D6368696C64286F6464292074642E742D5265706F';
wwv_flow_api.g_varchar2_table(14) := '72742D63656C6C2C0D0A74722E707265746975735F706C7567696E5F726F77202E742D5265706F72742D7265706F72742074723A6E74682D6368696C64286F6464292074642E742D5265706F72742D63656C6C207B0D0A20202F2A6261636B67726F756E';
wwv_flow_api.g_varchar2_table(15) := '642D636F6C6F723A20726762612835322C203235322C203235322C20302E35292021696D706F7274616E743B202A2F0D0A20206261636B67726F756E642D636F6C6F723A2072676261283233392C203233392C203233392C20302E35292021696D706F72';
wwv_flow_api.g_varchar2_table(16) := '74616E743B0D0A7D0D0A0D0A74722E707265746975735F706C7567696E5F726F773A686F766572202E742D5265706F72742D7265706F72742074723A6E74682D6368696C64286576656E292074642E742D5265706F72742D63656C6C2C0D0A74722E7072';
wwv_flow_api.g_varchar2_table(17) := '65746975735F706C7567696E5F726F77202E742D5265706F72742D7265706F72742074723A6E74682D6368696C64286576656E292074642E742D5265706F72742D63656C6C207B0D0A20202F2A6261636B67726F756E642D636F6C6F723A207267626128';
wwv_flow_api.g_varchar2_table(18) := '3235352C2037352C2037352C20302E35292021696D706F7274616E743B2A2F0D0A20206261636B67726F756E642D636F6C6F723A2072676261283235352C203235352C203235352C20302E35292021696D706F7274616E743B0D0A7D0D0A0D0A6469762E';
wwv_flow_api.g_varchar2_table(19) := '726F7744657461696C73436F6E7461696E6572203E207461626C652E742D5265706F72742D7265706F72742074723A6E74682D6368696C64286576656E293A686F766572203E2074642E742D5265706F72742D63656C6C2C0D0A6469762E726F77446574';
wwv_flow_api.g_varchar2_table(20) := '61696C73436F6E7461696E6572203E207461626C652E742D5265706F72742D7265706F72742074723A6E74682D6368696C64286F6464293A686F76657220203E2074642E742D5265706F72742D63656C6C207B0D0A20206261636B67726F756E642D636F';
wwv_flow_api.g_varchar2_table(21) := '6C6F723A2072676261283235352C203235352C203235352C20302E38292021696D706F7274616E743B0D0A7D0D0A0D0A2F2A2A2F0D0A2E616C657274506C7567696E207B0D0A2020706F736974696F6E3A206162736F6C7574653B0D0A20207769647468';
wwv_flow_api.g_varchar2_table(22) := '3A20363070783B0D0A20206865696768743A20363070783B0D0A20200D0A7D0D0A0D0A2E616C657274506C7567696E202E6661207B0D0A2020666F6E742D73697A653A20363070783B0D0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(319643139391709277)
,p_plugin_id=>wwv_flow_api.id(471258000703755090)
,p_file_name=>'pretius_row_details_styles.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2866756E6374696F6E20646566696E654D7573746163686528676C6F62616C2C666163746F7279297B696628747970656F66206578706F7274733D3D3D226F626A6563742226266578706F7274732626747970656F66206578706F7274732E6E6F64654E';
wwv_flow_api.g_varchar2_table(2) := '616D65213D3D22737472696E6722297B666163746F7279286578706F727473297D656C736520696628747970656F6620646566696E653D3D3D2266756E6374696F6E222626646566696E652E616D64297B646566696E65285B226578706F727473225D2C';
wwv_flow_api.g_varchar2_table(3) := '666163746F7279297D656C73657B676C6F62616C2E4D757374616368653D7B7D3B666163746F727928676C6F62616C2E4D75737461636865297D7D2928746869732C66756E6374696F6E206D75737461636865466163746F7279286D7573746163686529';
wwv_flow_api.g_varchar2_table(4) := '7B766172206F626A656374546F537472696E673D4F626A6563742E70726F746F747970652E746F537472696E673B76617220697341727261793D41727261792E697341727261797C7C66756E6374696F6E2069734172726179506F6C7966696C6C286F62';
wwv_flow_api.g_varchar2_table(5) := '6A656374297B72657475726E206F626A656374546F537472696E672E63616C6C286F626A656374293D3D3D225B6F626A6563742041727261795D227D3B66756E6374696F6E20697346756E6374696F6E286F626A656374297B72657475726E2074797065';
wwv_flow_api.g_varchar2_table(6) := '6F66206F626A6563743D3D3D2266756E6374696F6E227D66756E6374696F6E2074797065537472286F626A297B72657475726E2069734172726179286F626A293F226172726179223A747970656F66206F626A7D66756E6374696F6E2065736361706552';
wwv_flow_api.g_varchar2_table(7) := '656745787028737472696E67297B72657475726E20737472696E672E7265706C616365282F5B5C2D5C5B5C5D7B7D28292A2B3F2E2C5C5C5C5E247C235C735D2F672C225C5C242622297D66756E6374696F6E2068617350726F7065727479286F626A2C70';
wwv_flow_api.g_varchar2_table(8) := '726F704E616D65297B72657475726E206F626A213D6E756C6C2626747970656F66206F626A3D3D3D226F626A65637422262670726F704E616D6520696E206F626A7D76617220726567457870546573743D5265674578702E70726F746F747970652E7465';
wwv_flow_api.g_varchar2_table(9) := '73743B66756E6374696F6E20746573745265674578702872652C737472696E67297B72657475726E20726567457870546573742E63616C6C2872652C737472696E67297D766172206E6F6E537061636552653D2F5C532F3B66756E6374696F6E20697357';
wwv_flow_api.g_varchar2_table(10) := '68697465737061636528737472696E67297B72657475726E2174657374526567457870286E6F6E537061636552652C737472696E67297D76617220656E746974794D61703D7B2226223A2226616D703B222C223C223A22266C743B222C223E223A222667';
wwv_flow_api.g_varchar2_table(11) := '743B222C2722273A222671756F743B222C2227223A22262333393B222C222F223A2226237832463B222C2260223A2226237836303B222C223D223A2226237833443B227D3B66756E6374696F6E2065736361706548746D6C28737472696E67297B726574';
wwv_flow_api.g_varchar2_table(12) := '75726E20537472696E6728737472696E67292E7265706C616365282F5B263C3E2227603D5C2F5D2F672C66756E6374696F6E2066726F6D456E746974794D61702873297B72657475726E20656E746974794D61705B735D7D297D76617220776869746552';
wwv_flow_api.g_varchar2_table(13) := '653D2F5C732A2F3B76617220737061636552653D2F5C732B2F3B76617220657175616C7352653D2F5C732A3D2F3B766172206375726C7952653D2F5C732A5C7D2F3B7661722074616752653D2F237C5C5E7C5C2F7C3E7C5C7B7C267C3D7C212F3B66756E';
wwv_flow_api.g_varchar2_table(14) := '6374696F6E20706172736554656D706C6174652874656D706C6174652C74616773297B6966282174656D706C6174652972657475726E5B5D3B7661722073656374696F6E733D5B5D3B76617220746F6B656E733D5B5D3B766172207370616365733D5B5D';
wwv_flow_api.g_varchar2_table(15) := '3B766172206861735461673D66616C73653B766172206E6F6E53706163653D66616C73653B66756E6374696F6E207374726970537061636528297B6966286861735461672626216E6F6E5370616365297B7768696C65287370616365732E6C656E677468';
wwv_flow_api.g_varchar2_table(16) := '2964656C65746520746F6B656E735B7370616365732E706F7028295D7D656C73657B7370616365733D5B5D7D6861735461673D66616C73653B6E6F6E53706163653D66616C73657D766172206F70656E696E6754616752652C636C6F73696E6754616752';
wwv_flow_api.g_varchar2_table(17) := '652C636C6F73696E674375726C7952653B66756E6374696F6E20636F6D70696C65546167732874616773546F436F6D70696C65297B696628747970656F662074616773546F436F6D70696C653D3D3D22737472696E67222974616773546F436F6D70696C';
wwv_flow_api.g_varchar2_table(18) := '653D74616773546F436F6D70696C652E73706C697428737061636552652C32293B69662821697341727261792874616773546F436F6D70696C65297C7C74616773546F436F6D70696C652E6C656E677468213D3D32297468726F77206E6577204572726F';
wwv_flow_api.g_varchar2_table(19) := '722822496E76616C696420746167733A20222B74616773546F436F6D70696C65293B6F70656E696E6754616752653D6E657720526567457870286573636170655265674578702874616773546F436F6D70696C655B305D292B225C5C732A22293B636C6F';
wwv_flow_api.g_varchar2_table(20) := '73696E6754616752653D6E65772052656745787028225C5C732A222B6573636170655265674578702874616773546F436F6D70696C655B315D29293B636C6F73696E674375726C7952653D6E65772052656745787028225C5C732A222B65736361706552';
wwv_flow_api.g_varchar2_table(21) := '656745787028227D222B74616773546F436F6D70696C655B315D29297D636F6D70696C655461677328746167737C7C6D757374616368652E74616773293B766172207363616E6E65723D6E6577205363616E6E65722874656D706C617465293B76617220';
wwv_flow_api.g_varchar2_table(22) := '73746172742C747970652C76616C75652C6368722C746F6B656E2C6F70656E53656374696F6E3B7768696C6528217363616E6E65722E656F732829297B73746172743D7363616E6E65722E706F733B76616C75653D7363616E6E65722E7363616E556E74';
wwv_flow_api.g_varchar2_table(23) := '696C286F70656E696E675461675265293B69662876616C7565297B666F722876617220693D302C76616C75654C656E6774683D76616C75652E6C656E6774683B693C76616C75654C656E6774683B2B2B69297B6368723D76616C75652E63686172417428';
wwv_flow_api.g_varchar2_table(24) := '69293B6966286973576869746573706163652863687229297B7370616365732E7075736828746F6B656E732E6C656E677468297D656C73657B6E6F6E53706163653D747275657D746F6B656E732E70757368285B2274657874222C6368722C7374617274';
wwv_flow_api.g_varchar2_table(25) := '2C73746172742B315D293B73746172742B3D313B6966286368723D3D3D225C6E22297374726970537061636528297D7D696628217363616E6E65722E7363616E286F70656E696E6754616752652929627265616B3B6861735461673D747275653B747970';
wwv_flow_api.g_varchar2_table(26) := '653D7363616E6E65722E7363616E287461675265297C7C226E616D65223B7363616E6E65722E7363616E2877686974655265293B696628747970653D3D3D223D22297B76616C75653D7363616E6E65722E7363616E556E74696C28657175616C73526529';
wwv_flow_api.g_varchar2_table(27) := '3B7363616E6E65722E7363616E28657175616C735265293B7363616E6E65722E7363616E556E74696C28636C6F73696E675461675265297D656C736520696628747970653D3D3D227B22297B76616C75653D7363616E6E65722E7363616E556E74696C28';
wwv_flow_api.g_varchar2_table(28) := '636C6F73696E674375726C795265293B7363616E6E65722E7363616E286375726C795265293B7363616E6E65722E7363616E556E74696C28636C6F73696E675461675265293B747970653D2226227D656C73657B76616C75653D7363616E6E65722E7363';
wwv_flow_api.g_varchar2_table(29) := '616E556E74696C28636C6F73696E675461675265297D696628217363616E6E65722E7363616E28636C6F73696E67546167526529297468726F77206E6577204572726F722822556E636C6F7365642074616720617420222B7363616E6E65722E706F7329';
wwv_flow_api.g_varchar2_table(30) := '3B746F6B656E3D5B747970652C76616C75652C73746172742C7363616E6E65722E706F735D3B746F6B656E732E7075736828746F6B656E293B696628747970653D3D3D2223227C7C747970653D3D3D225E22297B73656374696F6E732E7075736828746F';
wwv_flow_api.g_varchar2_table(31) := '6B656E297D656C736520696628747970653D3D3D222F22297B6F70656E53656374696F6E3D73656374696F6E732E706F7028293B696628216F70656E53656374696F6E297468726F77206E6577204572726F722827556E6F70656E65642073656374696F';
wwv_flow_api.g_varchar2_table(32) := '6E2022272B76616C75652B272220617420272B7374617274293B6966286F70656E53656374696F6E5B315D213D3D76616C7565297468726F77206E6577204572726F722827556E636C6F7365642073656374696F6E2022272B6F70656E53656374696F6E';
wwv_flow_api.g_varchar2_table(33) := '5B315D2B272220617420272B7374617274297D656C736520696628747970653D3D3D226E616D65227C7C747970653D3D3D227B227C7C747970653D3D3D222622297B6E6F6E53706163653D747275657D656C736520696628747970653D3D3D223D22297B';
wwv_flow_api.g_varchar2_table(34) := '636F6D70696C65546167732876616C7565297D7D6F70656E53656374696F6E3D73656374696F6E732E706F7028293B6966286F70656E53656374696F6E297468726F77206E6577204572726F722827556E636C6F7365642073656374696F6E2022272B6F';
wwv_flow_api.g_varchar2_table(35) := '70656E53656374696F6E5B315D2B272220617420272B7363616E6E65722E706F73293B72657475726E206E657374546F6B656E7328737175617368546F6B656E7328746F6B656E7329297D66756E6374696F6E20737175617368546F6B656E7328746F6B';
wwv_flow_api.g_varchar2_table(36) := '656E73297B766172207371756173686564546F6B656E733D5B5D3B76617220746F6B656E2C6C617374546F6B656E3B666F722876617220693D302C6E756D546F6B656E733D746F6B656E732E6C656E6774683B693C6E756D546F6B656E733B2B2B69297B';
wwv_flow_api.g_varchar2_table(37) := '746F6B656E3D746F6B656E735B695D3B696628746F6B656E297B696628746F6B656E5B305D3D3D3D22746578742226266C617374546F6B656E26266C617374546F6B656E5B305D3D3D3D227465787422297B6C617374546F6B656E5B315D2B3D746F6B65';
wwv_flow_api.g_varchar2_table(38) := '6E5B315D3B6C617374546F6B656E5B335D3D746F6B656E5B335D7D656C73657B7371756173686564546F6B656E732E7075736828746F6B656E293B6C617374546F6B656E3D746F6B656E7D7D7D72657475726E207371756173686564546F6B656E737D66';
wwv_flow_api.g_varchar2_table(39) := '756E6374696F6E206E657374546F6B656E7328746F6B656E73297B766172206E6573746564546F6B656E733D5B5D3B76617220636F6C6C6563746F723D6E6573746564546F6B656E733B7661722073656374696F6E733D5B5D3B76617220746F6B656E2C';
wwv_flow_api.g_varchar2_table(40) := '73656374696F6E3B666F722876617220693D302C6E756D546F6B656E733D746F6B656E732E6C656E6774683B693C6E756D546F6B656E733B2B2B69297B746F6B656E3D746F6B656E735B695D3B73776974636828746F6B656E5B305D297B636173652223';
wwv_flow_api.g_varchar2_table(41) := '223A63617365225E223A636F6C6C6563746F722E7075736828746F6B656E293B73656374696F6E732E7075736828746F6B656E293B636F6C6C6563746F723D746F6B656E5B345D3D5B5D3B627265616B3B63617365222F223A73656374696F6E3D736563';
wwv_flow_api.g_varchar2_table(42) := '74696F6E732E706F7028293B73656374696F6E5B355D3D746F6B656E5B325D3B636F6C6C6563746F723D73656374696F6E732E6C656E6774683E303F73656374696F6E735B73656374696F6E732E6C656E6774682D315D5B345D3A6E6573746564546F6B';
wwv_flow_api.g_varchar2_table(43) := '656E733B627265616B3B64656661756C743A636F6C6C6563746F722E7075736828746F6B656E297D7D72657475726E206E6573746564546F6B656E737D66756E6374696F6E205363616E6E657228737472696E67297B746869732E737472696E673D7374';
wwv_flow_api.g_varchar2_table(44) := '72696E673B746869732E7461696C3D737472696E673B746869732E706F733D307D5363616E6E65722E70726F746F747970652E656F733D66756E6374696F6E20656F7328297B72657475726E20746869732E7461696C3D3D3D22227D3B5363616E6E6572';
wwv_flow_api.g_varchar2_table(45) := '2E70726F746F747970652E7363616E3D66756E6374696F6E207363616E287265297B766172206D617463683D746869732E7461696C2E6D61746368287265293B696628216D617463687C7C6D617463682E696E646578213D3D302972657475726E22223B';
wwv_flow_api.g_varchar2_table(46) := '76617220737472696E673D6D617463685B305D3B746869732E7461696C3D746869732E7461696C2E737562737472696E6728737472696E672E6C656E677468293B746869732E706F732B3D737472696E672E6C656E6774683B72657475726E2073747269';
wwv_flow_api.g_varchar2_table(47) := '6E677D3B5363616E6E65722E70726F746F747970652E7363616E556E74696C3D66756E6374696F6E207363616E556E74696C287265297B76617220696E6465783D746869732E7461696C2E736561726368287265292C6D617463683B7377697463682869';
wwv_flow_api.g_varchar2_table(48) := '6E646578297B636173652D313A6D617463683D746869732E7461696C3B746869732E7461696C3D22223B627265616B3B6361736520303A6D617463683D22223B627265616B3B64656661756C743A6D617463683D746869732E7461696C2E737562737472';
wwv_flow_api.g_varchar2_table(49) := '696E6728302C696E646578293B746869732E7461696C3D746869732E7461696C2E737562737472696E6728696E646578297D746869732E706F732B3D6D617463682E6C656E6774683B72657475726E206D617463687D3B66756E6374696F6E20436F6E74';
wwv_flow_api.g_varchar2_table(50) := '65787428766965772C706172656E74436F6E74657874297B746869732E766965773D766965773B746869732E63616368653D7B222E223A746869732E766965777D3B746869732E706172656E743D706172656E74436F6E746578747D436F6E746578742E';
wwv_flow_api.g_varchar2_table(51) := '70726F746F747970652E707573683D66756E6374696F6E20707573682876696577297B72657475726E206E657720436F6E7465787428766965772C74686973297D3B436F6E746578742E70726F746F747970652E6C6F6F6B75703D66756E6374696F6E20';
wwv_flow_api.g_varchar2_table(52) := '6C6F6F6B7570286E616D65297B7661722063616368653D746869732E63616368653B7661722076616C75653B69662863616368652E6861734F776E50726F7065727479286E616D6529297B76616C75653D63616368655B6E616D655D7D656C73657B7661';
wwv_flow_api.g_varchar2_table(53) := '7220636F6E746578743D746869732C6E616D65732C696E6465782C6C6F6F6B75704869743D66616C73653B7768696C6528636F6E74657874297B6966286E616D652E696E6465784F6628222E22293E30297B76616C75653D636F6E746578742E76696577';
wwv_flow_api.g_varchar2_table(54) := '3B6E616D65733D6E616D652E73706C697428222E22293B696E6465783D303B7768696C652876616C7565213D6E756C6C2626696E6465783C6E616D65732E6C656E677468297B696628696E6465783D3D3D6E616D65732E6C656E6774682D31296C6F6F6B';
wwv_flow_api.g_varchar2_table(55) := '75704869743D68617350726F70657274792876616C75652C6E616D65735B696E6465785D293B76616C75653D76616C75655B6E616D65735B696E6465782B2B5D5D7D7D656C73657B76616C75653D636F6E746578742E766965775B6E616D655D3B6C6F6F';
wwv_flow_api.g_varchar2_table(56) := '6B75704869743D68617350726F706572747928636F6E746578742E766965772C6E616D65297D6966286C6F6F6B757048697429627265616B3B636F6E746578743D636F6E746578742E706172656E747D63616368655B6E616D655D3D76616C75657D6966';
wwv_flow_api.g_varchar2_table(57) := '28697346756E6374696F6E2876616C7565292976616C75653D76616C75652E63616C6C28746869732E76696577293B72657475726E2076616C75657D3B66756E6374696F6E2057726974657228297B746869732E63616368653D7B7D7D5772697465722E';
wwv_flow_api.g_varchar2_table(58) := '70726F746F747970652E636C65617243616368653D66756E6374696F6E20636C656172436163686528297B746869732E63616368653D7B7D7D3B5772697465722E70726F746F747970652E70617273653D66756E6374696F6E2070617273652874656D70';
wwv_flow_api.g_varchar2_table(59) := '6C6174652C74616773297B7661722063616368653D746869732E63616368653B76617220746F6B656E733D63616368655B74656D706C6174655D3B696628746F6B656E733D3D6E756C6C29746F6B656E733D63616368655B74656D706C6174655D3D7061';
wwv_flow_api.g_varchar2_table(60) := '72736554656D706C6174652874656D706C6174652C74616773293B72657475726E20746F6B656E737D3B5772697465722E70726F746F747970652E72656E6465723D66756E6374696F6E2072656E6465722874656D706C6174652C766965772C70617274';
wwv_flow_api.g_varchar2_table(61) := '69616C73297B76617220746F6B656E733D746869732E70617273652874656D706C617465293B76617220636F6E746578743D7669657720696E7374616E63656F6620436F6E746578743F766965773A6E657720436F6E746578742876696577293B726574';
wwv_flow_api.g_varchar2_table(62) := '75726E20746869732E72656E646572546F6B656E7328746F6B656E732C636F6E746578742C7061727469616C732C74656D706C617465297D3B5772697465722E70726F746F747970652E72656E646572546F6B656E733D66756E6374696F6E2072656E64';
wwv_flow_api.g_varchar2_table(63) := '6572546F6B656E7328746F6B656E732C636F6E746578742C7061727469616C732C6F726967696E616C54656D706C617465297B766172206275666665723D22223B76617220746F6B656E2C73796D626F6C2C76616C75653B666F722876617220693D302C';
wwv_flow_api.g_varchar2_table(64) := '6E756D546F6B656E733D746F6B656E732E6C656E6774683B693C6E756D546F6B656E733B2B2B69297B76616C75653D756E646566696E65643B746F6B656E3D746F6B656E735B695D3B73796D626F6C3D746F6B656E5B305D3B69662873796D626F6C3D3D';
wwv_flow_api.g_varchar2_table(65) := '3D2223222976616C75653D746869732E72656E64657253656374696F6E28746F6B656E2C636F6E746578742C7061727469616C732C6F726967696E616C54656D706C617465293B656C73652069662873796D626F6C3D3D3D225E222976616C75653D7468';
wwv_flow_api.g_varchar2_table(66) := '69732E72656E646572496E76657274656428746F6B656E2C636F6E746578742C7061727469616C732C6F726967696E616C54656D706C617465293B656C73652069662873796D626F6C3D3D3D223E222976616C75653D746869732E72656E646572506172';
wwv_flow_api.g_varchar2_table(67) := '7469616C28746F6B656E2C636F6E746578742C7061727469616C732C6F726967696E616C54656D706C617465293B656C73652069662873796D626F6C3D3D3D2226222976616C75653D746869732E756E6573636170656456616C756528746F6B656E2C63';
wwv_flow_api.g_varchar2_table(68) := '6F6E74657874293B656C73652069662873796D626F6C3D3D3D226E616D65222976616C75653D746869732E6573636170656456616C756528746F6B656E2C636F6E74657874293B656C73652069662873796D626F6C3D3D3D2274657874222976616C7565';
wwv_flow_api.g_varchar2_table(69) := '3D746869732E72617756616C756528746F6B656E293B69662876616C7565213D3D756E646566696E6564296275666665722B3D76616C75657D72657475726E206275666665727D3B5772697465722E70726F746F747970652E72656E6465725365637469';
wwv_flow_api.g_varchar2_table(70) := '6F6E3D66756E6374696F6E2072656E64657253656374696F6E28746F6B656E2C636F6E746578742C7061727469616C732C6F726967696E616C54656D706C617465297B7661722073656C663D746869733B766172206275666665723D22223B7661722076';
wwv_flow_api.g_varchar2_table(71) := '616C75653D636F6E746578742E6C6F6F6B757028746F6B656E5B315D293B66756E6374696F6E2073756252656E6465722874656D706C617465297B72657475726E2073656C662E72656E6465722874656D706C6174652C636F6E746578742C7061727469';
wwv_flow_api.g_varchar2_table(72) := '616C73297D6966282176616C75652972657475726E3B696628697341727261792876616C756529297B666F7228766172206A3D302C76616C75654C656E6774683D76616C75652E6C656E6774683B6A3C76616C75654C656E6774683B2B2B6A297B627566';
wwv_flow_api.g_varchar2_table(73) := '6665722B3D746869732E72656E646572546F6B656E7328746F6B656E5B345D2C636F6E746578742E707573682876616C75655B6A5D292C7061727469616C732C6F726967696E616C54656D706C617465297D7D656C736520696628747970656F66207661';
wwv_flow_api.g_varchar2_table(74) := '6C75653D3D3D226F626A656374227C7C747970656F662076616C75653D3D3D22737472696E67227C7C747970656F662076616C75653D3D3D226E756D62657222297B6275666665722B3D746869732E72656E646572546F6B656E7328746F6B656E5B345D';
wwv_flow_api.g_varchar2_table(75) := '2C636F6E746578742E707573682876616C7565292C7061727469616C732C6F726967696E616C54656D706C617465297D656C736520696628697346756E6374696F6E2876616C756529297B696628747970656F66206F726967696E616C54656D706C6174';
wwv_flow_api.g_varchar2_table(76) := '65213D3D22737472696E6722297468726F77206E6577204572726F72282243616E6E6F7420757365206869676865722D6F726465722073656374696F6E7320776974686F757420746865206F726967696E616C2074656D706C61746522293B76616C7565';
wwv_flow_api.g_varchar2_table(77) := '3D76616C75652E63616C6C28636F6E746578742E766965772C6F726967696E616C54656D706C6174652E736C69636528746F6B656E5B335D2C746F6B656E5B355D292C73756252656E646572293B69662876616C7565213D6E756C6C296275666665722B';
wwv_flow_api.g_varchar2_table(78) := '3D76616C75657D656C73657B6275666665722B3D746869732E72656E646572546F6B656E7328746F6B656E5B345D2C636F6E746578742C7061727469616C732C6F726967696E616C54656D706C617465297D72657475726E206275666665727D3B577269';
wwv_flow_api.g_varchar2_table(79) := '7465722E70726F746F747970652E72656E646572496E7665727465643D66756E6374696F6E2072656E646572496E76657274656428746F6B656E2C636F6E746578742C7061727469616C732C6F726967696E616C54656D706C617465297B766172207661';
wwv_flow_api.g_varchar2_table(80) := '6C75653D636F6E746578742E6C6F6F6B757028746F6B656E5B315D293B6966282176616C75657C7C697341727261792876616C756529262676616C75652E6C656E6774683D3D3D302972657475726E20746869732E72656E646572546F6B656E7328746F';
wwv_flow_api.g_varchar2_table(81) := '6B656E5B345D2C636F6E746578742C7061727469616C732C6F726967696E616C54656D706C617465297D3B5772697465722E70726F746F747970652E72656E6465725061727469616C3D66756E6374696F6E2072656E6465725061727469616C28746F6B';
wwv_flow_api.g_varchar2_table(82) := '656E2C636F6E746578742C7061727469616C73297B696628217061727469616C732972657475726E3B7661722076616C75653D697346756E6374696F6E287061727469616C73293F7061727469616C7328746F6B656E5B315D293A7061727469616C735B';
wwv_flow_api.g_varchar2_table(83) := '746F6B656E5B315D5D3B69662876616C7565213D6E756C6C2972657475726E20746869732E72656E646572546F6B656E7328746869732E70617273652876616C7565292C636F6E746578742C7061727469616C732C76616C7565297D3B5772697465722E';
wwv_flow_api.g_varchar2_table(84) := '70726F746F747970652E756E6573636170656456616C75653D66756E6374696F6E20756E6573636170656456616C756528746F6B656E2C636F6E74657874297B7661722076616C75653D636F6E746578742E6C6F6F6B757028746F6B656E5B315D293B69';
wwv_flow_api.g_varchar2_table(85) := '662876616C7565213D6E756C6C2972657475726E2076616C75657D3B5772697465722E70726F746F747970652E6573636170656456616C75653D66756E6374696F6E206573636170656456616C756528746F6B656E2C636F6E74657874297B7661722076';
wwv_flow_api.g_varchar2_table(86) := '616C75653D636F6E746578742E6C6F6F6B757028746F6B656E5B315D293B69662876616C7565213D6E756C6C2972657475726E206D757374616368652E6573636170652876616C7565297D3B5772697465722E70726F746F747970652E72617756616C75';
wwv_flow_api.g_varchar2_table(87) := '653D66756E6374696F6E2072617756616C756528746F6B656E297B72657475726E20746F6B656E5B315D7D3B6D757374616368652E6E616D653D226D757374616368652E6A73223B6D757374616368652E76657273696F6E3D22322E322E31223B6D7573';
wwv_flow_api.g_varchar2_table(88) := '74616368652E746167733D5B227B7B222C227D7D225D3B7661722064656661756C745772697465723D6E6577205772697465723B6D757374616368652E636C65617243616368653D66756E6374696F6E20636C656172436163686528297B72657475726E';
wwv_flow_api.g_varchar2_table(89) := '2064656661756C745772697465722E636C656172436163686528297D3B6D757374616368652E70617273653D66756E6374696F6E2070617273652874656D706C6174652C74616773297B72657475726E2064656661756C745772697465722E7061727365';
wwv_flow_api.g_varchar2_table(90) := '2874656D706C6174652C74616773297D3B6D757374616368652E72656E6465723D66756E6374696F6E2072656E6465722874656D706C6174652C766965772C7061727469616C73297B696628747970656F662074656D706C617465213D3D22737472696E';
wwv_flow_api.g_varchar2_table(91) := '6722297B7468726F77206E657720547970654572726F722827496E76616C69642074656D706C617465212054656D706C6174652073686F756C6420626520612022737472696E672220272B276275742022272B747970655374722874656D706C61746529';
wwv_flow_api.g_varchar2_table(92) := '2B27222077617320676976656E2061732074686520666972737420272B22617267756D656E7420666F72206D757374616368652372656E6465722874656D706C6174652C20766965772C207061727469616C732922297D72657475726E2064656661756C';
wwv_flow_api.g_varchar2_table(93) := '745772697465722E72656E6465722874656D706C6174652C766965772C7061727469616C73297D3B6D757374616368652E746F5F68746D6C3D66756E6374696F6E20746F5F68746D6C2874656D706C6174652C766965772C7061727469616C732C73656E';
wwv_flow_api.g_varchar2_table(94) := '64297B76617220726573756C743D6D757374616368652E72656E6465722874656D706C6174652C766965772C7061727469616C73293B696628697346756E6374696F6E2873656E6429297B73656E6428726573756C74297D656C73657B72657475726E20';
wwv_flow_api.g_varchar2_table(95) := '726573756C747D7D3B6D757374616368652E6573636170653D65736361706548746D6C3B6D757374616368652E5363616E6E65723D5363616E6E65723B6D757374616368652E436F6E746578743D436F6E746578743B6D757374616368652E5772697465';
wwv_flow_api.g_varchar2_table(96) := '723D5772697465727D293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(471895700729001907)
,p_plugin_id=>wwv_flow_api.id(471258000703755090)
,p_file_name=>'mustache.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
