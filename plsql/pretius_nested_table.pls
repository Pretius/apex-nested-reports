create or replace package pretius_nested_table
is

function pretius_row_details (
  p_dynamic_action in apex_plugin.t_dynamic_action,
  p_plugin         in apex_plugin.t_plugin 
) return apex_plugin.t_dynamic_action_render_result;

function pretius_row_details_ajax (
  p_dynamic_action in apex_plugin.t_dynamic_action,
  p_plugin         in apex_plugin.t_plugin 
) return apex_plugin.t_dynamic_action_ajax_result;

end pretius_nested_table;
/