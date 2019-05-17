create or replace package body "PRETIUS_APEX_NESTED_REPORTS" is

  ------------------------
  function printAttributes(
    p_dynamic_action_render_result in apex_plugin.t_dynamic_action_render_result
  ) return clob is
    
  begin

    apex_json.initialize_clob_output;

    apex_json.open_object;
    apex_json.write( 'type', 'apex_plugin.t_dynamic_action_render_result' );

    apex_json.write( 'javascript_function'  , p_dynamic_action_render_result.javascript_function  );
    apex_json.write( 'ajax_identifier'      , p_dynamic_action_render_result.ajax_identifier  );
    apex_json.write( 'attribute_01'         , p_dynamic_action_render_result.attribute_01 );
    apex_json.write( 'attribute_02'         , p_dynamic_action_render_result.attribute_02 );
    apex_json.write( 'attribute_03'         , p_dynamic_action_render_result.attribute_03 );
    apex_json.write( 'attribute_04'         , p_dynamic_action_render_result.attribute_04 );
    apex_json.write( 'attribute_05'         , p_dynamic_action_render_result.attribute_05 );
    apex_json.write( 'attribute_06'         , p_dynamic_action_render_result.attribute_06 );
    apex_json.write( 'attribute_07'         , p_dynamic_action_render_result.attribute_07 );
    apex_json.write( 'attribute_08'         , p_dynamic_action_render_result.attribute_08 );
    apex_json.write( 'attribute_09'         , p_dynamic_action_render_result.attribute_09 );
    apex_json.write( 'attribute_10'         , p_dynamic_action_render_result.attribute_10 );
    apex_json.write( 'attribute_11'         , p_dynamic_action_render_result.attribute_11 );
    apex_json.write( 'attribute_12'         , p_dynamic_action_render_result.attribute_12 );
    apex_json.write( 'attribute_13'         , p_dynamic_action_render_result.attribute_13 );
    apex_json.write( 'attribute_14'         , p_dynamic_action_render_result.attribute_14 );
    apex_json.write( 'attribute_15'         , p_dynamic_action_render_result.attribute_15 );

    apex_json.close_object;

    return apex_json.get_clob_output;

  end printAttributes;


  ------------------------
  function printAttributes(
    p_plugin in apex_plugin.t_plugin
  ) return clob is
    
  begin

    apex_json.initialize_clob_output;

    apex_json.open_object;
    apex_json.write( 'type', 'apex_plugin.t_plugin' );

    apex_json.write( 'name'        , p_plugin.name         );
    apex_json.write( 'file_prefix' , p_plugin.file_prefix  );
    apex_json.write( 'attribute_01', p_plugin.attribute_01 );
    apex_json.write( 'attribute_02', p_plugin.attribute_02 );
    apex_json.write( 'attribute_03', p_plugin.attribute_03 );
    apex_json.write( 'attribute_04', p_plugin.attribute_04 );
    apex_json.write( 'attribute_05', p_plugin.attribute_05 );
    apex_json.write( 'attribute_06', p_plugin.attribute_06 );
    apex_json.write( 'attribute_07', p_plugin.attribute_07 );
    apex_json.write( 'attribute_08', p_plugin.attribute_08 );
    apex_json.write( 'attribute_09', p_plugin.attribute_09 );
    apex_json.write( 'attribute_10', p_plugin.attribute_10 );
    apex_json.write( 'attribute_11', p_plugin.attribute_11 );
    apex_json.write( 'attribute_12', p_plugin.attribute_12 );
    apex_json.write( 'attribute_13', p_plugin.attribute_13 );
    apex_json.write( 'attribute_14', p_plugin.attribute_14 );
    apex_json.write( 'attribute_15', p_plugin.attribute_15 );

    apex_json.close_object;

    return apex_json.get_clob_output;

  end printAttributes;

  ------------------------
  function printAttributes(
    p_dynamic_action in apex_plugin.t_dynamic_action
  ) return clob is
    
  begin

    apex_json.initialize_clob_output;

    apex_json.open_object;
    apex_json.write( 'type', 'apex_plugin.t_dynamic_action' );

    apex_json.write( 'id'          , p_dynamic_action.id          , false );
    apex_json.write( 'action'      , p_dynamic_action.action      , false );
    apex_json.write( 'attribute_01', p_dynamic_action.attribute_01, true );
    apex_json.write( 'attribute_02', p_dynamic_action.attribute_02, true );
    apex_json.write( 'attribute_03', p_dynamic_action.attribute_03, true );
    apex_json.write( 'attribute_04', p_dynamic_action.attribute_04, true );
    apex_json.write( 'attribute_05', p_dynamic_action.attribute_05, true );
    apex_json.write( 'attribute_06', p_dynamic_action.attribute_06, true );
    apex_json.write( 'attribute_07', p_dynamic_action.attribute_07, true );
    apex_json.write( 'attribute_08', p_dynamic_action.attribute_08, true );
    apex_json.write( 'attribute_09', p_dynamic_action.attribute_09, true );
    apex_json.write( 'attribute_10', p_dynamic_action.attribute_10, true );
    apex_json.write( 'attribute_11', p_dynamic_action.attribute_11, true );
    apex_json.write( 'attribute_12', p_dynamic_action.attribute_12, true );
    apex_json.write( 'attribute_13', p_dynamic_action.attribute_13, true );
    apex_json.write( 'attribute_14', p_dynamic_action.attribute_14, true );
    apex_json.write( 'attribute_15', p_dynamic_action.attribute_15, true );

    apex_json.close_object;

    return apex_json.get_clob_output;

  end printAttributes;

  --------------------------------
  function getColumnNamesFromQuery(
    p_string in varchar2
  ) return clob is
    v_count   number;
    v_pattern varchar2(50) := '#.+?#';
    
  begin
    apex_json.initialize_clob_output;

    v_count := regexp_count(p_string, v_pattern, 1, 'm');

    apex_json.open_object;
    apex_json.open_array('queryColumns');

    for i in 1..v_count loop
      apex_json.write( trim(both '#' from regexp_substr(p_string, v_pattern, 1, i, 'm') ) );
    end loop;  

    apex_json.close_array;
    apex_json.close_object;

    return apex_json.get_clob_output;
  end;

  -------------------------
  function getBindVariables(
    p_string in varchar2
  ) return clob is
    l_names DBMS_SQL.VARCHAR2_TABLE;
  begin
    l_names := WWV_FLOW_UTILITIES.GET_BINDS( p_string );

    apex_json.initialize_clob_output;

    apex_json.open_object;
    apex_json.open_array('queryItems');

    for i in 1..l_names.count loop
      apex_json.write( trim(both ':' from  l_names(i) ) );
    end loop;  

    apex_json.close_array;
    apex_json.close_object;

    return apex_json.get_clob_output;

  end getBindVariables;

  -------------------------------
  function getPluginAppAttributes(
    p_plugin in apex_plugin.t_plugin
  ) return varchar2 is
    attr_app_expand_time   number  := NVL(p_plugin.attribute_01, 200);
    attr_app_collapse_time number  := NVL(p_plugin.attribute_02, 400);
  begin
    apex_json.initialize_clob_output;

    apex_json.open_object;
    apex_json.open_object('plugin');
    apex_json.write('animationTime',      attr_app_expand_time   );
    apex_json.write('closeOtherDuration', attr_app_collapse_time );
    apex_json.close_object;
    apex_json.close_object;

    return apex_json.get_clob_output;

  end getPluginAppAttributes;

  ----------------------------
  function pretius_row_details (
    p_dynamic_action in apex_plugin.t_dynamic_action,
    p_plugin         in apex_plugin.t_plugin 
  ) return apex_plugin.t_dynamic_action_render_result
  is
    l_result apex_plugin.t_dynamic_action_render_result;

    l_attr_nestedQuery      varchar2(32767) := p_dynamic_action.attribute_01;
    l_attr_dc_settings      varchar2(100)   := p_dynamic_action.attribute_02;

    l_attr_mode             varchar2(100)   := p_dynamic_action.attribute_03;
    l_attr_customTemplate   varchar2(32767) := p_dynamic_action.attribute_04;
    l_attr_customCallback   varchar2(32767) := p_dynamic_action.attribute_05;
    l_attr_bgColor          varchar2(20)    := NVL( p_dynamic_action.attribute_06, '#EBEBEB' );
    l_attr_setMaxHeight     number          := p_dynamic_action.attribute_07;
    l_attr_borderColor      varchar2(20)    := NVL( p_dynamic_action.attribute_08, '#c5c5c5' );
    l_attr_highlightColor   varchar2(20)    := NVL( p_dynamic_action.attribute_09, '#F2F2F2' );
    l_attr_cc_settings      varchar2(100)   := p_dynamic_action.attribute_10;
    l_attr_noDataFound      varchar2(32767) := p_dynamic_action.attribute_11;
    l_attr_spinnerOptions   varchar2(100)   := NVL( p_dynamic_action.attribute_12, 'ATR' );
    l_attr_defaultTemplate  varchar2(4000)  := NVL(p_dynamic_action.attribute_13,  '#DEFAULT_TEMPLATE#');
    l_attr_dt_settings      varchar2(100)   := p_dynamic_action.attribute_14;
    /*
    p_dynamic_action.attribute_12;
    p_dynamic_action.attribute_13;
    p_dynamic_action.attribute_14;
    p_dynamic_action.attribute_15;  
    */
    attr_app_embedMustache boolean := CASE WHEN p_plugin.attribute_03 = 'Y' then true else false end;

  begin
    l_result.ajax_identifier     := wwv_flow_plugin.get_ajax_identifier;
    l_result.javascript_function := '
      function(){
        pretiusNestedReport(this, '||getColumnNamesFromQuery( l_attr_nestedQuery )||', '||getBindVariables( l_attr_nestedQuery )||', true, '||getPluginAppAttributes( p_plugin )||');
      }
    ';
    --l_result.attribute_01        := p_dynamic_action.attribute_01; --tajne, bo to zapytaie SQL, ktore mogloby byc dostepne przez this.options
    l_result.attribute_02        := l_attr_dc_settings;
    l_result.attribute_03        := l_attr_mode;
    l_result.attribute_04        := l_attr_customTemplate;
    l_result.attribute_05        := l_attr_customCallback;
    l_result.attribute_06        := l_attr_bgColor;
    l_result.attribute_07        := l_attr_setMaxHeight;
    l_result.attribute_08        := l_attr_borderColor;
    l_result.attribute_09        := l_attr_highlightColor;
    l_result.attribute_10        := l_attr_cc_settings;
    l_result.attribute_11        := l_attr_noDataFound;
    l_result.attribute_12        := l_attr_spinnerOptions;
    l_result.attribute_13        := l_attr_defaultTemplate;
    l_result.attribute_14        := l_attr_dt_settings;
    --l_result.attribute_15        := p_dynamic_action.attribute_15;

    --add mustache library
    if attr_app_embedMustache then

      apex_javascript.add_library(
        p_name => 'mustache', 
        p_directory => p_plugin.file_prefix, 
        p_version => null 
      );

    end if;

    if apex_application.G_DEBUG then

      APEX_PLUGIN_UTIL.DEBUG_DYNAMIC_ACTION (
        p_plugin         => p_plugin,
        p_dynamic_action => p_dynamic_action
      );

      apex_javascript.add_onload_code ('
        apex.debug.info("p_dynamic_action", '||printAttributes( p_dynamic_action )||');
        apex.debug.info("p_plugin",         '||printAttributes( p_plugin )||');
        apex.debug.info("l_result",         '||printAttributes( l_result )||');
      ');

    end if;

    return l_result;

  end pretius_row_details;

  --------------------
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

  -----------------------
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
          return sqlerrm;--||': '||chr(10)||chr(10)||l_source_query;
      end;
    end if;

    return null;
  exception
    when others then
      return SQLERRM;--||':'||chr(10)||chr(10)||p_query;
  end is_valid_query;

  ----------------------------
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

  ---------------------------------
  function pretius_row_details_ajax(
    p_dynamic_action in apex_plugin.t_dynamic_action,
    p_plugin         in apex_plugin.t_plugin 
  ) return apex_plugin.t_dynamic_action_ajax_result
  is
    l_status              number;
    l_desc_col_no         number          := 0;

    l_ajax_column_name    varchar2(4000);
    l_ajax_column_values  varchar2(4000);

    l_sql                 varchar2(32767);
    l_delimeter           varchar2(1)     := ':';
    l_parseResult         varchar2(4000);

    l_result              apex_plugin.t_dynamic_action_ajax_result;
    
    l_columnNames         apex_application_global.vc_arr2;
    l_columnValues        apex_application_global.vc_arr2;

    l_sys_cursor          sys_refcursor;

    l_cursor              pls_integer;

    l_desc_col_info       sys.dbms_sql.desc_tab2;

    l_apex_items_names    DBMS_SQL.VARCHAR2_TABLE;
  begin

    l_ajax_column_name    := apex_application.g_x01;
    l_ajax_column_values  := apex_application.g_x02;

    l_sql                 := p_dynamic_action.attribute_01;
    l_apex_items_names    := WWV_FLOW_UTILITIES.GET_BINDS( l_sql );

    l_columnNames         := apex_util.string_to_table( l_ajax_column_name  , l_delimeter );
    l_columnValues        := apex_util.string_to_table( l_ajax_column_values, l_delimeter );
    
    if l_columnNames.count <> l_columnValues.count then
      apex_json.open_object;
      apex_json.write('addInfo', 'The number of column names must be equal to the number of column values.</br>Check whether the query columns exist in parent report.');
      apex_json.write('error', 'Column names = "'||l_ajax_column_name||'"'||chr(10)||'Column values = "'||l_ajax_column_values||'"');
      apex_json.close_object;
      return null;      
    end if;

    --replacing space within column name is required to work with column aliases
    for i in 1..l_columnNames.count loop
      l_sql := replace( l_sql, chr(39)||'#'||l_columnNames(i)||'#'||chr(39) , ':' || replace(l_columnNames(i), ' ', '') );  
      l_sql := replace( l_sql, '#'||l_columnNames(i)||'#'                   , ':' || replace(l_columnNames(i), ' ', '') );  
    end loop;

    l_parseResult := is_valid_query( l_sql );

    if l_parseResult is not null then
      apex_json.open_object;
      apex_json.write('addInfo', 'Nested report SQL query is not valid');
      apex_json.write('error', l_parseResult);
      --apex_json.write('query', l_sql);
      apex_json.close_object;
      return null;
    end if;

    -- open l_cursor;
    l_cursor := dbms_sql.open_cursor;
    dbms_sql.parse (l_cursor, l_sql, dbms_sql.native);

    -- bind items
    begin

      for i in 1..l_apex_items_names.count loop
        dbms_sql.bind_variable (l_cursor, l_apex_items_names(i), v( trim(both ':' from l_apex_items_names(i)) ) );
      end loop;

    exception
      when others then
        apex_json.open_object;
        apex_json.write('addInfo', 'While binding APEX items error occured');
        apex_json.write('error', SQLERRM);
        apex_json.close_object;
        return null;      
    end;

    --bind all the values
    --replacing space within column name is required to work with column aliases
    begin
      for i in 1 .. l_columnNames.count loop
        dbms_sql.bind_variable (l_cursor, replace(l_columnNames(i), ' ', ''), l_columnValues(i));
      end loop;
    exception
      when others then
        apex_json.open_object;
        apex_json.write('addInfo', 'While binding query variables error occured');
        apex_json.write('error', SQLERRM);
        apex_json.close_object;
        return null;      
    end;

    -- describe columns
    sys.dbms_sql.describe_columns2( l_cursor, l_desc_col_no , l_desc_col_info);

    begin
      l_status := dbms_sql.execute(l_cursor);
    exception
      when others then
        apex_json.open_object;
        apex_json.write('addInfo', 'While executing query error occured ');
        apex_json.write('error', SQLERRM);
        apex_json.close_object;
        return null;      
    end;

    l_sys_cursor := dbms_sql.to_refcursor(l_cursor);  

    --apex_json.initialize_clob_output;

    apex_json.open_object;
    apex_json.write( 'data', l_sys_cursor );
    apex_json.open_array('headers');

    for i in 1..l_desc_col_no loop
      apex_json.open_object;
      apex_json.write('COLUMN_NAME', l_desc_col_info(i).col_name);
      apex_json.write('COLUMN_TYPE', getColumnTypeString( l_desc_col_info(i).col_type ) );
      apex_json.close_object;
    end loop;
    
    apex_json.close_array;
    
    apex_json.write( 'x01', l_ajax_column_name, true );
    apex_json.write( 'x02', l_ajax_column_values, true );

    apex_json.close_object;

    --htp.p( apex_json.get_clob_output );

    return l_result;
  exception
    when others then
      apex_json.open_object;
      apex_json.write('addInfo', 'Unknown ajax error');
      apex_json.write('error', SQLERRM);
      apex_json.close_object;
      htp.p( apex_json.get_clob_output );
      return l_result;
  end pretius_row_details_ajax;
  
end "PRETIUS_APEX_NESTED_REPORTS";
