# Pretius APEX Nested Reports
##### Oracle APEX dynamic action plugin v2.0
The plugin is dynamic action plugin implementing nested reports within APEX Classic Reports, Interactive Reports and static HTML tables. Scope of data, data appearance and behavior is customizable with the plugin attributes.

Live demo, instructions and more details about the plugin are available directly in [demo application](http://apex.pretius.com/apex/f?p=105:NESTED_REPORTS).

## Preview
![Alt text](/preview.gif?raw=true "Preview")

## Demo Application
[http://http://apex.pretius.com/apex/f?p=105:NESTED_REPORTS](http://apex.pretius.com/apex/f?p=105:NESTED_REPORTS)

## Features at Glance
* Compatible with Classic report, Interactive report and any HTML based table
* Nested report is defined as SQL query
* Nested report data can be limited with value from parent report
* Nesting levels is unlimited
* Data can be rendered with default template (table based) or with custom template (Mustache library)
* Default callback and Default template can be highly customized

## Roadmap
* Default template:
  * filtering data via columns
  * sorting data via columns (db side)
  * number of rows

## Install

### Installation package
1. Install package `PRETIUS_APEX_NESTED_REPORTS.sql` - the plugin package specification
1. Install package `PRETIUS_APEX_NESTED_REPORTS.plb` - the plugin package body
1. `dynamic_action_plugin_pretius_apex_nested_reports.sql` - the plugin installation files for Oracle APEX 5.1 or higher


### Install procedure
To successfully install/update the plugin follow those steps:
1. Install package `PRETIUS_APEX_NESTED_REPORTS` in Oracle APEX Schema
1. Install the plugin file `dynamic_action_plugin_pretius_apex_nested_reports.sql` using Oracle APEX plugin import wizard
1. Configure application level componenets

## Usage guide
Example nested report is based on `emp` and `dept` table. 
1. Create new application
1. Create new page
1. Create `Classic Report` based on SQL query `*` 
1. Create derivied column and configure it as follows:
   1. Change derivied column `Type` to `Link`
   1. Set `Target` to `URL` and set
   1. Set `URL` to `<span class="fa fa-search"></span><span class="DEPTNO" style="display: none">#DEPTNO#</span>`
   1. Set `Link Attributes` to `class="dept"`
1. Create new dynamic action and configure it as follows:
   1. Set `Event` to `Click`
   1. Set `Selection Type` to `jQuery Selector`
   1. Set `Event Scope` to `Dynamic`
   1. Set `Static Container (jQuery Selector)` to `body`
1. Create true action and configure it as follows:
   1. Set `Action` to `Pretius APEX Nested Reports [Plug-In]`
   1. Set `Details query` to `**` 
   1. Set `Affected Elements > Selection Type` to `Report`
   1. Set `Affected Elements > Region` to `Classic Report` defined in step 3.
   1. (Not required) Adjust the plugin behaviour up to your needs using the plugin attributes
1. Save and run page

`* SQL Query for step 3`
```sql
select * from dept
```
`** SQL Query for step 6.ii`
```sql 
select * from emp where deptno = '#DEPTNO#'
````

## Plugin Settings
Detailed information about how to use every attribute of the plugin is presented in built-in help texts in APEX Application Builder.

### Plugin Events
Whenever the plugin shows, hides or refreshes nested report it triggers `Default Callback [Pretius APEX Nested Reports]` event. The event can be bound with dynamic actions on `document` (`Selection Type set` to `Javascript Expression` = `document`) to listen all nested reports events. Or the event can be bound to particular report (`Selection Type` set to `Region`) to listen only specific report events.



## Authors
Author | Twitter | E-mail
-------|---------|-------
Bartosz Ostrowski | [@bostrowsk1](https://twitter.com/bostrowsk1) | bostrowski@pretius.com

**Pretius Sp. z o.o. Sp. K.**  
Address: Przy Parku 2/2; 02-384 Warsaw, Poland  
Website: [http://www.pretius.com](http://www.pretius.com)  
e-mail: [office@pretius.com](mailto:office@pretius.com)  

## Pretius Plugins for Oracle APEX
#### Item plugins
* [Enhanced LOV item](http://apex.pretius.com/apex/f?p=105:ENHANCED_LOV_ITEM_APEX_ITEM)

#### Dynamic action plugins
* [Client Side Validation](http://apex.pretius.com/apex/f?p=105:CLIENT_SIDE_VALIDATION)
* [Enhanced Modal dialog](http://apex.pretius.com/apex/f?p=105:ENHANCED_MODAL_PAGE)
* [Enhanced LOV item - tabular form](http://apex.pretius.com/apex/f?p=105:ENHANCED_LOV_ITEM_APEX_DA)
* [Nested reports](http://apex.pretius.com/apex/f?p=105:NESTED_REPORTS)

#### Browser plugins
* [Enhanced Column Attributes](http://apex.pretius.com/apex/f?p=105:CHROME_EXTENSION)
