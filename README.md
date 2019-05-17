# Pretius APEX Nested Reports
##### Oracle APEX dynamic action plugin v2.0
The plugin is dynamic action plugin implementing nested reports within APEX Classic Reports, Interactive Reports and static HTML tables. Scope of data, data appearance and behavior is customizable with the plugin attributes.

## Table of Contents
- [License](#license)
- [Preview](#preview)
- [Demo Application](#demo-application)
- [Features at Glance](#features-at-glance)
- [Roadmap](#roadmap)
- [Install](#install)
  - [Installation package](#installation-package)
  - [Install procedure](#install-procedure)
- [Usage guide](#usage-guide)
- [Plugin Settings](#plugin-settings)
  - [Plugin Events](#plugin-events)
  - [Manual events](#manual-events)
    - [Refresh nested report](#refresh-nested-report)
    - [Collapse nested report](#collapse-nested-report)
    - [Expand all nested reports](#expand-all-nested-reports)
    - [Collapse all expanded nested reports](#collapse-all-expanded-nested-reports)
- [About Author](#about-author)
- [About Pretius](#about-pretius)

## License
MIT

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
The plugin exposes one event that can be listened on `document` or on particular report.

* Default callback [pretius_default_callback] - triggered each time nested report is being shown or hidden. `this.data` is extended with additional information described below.

```javascript
{
  "isCollapsing"     : Boolean, // When true the nested report is collapsing
  "isCollapsed"      : Boolean, // When true the nested report is collapsed.
  "isExpanding"      : Boolean, // When true the nested report is expanding
  "isExpanded"       : Boolean, // When true the nested report is expanded.
  "animationRunning" : Boolean, // When true the nested report is the middle of animation (expanding or collapsing).
  "afterRefresh"     : Boolean, // When true the nested report is rendered after forced refresh.
  "report"           : jQuery Object,  // object reference to parent report (1 level higher report)
  "triggeringTd"     : jQuery Object,  // object reference to the cell from which nested report was performed.
  "triggeringElement": jQuery Object,  // object reference to the element that was bound in dynamic action (eg. Selection Type = jQuery Selector)
  "nestedReportRow"  : jQuery Object,  // object reference to newly crated tr element that stores rendered nested reaport
  "nestedReportData" : Object          // object with retrievied data from data base  
  "parent"           : {
    "type"    : String,         //When 'nested' the parent element of nested report is instance of the plugin. When 'affectedElement' the parent element of nested report is native APEX component such as Classic Report or Interactive report.
    "element" : jQuery Object,  //Reference to parent element of the nested report (instance of the plugin or native APEX report)
    "level"   : Number          //Describes the level of nested report. First level starts with 1.    
  }
}
```

### Manual events
Default callback supports 4 predefined actions (refresh, expand all, collapse, collapse all) that can be executed using anchors with proper classes. Those actions works only when anchors with given class are embeded in `Extend default template` or `Custom template` using `Default Callback` for particular nested report.

#### Refresh nested report
Action forces current nested report to be refreshed.
```html
<a href="javascript: void(0)" class="nestedreport--refresh">Refresh</a>
```
![Alt text](images/preview_refresh.gif?raw=true "Manual refresh")

#### Collapse nested report
Action forces current nested report to be collapsed.
```html
<a href="javascript: void(0)" class="nestedreport--slideup">Slide up</a>
```

![Alt text](images/preview_collapse.gif?raw=true "Manual collapse")

#### Expand all nested reports
Action forces all next level nested report to expand.
```html
<a href="javascript: void(0)" class="nestedreport--expandAll">Expand all</a>
```

![Alt text](images/preview_expand_all.gif?raw=true "Manual expand all")

#### Collapse all expanded nested reports
Action forces all next level expanded nested report to collapse.
```html
<a href="javascript: void(0)" class="nestedreport--slideup">Collapse all expanded</a>
```

![Alt text](images/preview_collapse_all.gif?raw=true "Manual collapse all")

## About Author
Author | Twitter | E-mail
-------|---------|-------
Bartosz Ostrowski | [@bostrowsk1](https://twitter.com/bostrowsk1) | bostrowski@pretius.com

## About Pretius
Pretius Sp. z o.o. Sp. K.

Address | Website | E-mail
--------|---------|-------
Przy Parku 2/2 Warsaw 02-384, Poland | [http://www.pretius.com](http://www.pretius.com) | [office@pretius.com](mailto:office@pretius.com)
