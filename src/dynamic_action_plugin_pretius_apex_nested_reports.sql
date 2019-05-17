prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_050100 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2016.08.24'
,p_release=>'5.1.4.00.08'
,p_default_workspace_id=>1680777737499838
,p_default_application_id=>2001
,p_default_owner=>'APEXCONNECT'
);
end;
/
prompt --application/shared_components/plugins/dynamic_action/pretius_apex_nested_reports
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(3079739495676097012)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'PRETIUS_APEX_NESTED_REPORTS'
,p_display_name=>'Pretius APEX Nested Reports'
,p_category=>'EXECUTE'
,p_supported_ui_types=>'DESKTOP'
,p_javascript_file_urls=>wwv_flow_string.join(wwv_flow_t_varchar2(
'#PLUGIN_FILES#pretius_main.js',
'#PLUGIN_FILES#pretius_nestedreport.js',
''))
,p_css_file_urls=>'#PLUGIN_FILES#pretius_row_details_styles.css'
,p_api_version=>1
,p_render_function=>'#OWNER#.PRETIUS_APEX_NESTED_REPORTS.pretius_row_details'
,p_ajax_function=>'#OWNER#.PRETIUS_APEX_NESTED_REPORTS.pretius_row_details_ajax'
,p_standard_attributes=>'REGION:JQUERY_SELECTOR:REQUIRED'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'  The plugin is dynamic action plugin implementing nested reports within APEX Classic Reports, Interactive Reports and static HTML tables. Scope of data, data appearance and behavior is customizable with the plugin attributes.',
'</p>',
'<p>',
'  Author: <code>Bartosz Ostrowski</code><br/>',
'  E-mail: <code>bostrowski@pretius.com</code>, <code>ostrowski.bartosz@gmail.com</code><br/>',
'  Twitter: <code>@bostrowsk1</code><br/>',
'  Plugin home page: <code>http://apex.pretius.com/apex/f?p=PLUGINS:NESTED_REPORTS</code>',
'</p>'))
,p_version_identifier=>'2.0.2'
,p_about_url=>'http://apex.pretius.com/apex/f?p=PLUGINS:NESTED_REPORTS'
,p_files_version=>319
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(1587034218244928903)
,p_plugin_id=>wwv_flow_api.id(3079739495676097012)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'Expanding time'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'200'
,p_unit=>'ms'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(1587059378562934612)
,p_plugin_id=>wwv_flow_api.id(3079739495676097012)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Collapsing time'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'400'
,p_unit=>'ms'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(3079739683264097015)
,p_plugin_id=>wwv_flow_api.id(3079739495676097012)
,p_attribute_scope=>'APPLICATION'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Include Mustache library'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'Y'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(3079740062350097015)
,p_plugin_attribute_id=>wwv_flow_api.id(3079739683264097015)
,p_display_sequence=>10
,p_display_value=>'Yes'
,p_return_value=>'Y'
,p_help_text=>'Mustache library will be included.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(3079740577154097016)
,p_plugin_attribute_id=>wwv_flow_api.id(3079739683264097015)
,p_display_sequence=>20
,p_display_value=>'No'
,p_return_value=>'N'
,p_help_text=>'Mustache library won''t be included. This library is essential for the plugin to work.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(3079741128608097016)
,p_plugin_id=>wwv_flow_api.id(3079739495676097012)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>1010
,p_prompt=>'Details query'
,p_attribute_type=>'SQL'
,p_is_required=>true
,p_is_translatable=>false
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
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
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'  Enter valid SQL query that returns at least one row. Fetched data is rendered in default or custom template depending on the plugin configuration.',
'</p>',
'<h4>',
'  Narrowing results',
'</h4>',
'<p>',
'  Condition value(s) should be column(s) name(s) from parent region enclosed by # characters (or parent report column aliases if used).',
'</p>',
'<pre>',
'...',
'where',
'  COLUMN_ID = ''#COLUMN_ID#''',
'</pre>',
'<h4>',
'  How does it work?',
'</h4>',
'<p>',
'  When column name is enclosed by <code>#</code> characters and dynamic action is triggered, the plugin scans triggering element table row for DOM elements matching one of following jQuery selectors:',
'</p>',
'<pre>',
'$(''[headers="COLUMN_ID"]'').text() or',
'$(''[headers="NR_COLUMN_ID"]'').text() or',
'$(''span[class*="COLUMN_ID"]'').text()',
'</pre>',
'<p>',
'  It means that the plugin looks for value from GUI witin',
'</p>',
'<ul>',
'  <li>TD element with header attribute set to <code>COLUMN_ID</code> (Classic report, Interactive report) or</li>',
'  <li>TD element with header attribute set to <code>NR_COLUMN_ID</code> (Nested reports) or</li>',
'  <li>span element with class COLUMN_ID (universal)</li>',
'</ul>',
'<p>',
'  The text value from matched element is used to replace #COLUMN_ID# in details row attribute.',
'</p>',
'<p>',
'  The safest way of binding GUI report with the plugin query is to use ',
'</p>',
'<pre><code><span class="COLUMN_NAME" style="display:none">#COLUMN_NAME#</span></code></pre>',
'<p>',
'  next to nested report''s triggering element (e.g. anchor).',
'</p>',
'<h4>',
'  Custom columns heading',
'</h4>',
'<p>',
'  Custom column headings can be used in <code>Default template</code>.',
'</p>',
'<ul>',
'  <li>To create nested report with empty heading use column alias <code>DERIVIED<XX>_EMPTY</code> </li>',
'  <li>To create nested report with font awesome icon heading use column alias <code>DERIVIED<XX>_FA_<NAME></code> </li>',
'</ul>   ',
'<p>',
'  where ',
'</p>',
'<ul>',
'  <li><XX> is 2 digits string e.g. 01</li>',
'  <li><NAME> is icon class name with "_" instead of "-" (e.g. SEARCH or SITE_MAP)</li>',
'</ul>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(3079741523857097017)
,p_plugin_id=>wwv_flow_api.id(3079739495676097012)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>7
,p_prompt=>'Default callback options'
,p_attribute_type=>'CHECKBOXES'
,p_is_required=>false
,p_default_value=>'CE:AA:CR'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(3079744359692097018)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'DTDC,CTDC'
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'  This attribute allows you to add extra functionalities to nested report rendered in new report row.',
'</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(3079741930119097017)
,p_plugin_attribute_id=>wwv_flow_api.id(3079741523857097017)
,p_display_sequence=>5
,p_display_value=>'Cache results'
,p_return_value=>'CR'
,p_help_text=>'If this option checked, <b>Details query</b> resulting data is cached on first plugin use.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(3079742376224097017)
,p_plugin_attribute_id=>wwv_flow_api.id(3079741523857097017)
,p_display_sequence=>10
,p_display_value=>'Collapse expanded'
,p_return_value=>'CE'
,p_help_text=>'If this option checked, every expanded row will be collapsed before new row is expanded.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(3079742876693097017)
,p_plugin_attribute_id=>wwv_flow_api.id(3079741523857097017)
,p_display_sequence=>20
,p_display_value=>'Set max height'
,p_return_value=>'SMH'
,p_help_text=>'If this option checked, max-height property is added to expanded row. Value in pixels must be provided in <strong>Set max height</strong> attribute.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(3079743412624097017)
,p_plugin_attribute_id=>wwv_flow_api.id(3079741523857097017)
,p_display_sequence=>30
,p_display_value=>'Add animation'
,p_return_value=>'AA'
,p_help_text=>'If this option checked, animation is added while expanding / collapsing row.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(1206579294645794474)
,p_plugin_attribute_id=>wwv_flow_api.id(3079741523857097017)
,p_display_sequence=>40
,p_display_value=>'Loading indicator'
,p_return_value=>'LI'
,p_help_text=>'If this option is checked, loading indicator is shown each time plugin fetches data from db (AJAX). Loading indicator style can be set in <strong>Loading indicator style</strong> attribute.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(3079744359692097018)
,p_plugin_id=>wwv_flow_api.id(3079739495676097012)
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
 p_id=>wwv_flow_api.id(3079744782789097018)
,p_plugin_attribute_id=>wwv_flow_api.id(3079744359692097018)
,p_display_sequence=>10
,p_display_value=>'Default template & default callback'
,p_return_value=>'DTDC'
,p_help_text=>'Default plugin behaviour. Resulting rows of data are rendered in default template (table of data) along with default callback settings.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(3079745335726097018)
,p_plugin_attribute_id=>wwv_flow_api.id(3079744359692097018)
,p_display_sequence=>20
,p_display_value=>'Default template & custom callback'
,p_return_value=>'DTCC'
,p_help_text=>'When this option is selected, resulting rows of data are rendered with template provided in custom template attribute.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(3079745804202097018)
,p_plugin_attribute_id=>wwv_flow_api.id(3079744359692097018)
,p_display_sequence=>30
,p_display_value=>'Custom template & default callback'
,p_return_value=>'CTDC'
,p_help_text=>'When this option is selected, resulting rows of data are rendered with default template and custom JS callback function defined in custom callback attribute.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(3079746248712097019)
,p_plugin_attribute_id=>wwv_flow_api.id(3079744359692097018)
,p_display_sequence=>40
,p_display_value=>'Custom template & custom callback'
,p_return_value=>'CTCC'
,p_help_text=>'When this option is selected, developer decides how template for resulting rows of data is build and how results should be displayed after receiving rows from database.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(3079746748930097019)
,p_plugin_id=>wwv_flow_api.id(3079739495676097012)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>1020
,p_prompt=>'Custom template'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(3079744359692097018)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'CTDC,CTCC'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
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
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
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
 p_id=>wwv_flow_api.id(3079747165437097019)
,p_plugin_id=>wwv_flow_api.id(3079739495676097012)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>1015
,p_prompt=>'Custom callback'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(3079744359692097018)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'DTCC,CTCC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
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
 p_id=>wwv_flow_api.id(3079747616227097019)
,p_plugin_id=>wwv_flow_api.id(3079739495676097012)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Background color'
,p_attribute_type=>'COLOR'
,p_is_required=>true
,p_default_value=>'#EBEBEB'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(3079744359692097018)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'DTDC,CTDC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Pick HEX color to be applied as background color for retrieved rows.</p>',
'<dl>',
'  <dt>Default value</dt>',
'  <dd>#EBEBEB</dd>',
'</dl>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(3079747955704097019)
,p_plugin_id=>wwv_flow_api.id(3079739495676097012)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>100
,p_prompt=>'Set max height'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'300'
,p_unit=>'px'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(3079741523857097017)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'SMH'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
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
 p_id=>wwv_flow_api.id(3079748399411097020)
,p_plugin_id=>wwv_flow_api.id(3079739495676097012)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Border color'
,p_attribute_type=>'COLOR'
,p_is_required=>true
,p_default_value=>'#c5c5c5'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(3079744359692097018)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'DTDC,CTDC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
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
 p_id=>wwv_flow_api.id(3079748749055097020)
,p_plugin_id=>wwv_flow_api.id(3079739495676097012)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Highlight row color'
,p_attribute_type=>'COLOR'
,p_is_required=>true
,p_default_value=>'#e3e3e3'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(3079744359692097018)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'DTDC,CTDC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
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
 p_id=>wwv_flow_api.id(3079749230147097020)
,p_plugin_id=>wwv_flow_api.id(3079739495676097012)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>55
,p_prompt=>'Custom callback settings'
,p_attribute_type=>'CHECKBOXES'
,p_is_required=>false
,p_default_value=>'CR:LI'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(3079744359692097018)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'NOT_IN_LIST'
,p_depending_on_expression=>'DTDC,CTDC'
,p_lov_type=>'STATIC'
,p_help_text=>'Custom callback attribute allows you to add extra efects to rendered data.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(3079749554103097020)
,p_plugin_attribute_id=>wwv_flow_api.id(3079749230147097020)
,p_display_sequence=>10
,p_display_value=>'Cache results'
,p_return_value=>'CR'
,p_help_text=>'If checked the result of the SQL query is retrieved only once for the specified table cell or jQuery selector.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(3079750574372097021)
,p_plugin_id=>wwv_flow_api.id(3079739495676097012)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>1015
,p_prompt=>'When no data found'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>false
,p_default_value=>'No data found'
,p_max_length=>4000
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(3079744359692097018)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'DTDC,CTDC'
,p_help_text=>'Enter text or HTML to be displayed when details query returns 0 rows.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(3065743898743995163)
,p_plugin_id=>wwv_flow_api.id(3079739495676097012)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>15
,p_prompt=>'Loading indicator style'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'ATR'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(3079741523857097017)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'LI'
,p_lov_type=>'STATIC'
,p_help_text=>'This attributes allows you to choose prefered style of loading indicator while fetching data.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(3065747473631016122)
,p_plugin_attribute_id=>wwv_flow_api.id(3065743898743995163)
,p_display_sequence=>10
,p_display_value=>'Aligned to report'
,p_return_value=>'ATR'
,p_is_quick_pick=>true
,p_help_text=>'Loading indicator is aligned to center of affected elements.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(3065747939242017165)
,p_plugin_attribute_id=>wwv_flow_api.id(3065743898743995163)
,p_display_sequence=>20
,p_display_value=>'Aligned to cell'
,p_return_value=>'ATC'
,p_is_quick_pick=>true
,p_help_text=>'Loading indicator is aligned to parent cell of triggering element.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(3065748341218018972)
,p_plugin_attribute_id=>wwv_flow_api.id(3065743898743995163)
,p_display_sequence=>30
,p_display_value=>'Cell icon spinner'
,p_return_value=>'CIS'
,p_help_text=>'Loading indicator is embeded within cell after triggering element.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(3065955622178348821)
,p_plugin_attribute_id=>wwv_flow_api.id(3065743898743995163)
,p_display_sequence=>40
,p_display_value=>'Replace cell content'
,p_return_value=>'RCC'
,p_help_text=>'Loading indicator replaces cell content. After AJAX finishes fetching data, cell content is restored to initial content.'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(1961097848885689150)
,p_plugin_id=>wwv_flow_api.id(3079739495676097012)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>13
,p_display_sequence=>12
,p_prompt=>'Default template HTML'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>false
,p_default_value=>'#DEFAULT_TEMPLATE#'
,p_max_length=>4000
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(1961345977778675003)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'EDT'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<strong>Expand all</strong>',
'<p>',
'  Force all child nested reports to expand on anchor click (where triggering element has class <code>showPersonal</code>)',
'</p>',
'<pre><code><a href="javascript: void(0)" class="nestedreport--expandAll" selector=".showPersonal">Expand all</a></code></pre>',
'<br/>',
'',
'<strong>Refresh</strong>',
'<p>',
'  Force current nested report to refresh itself (template and data).',
'</p>',
'<pre><code><a href="javascript: void(0)" title="Collapse all expanded" class="nestedreport--refresh">Refresh</a></code></pre>',
'',
'<br/>',
'',
'<strong>Collapse all expanded</strong>',
'<p>',
'  Force child expanded nested reports to collapse on anchor click. Adding attribute <code>duration</code> to anchor will force plugin to override animation duration with given number of miliseconds.',
'</p>',
'<pre><code><a href="javascript: void(0)" title="Collapse all expanded" class="nestedreport--slideupAll" duration="200">Collapse all</a></code></pre>',
'',
'<br/>',
'',
'<strong>Collapse</strong>',
'<p>',
'  Force current nested report to collapse. Adding attribute <code>duration</code> to anchor will force plugin to override animation duration with given number of miliseconds.',
'</p>',
'<pre><code><a href="javascript: void(0)" title="Collapse all expanded" class="nestedreport--slideupAll" duration="200">Collapse all</a></code></pre>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>',
'Any HTML applied before or after <code>#DEFAULT_TEMPLATE#</code> will be included in <code>default template</code>.',
'</p>',
'<p>',
'Manual events are supported witin default template (check examples). Manual events are bound to elements with specific class.',
'</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(1961345977778675003)
,p_plugin_id=>wwv_flow_api.id(3079739495676097012)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>14
,p_display_sequence=>10
,p_prompt=>'Default template options'
,p_attribute_type=>'CHECKBOXES'
,p_is_required=>false
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(3079744359692097018)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'DTDC,DTCC'
,p_lov_type=>'STATIC'
,p_help_text=>'This attribute allows you to add extra funcionalities to nested report rendered in HTML data.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(1961446949341682681)
,p_plugin_attribute_id=>wwv_flow_api.id(1961345977778675003)
,p_display_sequence=>20
,p_display_value=>'Strech report'
,p_return_value=>'SR'
,p_help_text=>'If this options is checked, nested report table is streched to 100% width of parent row.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(1961447356106683147)
,p_plugin_attribute_id=>wwv_flow_api.id(1961345977778675003)
,p_display_sequence=>30
,p_display_value=>'Sorting data'
,p_return_value=>'SD'
,p_help_text=>'If this option is checked, nested report supports sorting via column headings. Data is sorted using JavaScript function. Sort function supports NUMBER and VARCHAR2 column type.'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(1961598613741717324)
,p_plugin_attribute_id=>wwv_flow_api.id(1961345977778675003)
,p_display_sequence=>40
,p_display_value=>'Extend default template'
,p_return_value=>'EDT'
,p_help_text=>'If this option is checked, default template can be extended with additional HTML before and after nested report. See <strong>Default template HTML</strong> attribute for more informations.'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(2709266831347171748)
,p_plugin_id=>wwv_flow_api.id(3079739495676097012)
,p_name=>'pretius_default_callback'
,p_display_name=>'Default callback'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '242E7769646765742827707265746975732E6E65737465645265706F7274272C207B0D0A202064656661756C7454656D706C6174654D61726B65723A20272344454641554C545F54454D504C41544523272C0D0A2020636C61737365733A207B0D0A2020';
wwv_flow_api.g_varchar2_table(2) := '20206E65737465645265706F72745472436F6E7461696E6572202020202020203A2027707265746975735F706C7567696E5F726F77272C0D0A202020206E65737465645265706F7274446976436F6E7461696E65722020202020203A2027726F77446574';
wwv_flow_api.g_varchar2_table(3) := '61696C73436F6E7461696E6572272C200D0A202020206E65737465645265706F72744F766572666C6F77436F6E7461696E6572203A20276F766572666C6F77272C0D0A202020206E65737465645265706F72744865616465722020202020202020202020';
wwv_flow_api.g_varchar2_table(4) := '203A2027742D5265706F72742D636F6C48656164272C0D0A202020206E65737465645265706F727443656C6C20202020202020202020202020203A2027742D5265706F72742D63656C6C272C0D0A202020206E65737465645265706F72745461626C6520';
wwv_flow_api.g_varchar2_table(5) := '2020202020202020202020203A2027742D5265706F72742D7265706F7274272C0D0A202020207464457870616E64656420202020202020202020202020202020202020203A2027707265746975732D2D657870616E646564272C0D0A20202020616A6178';
wwv_flow_api.g_varchar2_table(6) := '496E64696361746F7252696768742020202020202020202020203A2027707265746975732D2D616A6178496E64696361746F7220666C6F61745269676874272C0D0A20202020616A6178496E64696361746F72436F6E74656E7420202020202020202020';
wwv_flow_api.g_varchar2_table(7) := '3A2027707265746975732D2D616A6178496E64696361746F7220636F6E74656E74272C0D0A20202020616A6178496E64696361746F7249636F6E202020202020202020202020203A202766612066612D7370696E202066612D72656672657368272C0D0A';
wwv_flow_api.g_varchar2_table(8) := '202020207461626C655374726563685265706F7274202020202020202020202020203A2027707265746975732D2D7374726563685265706F7274270D0A20207D2C0D0A0D0A0D0A20206572726F7254797065733A207B0D0A2020202027636F6E66696775';
wwv_flow_api.g_varchar2_table(9) := '726174696F6E273A207B0D0A202020202020277469746C65273A2027506C7567696E20636F6E66696775726174696F6E206572726F72270D0A202020207D2C0D0A202020202F2A0D0A20202020276A617661736372697074273A207B0D0A202020202020';
wwv_flow_api.g_varchar2_table(10) := '277469746C65273A2027506C7567696E204A617661536372697074206572726F72270D0A202020207D0D0A202020202A2F0D0A2020202027637573746F6D46756E6374696F6E273A207B0D0A202020202020277469746C65273A2027506C7567696E2063';
wwv_flow_api.g_varchar2_table(11) := '7573746F6D2063616C6C6261636B206572726F72270D0A202020207D2C0D0A2020202027616A6178273A207B0D0A202020202020277469746C65273A2027506C7567696E20414A4158206572726F72270D0A202020207D0D0A20207D2C0D0A2F2F0D0A2F';
wwv_flow_api.g_varchar2_table(12) := '2F0D0A20205F6372656174653A2066756E6374696F6E28297B0D0A20202020766172206E6F744D617463686564436F6C756D6E2C206572726F722C206E6F74466F756E644974656D733B0D0A202020200D0A20202020746869732E5F7375706572282074';
wwv_flow_api.g_varchar2_table(13) := '6869732E6F7074696F6E7320293B0D0A0D0A20202020746869732E73657474696E6773203D207B0D0A202020202020616E696D6174696F6E54696D652020202020202020203A20746869732E6F7074696F6E732E706C7567696E2E616E696D6174696F6E';
wwv_flow_api.g_varchar2_table(14) := '54696D652C0D0A202020202020636C6F73654F746865724475726174696F6E202020203A20746869732E6F7074696F6E732E706C7567696E2E636C6F73654F746865724475726174696F6E2C0D0A2020202020206973437573746F6D43616C6C6261636B';
wwv_flow_api.g_varchar2_table(15) := '2020202020203A20746869732E5F676574506C756741747472466C61672820273033272C20274343272020292C0D0A2020202020206973437573746F6D54656D706C6174652020202020203A20746869732E5F676574506C756741747472466C61672820';
wwv_flow_api.g_varchar2_table(16) := '273033272C20274354272020292C0D0A202020202020697344656661756C7443616C6C6261636B20202020203A20746869732E5F676574506C756741747472466C61672820273033272C20274443272020292C0D0A202020202020697344656661756C74';
wwv_flow_api.g_varchar2_table(17) := '54656D706C61746520202020203A20746869732E5F676574506C756741747472466C61672820273033272C20274454272020292C0D0A20202020202069735365744D617848656967687420202020202020203A20746869732E5F676574506C7567417474';
wwv_flow_api.g_varchar2_table(18) := '72466C61672820273032272C2027534D482720292C0D0A2020202020202F2F0D0A20202020202069735374726563685265706F727420202020202020203A20746869732E5F676574506C756741747472466C61672820273134272C20275352272020292C';
wwv_flow_api.g_varchar2_table(19) := '0D0A2020202020206973536F7274696E67537570706F72746564202020203A20746869732E5F676574506C756741747472466C61672820273134272C20275344272020292C0D0A2020202020206973457874656E6444656661756C7454706C202020203A';
wwv_flow_api.g_varchar2_table(20) := '20746869732E5F676574506C756741747472466C61672820273134272C20274544542720292C0D0A2020202020202F2F0D0A20202020202069734C6F6164696E67496E64696361746F72202020203A20746869732E5F676574506C756741747472466C61';
wwv_flow_api.g_varchar2_table(21) := '672820273032272C20274C49272020292C0D0A20202020202069735370696E6E6572546449636F6E202020202020203A20746869732E5F676574506C756741747472466C61672820273132272C20274349532720292C0D0A20202020202069735370696E';
wwv_flow_api.g_varchar2_table(22) := '6E65725265706F7274202020202020203A20746869732E5F676574506C756741747472466C61672820273132272C20274154522720292C0D0A20202020202069735370696E6E6572546443656C6C202020202020203A20746869732E5F676574506C7567';
wwv_flow_api.g_varchar2_table(23) := '41747472466C61672820273132272C20274154432720292C0D0A20202020202069735370696E6E65725464436F6E74656E74202020203A20746869732E5F676574506C756741747472466C61672820273132272C20275243432720292C0D0A0D0A202020';
wwv_flow_api.g_varchar2_table(24) := '2020206973436F6C6C61707365457861706E646564202020203A20746869732E5F676574506C756741747472466C61672820273032272C20274345272020292C0D0A2020202020206973416464416E696D6174696F6E20202020202020203A2074686973';
wwv_flow_api.g_varchar2_table(25) := '2E5F676574506C756741747472466C61672820273032272C20274141272020292C0D0A20202020202069734361636865526573756C747320202020202020203A20746869732E5F676574506C756741747472466C61672820273032272C20274352272020';
wwv_flow_api.g_varchar2_table(26) := '29207C7C20746869732E5F676574506C756741747472466C61672820273130272C20274352272020292C0D0A2020202020206E6F44617461466F756E6420202020202020202020203A20746869732E6F7074696F6E732E616374696F6E2E617474726962';
wwv_flow_api.g_varchar2_table(27) := '75746531312C0D0A202020202020637573746F6D43616C6C6261636B4A732020202020203A20746869732E6F7074696F6E732E616374696F6E2E61747472696275746530352C0D0A202020202020637573746F6D54656D706C6174652020202020202020';
wwv_flow_api.g_varchar2_table(28) := '3A20746869732E6F7074696F6E732E616374696F6E2E61747472696275746530342C0D0A202020202020626F72646572436F6C6F7220202020202020202020203A20746869732E6F7074696F6E732E616374696F6E2E61747472696275746530382C0D0A';
wwv_flow_api.g_varchar2_table(29) := '2020202020206267436F6C6F722020202020202020202020202020203A20746869732E6F7074696F6E732E616374696F6E2E61747472696275746530362C0D0A2020202020204267436F6C6F72686967686C696768742020202020203A20746869732E6F';
wwv_flow_api.g_varchar2_table(30) := '7074696F6E732E616374696F6E2E61747472696275746530392C0D0A2020202020206D6178486569676874202020202020202020202020203A207061727365496E7428746869732E6F7074696F6E732E616374696F6E2E6174747269627574653037292C';
wwv_flow_api.g_varchar2_table(31) := '0D0A202020202020697344656661756C7454656D706174654D61726B65723A20746869732E6F7074696F6E732E616374696F6E2E6174747269627574653133203D3D206E756C6C207C7C20746869732E6F7074696F6E732E616374696F6E2E6174747269';
wwv_flow_api.g_varchar2_table(32) := '6275746531332E7365617263682820746869732E64656661756C7454656D706C6174654D61726B65722029203D3D202D31203F2066616C7365203A20747275652C0D0A20202020202064656661756C7454656D706C6174654265666F7265203A20746869';
wwv_flow_api.g_varchar2_table(33) := '732E6F7074696F6E732E616374696F6E2E6174747269627574653133203D3D206E756C6C203F206E756C6C203A20273C64697620636C6173733D226265666F72654E65737465645265706F7274223E272B746869732E6F7074696F6E732E616374696F6E';
wwv_flow_api.g_varchar2_table(34) := '2E61747472696275746531332E73706C69742820746869732E64656661756C7454656D706C6174654D61726B657220295B305D2B273C2F6469763E272C0D0A20202020202064656661756C7454656D706C617465416674657220203A20746869732E6F70';
wwv_flow_api.g_varchar2_table(35) := '74696F6E732E616374696F6E2E6174747269627574653133203D3D206E756C6C203F206E756C6C203A20273C64697620636C6173733D2261667465724E65737465645265706F7274223E272B746869732E6F7074696F6E732E616374696F6E2E61747472';
wwv_flow_api.g_varchar2_table(36) := '696275746531332E73706C69742820746869732E64656661756C7454656D706C6174654D61726B657220295B315D2B273C2F6469763E270D0A202020207D3B0D0A0D0A20202020746869732E7464202020202020202020202020202020203D2074686973';
wwv_flow_api.g_varchar2_table(37) := '2E656C656D656E742E6973282774642729203F20746869732E656C656D656E74203A20746869732E656C656D656E742E636C6F736573742827746427293B0D0A0D0A20202020746869732E6166666563746564456C656D656E742020203D20746869732E';
wwv_flow_api.g_varchar2_table(38) := '6F7074696F6E732E6166666563746564456C656D656E74733B0D0A202020202F2F636C6F73657374207461626C6520746F2074726967676572696E6720656C656D656E740D0A20202020746869732E7461626C65202020202020202020202020203D2074';
wwv_flow_api.g_varchar2_table(39) := '6869732E74642E636C6F7365737428277461626C6527293B0D0A202020202F2F636C6F7365737420726F7720746F2074726967676572696E6720656C656D656E740D0A20202020746869732E726F772020202020202020202020202020203D2074686973';
wwv_flow_api.g_varchar2_table(40) := '2E74642E636C6F736573742827747227293B0D0A202020202F2F6F626A6563742064657363726962696E67206E6573746564207265706F727420656E746974790D0A20202020746869732E6E65737465645265706F72742020202020203D207B0D0A2020';
wwv_flow_api.g_varchar2_table(41) := '20202020616A6178446174613A206E756C6C2C0D0A20202020202074723A206E756C6C2C0D0A20202020202074643A206E756C6C2C0D0A202020202020636F6E7461696E65723A206E756C6C2C0D0A202020202020636F6E74656E74486572653A206E75';
wwv_flow_api.g_varchar2_table(42) := '6C6C0D0A202020207D3B0D0A0D0A20202020746869732E7370696E6E65722020202020202020202020203D206E756C6C3B0D0A0D0A20202020746869732E696E63657074696F6E202020202020202020203D207B0D0A2020202020202774797065272020';
wwv_flow_api.g_varchar2_table(43) := '203A20756E646566696E65642C0D0A20202020202027656C656D656E74273A20756E646566696E65642C0D0A202020202020276C6576656C2720203A20756E646566696E65640D0A202020207D3B0D0A0D0A20202020746869732E657870616E64656420';
wwv_flow_api.g_varchar2_table(44) := '202020202020202020203D2066616C73653B0D0A20202020746869732E616E696D6174696F6E52756E6E696E672020203D2066616C73653B0D0A20202020746869732E7175657279436F6C756D6E734E616D657320203D20746869732E6F7074696F6E73';
wwv_flow_api.g_varchar2_table(45) := '2E7175657279436F6C756D6E733B0D0A20202020746869732E71756572794974656D732020202020202020203D20746869732E6F7074696F6E732E71756572794974656D733B0D0A20202020746869732E7175657279436F6C756D6E7356616C75657320';
wwv_flow_api.g_varchar2_table(46) := '3D205B5D3B0D0A0D0A20202020746869732E616A6178203D207B0D0A20202020202069643A20746869732E6F7074696F6E732E616374696F6E2E616A61784964656E7469666965722C0D0A20202020202072756E6E696E673A2066616C73652C0D0A2020';
wwv_flow_api.g_varchar2_table(47) := '20202020666F726365643A2066616C73652C0D0A2020202020206973526566726573683A2066616C73650D0A202020207D3B0D0A0D0A20202020746869732E74640D0A2020202020202E6F6E28276D6F757365656E746572272C20242E70726F78792820';
wwv_flow_api.g_varchar2_table(48) := '746869732E5F686967686C696768742C746869732020202020202029290D0A2020202020202E6F6E28276D6F7573656C65617665272C20242E70726F78792820746869732E5F72656D6F7665486967686C696768742C746869732029293B0D0A0D0A2020';
wwv_flow_api.g_varchar2_table(49) := '2020746869732E726F770D0A2020202020202E6F6E28276D6F757365656E746572272C20242E70726F78792820746869732E5F6F76657272696465417065785472486F7665722C746869732C2074727565202029290D0A2020202020202E6F6E28276D6F';
wwv_flow_api.g_varchar2_table(50) := '7573656C65617665272C20242E70726F78792820746869732E5F6F76657272696465417065785472486F7665722C746869732C2066616C73652029293B0D0A202020200D0A202020202F2F3F0D0A202020206966202820746869732E6F7074696F6E732E';
wwv_flow_api.g_varchar2_table(51) := '7468726F774572726F7220213D20756E646566696E65642029207B0D0A202020202020746869732E7468726F774572726F722820746869732E6F7074696F6E732E7468726F774572726F722C20746869732E6572726F7254797065732E636F6E66696775';
wwv_flow_api.g_varchar2_table(52) := '726174696F6E20293B0D0A202020207D0D0A0D0A202020206E6F744D617463686564436F6C756D6E203D20746869732E5F6E6F744D617463686564436F6C756D6E28293B0D0A0D0A20202020746869732E696E63657074696F6E203D20746869732E5F69';
wwv_flow_api.g_varchar2_table(53) := '416D596F75724661746865724C756B6528293B0D0A0D0A2020202069662028206E6F744D617463686564436F6C756D6E20213D206E756C6C2029207B0D0A202020202020746869732E7468726F774572726F7228200D0A20202020202020207B0D0A2020';
wwv_flow_api.g_varchar2_table(54) := '20202020202020207469746C653A20746869732E6572726F7254797065732E636F6E66696775726174696F6E2E7469746C652C0D0A20202020202020202020746578743A2020274D61726B657220666F7220636F6C756D6E203C623E23272B6E6F744D61';
wwv_flow_api.g_varchar2_table(55) := '7463686564436F6C756D6E2B27233C2F623E206E6F7420666F756E6420696E20726F772E204174206C65617374206F6E65206F66206C69737465642073656C6563746F7273206D7573742072657475726E203C623E23272B6E6F744D617463686564436F';
wwv_flow_api.g_varchar2_table(56) := '6C756D6E2B27233C2F623E2076616C75652E272C0D0A2020202020202020202070726520203A205B0D0A2020202020202020202020202724285C275B686561646572733D22272B6E6F744D617463686564436F6C756D6E2B27225D5C27292E7465787428';
wwv_flow_api.g_varchar2_table(57) := '29202F2F666F72206E6573746564207265706F72747320656D6265646564206469726563746C7920696E20436C6173736963205265706F7274272C0D0A2020202020202020202020202724285C275B686561646572733D22272B6E6F744D617463686564';
wwv_flow_api.g_varchar2_table(58) := '436F6C756D6E2B27225D5C27292E746578742829202F2F666F72206E6573746564207265706F72747320656D6265646564206469726563746C7920696E20496E746572616374697665205265706F72742028636F6C756D6E207374617469632049442069';
wwv_flow_api.g_varchar2_table(59) := '7320726571756972656429272C0D0A2020202020202020202020202724285C275B686561646572733D224E525F272B746869732E696E63657074696F6E2E6C6576656C2B275F272B6E6F744D617463686564436F6C756D6E2B27225D5C27292E74657874';
wwv_flow_api.g_varchar2_table(60) := '2829202F2F666F72206E6573746564207265706F72747320656D626564656420696E206E6573746564207265706F727473272C0D0A2020202020202020202020202724285C277370616E5B636C6173732A3D22272B6E6F744D617463686564436F6C756D';
wwv_flow_api.g_varchar2_table(61) := '6E2B27225D5C27292E746578742829202F2F756E6976657273616C20636F6C756D6E206D61726B657220287265717569726573206368616E67657320696E204150455820436F6C756D6E20466F726D617474696E6729270D0A202020202020202020205D';
wwv_flow_api.g_varchar2_table(62) := '2C0D0A2020202020202020202068696E7473203A205B5D0D0A20202020202020207D20202020202020200D0A202020202020293B0D0A2020202020202F2F746869732E64657374726F7928293B0D0A202020207D0D0A0D0A202020206966202820746869';
wwv_flow_api.g_varchar2_table(63) := '732E73657474696E67732E697344656661756C7454656D706C617465203D3D207472756520262620746869732E73657474696E67732E697344656661756C7454656D706174654D61726B6572203D3D2066616C73652029207B0D0A202020202020746869';
wwv_flow_api.g_varchar2_table(64) := '732E7468726F774572726F7228200D0A20202020202020207B0D0A202020202020202020207469746C653A20746869732E6572726F7254797065732E636F6E66696775726174696F6E2E7469746C652C0D0A20202020202020202020746578743A202027';
wwv_flow_api.g_varchar2_table(65) := '4D61726B6572203C623E272B746869732E64656661756C7454656D706C6174654D61726B65722B273C2F623E206E6F7420666F756E6420696E20646566696E69746F6E206F662074686520706C7567696E202244656661756C742074656D706C61746520';
wwv_flow_api.g_varchar2_table(66) := '48544D4C22206174747269627574652E272C0D0A2020202020202020202070726520203A205B0D0A202020202020202020202020274D616B652073757265207468652076616C7565206F66202244656661756C742074656D706C6174652048544D4C2220';
wwv_flow_api.g_varchar2_table(67) := '61747472696275746520636F6E7461696E73206174206C6561737420272B746869732E64656661756C7454656D706C6174654D61726B65722B27206D61726B65722E22270D0A202020202020202020205D2C0D0A2020202020202020202068696E747320';
wwv_flow_api.g_varchar2_table(68) := '3A205B5D0D0A20202020202020207D20202020202020200D0A202020202020293B0D0A0D0A202020207D0D0A202020200D0A0D0A202020206966202820746869732E6F7074696F6E732E666F726365546F67676C652029207B0D0A202020202020746869';
wwv_flow_api.g_varchar2_table(69) := '732E746F67676C6528293B20200D0A202020207D0D0A202020200D0A20207D2C0D0A2F2F0D0A2F2F0D0A20205F64657374726F793A2066756E6374696F6E28297B0D0A20207D2C0D0A2F2F0D0A2F2F0D0A20205F7365744F7074696F6E3A2066756E6374';
wwv_flow_api.g_varchar2_table(70) := '696F6E2820704B65792C207056616C75652029207B0D0A202020206966202820704B6579203D3D3D202276616C7565222029207B0D0A2020202020207056616C7565203D20746869732E5F636F6E73747261696E28207056616C756520293B0D0A202020';
wwv_flow_api.g_varchar2_table(71) := '207D0D0A0D0A20202020746869732E5F73757065722820704B65792C207056616C756520293B0D0A20207D2C20200D0A20206F7074696F6E733A2066756E6374696F6E2820704F7074696F6E7320297B0D0A20202020746869732E5F7375706572282070';
wwv_flow_api.g_varchar2_table(72) := '4F7074696F6E7320293B0D0A20207D2C0D0A2F2F0D0A2F2F0D0A20205F7365744F7074696F6E733A2066756E6374696F6E2820704F7074696F6E732029207B0D0A20202020746869732E5F73757065722820704F7074696F6E7320293B0D0A20207D2C20';
wwv_flow_api.g_varchar2_table(73) := '200D0A2F2F0D0A2F2F206E696520757A7977616E650D0A2020736574436F6E74656E74486572653A2066756E6374696F6E2820704E6F646520297B0D0A20202020746869732E6E65737465645265706F72742E636F6E74656E7448657265203D20704E6F';
wwv_flow_api.g_varchar2_table(74) := '64653B0D0A20207D2C0D0A2F2F0D0A2F2F0D0A20205F6E6F744D617463686564436F6C756D6E3A2066756E6374696F6E28297B0D0A20202020766172200D0A2020202020206865616465725461672C0D0A2020202020207370616E5461672C0D0A202020';
wwv_flow_api.g_varchar2_table(75) := '202020636F6C756D6E3B0D0A0D0A20202020666F7220282076617220693D303B2069203C20746869732E7175657279436F6C756D6E734E616D65732E6C656E6774683B20692B2B20297B0D0A202020202020636F6C756D6E202020202020202020203D20';
wwv_flow_api.g_varchar2_table(76) := '746869732E7175657279436F6C756D6E734E616D65735B695D3B0D0A202020202020686561646572546167202020202020203D20746869732E726F772E66696E6428275B686561646572733D22272B636F6C756D6E2B27225D27293B0D0A202020202020';
wwv_flow_api.g_varchar2_table(77) := '6E6573746564486561646572546167203D20746869732E726F772E66696E6428275B686561646572733D224E525F272B746869732E696E63657074696F6E2E6C6576656C2B275F272B636F6C756D6E2B27225D27293B0D0A2020202020207370616E5461';
wwv_flow_api.g_varchar2_table(78) := '672020202020202020203D20746869732E726F772E66696E6428277370616E5B636C6173732A3D22272B636F6C756D6E2B27225D27293B0D0A0D0A20202020202069662028206865616465725461672E6C656E677468203D3D2030202626207370616E54';
wwv_flow_api.g_varchar2_table(79) := '61672E6C656E677468203D3D2030202626206E65737465644865616465725461672E6C656E677468203D3D203029207B0D0A202020202020202072657475726E20636F6C756D6E3B0D0A2020202020207D0D0A202020202020656C7365207B0D0A202020';
wwv_flow_api.g_varchar2_table(80) := '202020202069662028207370616E5461672E6C656E67746820213D20302029207B0D0A20202020202020202020746869732E7175657279436F6C756D6E7356616C7565732E7075736828207370616E5461672E666972737428292E74657874282920293B';
wwv_flow_api.g_varchar2_table(81) := '0D0A20202020202020207D0D0A2020202020202020656C73652069662028206865616465725461672E6C656E67746820213D20302029207B0D0A20202020202020202020746869732E7175657279436F6C756D6E7356616C7565732E7075736828206865';
wwv_flow_api.g_varchar2_table(82) := '616465725461672E666972737428292E74657874282920293B0D0A202020202020202020200D0A20202020202020207D0D0A2020202020202020656C7365207B0D0A20202020202020202020746869732E7175657279436F6C756D6E7356616C7565732E';
wwv_flow_api.g_varchar2_table(83) := '7075736828206E65737465644865616465725461672E666972737428292E74657874282920293B20200D0A20202020202020207D0D0A20202020202020200D0A2020202020207D0D0A0D0A202020207D0D0A2020202072657475726E206E756C6C3B0D0A';
wwv_flow_api.g_varchar2_table(84) := '20207D2C0D0A2F2F0D0A2F2F0D0A20205F676574506C756741747472466C61673A2066756E6374696F6E282070417474722C2070457870656374656456616C756520297B0D0A20202020766172207041747472203D20746869732E6F7074696F6E732E61';
wwv_flow_api.g_varchar2_table(85) := '6374696F6E5B27617474726962757465272B70417474725D3B0D0A0D0A2020202069662028207041747472203D3D20756E646566696E6564207C7C207041747472203D3D206E756C6C2029207B0D0A20202020202072657475726E2066616C73653B0D0A';
wwv_flow_api.g_varchar2_table(86) := '202020207D0D0A0D0A2020202072657475726E2070417474722E696E6465784F66282070457870656374656456616C75652029203E202D313B0D0A20207D2C0D0A2F2F0D0A2F2F0D0A2020676574506172656E743A2066756E6374696F6E28297B0D0A20';
wwv_flow_api.g_varchar2_table(87) := '20202072657475726E20746869732E696E63657074696F6E3B0D0A20207D2C0D0A2F2F0D0A2F2F0D0A20206765744C6576656C3A2066756E6374696F6E28297B0D0A2020202072657475726E20746869732E696E63657074696F6E2E6C6576656C3B0D0A';
wwv_flow_api.g_varchar2_table(88) := '20207D2C0D0A2F2F0D0A2F2F0D0A20205F676574457870616E64656446726F6D3A2066756E6374696F6E282070456C656D656E742029207B0D0A2020202076617220657870616E6465643B0D0A20202020617065782E64656275672E6C6F6728275F6765';
wwv_flow_api.g_varchar2_table(89) := '74457870616E64656446726F6D272C20272C2073656172636820696E2070456C656D656E74203D272C2070456C656D656E74293B0D0A0D0A20202020657870616E646564203D2070456C656D656E742E66696E6428272A27292E66696C74657228206675';
wwv_flow_api.g_varchar2_table(90) := '6E6374696F6E2870496E6465782C2070456C656D656E74297B0D0A2020202020207661722073656C66203D20242870456C656D656E74293B0D0A0D0A202020202020696620282073656C662E646174612827707265746975732D6E65737465645265706F';
wwv_flow_api.g_varchar2_table(91) := '7274272920213D20756E646566696E65642026262073656C662E6E65737465645265706F727428276973457870616E6465642729203D3D20747275652029207B0D0A202020202020202072657475726E20747275653B0D0A2020202020207D0D0A202020';
wwv_flow_api.g_varchar2_table(92) := '207D20293B0D0A0D0A20202020617065782E64656275672E6C6F6728275F676574457870616E64656446726F6D272C20272C20666F756E6420656C656D656E747320636F756E74203D20272C20657870616E6465642E6C656E6774682C20272C20656C65';
wwv_flow_api.g_varchar2_table(93) := '6D656E7473203D272C20657870616E646564293B0D0A0D0A2020202072657475726E20657870616E6465643B0D0A20207D2C0D0A2F2F0D0A2F2F0D0A20205F69416D596F75724661746865724C756B653A2066756E6374696F6E28297B0D0A2020202076';
wwv_flow_api.g_varchar2_table(94) := '6172200D0A202020202020636C6F73657374436F6E7461696E6572203D20746869732E74642E636C6F7365737428275B636C6173732A3D272B746869732E636C61737365732E6E65737465645265706F72745472436F6E7461696E65722B275D27292C0D';
wwv_flow_api.g_varchar2_table(95) := '0A20202020202076616465723B0D0A0D0A20202020206966202820636C6F73657374436F6E7461696E65722E6C656E677468203E20302029207B0D0A2020202020202F2F6E61207065776E6F206A657374656D2070727A796E616A6D6E69656A206C6576';
wwv_flow_api.g_varchar2_table(96) := '656C20310D0A2020202020207661646572203D20746869732E5F676574457870616E64656446726F6D2820636C6F73657374436F6E7461696E65722E70726576282920293B0D0A0D0A2020202020206966202820766164657220213D20756E646566696E';
wwv_flow_api.g_varchar2_table(97) := '65642026262076616465722E6C656E677468203E20302029207B0D0A202020202020202072657475726E207B0D0A202020202020202020202774797065272020203A20276E6573746564272C0D0A2020202020202020202027656C656D656E74273A2076';
wwv_flow_api.g_varchar2_table(98) := '616465722C0D0A20202020202020202020276C6576656C2720203A202876616465722E6E65737465645265706F727428276765744C6576656C2729292B310D0A20202020202020207D3B0D0A2020202020207D0D0A202020202020656C7365207B0D0A20';
wwv_flow_api.g_varchar2_table(99) := '202020202020202F2F6669727374206C6576656C0D0A202020202020202072657475726E207B0D0A202020202020202020202774797065272020203A2027496E76616C6964206E6573746564207265706F7274272C0D0A2020202020202020202027656C';
wwv_flow_api.g_varchar2_table(100) := '656D656E74273A20756E646566696E65642C0D0A20202020202020202020276C6576656C2720203A202D310D0A202020202020202020200D0A20202020202020207D3B0D0A2020202020207D0D0A0D0A202020207D0D0A202020202F2F747520646F726F';
wwv_flow_api.g_varchar2_table(101) := '62696320637A79206E61207065776E6F206166666563746564456C656D656E7473206A657374206E616A626C697A737A796D20726F647A6963656D0D0A20202020656C7365207B0D0A20202020202072657475726E207B0D0A2020202020202020277479';
wwv_flow_api.g_varchar2_table(102) := '7065272020203A20276166666563746564456C656D656E74272C0D0A202020202020202027656C656D656E74273A20746869732E6166666563746564456C656D656E742C0D0A2020202020202020276C6576656C2720203A20310D0A2020202020202020';
wwv_flow_api.g_varchar2_table(103) := '0D0A2020202020207D3B0D0A202020207D0D0A20207D2C200D0A2F2F0D0A2F2F0D0A20207468726F774572726F723A2066756E6374696F6E2820704572726F7220297B0D0A20202020766172200D0A2020202020207472203D20746869732E6372656174';
wwv_flow_api.g_varchar2_table(104) := '6544656661756C7443616C6C6261636B526F7728292C0D0A202020202020707265203D202428273C7072653E3C2F7072653E27292E617070656E6428204A534F4E2E737472696E676966792820704572726F722C206E756C6C2C20322920292C0D0A2020';
wwv_flow_api.g_varchar2_table(105) := '202020206475726174696F6E203D203430302C0D0A202020202020636C6F73654475726174696F6E203D20302C0D0A202020202020646976203D20746869732E5F6765744572726F7254656D706C6174652820704572726F7220292C0D0A202020202020';
wwv_flow_api.g_varchar2_table(106) := '636C6F73654265666F7265203D20746869732E5F657870616E6465645369737465727328293B0D0A0D0A20202020746869732E6E65737465645265706F72742E746420202020202020203D2074722E66696E642827746427293B0D0A2020202074686973';
wwv_flow_api.g_varchar2_table(107) := '2E6E65737465645265706F72742E636F6E7461696E6572203D2074722E66696E642820275B636C6173732A3D272B746869732E636C61737365732E6E65737465645265706F7274446976436F6E7461696E65722B275D2720293B0D0A2020202074686973';
wwv_flow_api.g_varchar2_table(108) := '2E6E65737465645265706F72742E747220202020202020203D2074723B0D0A0D0A20202020636C6F73654265666F72652E6E65737465645265706F72742827636F6C6C61707365272C20636C6F73654475726174696F6E293B20200D0A0D0A2020202069';
wwv_flow_api.g_varchar2_table(109) := '66202820636C6F73654265666F72652E6C656E677468203E20302029207B0D0A202020202020636C6F73654475726174696F6E203D20746869732E73657474696E67732E636C6F73654F746865724475726174696F6E3B0D0A202020207D0D0A0D0A2020';
wwv_flow_api.g_varchar2_table(110) := '202073657454696D656F75742820242E70726F78792866756E6374696F6E28297B0D0A202020202020746869732E6E65737465645265706F72742E636F6E7461696E65722E68746D6C282064697620293B0D0A202020202020746869732E6E6573746564';
wwv_flow_api.g_varchar2_table(111) := '5265706F72742E74722E696E7365727441667465722820746869732E726F7720293B0D0A0D0A202020202020746869732E74642E616464436C6173732820746869732E636C61737365732E7464457870616E64656420293B0D0A20202020202074686973';
wwv_flow_api.g_varchar2_table(112) := '2E657870616E646564203D20747275653B0D0A202020202020746869732E74642E646174612827707265746975732D6E65737465645265706F72742D6F776E6572272C20746869732E656C656D656E74293B0D0A0D0A202020202020746869732E636861';
wwv_flow_api.g_varchar2_table(113) := '6E6765426F726465725374796C6528293B0D0A202020202020746869732E6E65737465645265706F72742E74722E73686F7728293B0D0A0D0A2020202020206966202820746869732E73657474696E67732E697344656661756C7443616C6C6261636B20';
wwv_flow_api.g_varchar2_table(114) := '262620746869732E73657474696E67732E6973416464416E696D6174696F6E203D3D2066616C736529207B0D0A20202020202020206475726174696F6E203D20303B0D0A2020202020207D0D0A0D0A202020202020746869732E6E65737465645265706F';
wwv_flow_api.g_varchar2_table(115) := '72742E636F6E7461696E65722E736C696465446F776E28206475726174696F6E202C20242E70726F78792866756E6374696F6E28297B0D0A2020202020202020746869732E63616C6C6261636B457870616E64656428293B0D0A2020202020207D2C2074';
wwv_flow_api.g_varchar2_table(116) := '68697329293B202020200D0A202020207D2C2074686973292C20636C6F73654475726174696F6E202B20313530293B0D0A0D0A20202020617065782E64656275672E6572726F72280D0A20202020202022507265746975732041504558204E6573746564';
wwv_flow_api.g_varchar2_table(117) := '205265706F727473206572726F723A5C6E222C0D0A202020202020222020222B704572726F722E7469746C652E7265706C616365282F3C5B5E3E5D2B3E2F672C202727292B225C6E222C200D0A2020202020202220202020222B704572726F722E746578';
wwv_flow_api.g_varchar2_table(118) := '742E7265706C616365282F3C5B5E3E5D2B3E2F672C20272729200D0A20202020293B0D0A0D0A202020206966202820704572726F722E68696E74732E6C656E677468203E20302029207B0D0A202020202020666F722028207661722069203D20303B2069';
wwv_flow_api.g_varchar2_table(119) := '203C20704572726F722E68696E74732E6C656E6774683B20692B2B2029207B0D0A2020202020202020617065782E64656275672E7761726E28704572726F722E68696E74735B695D2E6C6162656C2B273A272C20225C6E5C6E222B704572726F722E6869';
wwv_flow_api.g_varchar2_table(120) := '6E74735B695D2E76616C756520293B0D0A2020202020207D0D0A202020207D0D0A0D0A20202020696620282020617267756D656E74732E6C656E677468203E20312029207B0D0A202020202020666F722028207661722069203D20313B2069203C206172';
wwv_flow_api.g_varchar2_table(121) := '67756D656E74732E6C656E6774683B20692B2B2029207B0D0A2020202020202020617065782E64656275672E7761726E28274164646974696F6E616C20696E666F2023272B28692D31292B273A272C20617267756D656E74735B695D20293B0D0A202020';
wwv_flow_api.g_varchar2_table(122) := '2020207D0D0A202020207D0D0A0D0A202020207468726F772027506C7567696E20657865637574696F6E2073746F707065642E270D0A20207D2C0D0A2F2F0D0A2F2F0D0A20206973416A617852756E6E696E673A2066756E6374696F6E28297B0D0A2020';
wwv_flow_api.g_varchar2_table(123) := '202072657475726E20746869732E616A61782E72756E6E696E673B0D0A20207D2C0D0A2F2F0D0A2F2F0D0A20206973457870616E6465643A2066756E6374696F6E28297B0D0A2020202072657475726E20746869732E657870616E6465643B0D0A20207D';
wwv_flow_api.g_varchar2_table(124) := '2C0D0A2F2F0D0A2F2F0D0A2020746F67676C653A2066756E6374696F6E28297B0D0A202020207661720D0A202020202020636C6F73654475726174696F6E203D20302C0D0A202020202020636C6F73654265666F72653B0D0A0D0A202020206966202820';
wwv_flow_api.g_varchar2_table(125) := '746869732E657870616E646564203D3D20747275652029207B0D0A202020202020746869732E636F6C6C6170736528293B0D0A202020207D0D0A20202020656C7365207B0D0A2020202020206966202820746869732E73657474696E67732E6973436F6C';
wwv_flow_api.g_varchar2_table(126) := '6C61707365457861706E646564203D3D207472756529207B0D0A2020202020202020636C6F73654265666F7265203D20746869732E5F657870616E646564496E5265706F727428293B0D0A2020202020207D20656C7365207B0D0A202020202020202063';
wwv_flow_api.g_varchar2_table(127) := '6C6F73654265666F7265203D20746869732E5F657870616E6465645369737465727328293B0D0A2020202020207D0D0A0D0A2020202020206966202820636C6F73654265666F72652E6C656E677468203E20302029207B0D0A2020202020202020636C6F';
wwv_flow_api.g_varchar2_table(128) := '73654475726174696F6E203D20746869732E73657474696E67732E636C6F73654F746865724475726174696F6E3B0D0A2020202020202020636C6F73654265666F72652E6E65737465645265706F72742827636F6C6C61707365272C20636C6F73654475';
wwv_flow_api.g_varchar2_table(129) := '726174696F6E293B20200D0A0D0A202020202020202073657454696D656F75742820242E70726F78792866756E6374696F6E28297B2020202020200D0A20202020202020202020746869732E73686F7728293B0D0A20202020202020207D2C2074686973';
wwv_flow_api.g_varchar2_table(130) := '292C20636C6F73654475726174696F6E202B20313530293B0D0A0D0A2020202020207D0D0A202020202020656C7365207B0D0A2020202020202020746869732E73686F7728293B0D0A2020202020207D0D0A202020207D0D0A20207D2C0D0A0D0A2F2F0D';
wwv_flow_api.g_varchar2_table(131) := '0A2F2F0D0A202073686F773A2066756E6374696F6E28297B0D0A202020200D0A202020206966202820746869732E6E65737465645265706F72742E616A617844617461203D3D206E756C6C2029207B0D0A202020202020746869732E616A61782E666F72';
wwv_flow_api.g_varchar2_table(132) := '636564203D20747275653B0D0A202020202020746869732E616A617846657463684461746128293B0D0A20202020202072657475726E20766F69642830293B0D0A202020207D0D0A20202020656C7365207B0D0A0D0A2020202020202F2F64616E652073';
wwv_flow_api.g_varchar2_table(133) := 'C4852C207370726177647A20637A7920636163686520776C61637A6F6E790D0A2020202020206966202820746869732E73657474696E67732E69734361636865526573756C7473203D3D2066616C736520262620746869732E616A61782E666F72636564';
wwv_flow_api.g_varchar2_table(134) := '203D3D2066616C736520262620746869732E616A61782E697352656672657368203D3D2066616C736529207B0D0A20202020202020202F2F7A7265736574756A207A61776172746FC59BC487206E6573746564207265706F72742C2074616B207A656279';
wwv_flow_api.g_varchar2_table(135) := '20777967656E65726F77616320676F206E61206E6F776F0D0A20202020202020202F2F746869732E6E65737465645265706F72742E74722E72656D6F766528293B0D0A2020202020202020746869732E6E65737465645265706F72742E7472203D206E75';
wwv_flow_api.g_varchar2_table(136) := '6C6C3B0D0A2020202020202020746869732E616A61782E666F72636564203D20747275653B0D0A2020202020202020746869732E616A617846657463684461746128293B0D0A202020202020202072657475726E3B0D0A2020202020207D0D0A20202020';
wwv_flow_api.g_varchar2_table(137) := '2020656C7365206966202820746869732E73657474696E67732E69734361636865526573756C7473203D3D2066616C736520262620746869732E616A61782E666F72636564203D3D207472756520262620746869732E616A61782E697352656672657368';
wwv_flow_api.g_varchar2_table(138) := '203D3D2066616C736529207B0D0A2020202020202020746869732E616A61782E666F72636564203D2066616C73653B0D0A2020202020207D0D0A202020207D0D0A0D0A202020206966202820746869732E73657474696E67732E697344656661756C7443';
wwv_flow_api.g_varchar2_table(139) := '616C6C6261636B2029207B0D0A202020202020746869732E646F43616C6C6261636B44656661756C7428293B0D0A202020207D0D0A20202020656C7365207B0D0A202020202020746869732E646F43616C6C6261636B437573746F6D28290D0A20202020';
wwv_flow_api.g_varchar2_table(140) := '7D0D0A20207D2C0D0A2F2F0D0A2F2F0D0A2020657870616E643A2066756E6374696F6E282070466F7263654475726174696F6E20297B0D0A20202020766172200D0A2020202020206475726174696F6E203D20746869732E73657474696E67732E616E69';
wwv_flow_api.g_varchar2_table(141) := '6D6174696F6E54696D653B0D0A0D0A202020206966202820746869732E73657474696E67732E6973416464416E696D6174696F6E203D3D2066616C736529207B0D0A2020202020206475726174696F6E203D20303B0D0A202020207D0D0A0D0A20202020';
wwv_flow_api.g_varchar2_table(142) := '696620282070466F7263654475726174696F6E20213D206E756C6C2026262070466F7263654475726174696F6E20213D20756E646566696E65642029207B0D0A2020202020206475726174696F6E203D2070466F7263654475726174696F6E3B20202020';
wwv_flow_api.g_varchar2_table(143) := '20200D0A202020207D0D0A0D0A20202020746869732E616E696D6174696F6E52756E6E696E67203D20747275653B0D0A202020202F2F6265666F726520736C69646520646F776E0D0A20202020617065782E6576656E742E747269676765722874686973';
wwv_flow_api.g_varchar2_table(144) := '2E6166666563746564456C656D656E742C2027707265746975735F64656661756C745F63616C6C6261636B272C20746869732E6765744576656E74446174612829293B0D0A0D0A202020202F2F707265746975732D6E65737465645265706F72742D6F77';
wwv_flow_api.g_varchar2_table(145) := '6E6572206973207573656420746F2066696E64206F75742074726967676572696E6720656C656D656E740D0A202020202F2F7768696C65207363616E6E696E6720726F77206F72207461626C6520666F7220657870616E6465642063656C6C730D0A2020';
wwv_flow_api.g_varchar2_table(146) := '2020746869732E74642E646174612827707265746975732D6E65737465645265706F72742D6F776E6572272C20746869732E656C656D656E74293B0D0A20202020746869732E74642E616464436C6173732820746869732E636C61737365732E74644578';
wwv_flow_api.g_varchar2_table(147) := '70616E64656420293B0D0A0D0A20202020746869732E657870616E646564203D20747275653B0D0A20202020746869732E6368616E6765426F726465725374796C6528293B0D0A202020200D0A20202020746869732E6E65737465645265706F72742E74';
wwv_flow_api.g_varchar2_table(148) := '722E73686F7728293B0D0A0D0A202020202F2F616674657220736C69646520646F776E0D0A20202020746869732E6E65737465645265706F72742E636F6E7461696E65722E736C696465446F776E28206475726174696F6E202C20242E70726F78792820';
wwv_flow_api.g_varchar2_table(149) := '746869732E63616C6C6261636B457870616E6465642C20746869732029293B0D0A20207D2C0D0A2F2F0D0A2F2F0D0A2020636F6C6C617073653A2066756E6374696F6E282070466F7263654475726174696F6E20297B0D0A202020207661722064757261';
wwv_flow_api.g_varchar2_table(150) := '74696F6E203D2070466F7263654475726174696F6E203D3D20756E646566696E6564203F20746869732E73657474696E67732E636C6F73654F746865724475726174696F6E203A2070466F7263654475726174696F6E3B0D0A0D0A202020206966202820';
wwv_flow_api.g_varchar2_table(151) := '746869732E73657474696E67732E6973416464416E696D6174696F6E203D3D2066616C736529207B0D0A2020202020206475726174696F6E203D20303B0D0A202020207D0D0A0D0A20202020746869732E616E696D6174696F6E52756E6E696E67203D20';
wwv_flow_api.g_varchar2_table(152) := '747275653B0D0A202020200D0A20202020617065782E6576656E742E7472696767657228746869732E6166666563746564456C656D656E742C2027707265746975735F64656661756C745F63616C6C6261636B272C20746869732E6765744576656E7444';
wwv_flow_api.g_varchar2_table(153) := '617461282920293B0D0A0D0A20202020746869732E6E65737465645265706F72742E636F6E7461696E65722E736C696465557028206475726174696F6E202C20242E70726F78792820746869732E63616C6C6261636B436F6C6C61707365642C20746869';
wwv_flow_api.g_varchar2_table(154) := '732920293B0D0A20207D2C0D0A2F2F0D0A2F2F0D0A2020646F43616C6C6261636B44656661756C743A2066756E6374696F6E28297B0D0A20202020766172200D0A2020202020206E657754722C0D0A2020202020206E65737465645265706F7274436F6E';
wwv_flow_api.g_varchar2_table(155) := '74656E743B0D0A0D0A202020206966202820746869732E6E65737465645265706F72742E7472203D3D206E756C6C2029207B0D0A2020202020202F2F206669727374206472696C6C20646F776E0D0A0D0A2020202020202F2F637265617465206E657720';
wwv_flow_api.g_varchar2_table(156) := '6E6573746564207265706F727420726F770D0A2020202020206E6577547220202020202020202020202020202020202020202020203D20746869732E63726561746544656661756C7443616C6C6261636B526F7728290D0A2020202020202F2F74686973';
wwv_flow_api.g_varchar2_table(157) := '2E6E65737465645265706F72742E636F6E74656E744865726520706F696E747320746420696E206E65776C7920637265617465642074720D0A202020202020746869732E6E65737465645265706F72742E746420202020202020203D206E657754722E66';
wwv_flow_api.g_varchar2_table(158) := '696E642827746427293B0D0A202020202020746869732E6E65737465645265706F72742E636F6E7461696E6572203D206E657754722E66696E642820275B636C6173732A3D272B746869732E636C61737365732E6E65737465645265706F727444697643';
wwv_flow_api.g_varchar2_table(159) := '6F6E7461696E65722B275D2720293B0D0A202020202020746869732E6E65737465645265706F72742E747220202020202020203D206E657754723B0D0A0D0A202020202020746869732E6E65737465645265706F72742E74722E696E7365727441667465';
wwv_flow_api.g_varchar2_table(160) := '722820746869732E726F7720293B0D0A0D0A2020202020206966202820746869732E73657474696E67732E697344656661756C7454656D706C6174652029207B0D0A0D0A20202020202020206E65737465645265706F7274436F6E74656E74203D207468';
wwv_flow_api.g_varchar2_table(161) := '69732E72656E64657254656D706C61746544656661756C7428293B0D0A0D0A2020202020202020746869732E6E65737465645265706F72742E636F6E74656E74486572652E656D70747928293B0D0A2020202020202020746869732E6E65737465645265';
wwv_flow_api.g_varchar2_table(162) := '706F72742E636F6E74656E74486572652E617070656E642820746869732E73657474696E67732E64656661756C7454656D706C6174654265666F726520293B0D0A2020202020202020746869732E6E65737465645265706F72742E636F6E74656E744865';
wwv_flow_api.g_varchar2_table(163) := '72652E617070656E6428206E65737465645265706F7274436F6E74656E7420293B0D0A2020202020202020746869732E6E65737465645265706F72742E636F6E74656E74486572652E617070656E642820746869732E73657474696E67732E6465666175';
wwv_flow_api.g_varchar2_table(164) := '6C7454656D706C617465416674657220293B0D0A0D0A2020202020207D0D0A202020202020656C7365207B0D0A20202020202020206E65737465645265706F7274436F6E74656E74203D20746869732E72656E64657254656D706C617465437573746F6D';
wwv_flow_api.g_varchar2_table(165) := '28293B0D0A2020202020202020746869732E6E65737465645265706F72742E636F6E74656E74486572652E68746D6C28206E65737465645265706F7274436F6E74656E7420290D0A2020202020207D0D0A0D0A202020207D0D0A20202020656C7365207B';
wwv_flow_api.g_varchar2_table(166) := '0D0A2020202020202F2F206E657874206472696C6C20646F776E2C2074686520636F6E74656E74206973206F6E6C79207265706C61636564207768656E2063616368696E67206973207475726E6564206F66660D0A0D0A20202020202069662028207468';
wwv_flow_api.g_varchar2_table(167) := '69732E616A61782E6973526566726573682029207B0D0A20202020202020202F2F746869732E616A61782E697352656672657368203D2066616C73653B0D0A0D0A2020202020202020746869732E6E65737465645265706F72742E636F6E74656E744865';
wwv_flow_api.g_varchar2_table(168) := '72652E656D70747928293B0D0A0D0A20202020202020206966202820746869732E73657474696E67732E697344656661756C7454656D706C6174652029207B0D0A202020202020202020206E65737465645265706F7274436F6E74656E74203D20746869';
wwv_flow_api.g_varchar2_table(169) := '732E72656E64657254656D706C61746544656661756C7428293B0D0A0D0A20202020202020202020746869732E6E65737465645265706F72742E636F6E74656E74486572652E617070656E642820746869732E73657474696E67732E64656661756C7454';
wwv_flow_api.g_varchar2_table(170) := '656D706C6174654265666F726520293B0D0A20202020202020202020746869732E6E65737465645265706F72742E636F6E74656E74486572652E617070656E6428206E65737465645265706F7274436F6E74656E7420293B0D0A20202020202020202020';
wwv_flow_api.g_varchar2_table(171) := '746869732E6E65737465645265706F72742E636F6E74656E74486572652E617070656E642820746869732E73657474696E67732E64656661756C7454656D706C617465416674657220293B0D0A20202020202020207D0D0A2020202020202020656C7365';
wwv_flow_api.g_varchar2_table(172) := '207B0D0A202020202020202020206E65737465645265706F7274436F6E74656E74203D20746869732E72656E64657254656D706C617465437573746F6D28293B0D0A20202020202020202020746869732E6E65737465645265706F72742E636F6E74656E';
wwv_flow_api.g_varchar2_table(173) := '74486572652E68746D6C28206E65737465645265706F7274436F6E74656E7420290D0A20202020202020207D0D0A202020202020200D0A2020202020207D0D0A202020202020656C7365207B0D0A20202020202020202F2F646F206E6F7468696E672C20';
wwv_flow_api.g_varchar2_table(174) := '74686520636F6E74656E7420697320616C72656164792072656E64657265640D0A20202020202020206E756C6C3B0D0A2020202020207D0D0A202020207D0D0A0D0A0D0A202020202F2F62696E64206E6573746564207265706F72742077697468206D61';
wwv_flow_api.g_varchar2_table(175) := '6E75616C7920747269676765726564206576656E742066726F6D20415045580D0A202020202F2F65783A202428746869732E74726967676572696E67456C656D656E74292E7472696767657228276E65737465647265706F72747265667265736827293B';
wwv_flow_api.g_varchar2_table(176) := '0D0A20202020746869732E6E65737465645265706F72742E74722E6F666628276E65737465647265706F72747265667265736827292E6F6E28276E65737465647265706F727472656672657368272C20242E70726F78792820746869732E64656661756C';
wwv_flow_api.g_varchar2_table(177) := '7443616C6C6261636B4576656E745F726566726573682C2074686973202920293B0D0A0D0A202020202F2F62696E6420616E63686F7273207769746820636C61737320222E6E65737465647265706F72742D2D726566726573682220746F207265667265';
wwv_flow_api.g_varchar2_table(178) := '736820636F6E74656E74206F66206E6573746564207265706F72740D0A20202020746869732E6E65737465645265706F72742E74722E6F66662827636C69636B272C20272E6E65737465647265706F72742D2D7265667265736827292020202E6F6E2827';
wwv_flow_api.g_varchar2_table(179) := '636C69636B272C20272E6E65737465647265706F72742D2D72656672657368272C20242E70726F78792820746869732E64656661756C7443616C6C6261636B4576656E745F726566726573682C2074686973202920293B0D0A202020202F2F62696E6420';
wwv_flow_api.g_varchar2_table(180) := '616E63686F7273207769746820636C61737320222E6E65737465647265706F72742D2D736C69646575702220746F206D616E75616C79200D0A202020202F2F636F6C6C61707365206E6573746564207265706F72740D0A20202020746869732E6E657374';
wwv_flow_api.g_varchar2_table(181) := '65645265706F72742E74722E6F66662827636C69636B272C20272E6E65737465647265706F72742D2D736C696465757027292020202E6F6E2827636C69636B272C20272E6E65737465647265706F72742D2D736C6964657570272C20242E70726F787928';
wwv_flow_api.g_varchar2_table(182) := '20746869732E64656661756C7443616C6C6261636B4576656E745F736C69646575702C2074686973202920293B202020200D0A202020202F2F62696E6420616E63686F7273207769746820636C61737320222E6E65737465647265706F72742D2D736C69';
wwv_flow_api.g_varchar2_table(183) := '64657570416C6C2220746F206D616E75616C79200D0A202020202F2F636F6C6C6170736520616C6C206E6573746564207265706F7274730D0A20202020746869732E6E65737465645265706F72742E74722E6F66662827636C69636B272C20272E6E6573';
wwv_flow_api.g_varchar2_table(184) := '7465647265706F72742D2D736C6964657570416C6C27292E6F6E2827636C69636B272C20272E6E65737465647265706F72742D2D736C6964657570416C6C272C20242E70726F78792820746869732E64656661756C7443616C6C6261636B4576656E745F';
wwv_flow_api.g_varchar2_table(185) := '736C6964657570416C6C2C2074686973202920293B0D0A202020202F2F62696E6420616E63686F7273207769746820636C61737320222E6E65737465647265706F72742D2D657870616E64416C6C2220746F206D616E75616C79200D0A202020202F2F65';
wwv_flow_api.g_varchar2_table(186) := '7870616E6420616C6C206E6573746564207265706F727473206D617463686564207769746820676976656E2073656C6563746F7220617320616E63686F72206174747269627574650D0A20202020746869732E6E65737465645265706F72742E74722E6F';
wwv_flow_api.g_varchar2_table(187) := '66662827636C69636B272C20272E6E65737465647265706F72742D2D657870616E64416C6C27292E6F6E2827636C69636B272C20272E6E65737465647265706F72742D2D657870616E64416C6C272C20242E70726F78792820746869732E64656661756C';
wwv_flow_api.g_varchar2_table(188) := '7443616C6C6261636B4576656E745F657870616E64416C6C2C2074686973202920293B20202020202020200D0A0D0A20202020746869732E657870616E6428293B0D0A202020200D0A20207D2C0D0A2F2F0D0A202064656661756C7443616C6C6261636B';
wwv_flow_api.g_varchar2_table(189) := '4576656E745F657870616E64416C6C3A2066756E6374696F6E2820704576656E7420297B0D0A20202020766172200D0A202020202020616E63686F722020203D202428704576656E742E746172676574292C0D0A20202020202073656C6563746F72203D';
wwv_flow_api.g_varchar2_table(190) := '20616E63686F722E61747472282773656C6563746F7227292C0D0A202020202020746F4265457870616E646564203D20746869732E6E65737465645265706F72742E74722E66696E64282073656C6563746F7220293B0D0A0D0A20202020704576656E74';
wwv_flow_api.g_varchar2_table(191) := '2E73746F7050726F7061676174696F6E28293B0D0A20202020704576656E742E70726576656E7444656661756C7428293B0D0A0D0A202020202F2F66696C74657220746F206F6E6C792073656C6563746F72732066726F6D2074686973206E6573746564';
wwv_flow_api.g_varchar2_table(192) := '207265706F72740D0A20202020746F4265457870616E646564203D20746F4265457870616E6465642E66696C7465722820242E70726F78792866756E6374696F6E2870496E6465782C2070456C656D297B0D0A20202020202076617220636C6F73657374';
wwv_flow_api.g_varchar2_table(193) := '4E6573746564436F6E7461696E6572203D20242870456C656D292E636C6F7365737428275B636C6173732A3D272B746869732E636C61737365732E6E65737465645265706F7274446976436F6E7461696E65722B275D27290D0A20202020202072657475';
wwv_flow_api.g_varchar2_table(194) := '726E20636C6F736573744E6573746564436F6E7461696E65722E676574283029203D3D20746869732E6E65737465645265706F72742E636F6E7461696E65722E6765742830293B0D0A202020207D2C20746869732920293B0D0A0D0A20202020746F4265';
wwv_flow_api.g_varchar2_table(195) := '457870616E6465642E656163682820242E70726F7879282066756E6374696F6E2820704964782C2070456C656D20297B0D0A2020202020207661722073656C66203D20242870456C656D293B0D0A0D0A202020202020696620282073656C662E64617461';
wwv_flow_api.g_varchar2_table(196) := '2827707265746975732D6E65737465645265706F72742729203D3D20756E646566696E65642029207B0D0A202020202020202073656C662E747269676765722827636C69636B27293B0D0A2020202020207D0D0A202020202020656C7365206966202820';
wwv_flow_api.g_varchar2_table(197) := '73656C662E6E65737465645265706F727428276973457870616E6465642729203D3D2066616C73652029207B0D0A202020202020202073656C662E6E65737465645265706F72742827657870616E6427293B0D0A2020202020207D0D0A202020207D2C20';
wwv_flow_api.g_varchar2_table(198) := '746869732920293B0D0A202020200D0A20207D2C0D0A2F2F0D0A2F2F0D0A202064656661756C7443616C6C6261636B4576656E745F736C6964657570416C6C3A2066756E6374696F6E2820704576656E7420297B0D0A20202020766172200D0A20202020';
wwv_flow_api.g_varchar2_table(199) := '2020616E63686F7220202020202020202020202020203D202428704576656E742E746172676574292C0D0A202020202020616E63686F72417474724475726174696F6E20203D20616E63686F722E6174747228276475726174696F6E2729203D3D20756E';
wwv_flow_api.g_varchar2_table(200) := '646566696E656420203F20746869732E73657474696E67732E616E696D6174696F6E54696D65203A207061727365496E742820616E63686F722E6174747228276475726174696F6E272920292C0D0A2020202020206475726174696F6E20202020202020';
wwv_flow_api.g_varchar2_table(201) := '20202020203D2069734E614E28616E63686F72417474724475726174696F6E29202020202020202020202020203F20746869732E73657474696E67732E616E696D6174696F6E54696D65203A20616E63686F72417474724475726174696F6E2C0D0A2020';
wwv_flow_api.g_varchar2_table(202) := '20202020657870616E6465642020202020202020202020203D20746869732E5F676574457870616E64656446726F6D2820746869732E6E65737465645265706F72742E747220293B0D0A0D0A20202020704576656E742E73746F7050726F706167617469';
wwv_flow_api.g_varchar2_table(203) := '6F6E28293B0D0A20202020704576656E742E70726576656E7444656661756C7428293B0D0A0D0A20202020657870616E6465642E6E65737465645265706F72742827636F6C6C61707365272C206475726174696F6E293B0D0A20207D2C0D0A2F2F0D0A2F';
wwv_flow_api.g_varchar2_table(204) := '2F20200D0A202064656661756C7443616C6C6261636B4576656E745F736C69646575703A2066756E6374696F6E2820704576656E7420297B0D0A20202020766172200D0A202020202020616E63686F7220202020202020202020202020203D2024287045';
wwv_flow_api.g_varchar2_table(205) := '76656E742E746172676574292C0D0A202020202020616E63686F72417474724475726174696F6E20203D20616E63686F722E6174747228276475726174696F6E2729203D3D20756E646566696E656420203F20746869732E73657474696E67732E616E69';
wwv_flow_api.g_varchar2_table(206) := '6D6174696F6E54696D65203A207061727365496E742820616E63686F722E6174747228276475726174696F6E272920292C0D0A2020202020206475726174696F6E2020202020202020202020203D2069734E614E28616E63686F72417474724475726174';
wwv_flow_api.g_varchar2_table(207) := '696F6E29202020202020202020202020203F20746869732E73657474696E67732E616E696D6174696F6E54696D65203A20616E63686F72417474724475726174696F6E3B0D0A0D0A20202020704576656E742E73746F7050726F7061676174696F6E2829';
wwv_flow_api.g_varchar2_table(208) := '3B0D0A20202020704576656E742E70726576656E7444656661756C7428293B0D0A202020200D0A20202020746869732E636F6C6C6170736528206475726174696F6E20293B0D0A20207D2C0D0A2F2F0D0A2F2F0D0A202064656661756C7443616C6C6261';
wwv_flow_api.g_varchar2_table(209) := '636B4576656E745F726566726573683A2066756E6374696F6E2820704576656E7420297B0D0A20202020704576656E742E73746F7050726F7061676174696F6E28293B0D0A20202020704576656E742E70726576656E7444656661756C7428293B0D0A20';
wwv_flow_api.g_varchar2_table(210) := '2020200D0A20202020746869732E616A617846657463684461746128207472756520293B0D0A20207D2C0D0A0D0A2020646F43616C6C6261636B437573746F6D3A2066756E6374696F6E28297B0D0A202020207661720D0A20202020202066756E637469';
wwv_flow_api.g_varchar2_table(211) := '6F6E426F6479203D20222020202020202020202020202020202020202020202020202020202020202020202020202020205C6E222B0D0A202020202020202022746869732E63616C6C6261636B203D207B20202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(212) := '202020202020202020202020202020205C6E222B0D0A20202020202020202220202773716C526573756C744F626A272020202020203A20646174612C20202020202020202020202020202020202020202020205C6E222B0D0A2020202020202020222020';
wwv_flow_api.g_varchar2_table(213) := '2774726967676572696E67456C656D656E7427203A20242864612E74726967676572696E67456C656D656E74292C202020205C6E222B0D0A20202020202020202220202761666661637465645265706F727427202020203A20242864612E616666656374';
wwv_flow_api.g_varchar2_table(214) := '6564456C656D656E74735B305D292C20205C6E222B0D0A20202020202020202220202772656E646572656454656D706C6174652720203A2074656D706C617465436F6E74656E742C2020202020202020202020205C6E222B0D0A20202020202020202220';
wwv_flow_api.g_varchar2_table(215) := '202762726F777365724576656E74272020202020203A2064612E62726F777365724576656E742C2020202020202020202020205C6E222B0D0A20202020202020202220202F2F6E65776C7920616464656420696E2076312E312020202020202020202020';
wwv_flow_api.g_varchar2_table(216) := '2020202020202020202020202020202020205C6E222B0D0A20202020202020202220202764796E616D6963416374696F6E2720202020203A2064612C202020202020202020202020202020202020202020202020205C6E222B0D0A202020202020202022';
wwv_flow_api.g_varchar2_table(217) := '202027706C7567696E53657474696E677327202020203A2073657474696E677320202020202020202020202020202020202020205C6E222B0D0A2020202020202020227D3B20202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(218) := '202020202020202020202020202020202020205C6E222B0D0A2020202020202020222F2F7374617274206F6620637573746F6D2063616C6C6261636B206A6176617363726970742020202020202020202020202020205C6E222B0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(219) := '746869732E73657474696E67732E637573746F6D43616C6C6261636B4A732020202020202020202020202020202020202020202B225C6E222B0D0A2020202020202020222F2F656E64206F6620637573746F6D2063616C6C6261636B206A617661736372';
wwv_flow_api.g_varchar2_table(220) := '69707420202020202020202020202020202020205C6E222C0D0A0D0A20202020202074656D7046756E63203D206E65772046756E6374696F6E282274656D706C617465436F6E74656E74222C202273657474696E6773222C20226461222C202264617461';
wwv_flow_api.g_varchar2_table(221) := '222C2066756E6374696F6E426F6479292C0D0A20202020202074656D706C6174653B0D0A0D0A202020206966202820746869732E73657474696E67732E697344656661756C7454656D706C6174652029207B0D0A20202020202074656D706C617465203D';
wwv_flow_api.g_varchar2_table(222) := '202428273C6469763E3C2F6469763E27292E616464436C6173732820746869732E636C61737365732E6E65737465645265706F7274446976436F6E7461696E657220292E617070656E642820746869732E72656E64657254656D706C6174654465666175';
wwv_flow_api.g_varchar2_table(223) := '6C74282920293B0D0A202020207D0D0A20202020656C7365207B0D0A20202020202074656D706C617465203D20746869732E72656E64657254656D706C617465437573746F6D28293B0D0A202020207D0D0A0D0A20202020747279207B0D0A2020202020';
wwv_flow_api.g_varchar2_table(224) := '2074656D7046756E63282074656D706C6174652C20746869732E73657474696E67732C20746869732E6F7074696F6E732C20746869732E6E65737465645265706F72742E616A61784461746120293B0D0A202020207D20636174636828207468726F776E';
wwv_flow_api.g_varchar2_table(225) := '4572726F722029207B0D0A0D0A202020202020746869732E7468726F774572726F7228200D0A20202020202020207B0D0A202020202020202020207469746C653A20746869732E6572726F7254797065732E637573746F6D46756E6374696F6E2E746974';
wwv_flow_api.g_varchar2_table(226) := '6C652C0D0A2020202020202020202074657874203A20275768696C6520657865637574696E6720437573746F6D2043616C6C6261636B204A617661536372697074206572726F72206F636375726564272C0D0A2020202020202020202070726520203A20';
wwv_flow_api.g_varchar2_table(227) := '5B7468726F776E4572726F725D2C0D0A2020202020202020202068696E7473203A205B0D0A202020202020202020202020746869732E5F68696E74282027437573746F6D2063616C6C6261636B204A617661536372697074272C2074656D7046756E632E';
wwv_flow_api.g_varchar2_table(228) := '746F537472696E67282920290D0A202020202020202020205D0D0A20202020202020207D200D0A202020202020293B0D0A0D0A202020207D0D0A20207D2C0D0A2F2F0D0A2F2F0D0A20205F616A617853746172743A2066756E6374696F6E28297B0D0A20';
wwv_flow_api.g_varchar2_table(229) := '202020746869732E616A61782E72756E6E696E67203D20747275653B0D0A0D0A202020206966202820746869732E73657474696E67732E69734C6F6164696E67496E64696361746F722029207B0D0A202020202020746869732E5F73686F775370696E6E';
wwv_flow_api.g_varchar2_table(230) := '657228293B2020202020200D0A202020207D0D0A202020200D0A20207D2C0D0A2F2F0D0A2F2F0D0A20205F616A6178456E643A2066756E6374696F6E28297B0D0A20202020746869732E616A61782E72756E6E696E67203D2066616C73653B0D0A202020';
wwv_flow_api.g_varchar2_table(231) := '20746869732E5F686964655370696E6E657228293B0D0A202020200D0A20207D2C0D0A2F2F0D0A2F2F0D0A20205F616A6178537563636573733A2066756E6374696F6E2870446174612C2070546578745374617475732C20704A71584852297B0D0A2020';
wwv_flow_api.g_varchar2_table(232) := '2020746869732E5F616A6178456E6428293B0D0A0D0A20202020666F7220282076617220693D303B2069203C2070446174612E646174612E6C656E6774683B20692B2B2029207B0D0A20202020202070446174612E646174615B695D2E726F77436C6173';
wwv_flow_api.g_varchar2_table(233) := '73203D206920252032203D3D2030203F20276F646427203A20276576656E273B0D0A202020207D0D0A0D0A20202020746869732E6E65737465645265706F72742E616A617844617461203D2070446174613B0D0A20202020746869732E73686F7728293B';
wwv_flow_api.g_varchar2_table(234) := '20200D0A20207D2C0D0A2F2F0D0A2F2F0D0A20205F68696E743A2066756E6374696F6E2820705469746C652C207056616C75652029207B0D0A2020202072657475726E207B0D0A2020202020206C6162656C3A20705469746C652C0D0A20202020202076';
wwv_flow_api.g_varchar2_table(235) := '616C75653A207056616C75650D0A202020207D0D0A20207D2C0D0A20205F616A61784572726F723A2066756E6374696F6E2820704A715848522C2070546578745374617475732C20704572726F725468726F776E20297B0D0A20202020746869732E5F61';
wwv_flow_api.g_varchar2_table(236) := '6A6178456E6428293B0D0A0D0A2020202069662028207054657874537461747573203D3D20277061727365726572726F72272029207B0D0A202020202020746869732E7468726F774572726F72287B0D0A20202020202020207469746C653A2074686973';
wwv_flow_api.g_varchar2_table(237) := '2E6572726F7254797065732E616A61782E7469746C652C0D0A202020202020202074657874203A2027416A617820726573706F6E736520636F756C64206E6F7420626520706172736564206173204A534F4E272C0D0A202020202020202070726520203A';
wwv_flow_api.g_varchar2_table(238) := '20704572726F725468726F776E2E6D6573736167652C0D0A202020202020202068696E7473203A205B0D0A20202020202020202020746869732E5F68696E74282027416A617820726573706F6E73652074657874272C20704A715848522E726573706F6E';
wwv_flow_api.g_varchar2_table(239) := '73655465787420290D0A20202020202020205D0D0A2020202020207D293B0D0A20202020202072657475726E20766F69642830293B0D0A202020207D0D0A0D0A20202020746869732E7468726F774572726F72287B0D0A2020202020207469746C653A20';
wwv_flow_api.g_varchar2_table(240) := '746869732E6572726F7254797065732E616A61782E7469746C652C0D0A20202020202074657874203A20704A715848522E726573706F6E73654A534F4E2E616464496E666F2C0D0A20202020202070726520203A20704A715848522E726573706F6E7365';
wwv_flow_api.g_varchar2_table(241) := '4A534F4E2E6572726F722C0D0A20202020202068696E7473203A205B0D0A2020202020202020746869732E5F68696E74282027416A6178204A534F4E272C20704A715848522E726573706F6E73654A534F4E20292C0D0A2020202020202020746869732E';
wwv_flow_api.g_varchar2_table(242) := '5F68696E74282027416A6178206572726F7220696E666F272C20704A715848522E726573706F6E73654A534F4E2E616464496E666F20292C0D0A2020202020202020746869732E5F68696E74282027416A6178206572726F72207468726F776E272C2070';
wwv_flow_api.g_varchar2_table(243) := '4572726F725468726F776E20290D0A2020202020205D0D0A202020207D293B0D0A20207D2C20200D0A2F2F0D0A2F2F0D0A2020616A61784665746368446174613A2066756E6374696F6E28207049735265667265736820297B0D0A20202020766172200D';
wwv_flow_api.g_varchar2_table(244) := '0A20202020202070416A617843616C6C6261636B4E616D65203D20746869732E616A61782E69642C0D0A2020202020207044617461203D207B0D0A20202020202020202F2F747970652020202020203A2022474554222C0D0A20202020202020202F2F64';
wwv_flow_api.g_varchar2_table(245) := '6174615479706520203A20226A736F6E222C0D0A2020202020202020783031202020202020203A20746869732E7175657279436F6C756D6E734E616D65732E6A6F696E28273A27292C202F2F6E617A7779206B6F6C756D6E0D0A20202020202020207830';
wwv_flow_api.g_varchar2_table(246) := '32202020202020203A20746869732E7175657279436F6C756D6E7356616C7565732E6A6F696E28273A2729202F2F776172746FC59B6369206B6F6C756D6E0D0A2020202020207D2C0D0A202020202020704F7074696F6E733B0D0A0D0A20202020746869';
wwv_flow_api.g_varchar2_table(247) := '732E616A61782E697352656672657368203D2070497352656672657368203D3D20756E646566696E6564203F2066616C7365203A20704973526566726573683B0D0A202020200D0A20202020704F7074696F6E73203D207B0D0A20202020202073756363';
wwv_flow_api.g_varchar2_table(248) := '657373202020202020202020202020202020202020203A20242E70726F787928746869732E5F616A6178537563636573732C2074686973292C0D0A2020202020206572726F722020202020202020202020202020202020202020203A20242E70726F7879';
wwv_flow_api.g_varchar2_table(249) := '28746869732E5F616A61784572726F7220202C2074686973290D0A202020207D3B0D0A0D0A20202020696620282021746869732E6973416A617852756E6E696E6728292029207B0D0A202020202020746869732E5F616A6178537461727428293B0D0A0D';
wwv_flow_api.g_varchar2_table(250) := '0A2020202020206966202820746869732E71756572794974656D732E6C656E677468203E20302029207B0D0A202020202020202070446174612E706167654974656D73203D202723272B746869732E71756572794974656D732E6A6F696E28272C232729';
wwv_flow_api.g_varchar2_table(251) := '3B0D0A2020202020207D0D0A0D0A202020202020617065782E7365727665722E706C7567696E20282070416A617843616C6C6261636B4E616D652C2070446174612C20704F7074696F6E7320293B0D0A202020207D0D0A20207D2C20200D0A2F2F0D0A2F';
wwv_flow_api.g_varchar2_table(252) := '2F0D0A20205F616A6178437265617465496E64696361746F72546449636F6E3A2066756E6374696F6E28297B0D0A20202020766172200D0A20202020202069636F6E203D202428273C7370616E20636C6173733D22272B746869732E636C61737365732E';
wwv_flow_api.g_varchar2_table(253) := '616A6178496E64696361746F7249636F6E2B27223E3C2F7370616E3E27292C0D0A202020202020646976203D202428273C6469763E3C2F6469763E27293B0D0A0D0A202020206966202820746869732E73657474696E67732E69735370696E6E65725464';
wwv_flow_api.g_varchar2_table(254) := '49636F6E2029207B0D0A2020202020206469762E616464436C6173732820746869732E636C61737365732E616A6178496E64696361746F72526967687420293B20200D0A202020207D0D0A20202020656C7365206966202820746869732E73657474696E';
wwv_flow_api.g_varchar2_table(255) := '67732E69735370696E6E65725464436F6E74656E742029207B0D0A2020202020206469762E616464436C6173732820746869732E636C61737365732E616A6178496E64696361746F72436F6E74656E7420293B2020200D0A202020207D0D0A202020200D';
wwv_flow_api.g_varchar2_table(256) := '0A202020206469762E617070656E642869636F6E293B0D0A2020202072657475726E206469763B0D0A20207D2C20200D0A2F2F0D0A2F2F0D0A20205F73686F775370696E6E65723A2066756E6374696F6E28297B0D0A0D0A202020206966202820746869';
wwv_flow_api.g_varchar2_table(257) := '732E73657474696E67732E69735370696E6E6572546449636F6E2029207B0D0A202020202020746869732E7370696E6E6572203D20746869732E5F616A6178437265617465496E64696361746F72546449636F6E28293B0D0A202020202020746869732E';
wwv_flow_api.g_varchar2_table(258) := '74642E617070656E642820746869732E7370696E6E657220293B0D0A202020207D0D0A20202020656C7365206966202820746869732E73657474696E67732E69735370696E6E65725265706F72742029207B0D0A202020202020746869732E7370696E6E';
wwv_flow_api.g_varchar2_table(259) := '6572203D20617065782E7574696C2E73686F775370696E6E65722820746869732E7461626C6520293B0D0A202020207D0D0A20202020656C7365206966202820746869732E73657474696E67732E69735370696E6E6572546443656C6C2029207B0D0A20';
wwv_flow_api.g_varchar2_table(260) := '2020202020746869732E7370696E6E6572203D20617065782E7574696C2E73686F775370696E6E65722820746869732E746420293B0D0A202020207D0D0A20202020656C7365206966202820746869732E73657474696E67732E69735370696E6E657254';
wwv_flow_api.g_varchar2_table(261) := '64436F6E74656E742029207B0D0A202020202020746869732E7370696E6E6572203D20746869732E5F616A6178437265617465496E64696361746F72546449636F6E28293B0D0A2020202020206966202820746869732E74642E6368696C6472656E2829';
wwv_flow_api.g_varchar2_table(262) := '2E6C656E677468203E20302029207B0D0A2020202020202020746869732E74642E646174612827707265746975732D6E65737465645265706F72742D636F6E74656E74272C20746869732E74642E6368696C6472656E28292E646574616368282920293B';
wwv_flow_api.g_varchar2_table(263) := '0D0A2020202020207D0D0A202020202020656C7365207B0D0A2020202020202020746869732E74642E646174612827707265746975732D6E65737465645265706F72742D636F6E74656E74272C20746869732E74642E74657874282920293B0D0A202020';
wwv_flow_api.g_varchar2_table(264) := '2020207D0D0A2020202020200D0A202020202020746869732E74642E68746D6C2820746869732E7370696E6E657220293B0D0A202020207D0D0A20202020656C7365207B0D0A2020202020200D0A20202020202072657475726E2020746869732E746872';
wwv_flow_api.g_varchar2_table(265) := '6F774572726F72287B0D0A20202020202020207469746C653A20746869732E6572726F7254797065732E636F6E66696775726174696F6E2E7469746C652C0D0A202020202020202074657874203A2027556E6B6E6F776E207370696E6E6572206F707469';
wwv_flow_api.g_varchar2_table(266) := '6F6E272C0D0A202020202020202070726520203A205B2761747472696275746531323A20272B746869732E6F7074696F6E732E616374696F6E2E61747472696275746531325D2C0D0A202020202020202068696E7473203A205B5D2C0D0A0D0A20202020';
wwv_flow_api.g_varchar2_table(267) := '20202020616464496E666F3A2027556E6B6E6F776E207370696E6E6572206F7074696F6E272C0D0A20202020202020206572726F723A202761747472696275746531323A20272B746869732E6F7074696F6E732E616374696F6E2E617474726962757465';
wwv_flow_api.g_varchar2_table(268) := '31320D0A2020202020207D2C20746869732E6572726F7254797065732E636F6E66696775726174696F6E20293B0D0A0D0A202020207D0D0A20207D2C0D0A2F2F0D0A2F2F0D0A20205F686964655370696E6E65723A2066756E6374696F6E28297B0D0A20';
wwv_flow_api.g_varchar2_table(269) := '2020206966202820746869732E73657474696E67732E69734C6F6164696E67496E64696361746F722029207B0D0A202020202020746869732E7370696E6E65722E666164654F7574283430302C20242E70726F78792866756E6374696F6E28297B200D0A';
wwv_flow_api.g_varchar2_table(270) := '2020202020202020746869732E7370696E6E65722E72656D6F766528293B0D0A0D0A20202020202020206966202820746869732E73657474696E67732E69735370696E6E65725464436F6E74656E742029207B0D0A20202020202020202020746869732E';
wwv_flow_api.g_varchar2_table(271) := '74642E68746D6C2820746869732E74642E646174612827707265746975732D6E65737465645265706F72742D636F6E74656E74272920290D0A20202020202020207D0D0A2020202020207D2C207468697329293B0D0A202020207D0D0A20207D2C0D0A0D';
wwv_flow_api.g_varchar2_table(272) := '0A2F2F0D0A2F2F0D0A202072656E64657254656D706C617465437573746F6D3A2066756E6374696F6E28297B0D0A20202020766172200D0A20202020202074656D706C617465203D20746869732E73657474696E67732E637573746F6D54656D706C6174';
wwv_flow_api.g_varchar2_table(273) := '652C0D0A20202020202072656E64657265642C0D0A202020202020646174614F626A656374203D20746869732E6E65737465645265706F72742E616A6178446174612C0D0A2020202020206572726F72203D207B0D0A2020202020202020616464496E66';
wwv_flow_api.g_varchar2_table(274) := '6F3A206E756C6C2C0D0A20202020202020206572726F723A206E756C6C0D0A2020202020207D2C0D0A20202020202072656E64657265642C0D0A2020202020206572726F72546578743B0D0A0D0A202020206966202820646174614F626A6563742E6461';
wwv_flow_api.g_varchar2_table(275) := '74612E6C656E677468203D3D20302029207B0D0A20202020202072657475726E20746869732E5F72656E6465724E6F44617461466F756E6428293B0D0A202020207D0D0A0D0A20202020747279207B0D0A20202020202072656E6465726564203D204D75';
wwv_flow_api.g_varchar2_table(276) := '7374616368652E72656E646572282074656D706C6174652C20646174614F626A656374293B0D0A202020207D20636174636828206572726F722029207B0D0A0D0A2020202020206572726F722E616464496E666F203D20275768696C652072656E646572';
wwv_flow_api.g_varchar2_table(277) := '696E6720637573746F6D2074656D706C61746520756E6578706563746564206572726F72206F6363757265643A20273B0D0A2020202020206572726F722E6572726F72203D206572726F723B0D0A20202020202072657475726E20746869732E5F676574';
wwv_flow_api.g_varchar2_table(278) := '4572726F7254656D706C61746528206572726F722C2027636F6E66696775726174696F6E2720293B0D0A202020207D0D0A0D0A2020202072657475726E2072656E64657265643B0D0A20207D2C20200D0A2F2F0D0A2F2F0D0A20205F72656E6465724E6F';
wwv_flow_api.g_varchar2_table(279) := '44617461466F756E643A2066756E6374696F6E28297B0D0A2020202072657475726E20273C64697620636C6173733D226E6F44617461466F756E64223E272B746869732E73657474696E67732E6E6F44617461466F756E642B273C2F6469763E270D0A20';
wwv_flow_api.g_varchar2_table(280) := '207D2C0D0A2F2F0D0A2F2F0D0A202067657454656D706C61746544656661756C74426F64793A2066756E6374696F6E28297B0D0A20202020766172200D0A202020202020646174614F626A656374203D20746869732E6E65737465645265706F72742E61';
wwv_flow_api.g_varchar2_table(281) := '6A6178446174612C0D0A20202020202074645F726F775F74656D706C617465203D2027272C0D0A2020202020206C6576656C203D20746869732E696E63657074696F6E2E6C6576656C3B0D0A0D0A0D0A20202020666F722028207661722069203D20303B';
wwv_flow_api.g_varchar2_table(282) := '2069203C20646174614F626A6563742E686561646572732E6C656E6774683B20692B2B2029207B0D0A20202020202074645F726F775F74656D706C617465202B3D2027272020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(283) := '20202020202020202020202020202020202020202020202020202020202020202020202B0D0A2020202020202020273C74642720202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(284) := '20202020202020202020202020202020202020202020202020202020202020202B0D0A202020202020202020202720686561646572733D224E525F272B6C6576656C2B275F272B646174614F626A6563742E686561646572735B695D2E434F4C554D4E5F';
wwv_flow_api.g_varchar2_table(285) := '4E414D452B2722202720202020202020202020202020202020202020202B0D0A2020202020202020202027206C6576656C3D22272B6C6576656C2B2722202720202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(286) := '20202020202020202020202020202020202020202020202020202B0D0A202020202020202020202720636C6173733D22272B746869732E636C61737365732E6E65737465645265706F727443656C6C2B2720272B646174614F626A6563742E6865616465';
wwv_flow_api.g_varchar2_table(287) := '72735B695D2E434F4C554D4E5F545950452B27222720202B0D0A202020202020202020202720747970653D22272B646174614F626A6563742E686561646572735B695D2E434F4C554D4E5F545950452B2722272020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(288) := '20202020202020202020202020202020202020202B0D0A2020202020202020273E27202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(289) := '20202020202020202020202020202020202B0D0A20202020202020202020277B7B7B272B20646174614F626A6563742E686561646572735B695D2E434F4C554D4E5F4E414D45202B277D7D7D272020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(290) := '20202020202020202020202020202B0D0A2020202020202020273C2F74643E273B0D0A202020207D0D0A0D0A2020202074645F726F775F74656D706C617465203D20277B7B23646174617D7D3C747220636C6173733D227B7B726F77436C6173737D7D22';
wwv_flow_api.g_varchar2_table(291) := '3E272B74645F726F775F74656D706C6174652B273C2F74723E7B7B2F646174617D7D273B20202020200D0A2020202072657475726E2074645F726F775F74656D706C6174653B0D0A20207D2C0D0A2F2F0D0A2F2F0D0A202067657454656D706C61746544';
wwv_flow_api.g_varchar2_table(292) := '656661756C743A2066756E6374696F6E28297B0D0A202020207661720D0A20202020202074685F726F775F74656D706C617465203D2027272C0D0A202020202020646174614F626A656374203D20746869732E6E65737465645265706F72742E616A6178';
wwv_flow_api.g_varchar2_table(293) := '446174612C0D0A20202020202074656D706C6174652C0D0A20202020202068656164657248746D6C2C0D0A2020202020206865616465724172722C0D0A202020202020697348656164657249636F6E203D2066616C73652C0D0A2020202020207461626C';
wwv_flow_api.g_varchar2_table(294) := '65436C617373203D20746869732E73657474696E67732E69735374726563685265706F7274203F20746869732E636C61737365732E6E65737465645265706F72745461626C652B2720272B746869732E636C61737365732E7461626C6553747265636852';
wwv_flow_api.g_varchar2_table(295) := '65706F7274203A20746869732E636C61737365732E6E65737465645265706F72745461626C653B0D0A0D0A20202020666F722028207661722069203D20303B2069203C20646174614F626A6563742E686561646572732E6C656E6774683B20692B2B2029';
wwv_flow_api.g_varchar2_table(296) := '207B0D0A2020202020202F2F69636F6E732066612D69636F6E6E616D650D0A20202020202069662028202F5E64657269766965645B302D395D7B317D5B302D395D7B317D5F66615F5B612D7A5D7B332C7D242F67692E746573742820646174614F626A65';
wwv_flow_api.g_varchar2_table(297) := '63742E686561646572735B695D2E434F4C554D4E5F4E414D452E746F4C6F776572436173652829292029207B0D0A2020202020202020686561646572417272203D20646174614F626A6563742E686561646572735B695D2E434F4C554D4E5F4E414D452E';
wwv_flow_api.g_varchar2_table(298) := '73706C697428275F27293B0D0A202020202020202068656164657248746D6C203D20273C7370616E20636C6173733D2266612066612D272B6865616465724172725B325D2E746F4C6F7765724361736528292B27223E3C2F7370616E3E273B0D0A202020';
wwv_flow_api.g_varchar2_table(299) := '2020202020697348656164657249636F6E203D20747275653B0D0A2020202020207D0D0A2020202020202F2F69636F6E732066612D69636F6E6E616D652D6D6F72656E616D650D0A202020202020656C736520696620282F5E64657269766965645B302D';
wwv_flow_api.g_varchar2_table(300) := '395D7B317D5B302D395D7B317D5F66615F5B612D7A5D7B332C7D5F5B612D7A5D7B332C7D242F67692E746573742820646174614F626A6563742E686561646572735B695D2E434F4C554D4E5F4E414D452E746F4C6F776572436173652829292029207B0D';
wwv_flow_api.g_varchar2_table(301) := '0A2020202020202020686561646572417272203D20646174614F626A6563742E686561646572735B695D2E434F4C554D4E5F4E414D452E73706C697428275F27293B0D0A202020202020202068656164657248746D6C203D20273C7370616E20636C6173';
wwv_flow_api.g_varchar2_table(302) := '733D2266612066612D272B6865616465724172725B325D2E746F4C6F7765724361736528292B272D272B6865616465724172725B335D2E746F4C6F7765724361736528292B27223E3C2F7370616E3E273B0D0A2020202020202020697348656164657249';
wwv_flow_api.g_varchar2_table(303) := '636F6E203D20747275653B0D0A2020202020207D0D0A202020202020656C73652069662028202F5E64657269766965645B302D395D7B317D5B302D395D7B317D5F656D707479242F67692E746573742820646174614F626A6563742E686561646572735B';
wwv_flow_api.g_varchar2_table(304) := '695D2E434F4C554D4E5F4E414D452E746F4C6F776572436173652829292029207B0D0A202020202020202068656164657248746D6C203D20273C212D2D20272B646174614F626A6563742E686561646572735B695D2E434F4C554D4E5F4E414D452B2720';
wwv_flow_api.g_varchar2_table(305) := '2D2D3E273B0D0A2020202020202020697348656164657249636F6E203D20747275653B0D0A2020202020207D0D0A202020202020656C7365207B0D0A2020202020202020697348656164657249636F6E203D2066616C73653B0D0A202020202020202068';
wwv_flow_api.g_varchar2_table(306) := '656164657248746D6C203D20646174614F626A6563742E686561646572735B695D2E434F4C554D4E5F4E414D453B0D0A2020202020207D0D0A0D0A2020202020206966202820746869732E73657474696E67732E6973536F7274696E67537570706F7274';
wwv_flow_api.g_varchar2_table(307) := '656420262620697348656164657249636F6E203D3D2066616C73652029207B0D0A202020202020202074685F726F775F74656D706C617465202B3D2027272B0D0A20202020202020202020273C746820636F6C756D6E3D22272B646174614F626A656374';
wwv_flow_api.g_varchar2_table(308) := '2E686561646572735B695D2E434F4C554D4E5F4E414D452B272220202020202020202020202020202020202020202020202020202020202020202020202020272B0D0A202020202020202020202720202020636C6173733D22272B746869732E636C6173';
wwv_flow_api.g_varchar2_table(309) := '7365732E6E65737465645265706F72744865616465722B2720272B646174614F626A6563742E686561646572735B695D2E434F4C554D4E5F545950452B27223E20272B200D0A202020202020202020202720203C64697620636C6173733D22752D526570';
wwv_flow_api.g_varchar2_table(310) := '6F72742D736F7274223E20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020272B0D0A2020202020202020202027202020203C7370616E20636C6173733D22';
wwv_flow_api.g_varchar2_table(311) := '752D5265706F72742D736F727448656164696E67223E202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020272B0D0A20202020202020202020272020202020203C6120687265663D22';
wwv_flow_api.g_varchar2_table(312) := '6A6176617363726970743A766F696428302922207469746C653D22536F7274206279207468697320636F6C756D6E223E272B202068656164657248746D6C202B273C2F613E202020272B0D0A2020202020202020202027202020203C2F7370616E3E2020';
wwv_flow_api.g_varchar2_table(313) := '2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020272B0D0A2020202020202020202027202020203C7370616E2063';
wwv_flow_api.g_varchar2_table(314) := '6C6173733D22752D5265706F72742D736F727449636F6E20612D49636F6E2069636F6E2D7270742D736F72742D64657363223E3C2F7370616E3E202020202020202020202020202020202020272B0D0A2020202020202020202027202020203C7370616E';
wwv_flow_api.g_varchar2_table(315) := '20636C6173733D22752D5265706F72742D736F727449636F6E20612D49636F6E2069636F6E2D7270742D736F72742D617363223E3C2F7370616E3E20202020202020202020202020202020202020272B0D0A202020202020202020202720203C2F646976';
wwv_flow_api.g_varchar2_table(316) := '3E20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020272B0D0A20202020202020202020273C2F74683E';
wwv_flow_api.g_varchar2_table(317) := '273B20200D0A2020202020207D0D0A202020202020656C7365207B0D0A202020202020202074685F726F775F74656D706C617465202B3D20273C746820272B0D0A2020202020202020202027636C6173733D22272B746869732E636C61737365732E6E65';
wwv_flow_api.g_varchar2_table(318) := '737465645265706F72744865616465722B2720272B2820697348656164657249636F6E203F202749434F4E27203A20272720292B2720272B646174614F626A6563742E686561646572735B695D2E434F4C554D4E5F545950452B2722272B0D0A20202020';
wwv_flow_api.g_varchar2_table(319) := '20202020202027636F6C756D6E3D22272B646174614F626A6563742E686561646572735B695D2E434F4C554D4E5F4E414D452B27223E272B2068656164657248746D6C202B273C2F74683E273B0D0A2020202020207D0D0A202020207D0D0A0D0A202020';
wwv_flow_api.g_varchar2_table(320) := '2074685F726F775F74656D706C617465203D20273C74723E272B74685F726F775F74656D706C6174652B273C2F74723E273B0D0A202020200D0A2020202074656D706C617465203D20273C7461626C6520636C6173733D22272B7461626C65436C617373';
wwv_flow_api.g_varchar2_table(321) := '2B27223E3C74686561643E272B74685F726F775F74656D706C6174652B273C2F74686561643E3C74626F64793E272B20746869732E67657454656D706C61746544656661756C74426F64792829202B273C2F74626F64793E3C2F7461626C653E273B0D0A';
wwv_flow_api.g_varchar2_table(322) := '2020202072657475726E2074656D706C6174653B0D0A0D0A20207D2C20200D0A2F2F0D0A2F2F205573656420627920746869732E736F72742066756E6374696F6E20746F2072656E6465722074626F6479206F66206E6573746564207265706F72740D0A';
wwv_flow_api.g_varchar2_table(323) := '202072656E64657254656D706C61746544656661756C74426F64793A2066756E6374696F6E28297B0D0A2020202072657475726E204D757374616368652E72656E6465722820746869732E67657454656D706C61746544656661756C74426F647928292C';
wwv_flow_api.g_varchar2_table(324) := '20746869732E6E65737465645265706F72742E616A61784461746120293B0D0A20207D2C0D0A2F2F0D0A2F2F0D0A202072656E64657254656D706C61746544656661756C743A2066756E6374696F6E28297B0D0A20202020766172200D0A202020202020';
wwv_flow_api.g_varchar2_table(325) := '636F6E74656E743B0D0A0D0A202020206966202820746869732E6E65737465645265706F72742E616A6178446174612E646174612E6C656E677468203D3D20302029207B0D0A202020202020636F6E74656E74203D202428746869732E5F72656E646572';
wwv_flow_api.g_varchar2_table(326) := '4E6F44617461466F756E642829293B0D0A202020207D0D0A20202020656C7365207B0D0A202020202020636F6E74656E74203D204D757374616368652E72656E6465722820746869732E67657454656D706C61746544656661756C7428292C2074686973';
wwv_flow_api.g_varchar2_table(327) := '2E6E65737465645265706F72742E616A61784461746120293B0D0A202020202020636F6E74656E74203D202428636F6E74656E74293B0D0A0D0A202020202020636F6E74656E742E637373287B0D0A2020202020202020276261636B67726F756E64436F';
wwv_flow_api.g_varchar2_table(328) := '6C6F72273A20746869732E73657474696E67732E6267436F6C6F720D0A2020202020207D293B0D0A0D0A202020202020636F6E74656E742E66696E6428277468206127292E62696E642827636C69636B272C20242E70726F787928746869732E736F7274';
wwv_flow_api.g_varchar2_table(329) := '2C207468697329293B20200D0A202020207D0D0A0D0A2020202072657475726E20636F6E74656E743B0D0A20207D2C20200D0A2F2F0D0A2F2F0D0A202063726561746544656661756C7443616C6C6261636B526F773A2066756E6374696F6E28297B0D0A';
wwv_flow_api.g_varchar2_table(330) := '202020202F2F646F20726F7A77617A656E69612C206E61646177616E696520756E696B616C6E65676F2049440D0A20202020766172200D0A20202020202074722020202020202020202020203D202428273C74723E3C2F74723E27292C0D0A2020202020';
wwv_flow_api.g_varchar2_table(331) := '2074642020202020202020202020203D202428273C74643E3C2F74643E27292C0D0A202020202020646976496E5464202020202020203D202428273C6469763E3C2F6469763E27292C0D0A20202020202064697654644F766572666C6F77203D20242827';
wwv_flow_api.g_varchar2_table(332) := '3C6469763E3C2F6469763E27293B0D0A0D0A202020202F2F6A65736C692077796B6F727A797374756A65206D617848656967687420746F207573746177206D6178486569676874206F72617A207573746177207265666572656E636A652067647A696520';
wwv_flow_api.g_varchar2_table(333) := '70697361C4870D0A202020206966202820746869732E73657474696E67732E69735365744D61784865696768742029207B0D0A20202020202064697654644F766572666C6F772E616464436C6173732820746869732E636C61737365732E6E6573746564';
wwv_flow_api.g_varchar2_table(334) := '5265706F72744F766572666C6F77436F6E7461696E657220290D0A20202020202064697654644F766572666C6F772E63737328276D6178486569676874272C20746869732E73657474696E67732E6D6178486569676874293B0D0A202020202020646976';
wwv_flow_api.g_varchar2_table(335) := '54644F766572666C6F772E617070656E64546F2820646976496E546420293B0D0A202020202020746869732E6E65737465645265706F72742E636F6E74656E7448657265203D2064697654644F766572666C6F773B0D0A202020207D0D0A20202020656C';
wwv_flow_api.g_varchar2_table(336) := '7365207B0D0A202020202020746869732E6E65737465645265706F72742E636F6E74656E7448657265203D20646976496E54643B0D0A202020207D0D0A0D0A2020202074722E6174747228276E65737465642D6C6576656C272C20746869732E696E6365';
wwv_flow_api.g_varchar2_table(337) := '7074696F6E2E6C6576656C20293B0D0A2020202074722E616464436C6173732820746869732E636C61737365732E6E65737465645265706F72745472436F6E7461696E657220293B0D0A2020202074642E617474722827636F6C7370616E272C20746869';
wwv_flow_api.g_varchar2_table(338) := '732E726F772E66696E642827746427292E6C656E677468293B0D0A0D0A20202020646976496E54642E616464436C6173732820746869732E636C61737365732E6E65737465645265706F7274446976436F6E7461696E657220293B0D0A0D0A2020202074';
wwv_flow_api.g_varchar2_table(339) := '642E6F6E28276D6F757365656E746572272C20242E70726F787928746869732E5F686967686C696768742C7468697329290D0A2020202074642E6F6E28276D6F7573656C65617665272C20242E70726F787928746869732E5F72656D6F7665486967686C';
wwv_flow_api.g_varchar2_table(340) := '696768742C7468697329293B0D0A0D0A2020202074642E617070656E642820646976496E546420293B0D0A2020202074722E617070656E642820746420293B0D0A0D0A2020202072657475726E2074723B0D0A20207D2C0D0A2F2F0D0A2F2F0D0A20205F';
wwv_flow_api.g_varchar2_table(341) := '6765744572726F7254656D706C6174653A2066756E6374696F6E2820704572726F7220297B0D0A20202020766172200D0A2020202020207469746C652C206469763B0D0A0D0A0D0A202020206966202820704572726F722E70726520696E7374616E6365';
wwv_flow_api.g_varchar2_table(342) := '6F662041727261792029207B0D0A202020202020704572726F722E707265203D20704572726F722E7072652E6A6F696E28225C6E22293B0D0A202020202020704572726F722E707265203D20704572726F722E7072652E7265706C616365282F3C2F6769';
wwv_flow_api.g_varchar2_table(343) := '2C2027266C743B27292E7265706C616365282F3E2F67692C20272667743B27293B0D0A202020207D0D0A20202020656C7365206966202820704572726F722E70726520696E7374616E63656F66204F626A6563742029207B0D0A20202020202070457272';
wwv_flow_api.g_varchar2_table(344) := '6F722E707265203D204A534F4E2E737472696E676966792820704572726F722E7072652C206E756C6C2C203220292E7265706C616365282F3C2F67692C2027266C743B27292E7265706C616365282F3E2F67692C20272667743B27293B0D0A202020207D';
wwv_flow_api.g_varchar2_table(345) := '0D0A20202020656C7365206966202820747970656F6620704572726F722E707265203D3D2022737472696E672229207B0D0A202020202020704572726F722E707265203D20704572726F722E7072652E7265706C616365282F3C2F67692C2027266C743B';
wwv_flow_api.g_varchar2_table(346) := '27292E7265706C616365282F3E2F67692C20272667743B27293B200D0A202020207D0D0A20202020656C7365207B0D0A202020202020617065782E64656275672E696E666F28275F6765744572726F7254656D706C6174652074797065206F6620704572';
wwv_flow_api.g_varchar2_table(347) := '726F722E7072653A272C2028747970656F6620704572726F722E7072652920290D0A202020207D0D0A0D0A202020202F2F7A726F62696320626172647A69656A20637A7974656C6E650D0A20202020646976203D20242827272B0D0A202020202020273C';
wwv_flow_api.g_varchar2_table(348) := '64697620636C6173733D22707265746975732D2D6572726F72223E202020202020202020202020202020202020202020202020202020202020202020202020272B0D0A2020202020202720203C64697620636C6173733D22707265746975732D2D726561';
wwv_flow_api.g_varchar2_table(349) := '736F6E223E202020202020202020202020202020202020202020202020202020202020202020272B0D0A20202020202027202020203C7370616E20636C6173733D2266612066612D7761726E696E67223E3C2F7370616E3E202020202020202020202020';
wwv_flow_api.g_varchar2_table(350) := '20202020202020202020202020272B0D0A20202020202027202020203C7370616E20636C6173733D22707265746975732D2D6572726F725469746C65223E272B704572726F722E7469746C652B273C2F7370616E3E202020272B0D0A2020202020202720';
wwv_flow_api.g_varchar2_table(351) := '203C2F6469763E2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020272B0D0A2020202020202720203C6469763E20202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(352) := '2020202020202020202020202020202020202020202020202020202020202020202020202020272B0D0A20202020202027202020203C7370616E20636C6173733D22707265746975732D2D6572726F72416464496E666F223E272B704572726F722E7465';
wwv_flow_api.g_varchar2_table(353) := '78742B273C2F7370616E3E2020272B0D0A2020202020202720203C2F6469763E2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020272B0D0A2020202020202720';
wwv_flow_api.g_varchar2_table(354) := '203C64697620636C6173733D22707265746975732D2D746563684572726F72223E202020202020202020202020202020202020202020202020202020202020272B0D0A20202020202027202020203C7072653E272B704572726F722E7072652B273C2F70';
wwv_flow_api.g_varchar2_table(355) := '72653E2020202020202020202020202020202020202020202020202020202020202020202020272B0D0A2020202020202720203C2F6469763E20202020202020202020202020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(356) := '20202020202020202020202020272B0D0A202020202020273C2F6469763E20202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020272B0D0A202020202727293B';
wwv_flow_api.g_varchar2_table(357) := '0D0A0D0A2020202072657475726E206469763B0D0A20207D2C20200D0A0D0A2F2F0D0A2F2F0D0A20205F657870616E646564496E5265706F72743A2066756E6374696F6E28297B0D0A2020202076617220657870616E646564456C656D656E7473203D20';
wwv_flow_api.g_varchar2_table(358) := '2428293B0D0A0D0A20202020746869732E7461626C652E66696E642827746427292E65616368282066756E6374696F6E28297B0D0A202020202020766172200D0A202020202020202073656C66203D20242874686973292C0D0A20202020202020207464';
wwv_flow_api.g_varchar2_table(359) := '4F776E6572203D2073656C662E646174612827707265746975732D6E65737465645265706F72742D6F776E657227293B0D0A0D0A202020202020696620282074644F776E657220213D20756E646566696E65642026262074644F776E65722E6E65737465';
wwv_flow_api.g_varchar2_table(360) := '645265706F727428276973457870616E6465642729203D3D20747275652029207B0D0A2020202020202020657870616E646564456C656D656E7473203D20657870616E646564456C656D656E74732E616464282074644F776E657220293B0D0A20202020';
wwv_flow_api.g_varchar2_table(361) := '20207D0D0A0D0A0D0A202020207D20293B0D0A0D0A2020202072657475726E20657870616E646564456C656D656E74733B0D0A20207D2C0D0A2F2F0D0A2F2F0D0A20205F657870616E646564536973746572733A2066756E6374696F6E28297B0D0A2020';
wwv_flow_api.g_varchar2_table(362) := '202076617220657870616E646564456C656D656E7473203D202428293B0D0A0D0A20202020746869732E726F772E66696E642827746427292E65616368282066756E6374696F6E28297B0D0A202020202020766172200D0A202020202020202073656C66';
wwv_flow_api.g_varchar2_table(363) := '203D20242874686973292C0D0A202020202020202074644F776E6572203D2073656C662E646174612827707265746975732D6E65737465645265706F72742D6F776E657227293B0D0A0D0A202020202020696620282074644F776E657220213D20756E64';
wwv_flow_api.g_varchar2_table(364) := '6566696E65642026262074644F776E65722E6E65737465645265706F727428276973457870616E6465642729203D3D20747275652029207B0D0A2020202020202020657870616E646564456C656D656E7473203D20657870616E646564456C656D656E74';
wwv_flow_api.g_varchar2_table(365) := '732E616464282074644F776E657220293B0D0A2020202020207D0D0A202020207D20293B0D0A0D0A2020202072657475726E20657870616E646564456C656D656E74733B0D0A20207D2C20200D0A2F2F0D0A2F2F0D0A2020736F72743A2066756E637469';
wwv_flow_api.g_varchar2_table(366) := '6F6E2820704576656E7420297B0D0A20202020766172200D0A202020202020616E63686F72203D202428704576656E742E63757272656E74546172676574292C0D0A2020202020207468203D20616E63686F722E636C6F736573742827746827292C0D0A';
wwv_flow_api.g_varchar2_table(367) := '2020202020206F746865725468203D2074682E70726576416C6C28292E616464282074682E6E657874416C6C282920292C0D0A202020202020646976203D2074682E66696E6428272E752D5265706F72742D736F727427292C0D0A202020202020686561';
wwv_flow_api.g_varchar2_table(368) := '64657254657874203D20616E63686F722E7465787428293B0D0A0D0A202020202F2F617065782E64656275672E6C6F672827736F7274272C20276E65737465645265706F727444617461272C20746869732E6E65737465645265706F72742E616A617844';
wwv_flow_api.g_varchar2_table(369) := '617461293B0D0A0D0A202020206F7468657254682E66696E6428272E752D5265706F72742D736F727427292E72656D6F7665436C6173732827736F72742D2D6465736320736F72742D2D61736320736F727427293B0D0A0D0A2020202069662028202164';
wwv_flow_api.g_varchar2_table(370) := '69762E697328272E736F72742729207C7C206469762E697328272E736F72742D2D617363272929207B0D0A202020202020746869732E6E65737465645265706F72742E616A6178446174612E646174612E736F727428746869732E5F736F727446756E63';
wwv_flow_api.g_varchar2_table(371) := '2820686561646572546578742029293B0D0A202020202020746869732E6E65737465645265706F72742E616A6178446174612E646174612E7265766572736528293B0D0A2020202020206469762E72656D6F7665436C6173732827736F72742D2D617363';
wwv_flow_api.g_varchar2_table(372) := '27292E616464436C617373282027736F727420736F72742D2D646573632720293B0D0A202020207D0D0A20202020656C7365207B0D0A202020202020746869732E6E65737465645265706F72742E616A6178446174612E646174612E736F727428746869';
wwv_flow_api.g_varchar2_table(373) := '732E5F736F727446756E632820686561646572546578742029293B0D0A2020202020206469762E72656D6F7665436C6173732827736F72742D2D6465736327292E616464436C617373282027736F727420736F72742D2D6173632720293B200D0A202020';
wwv_flow_api.g_varchar2_table(374) := '207D0D0A0D0A20202020746869732E6E65737465645265706F72742E636F6E74656E74486572652E66696E64282774626F647927292E68746D6C2820746869732E72656E64657254656D706C61746544656661756C74426F6479282920293B0D0A20207D';
wwv_flow_api.g_varchar2_table(375) := '2C0D0A2F2F0D0A2F2F0D0A20205F736F727446756E633A2066756E6374696F6E287050726F706572747929207B0D0A2020202076617220736F72744F72646572203D20313B0D0A0D0A202020206966287050726F70657274795B305D203D3D3D20222D22';
wwv_flow_api.g_varchar2_table(376) := '29207B0D0A202020202020736F72744F72646572203D202D313B0D0A2020202020207050726F7065727479203D207050726F70657274792E7375627374722831293B0D0A202020207D0D0A0D0A2020202072657475726E2066756E6374696F6E2028612C';
wwv_flow_api.g_varchar2_table(377) := '6229207B0D0A20202020202076617220726573756C74203D2028615B7050726F70657274795D203C20625B7050726F70657274795D29203F202D31203A2028615B7050726F70657274795D203E20625B7050726F70657274795D29203F2031203A20303B';
wwv_flow_api.g_varchar2_table(378) := '0D0A20202020202072657475726E20726573756C74202A20736F72744F726465723B0D0A202020207D0D0A20207D2C0D0A2F2F0D0A2F2F0D0A20205F72656D6F7665486967686C696768743A2066756E6374696F6E2820704576656E7420297B0D0A2020';
wwv_flow_api.g_varchar2_table(379) := '2020704576656E742E73746F70496D6D65646961746550726F7061676174696F6E28293B0D0A0D0A202020206966202820746869732E657870616E6465642029207B0D0A202020202020746869732E74642E6373732820276261636B67726F756E64436F';
wwv_flow_api.g_varchar2_table(380) := '6C6F72272C20746869732E73657474696E67732E6267436F6C6F7220290D0A202020202020746869732E5F666F7263654261636B67726F756E64436F6C6F722820746869732E746420293B0D0A0D0A202020202020746869732E6E65737465645265706F';
wwv_flow_api.g_varchar2_table(381) := '72742E74642E6373732820276261636B67726F756E64436F6C6F72272C20746869732E73657474696E67732E6267436F6C6F7220293B0D0A0D0A0D0A202020202020746869732E726F772E72656D6F7665436C6173732827707265746975732D2D686F76';
wwv_flow_api.g_varchar2_table(382) := '657227293B0D0A2020202020202F2F626C6164206764792077796C61637A6F6E792063616368652069206E6173746570756A612070726F6261206F64737769657A656E6961206E6573746564207265706F7274207A20706F7A696F6D75206E6573746564';
wwv_flow_api.g_varchar2_table(383) := '207265706F72740D0A202020202020746869732E6E65737465645265706F72742E74722E72656D6F7665436C6173732827707265746975732D2D686F76657227293B0D0A202020207D0D0A20207D2C0D0A2F2F0D0A2F2F0D0A20205F686967686C696768';
wwv_flow_api.g_varchar2_table(384) := '743A2066756E6374696F6E2820704576656E7420297B0D0A20202020704576656E742E73746F70496D6D65646961746550726F7061676174696F6E28293B0D0A0D0A202020206966202820746869732E657870616E6465642029207B0D0A202020202020';
wwv_flow_api.g_varchar2_table(385) := '746869732E74642E6373732820276261636B67726F756E64436F6C6F72272C20746869732E73657474696E67732E4267436F6C6F72686967686C6967687420293B0D0A2020202020202F2F697473206E656564656420746F206F76657272696465202169';
wwv_flow_api.g_varchar2_table(386) := '6D706F7274616E742066726F6D2041504558207468656D65206373730D0A202020202020746869732E5F666F7263654261636B67726F756E64436F6C6F722820746869732E746420293B0D0A0D0A202020202020746869732E6E65737465645265706F72';
wwv_flow_api.g_varchar2_table(387) := '742E74642E6373732820276261636B67726F756E64436F6C6F72272C20746869732E73657474696E67732E4267436F6C6F72686967686C6967687420293B0D0A2020202020200D0A202020202020746869732E726F772E616464436C6173732827707265';
wwv_flow_api.g_varchar2_table(388) := '746975732D2D686F76657227293B0D0A202020202020746869732E6E65737465645265706F72742E74722E616464436C6173732827707265746975732D2D686F76657227293B0D0A202020207D0D0A20207D2C0D0A2F2F0D0A2F2F0D0A20206368616E67';
wwv_flow_api.g_varchar2_table(389) := '65426F726465725374796C653A2066756E6374696F6E28297B0D0A20202020766172200D0A2020202020206F74686572546473202020203D20746869732E74642E70726576416C6C2827746427292E6164642820746869732E74642E6E657874416C6C28';
wwv_flow_api.g_varchar2_table(390) := '277464272920292C0D0A202020202020626F726465725374796C65203D2027736F6C6964272C0D0A202020202020626F726465725769647468203D2027317078272C0D0A202020202020626F72646572436F6C6F72203D20746869732E73657474696E67';
wwv_flow_api.g_varchar2_table(391) := '732E626F72646572436F6C6F722C0D0A2020202020206267436F6C6F7220202020203D20746869732E73657474696E67732E6267436F6C6F723B0D0A0D0A202020206966202820746869732E657870616E6465642029207B0D0A20202020202074686973';
wwv_flow_api.g_varchar2_table(392) := '2E74642E637373287B0D0A202020202020202027626F726465722D6C65667427202020203A20626F7264657257696474682B2720272B626F726465725374796C652B2720272B626F72646572436F6C6F722C0D0A202020202020202027626F726465722D';
wwv_flow_api.g_varchar2_table(393) := '746F702720202020203A20626F7264657257696474682B2720272B626F726465725374796C652B2720272B626F72646572436F6C6F722C0D0A202020202020202027626F726465722D7269676874272020203A20626F7264657257696474682B2720272B';
wwv_flow_api.g_varchar2_table(394) := '626F726465725374796C652B2720272B626F72646572436F6C6F722C0D0A202020202020202027626F726465722D626F74746F6D2720203A20626F7264657257696474682B2720272B626F726465725374796C652B2720272B6267436F6C6F722C0D0A20';
wwv_flow_api.g_varchar2_table(395) := '20202020202020276261636B67726F756E64436F6C6F72273A206267436F6C6F720D0A2020202020207D293B0D0A0D0A202020202020746869732E6E65737465645265706F72742E74642E637373287B0D0A2020202020202020276261636B67726F756E';
wwv_flow_api.g_varchar2_table(396) := '64436F6C6F72273A206267436F6C6F722C0D0A202020202020202027626F726465724C6566742720202020203A20626F7264657257696474682B2720272B626F726465725374796C652B2720272B626F72646572436F6C6F722C0D0A2020202020202020';
wwv_flow_api.g_varchar2_table(397) := '27626F72646572526967687427202020203A20626F7264657257696474682B2720272B626F726465725374796C652B2720272B626F72646572436F6C6F722C0D0A202020202020202027626F72646572426F74746F6D272020203A20626F726465725769';
wwv_flow_api.g_varchar2_table(398) := '6474682B2720272B626F726465725374796C652B2720272B626F72646572436F6C6F720D0A2020202020207D293B0D0A0D0A2020202020206F746865725464732E6373732827626F726465722D626F74746F6D272C20626F7264657257696474682B2720';
wwv_flow_api.g_varchar2_table(399) := '272B626F726465725374796C652B2720272B626F72646572436F6C6F72293B0D0A202020207D0D0A20202020656C7365207B0D0A202020202020746869732E74642E637373287B0D0A202020202020202027626F726465722D6C65667427202020203A20';
wwv_flow_api.g_varchar2_table(400) := '27272C0D0A202020202020202027626F726465722D746F702720202020203A2027272C0D0A202020202020202027626F726465722D7269676874272020203A2027272C0D0A202020202020202027626F726465722D626F74746F6D2720203A2027272C0D';
wwv_flow_api.g_varchar2_table(401) := '0A2020202020202020276261636B67726F756E64436F6C6F72273A2027270D0A2020202020207D293B0D0A0D0A2020202020206966202820746869732E6E65737465645265706F72742E74722E697328273A6C6173742D6368696C6427292029207B0D0A';
wwv_flow_api.g_varchar2_table(402) := '2020202020202020746869732E6E65737465645265706F72742E74722E73686F7728293B0D0A2020202020202020746869732E6E65737465645265706F72742E74642E6373732827626F72646572436F6C6F72272C20746869732E74642E637373282762';
wwv_flow_api.g_varchar2_table(403) := '6F72646572546F70436F6C6F722729293B0D0A2020202020207D0D0A0D0A2020202020206F746865725464732E6373732827626F726465722D626F74746F6D272C202727293B0D0A202020207D0D0A20207D2C0D0A2F2F0D0A2F2F0D0A20205F6F766572';
wwv_flow_api.g_varchar2_table(404) := '72696465417065785472486F7665723A2066756E6374696F6E282070466C616720297B0D0A202020206966202820746869732E6973457870616E64656428292029207B0D0A2020202020202F2F7573746177206B6F6C6F72206A616B207A206B6F6E6669';
wwv_flow_api.g_varchar2_table(405) := '67757261636A690D0A202020202020746869732E74642E6373732820276261636B67726F756E64436F6C6F72272C20746869732E73657474696E67732E6267436F6C6F7220293B0D0A2020202020202F2F697473206E656564656420746F206F76657272';
wwv_flow_api.g_varchar2_table(406) := '6964652021696D706F7274616E742066726F6D2041504558207468656D65206373730D0A202020202020746869732E5F666F7263654261636B67726F756E64436F6C6F722820746869732E746420293B0D0A202020207D0D0A20207D2C0D0A2F2F0D0A2F';
wwv_flow_api.g_varchar2_table(407) := '2F0D0A20205F666F7263654261636B67726F756E64436F6C6F723A2066756E6374696F6E282070456C656D2029207B0D0A20202020766172200D0A2020202020207374796C6573203D2070456C656D2E6174747228277374796C6527292C0D0A20202020';
wwv_flow_api.g_varchar2_table(408) := '2020617272203D207374796C65732E73706C697428273B27293B0D0A0D0A20202020666F7220287661722069647820696E2061727229207B0D0A20202020202069662028206172725B6964785D2E696E6465784F6628276261636B67726F756E642D636F';
wwv_flow_api.g_varchar2_table(409) := '6C6F722729203E202D312029207B0D0A20202020202020206172725B6964785D202B3D20272021696D706F7274616E74270D0A2020202020207D0D0A202020207D0D0A0D0A2020202070456C656D2E6174747228277374796C65272C206172722E6A6F69';
wwv_flow_api.g_varchar2_table(410) := '6E28273B2729293B0D0A20207D2C0D0A2F2F0D0A2F2F0D0A202063616C6C6261636B457870616E6465643A2066756E6374696F6E28297B0D0A20202020746869732E616E696D6174696F6E52756E6E696E67203D2066616C73653B0D0A20202020617065';
wwv_flow_api.g_varchar2_table(411) := '782E6576656E742E7472696767657228746869732E6166666563746564456C656D656E742C2027707265746975735F64656661756C745F63616C6C6261636B272C20746869732E6765744576656E74446174612829293B0D0A20207D2C0D0A2F2F0D0A2F';
wwv_flow_api.g_varchar2_table(412) := '2F0D0A20206765744576656E74446174613A2066756E6374696F6E28297B0D0A20202020766172200D0A2020202020206973416674657252656672657368203D2066616C73652C0D0A20202020202072657475726E4F626A6563743B0D0A0D0A20202020';
wwv_flow_api.g_varchar2_table(413) := '2F2F616674657220726566726573682062757420616E696D6174696F6E20697320696E2070726F677265737320286475726174696F6E203D2030290D0A202020206966202820746869732E616A61782E697352656672657368203D3D2074727565202626';
wwv_flow_api.g_varchar2_table(414) := '20746869732E616E696D6174696F6E52756E6E696E67203D3D207472756520262620746869732E657870616E646564203D3D20747275652029207B0D0A2020202020206973416674657252656672657368203D20747275653B0D0A202020207D0D0A2020';
wwv_flow_api.g_varchar2_table(415) := '20202F2F616674657220726566726573682062797420726F772069732066756C6C7920657870616E6465640D0A20202020656C7365206966202820746869732E616A61782E697352656672657368203D3D207472756520262620746869732E616E696D61';
wwv_flow_api.g_varchar2_table(416) := '74696F6E52756E6E696E67203D3D2066616C736520262620746869732E657870616E646564203D3D20747275652029207B0D0A2020202020206973416674657252656672657368203D20747275653B0D0A202020202020746869732E616A61782E697352';
wwv_flow_api.g_varchar2_table(417) := '656672657368203D2066616C73653B0D0A202020207D0D0A0D0A2020202072657475726E4F626A656374203D207B0D0A202020202020276973436F6C6C617073696E67272020202020203A20746869732E616E696D6174696F6E52756E6E696E67203D3D';
wwv_flow_api.g_varchar2_table(418) := '20747275652020262620746869732E657870616E646564203D3D207472756520203F2074727565203A2066616C73652C0D0A202020202020276973436F6C6C617073656427202020202020203A20746869732E616E696D6174696F6E52756E6E696E6720';
wwv_flow_api.g_varchar2_table(419) := '3D3D2066616C736520262620746869732E657870616E646564203D3D2066616C7365203F2074727565203A2066616C73652C0D0A202020202020276973457870616E64696E6727202020202020203A20746869732E616E696D6174696F6E52756E6E696E';
wwv_flow_api.g_varchar2_table(420) := '67203D3D20747275652020262620746869732E657870616E646564203D3D2066616C7365203F2074727565203A2066616C73652C0D0A202020202020276973457870616E6465642720202020202020203A20746869732E616E696D6174696F6E52756E6E';
wwv_flow_api.g_varchar2_table(421) := '696E67203D3D2066616C736520262620746869732E657870616E646564203D3D207472756520203F2074727565203A2066616C73652C0D0A20202020202027616E696D6174696F6E52756E6E696E672720203A20746869732E616E696D6174696F6E5275';
wwv_flow_api.g_varchar2_table(422) := '6E6E696E672C0D0A20202020202027616674657252656672657368272020202020203A2069734166746572526566726573682C0D0A2020202020202F2F27706C7567696E272020202020202020202020203A20746869732C0D0A20202020202027726570';
wwv_flow_api.g_varchar2_table(423) := '6F7274272020202020202020202020203A20746869732E6166666563746564456C656D656E742C0D0A2020202020202774726967676572696E675464272020202020203A20746869732E74642C0D0A2020202020202774726967676572696E67456C656D';
wwv_flow_api.g_varchar2_table(424) := '656E7427203A20746869732E656C656D656E742C0D0A202020202020276E65737465645265706F7274526F77272020203A20746869732E6E65737465645265706F72742E74722C0D0A202020202020276E65737465645265706F7274446174612720203A';
wwv_flow_api.g_varchar2_table(425) := '20746869732E6E65737465645265706F72742E616A6178446174612C0D0A20202020202027706172656E74272020202020202020202020203A20746869732E696E63657074696F6E0D0A202020207D3B0D0A0D0A202020200D0A2020202072657475726E';
wwv_flow_api.g_varchar2_table(426) := '2072657475726E4F626A6563743B0D0A20207D2C0D0A2F2F0D0A2F2F0D0A202063616C6C6261636B436F6C6C61707365643A2066756E6374696F6E28297B0D0A20202020746869732E74642E72656D6F7665436C6173732820746869732E636C61737365';
wwv_flow_api.g_varchar2_table(427) := '732E7464457870616E64656420293B0D0A20202020746869732E657870616E646564203D2066616C73653B0D0A0D0A20202020746869732E6E65737465645265706F72742E74722E6869646528293B0D0A20202020746869732E6368616E6765426F7264';
wwv_flow_api.g_varchar2_table(428) := '65725374796C6528293B0D0A0D0A202020206966202820746869732E73657474696E67732E69734361636865526573756C7473203D3D2066616C736529207B0D0A202020202020746869732E6E65737465645265706F72742E74722E72656D6F76652829';
wwv_flow_api.g_varchar2_table(429) := '3B0D0A202020207D0D0A20202020746869732E616E696D6174696F6E52756E6E696E67203D2066616C73653B0D0A20202020617065782E6576656E742E7472696767657228746869732E6166666563746564456C656D656E742C2027707265746975735F';
wwv_flow_api.g_varchar2_table(430) := '64656661756C745F63616C6C6261636B272C20746869732E6765744576656E74446174612829293B0D0A20207D0D0A7D293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(2344466188782348836)
,p_plugin_id=>wwv_flow_api.id(3079739495676097012)
,p_file_name=>'pretius_nestedreport.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '77696E646F772E707265746975734E65737465645265706F7274203D2066756E6374696F6E2864612C207175657279436F6C756D6E732C2071756572794974656D732C2070466F726365546F67676C652C2070506C7567696E41707041747472297B0D0A';
wwv_flow_api.g_varchar2_table(2) := '2020766172200D0A2020202073656C66203D20242864612E74726967676572696E67456C656D656E74292C0D0A202020206475726174696F6E203D20756E646566696E65643B0D0A0D0A0D0A2F2A20200D0A2020696620282064612E6166666563746564';
wwv_flow_api.g_varchar2_table(3) := '456C656D656E74735B305D203D3D20756E646566696E65642029207B0D0A20202020636F6E736F6C652E6C6F672831323334293B0D0A20202020636F6E736F6C652E6C6F672864612E616374696F6E293B0D0A0D0A20202020696620282064612E616374';
wwv_flow_api.g_varchar2_table(4) := '696F6E2E6166666563746564456C656D656E747354797065203D3D20224A51554552595F53454C4543544F52222029207B0D0A20202020202072657475726E20766F69642830293B0D0A202020207D0D0A0D0A2020202073656C662E6E65737465645265';
wwv_flow_api.g_varchar2_table(5) := '706F72742864612C207175657279436F6C756D6E732C2071756572794974656D732C207B0D0A2020202020207468726F774572726F723A207B0D0A2020202020202020616464496E666F3A202744796E616D696320616374696F6E202241666665637465';
wwv_flow_api.g_varchar2_table(6) := '6420656C656D656E742220646F6573206E6F7420657869737420696E20444F4D2E272C0D0A20202020202020206572726F723A2027272B0D0A202020202020202020202744796E616D696320616374696F6E206166666563746564456C656D656E747354';
wwv_flow_api.g_varchar2_table(7) := '797065203D2022272B64612E616374696F6E2E6166666563746564456C656D656E7473547970652B2722272B225C6E222B0D0A202020202020202020202744796E616D696320616374696F6E206166666563746564526567696F6E4964203D2022272B64';
wwv_flow_api.g_varchar2_table(8) := '612E616374696F6E2E6166666563746564526567696F6E49642B27222020202020202020270D0A2020202020207D0D0A202020207D293B0D0A0D0A2020202072657475726E20766F69642830293B0D0A20207D0D0A2A2F20200D0A20200D0A20202F2F63';
wwv_flow_api.g_varchar2_table(9) := '6865636B20776865746865722044796E616D696320416374696F6E2073656C6563746F72206973206368696C6472656E206F66206166666163746564456C656D656E740D0A2020696620282064612E6166666563746564456C656D656E74735B305D2021';
wwv_flow_api.g_varchar2_table(10) := '3D20756E646566696E6564202626206A51756572792E636F6E7461696E73282064612E6166666563746564456C656D656E74735B305D2C2064612E74726967676572696E67456C656D656E7420292029207B0D0A0D0A20202020696620282064612E6461';
wwv_flow_api.g_varchar2_table(11) := '746120213D20756E646566696E65642026262064612E646174612E6475726174696F6E20213D20756E646566696E65642029207B0D0A2020202020206475726174696F6E203D2064612E646174612E6475726174696F6E3B0D0A202020207D0D0A0D0A20';
wwv_flow_api.g_varchar2_table(12) := '202020696620282073656C662E646174612827707265746975732D6E65737465645265706F7274272920213D20756E646566696E65642029207B0D0A20202020202073656C662E6E65737465645265706F72742827746F67676C65272C20647572617469';
wwv_flow_api.g_varchar2_table(13) := '6F6E293B0D0A202020207D0D0A20202020656C7365207B0D0A20202020202073656C662E6E65737465645265706F72742864612C207175657279436F6C756D6E732C2071756572794974656D732C207B27666F726365546F67676C65273A2070466F7263';
wwv_flow_api.g_varchar2_table(14) := '65546F67676C652C20276475726174696F6E273A206475726174696F6E7D2C2070506C7567696E41707041747472293B0D0A202020207D0D0A20207D0D0A2020656C7365207B0D0A202020206E756C6C3B0D0A202020202F2F64796E616D696320616374';
wwv_flow_api.g_varchar2_table(15) := '696F6E20666972656420627920656C656D656E742074686174206973206E6F7420636F6E7461696E65722077697468696E20616666656374656420656C656D656E740D0A20207D0D0A0D0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(2712401318193480610)
,p_plugin_id=>wwv_flow_api.id(3079739495676097012)
,p_file_name=>'pretius_main.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '0D0A7464203E202E726F7744657461696C73436F6E7461696E6572207B0D0A2020646973706C61793A206E6F6E653B0D0A202070616464696E673A20313070783B0D0A7D0D0A0D0A7464203E202E726F7744657461696C73436F6E7461696E6572203E20';
wwv_flow_api.g_varchar2_table(2) := '2E6F766572666C6F77207B0D0A20206F766572666C6F773A206175746F3B0D0A7D0D0A0D0A2F2A0D0A6469762E726F7744657461696C73436F6E7461696E6572207461626C65207B0D0A20206261636B67726F756E642D636F6C6F723A207265643B0D0A';
wwv_flow_api.g_varchar2_table(3) := '7D0D0A2A2F0D0A0D0A2E707265746975732D2D616A6178496E64696361746F722E666C6F61745269676874207B0D0A2020666C6F61743A72696768743B0D0A20206F7061636974793A20302E353B0D0A7D0D0A0D0A2E707265746975732D2D616A617849';
wwv_flow_api.g_varchar2_table(4) := '6E64696361746F722E636F6E74656E74207B0D0A20202F2A746578742D616C69676E3A63656E7465723B2A2F0D0A20206F7061636974793A20302E353B0D0A7D0D0A0D0A6469762E707265746975732D2D6572726F72207B0D0A2020746578742D616C69';
wwv_flow_api.g_varchar2_table(5) := '676E3A63656E7465723B0D0A7D0D0A0D0A2E707265746975732D2D726561736F6E207B0D0A0D0A7D0D0A0D0A2E707265746975732D2D726561736F6E202E6661207B0D0A2020666F6E742D73697A653A20333070783B0D0A20206C696E652D6865696768';
wwv_flow_api.g_varchar2_table(6) := '743A20343070783B0D0A2020646973706C61793A20626C6F636B3B0D0A20206F7061636974793A20302E373B0D0A7D0D0A0D0A2E707265746975732D2D6572726F725469746C65207B0D0A2020666F6E742D73697A653A20323070783B0D0A20206C696E';
wwv_flow_api.g_varchar2_table(7) := '652D6865696768743A20333070783B0D0A7D0D0A0D0A2E707265746975732D2D746563684572726F72207072652C0D0A2E707265746975732D2D6572726F72416464496E666F207B0D0A20206D617267696E3A203070783B0D0A20206C696E652D686569';
wwv_flow_api.g_varchar2_table(8) := '6768743A20333070783B0D0A2020666F6E742D73697A653A313470783B0D0A7D0D0A0D0A2E707265746975732D2D746563684572726F7220707265207B0D0A20206C696E652D6865696768743A20313670783B0D0A2020746578742D616C69676E3A6C65';
wwv_flow_api.g_varchar2_table(9) := '66743B0D0A20206261636B67726F756E642D636F6C6F723A2072676261283235352C3235352C3235352C20302E34293B0D0A2020626F726465723A2031707820646173686564207267626128302C302C302C302E33293B0D0A202070616464696E673A20';
wwv_flow_api.g_varchar2_table(10) := '32707820313070783B0D0A7D2020200D0A0D0A6469762E726F7744657461696C73436F6E7461696E6572202E752D5265706F72742D736F72742E736F72742D2D617363202E69636F6E2D7270742D736F72742D617363207B0D0A2020646973706C61793A';
wwv_flow_api.g_varchar2_table(11) := '20696E6C696E652D626C6F636B3B0D0A7D0D0A0D0A6469762E726F7744657461696C73436F6E7461696E6572202E752D5265706F72742D736F72742E736F72742D2D64657363202E69636F6E2D7270742D736F72742D64657363207B0D0A202064697370';
wwv_flow_api.g_varchar2_table(12) := '6C61793A20696E6C696E652D626C6F636B3B0D0A7D0D0A0D0A6469762E726F7744657461696C73436F6E7461696E6572202E752D5265706F72742D736F727449636F6E207B0D0A2020646973706C61793A206E6F6E653B0D0A7D0D0A0D0A2E742D526570';
wwv_flow_api.g_varchar2_table(13) := '6F72742D7265706F7274206469762E726F7744657461696C73436F6E7461696E6572202E742D5265706F72742D7265706F72742E707265746975732D2D7374726563685265706F72742C0D0A2E612D4952522D7461626C65206469762E726F7744657461';
wwv_flow_api.g_varchar2_table(14) := '696C73436F6E7461696E6572202E742D5265706F72742D7265706F72742E707265746975732D2D7374726563685265706F72742C0D0A2E742D5265706F72742D7265706F72742E707265746975732D2D7374726563685265706F7274207B0D0A20207769';
wwv_flow_api.g_varchar2_table(15) := '6474683A20313030253B0D0A7D0D0A0D0A2E742D5265706F72742D7265706F7274206469762E726F7744657461696C73436F6E7461696E6572202E742D5265706F72742D7265706F7274207B0D0A202077696474683A206175746F3B0D0A7D0D0A0D0A2F';
wwv_flow_api.g_varchar2_table(16) := '2A2044656661756C742074656D706C617465202F20626F7264657220636F6C6F72202A2F0D0A6469762E726F7744657461696C73436F6E7461696E65722074642E742D5265706F72742D63656C6C3A6C6173742D6368696C643A6E6F74282E7072657469';
wwv_flow_api.g_varchar2_table(17) := '75732D2D657870616E646564292C0D0A6469762E726F7744657461696C73436F6E7461696E65722074682E742D5265706F72742D636F6C486561643A6C6173742D6368696C642C0D0A6469762E726F7744657461696C73436F6E7461696E65722074642E';
wwv_flow_api.g_varchar2_table(18) := '742D5265706F72742D63656C6C3A6E6F74282E707265746975732D2D657870616E646564292C0D0A6469762E726F7744657461696C73436F6E7461696E65722074682E742D5265706F72742D636F6C48656164207B0D0A20202F2A626F726465722D636F';
wwv_flow_api.g_varchar2_table(19) := '6C6F723A207267626128302C302C302C20302E31292021696D706F7274616E743B2A2F0D0A2020626F726465722D636F6C6F723A20236463646364633B0D0A7D0D0A0D0A2F2A2044656661756C742074656D706C617465202F206F646420726F77206365';
wwv_flow_api.g_varchar2_table(20) := '6C6C73206261636B67726F756E64202A2F0D0A74722E707265746975732D2D686F766572206469762E726F7744657461696C73436F6E7461696E6572207461626C652E742D5265706F72742D7265706F7274203E2074626F6479203E2074722E6F646420';
wwv_flow_api.g_varchar2_table(21) := '74642E742D5265706F72742D63656C6C3A6E6F74282E707265746975732D2D657870616E646564292C0D0A2020202020202020202020202020202020206469762E726F7744657461696C73436F6E7461696E6572207461626C652E742D5265706F72742D';
wwv_flow_api.g_varchar2_table(22) := '7265706F7274203E2074626F6479203E2074722E6F64642074642E742D5265706F72742D63656C6C3A6E6F74282E707265746975732D2D657870616E64656429207B0D0A20202F2A6261636B67726F756E642D636F6C6F723A2072676261283235352C20';
wwv_flow_api.g_varchar2_table(23) := '3235352C203235352C20302E33292021696D706F7274616E743B2A2F0D0A20206261636B67726F756E642D636F6C6F723A20236637663766372021696D706F7274616E743B200D0A7D0D0A2F2A2044656661756C742074656D706C617465202F20657665';
wwv_flow_api.g_varchar2_table(24) := '6E20726F772063656C6C73206261636B67726F756E64202A2F0D0A74722E707265746975732D2D686F766572206469762E726F7744657461696C73436F6E7461696E6572207461626C652E742D5265706F72742D7265706F7274203E2074626F6479203E';
wwv_flow_api.g_varchar2_table(25) := '2074722E6576656E2074642E742D5265706F72742D63656C6C3A6E6F74282E707265746975732D2D657870616E646564292C0D0A2020202020202020202020202020202020206469762E726F7744657461696C73436F6E7461696E6572207461626C652E';
wwv_flow_api.g_varchar2_table(26) := '742D5265706F72742D7265706F7274203E2074626F6479203E2074722E6576656E2074642E742D5265706F72742D63656C6C3A6E6F74282E707265746975732D2D657870616E64656429207B0D0A20202F2A6261636B67726F756E642D636F6C6F723A20';
wwv_flow_api.g_varchar2_table(27) := '72676261283235352C203235352C203235352C20302E36292021696D706F7274616E743B2A2F0D0A20206261636B67726F756E642D636F6C6F723A20236663666366632021696D706F7274616E743B0D0A7D0D0A0D0A2F2A2044656661756C742074656D';
wwv_flow_api.g_varchar2_table(28) := '706C617465202F20686967686C696768742063656C6C20636F6C6F72202A2F0D0A74722E707265746975732D2D686F766572206469762E726F7744657461696C73436F6E7461696E6572207461626C652E742D5265706F72742D7265706F7274203E2074';
wwv_flow_api.g_varchar2_table(29) := '626F6479203E2074722E6F64643A686F766572202074642E742D5265706F72742D63656C6C3A6E6F74282E707265746975732D2D657870616E646564292C0D0A74722E707265746975732D2D686F766572206469762E726F7744657461696C73436F6E74';
wwv_flow_api.g_varchar2_table(30) := '61696E6572207461626C652E742D5265706F72742D7265706F7274203E2074626F6479203E2074722E6576656E3A686F7665722074642E742D5265706F72742D63656C6C3A6E6F74282E707265746975732D2D657870616E64656429207B0D0A20202F2A';
wwv_flow_api.g_varchar2_table(31) := '6261636B67726F756E642D636F6C6F723A2072676261283235352C203235352C203235352C20302E38292021696D706F7274616E743B2A2F0D0A20206261636B67726F756E642D636F6C6F723A20236630663066302021696D706F7274616E743B0D0A7D';
wwv_flow_api.g_varchar2_table(32) := '0D0A0D0A2F2A2044656661756C742074656D706C617465202F2068656164696E67206261636B67726F756E6420636F6C6F72202A2F0D0A6469762E726F7744657461696C73436F6E7461696E65722074682E742D5265706F72742D636F6C48656164207B';
wwv_flow_api.g_varchar2_table(33) := '0D0A20202F2A6261636B67726F756E642D636F6C6F723A2072676261283235352C203235352C203235352C20302E38293B2A2F0D0A20206261636B67726F756E642D636F6C6F723A20236666662021696D706F7274616E743B0D0A7D0D0A0D0A2F2A2049';
wwv_flow_api.g_varchar2_table(34) := '52202A2F0D0A2E612D4952522D7461626C65206469762E726F7744657461696C73436F6E7461696E6572202074722074643A66697273742D6368696C642C200D0A2E612D4952522D7461626C65206469762E726F7744657461696C73436F6E7461696E65';
wwv_flow_api.g_varchar2_table(35) := '72202074722074683A66697273742D6368696C64207B0D0A2020626F726465722D6C6566742D77696474683A203170783B0D0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(2712402035846481538)
,p_plugin_id=>wwv_flow_api.id(3079739495676097012)
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
 p_id=>wwv_flow_api.id(3079754194210097024)
,p_plugin_id=>wwv_flow_api.id(3079739495676097012)
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
