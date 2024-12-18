# Pretius Nested Reports

Oracle APEX dynamic action plugin v2.0.2
The plugin is dynamic action plugin implementing nested reports within APEX Classic Reports, Interactive Reports and static HTML tables. Scope of data, data appearance and behavior is customizable with the plugin attributes.

## Table of Contents
- [Preview](#preview)
- [License](#license)
- [Features at glance](#features-at-glance)
- [Roadmap](#roadmap)
- [Installation](#installation)
  - [Installation package](#installation-package)
  - [Installation procedure](#installation-procedure)
- [Usage guide & Demo application](#usage-guide-demo-application)
- [Free support](#free-support)
  - [Bug reporting and change requests](#bug-reporting-and-change-requests)
  - [Implementation issues](#implementation-issues)
- [Become a contributor](#become-a-contributor)
- [Comercial support](#comercial-support)
- [Changelog](#changelog)
- [Known issues](#known-issues)
- [About Author](#about-author)
- [About Pretius](#about-pretius)

## Preview
![Alt text](images/preview.gif?raw=true "Preview")

## License
MIT

## Features at Glance
* Compatible with Classic report, Interactive report and any HTML based table
* Nested report is defined as SQL query
* Nested report data can be limited with value from parent report
* Nesting levels is unlimited
* Data can be rendered with default template (table based) or with custom template (Mustache library)
* Default callback and Default template can be highly customized

## Roadmap
* [ ] "No data found" attribute should be translatable
* [ ] Default template:
  * filtering data via columns
  * sorting data via columns (db side)
  * number of rows
* [x] Plugin events on collapsing and expanding row (default callback)
* [x] Support for Interactive report 
* [x] More attributes to customize

## Installation

### Installation package
1. `src/PRETIUS_APEX_NESTED_REPORTS.sql` - the plugin package specification
1. `src/PRETIUS_APEX_NESTED_REPORTS.plb` - the plugin package body
1. `plugin_install.sql` - the plugin installation files for Oracle APEX 5.1 or higher

### Installation procedure
To successfully install/update the plugin follow those steps:
1. Install package `PRETIUS_APEX_NESTED_REPORTS` in Oracle APEX Schema owner (ie. via SQL Workshop)
1. Install the plugin file `plugin_install.sql` using Oracle APEX plugin import wizard
1. Configure application level componenets of the plugin

## Usage guide & Demo application
### Basic usage
Example nested report is based on `emp` and `dept` table. 
1. Create new application
1. Create new page
1. Create `Classic Report` based on SQL query `*` 
1. Create derivied column and configure it as follows:
   1. Change derivied column `Type` to `Link`
   1. Set `Target` to `URL`
   1. Set `URL` to `javascript: void(0);` and click `OK`
   1. Set `Link Text` to `<span class="fa fa-search"></span><span class="DEPTNO" style="display: none">#DEPTNO#</span>`
   1. Set `Link Attributes` to `class="dept"`
1. Create new dynamic action and configure it as follows:
   1. Set `Event` to `Click`
   1. Set `Selection Type` to `jQuery Selector`
   1. Set `jQuery Selector` to `.dept`
   1. Set `Event Scope` to `Dynamic`
   1. Set `Static Container (jQuery Selector)` to `body`
1. Create true action and configure it as follows:
   1. Set `Action` to `Pretius Nested Reports [Plug-In]`
   1. Set `Details query` to `**` 
   1. Set `Affected Elements > Selection Type` to `Region`
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
### Demo application
Check different plugin configurations and use cases in our  [Live Demo](http://apex.pretius.com/apex/f?p=105:NESTED_REPORTS)

## Free support
Pretius provides free support for the plugins at the GitHub platform. 
We monitor raised issues, prepare fixes, and answer your questions. However, please note that we deliver the plug-ins free of charge, and therefore we will not always be able to help you immediately. 

Interested in better support? 
* [Become a contributor!](#become-a-contributor) We always prioritize the issues raised by our contributors and fix them for free.
* [Consider comercial support.](#comercial-support) Options and benefits are described in the chapter below.

### Bug reporting and change requests
Have you found a bug or have an idea of additional features that the plugin could cover? Firstly, please check the Roadmap and Known issues sections. If your case is not on the lists, please open an issue on a GitHub page following these rules:
* issue should contain login credentials to the application at apex.oracle.com where the problem is reproduced;
* issue should include steps to reproduce the case in the demo application;
* issue should contain description about its nature.

### Implementation issues
If you encounter a problem during the plug-in implementation, please check out our demo application. We do our best to describe each possible use case precisely. If you can not find a solution or your problem is different, contact us: apex-plugins@pretius.com.

## Become a contributor!
We consider our plugins as genuine open source products, and we encourage you to become a contributor. Help us improve plugins by fixing bugs and developing extra features. Comment one of the opened issues or register a new one, to let others know what you are working on. When you finish, create a new pull request. We will review your code and add the changes to the repository.

By contributing to this repository, you help to build a strong APEX community. We will prioritize any issues raised by you in this and any other plugins.

## Comercial support
We are happy to share our experience for free, but we also realize that sometimes response time, quick implementation, SLA, and instant release for the latest version are crucial. That’s why if you need extended support for our plug-ins, please contact us at apex-plugins@pretius.com.
We offer:
* enterprise-level assistance;
* support in plug-ins implementation and utilization;
* dedicated contact channel to our developers;
* SLA at the level your organization require;
* priority update to next APEX releases and features listed in the roadmap.


## Changelog

### 2.0.2
- `PL/SQL` fix to multiple columns value placeholders by @darshanputtaswamy https://github.com/Pretius/apex-nested-reports/issues/16
- `PL/SQL` fix to `ORA-06502: PL/SQL: numeric or value error` by @rimblas https://github.com/Pretius/apex-nested-reports/issues/7
- `JS` jQuery `size` method removed in favor for `length` property - compatibility for APEX 18+


### 2.0.0 / 2.0.1
- `JS` Highlighting nested reports no longer embeds CSS rules within DOM as <style></style> tag
- `JS` Default callback supports special events that can be triggered using anchor with special classes (refresh, expand all, collapse, collapse all)
- `JS` The plugin triggers event on collapsing and expanding nested report
- `JS` The plugin can be bound with "dialog close" event to refresh nested report after closing modal page
- `JS` The plugin no longer supports TR tag as triggering element
- `JS` HTML within nested report is fully supported
- `JS` Nested report can be bound to any HTML table (the plugin is not limited to Classic or Interactive Report)
- `PL/SQL` "#COLUMN_VALUE#" marker should be surrounded with apostrophes to avoid APEX query compilation error. When value is number, apostrophes are removed by the plugin automatically.
- `PL/SQL` Nested report uses DBMS_SQL.BIND_VARIABLES to bind values from GUI (APEX items included)
- `PL/SQL` The plugin supports special column aliases in nested report to create headings without content or font-awesome icon as heading
- `PL/SQL` The plugin supports SQL comments within nested report query
- `Plugin` Interactive Report is supported
- `Plugin` The plugin no longer checks compatibility between nested report and parent report. Setting the plugin is easier and only requires existing span tag with proper class and value marker
- `Plugin` The plugin supports embedding nested report within nested reports (the number of nested reports is not limited by the plugin)
- `Plugin` The plugin configuration errors are now displayed as nested report with error and hint (not only in console)
- `Plugin` The plugin javascript and PL/SQL code was written from very beginning.
- `Plugin attributes` New styles of "Default callback" loading indicator (align to report, align to cell, embed in cell, replace cell content).
- `Plugin attributes` Data rendered in "Default template" can be sorted by end-user. Javascript sorting function uses column type (varchar2 or number)
- `Plugin attributes` New plugin attribute for extending "Default template" HTML with preceding and following HTML.
- `Plugin attributes` Default template supports stretching
- `Plugin attributes` Animation duration for expanding and collapsing nested report can be specified in „Plugin component settings”

### 1.0.0
- Initial release

## Known issues
* Column alias can't contain period - https://github.com/Pretius/apex-nested-reports/issues/13

## About Author
Author            | Website                                 | Github                                       | Twitter                                       | E-mail
------------------|-----------------------------------------|----------------------------------------------|-----------------------------------------------|----------------------------------------------------
Bartosz Ostrowski | [http://ostrowskibartosz.pl](https://www.ostrowskibartosz.pl) | [@bostrowski](https://github.com/bostrowski) | [@bostrowsk1](https://twitter.com/bostrowsk1) | bostrowski@pretius.com, ostrowski.bartosz@gmail.com

## About Pretius
Pretius Sp. z o.o. Sp. K.

Pretius is a software company specialized in Java-based and low-code applications, with a dedicated team of over 25 Oracle APEX developers.
Members of our APEX team are technical experts, have excellent communication skills, and work directly with end-users / business owners of the software. Some of them are also well-known APEX community members, winners of APEX competitions, and speakers at international conferences.
We are the authors of the translate-apex.com project and some of the best APEX plug-ins available at the apex.world.
We are located in Poland, but working globally. If you need the APEX support, contact us right now.

Address | Website | E-mail
--------|---------|-------
Żwirki i Wigury 16A, 02-092 Warsaw, Poland | [http://www.pretius.com](http://www.pretius.com) | [office@pretius.com](mailto:office@pretius.com)



