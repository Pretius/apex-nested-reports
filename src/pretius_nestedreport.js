$.widget('pretius.nestedReport', {
  defaultTemplateMarker: '#DEFAULT_TEMPLATE#',
  classes: {
    nestedReportTrContainer       : 'pretius_plugin_row',
    nestedReportDivContainer      : 'rowDetailsContainer', 
    nestedReportOverflowContainer : 'overflow',
    nestedReportHeader            : 't-Report-colHead',
    nestedReportCell              : 't-Report-cell',
    nestedReportTable             : 't-Report-report',
    tdExpanded                    : 'pretius--expanded',
    ajaxIndicatorRight            : 'pretius--ajaxIndicator floatRight',
    ajaxIndicatorContent          : 'pretius--ajaxIndicator content',
    ajaxIndicatorIcon             : 'fa fa-spin  fa-refresh',
    tableStrechReport             : 'pretius--strechReport'
  },


  errorTypes: {
    'configuration': {
      'title': 'Plugin configuration error'
    },
    /*
    'javascript': {
      'title': 'Plugin JavaScript error'
    }
    */
    'customFunction': {
      'title': 'Plugin custom callback error'
    },
    'ajax': {
      'title': 'Plugin AJAX error'
    }
  },
//
//
  _create: function(){
    var notMatchedColumn, error, notFoundItems;
    
    this._super( this.options );

    this.settings = {
      animationTime         : this.options.plugin.animationTime,
      closeOtherDuration    : this.options.plugin.closeOtherDuration,
      isCustomCallback      : this._getPlugAttrFlag( '03', 'CC'  ),
      isCustomTemplate      : this._getPlugAttrFlag( '03', 'CT'  ),
      isDefaultCallback     : this._getPlugAttrFlag( '03', 'DC'  ),
      isDefaultTemplate     : this._getPlugAttrFlag( '03', 'DT'  ),
      isSetMaxHeight        : this._getPlugAttrFlag( '02', 'SMH' ),
      //
      isStrechReport        : this._getPlugAttrFlag( '14', 'SR'  ),
      isSortingSupported    : this._getPlugAttrFlag( '14', 'SD'  ),
      isExtendDefaultTpl    : this._getPlugAttrFlag( '14', 'EDT' ),
      //
      isLoadingIndicator    : this._getPlugAttrFlag( '02', 'LI'  ),
      isSpinnerTdIcon       : this._getPlugAttrFlag( '12', 'CIS' ),
      isSpinnerReport       : this._getPlugAttrFlag( '12', 'ATR' ),
      isSpinnerTdCell       : this._getPlugAttrFlag( '12', 'ATC' ),
      isSpinnerTdContent    : this._getPlugAttrFlag( '12', 'RCC' ),

      isCollapseExapnded    : this._getPlugAttrFlag( '02', 'CE'  ),
      isAddAnimation        : this._getPlugAttrFlag( '02', 'AA'  ),
      isCacheResults        : this._getPlugAttrFlag( '02', 'CR'  ) || this._getPlugAttrFlag( '10', 'CR'  ),
      noDataFound           : this.options.action.attribute11,
      customCallbackJs      : this.options.action.attribute05,
      customTemplate        : this.options.action.attribute04,
      borderColor           : this.options.action.attribute08,
      bgColor               : this.options.action.attribute06,
      BgColorhighlight      : this.options.action.attribute09,
      maxHeight             : parseInt(this.options.action.attribute07),
      isDefaultTempateMarker: this.options.action.attribute13 == null || this.options.action.attribute13.search( this.defaultTemplateMarker ) == -1 ? false : true,
      defaultTemplateBefore : this.options.action.attribute13 == null ? null : '<div class="beforeNestedReport">'+this.options.action.attribute13.split( this.defaultTemplateMarker )[0]+'</div>',
      defaultTemplateAfter  : this.options.action.attribute13 == null ? null : '<div class="afterNestedReport">'+this.options.action.attribute13.split( this.defaultTemplateMarker )[1]+'</div>'
    };

    this.td                = this.element.is('td') ? this.element : this.element.closest('td');

    this.affectedElement   = this.options.affectedElements;
    //closest table to triggering element
    this.table             = this.td.closest('table');
    //closest row to triggering element
    this.row               = this.td.closest('tr');
    //object describing nested report entity
    this.nestedReport      = {
      ajaxData: null,
      tr: null,
      td: null,
      container: null,
      contentHere: null
    };

    this.spinner            = null;

    this.inception          = {
      'type'   : undefined,
      'element': undefined,
      'level'  : undefined
    };

    this.expanded           = false;
    this.animationRunning   = false;
    this.queryColumnsNames  = this.options.queryColumns;
    this.queryItems         = this.options.queryItems;
    this.queryColumnsValues = [];

    this.ajax = {
      id: this.options.action.ajaxIdentifier,
      running: false,
      forced: false,
      isRefresh: false
    };

    this.td
      .on('mouseenter', $.proxy( this._highlight,this       ))
      .on('mouseleave', $.proxy( this._removeHighlight,this ));

    this.row
      .on('mouseenter', $.proxy( this._overrideApexTrHover,this, true  ))
      .on('mouseleave', $.proxy( this._overrideApexTrHover,this, false ));
    
    //?
    if ( this.options.throwError != undefined ) {
      this.throwError( this.options.throwError, this.errorTypes.configuration );
    }

    notMatchedColumn = this._notMatchedColumn();

    this.inception = this._iAmYourFatherLuke();

    if ( notMatchedColumn != null ) {
      this.throwError( 
        {
          title: this.errorTypes.configuration.title,
          text:  'Marker for column <b>#'+notMatchedColumn+'#</b> not found in row. At least one of listed selectors must return <b>#'+notMatchedColumn+'#</b> value.',
          pre  : [
            '$(\'[headers="'+notMatchedColumn+'"]\').text() //for nested reports embeded directly in Classic Report',
            '$(\'[headers="'+notMatchedColumn+'"]\').text() //for nested reports embeded directly in Interactive Report (column static ID is required)',
            '$(\'[headers="NR_'+this.inception.level+'_'+notMatchedColumn+'"]\').text() //for nested reports embeded in nested reports',
            '$(\'span[class*="'+notMatchedColumn+'"]\').text() //universal column marker (requires changes in APEX Column Formatting)'
          ],
          hints : []
        }        
      );
      //this.destroy();
    }

    if ( this.settings.isDefaultTemplate == true && this.settings.isDefaultTempateMarker == false ) {
      this.throwError( 
        {
          title: this.errorTypes.configuration.title,
          text:  'Marker <b>'+this.defaultTemplateMarker+'</b> not found in definiton of the plugin "Default template HTML" attribute.',
          pre  : [
            'Make sure the value of "Default template HTML" attribute contains at least '+this.defaultTemplateMarker+' marker."'
          ],
          hints : []
        }        
      );

    }
    

    if ( this.options.forceToggle ) {
      this.toggle();  
    }
    
  },
//
//
  _destroy: function(){
  },
//
//
  _setOption: function( pKey, pValue ) {
    if ( pKey === "value" ) {
      pValue = this._constrain( pValue );
    }

    this._super( pKey, pValue );
  },  
  options: function( pOptions ){
    this._super( pOptions );
  },
//
//
  _setOptions: function( pOptions ) {
    this._super( pOptions );
  },  
//
// nie uzywane
  setContentHere: function( pNode ){
    this.nestedReport.contentHere = pNode;
  },
//
//
  _notMatchedColumn: function(){
    var 
      headerTag,
      spanTag,
      column;

    for ( var i=0; i < this.queryColumnsNames.length; i++ ){
      column          = this.queryColumnsNames[i];
      headerTag       = this.row.find('[headers="'+column+'"]');
      nestedHeaderTag = this.row.find('[headers="NR_'+this.inception.level+'_'+column+'"]');
      spanTag         = this.row.find('span[class*="'+column+'"]');

      if ( headerTag.length == 0 && spanTag.length == 0 && nestedHeaderTag.length == 0) {
        return column;
      }
      else {
        if ( spanTag.length != 0 ) {
          this.queryColumnsValues.push( spanTag.first().text() );
        }
        else if ( headerTag.length != 0 ) {
          this.queryColumnsValues.push( headerTag.first().text() );
          
        }
        else {
          this.queryColumnsValues.push( nestedHeaderTag.first().text() );  
        }
        
      }

    }
    return null;
  },
//
//
  _getPlugAttrFlag: function( pAttr, pExpectedValue ){
    var pAttr = this.options.action['attribute'+pAttr];

    if ( pAttr == undefined || pAttr == null ) {
      return false;
    }

    return pAttr.indexOf( pExpectedValue ) > -1;
  },
//
//
  getParent: function(){
    return this.inception;
  },
//
//
  getLevel: function(){
    return this.inception.level;
  },
//
//
  _getExpandedFrom: function( pElement ) {
    var expanded;
    apex.debug.log('_getExpandedFrom', ', search in pElement =', pElement);

    expanded = pElement.find('*').filter( function(pIndex, pElement){
      var self = $(pElement);

      if ( self.data('pretius-nestedReport') != undefined && self.nestedReport('isExpanded') == true ) {
        return true;
      }
    } );

    apex.debug.log('_getExpandedFrom', ', found elements count = ', expanded.length, ', elements =', expanded);

    return expanded;
  },
//
//
  _iAmYourFatherLuke: function(){
    var 
      closestContainer = this.td.closest('[class*='+this.classes.nestedReportTrContainer+']'),
      vader;

     if ( closestContainer.length > 0 ) {
      //na pewno jestem przynajmniej level 1
      vader = this._getExpandedFrom( closestContainer.prev() );

      if ( vader != undefined && vader.length > 0 ) {
        return {
          'type'   : 'nested',
          'element': vader,
          'level'  : (vader.nestedReport('getLevel'))+1
        };
      }
      else {
        //first level
        return {
          'type'   : 'Invalid nested report',
          'element': undefined,
          'level'  : -1
          
        };
      }

    }
    //tu dorobic czy na pewno affectedElements jest najblizszym rodzicem
    else {
      return {
        'type'   : 'affectedElement',
        'element': this.affectedElement,
        'level'  : 1
        
      };
    }
  }, 
//
//
  throwError: function( pError ){
    var 
      tr = this.createDefaultCallbackRow(),
      pre = $('<pre></pre>').append( JSON.stringify( pError, null, 2) ),
      duration = 400,
      closeDuration = 0,
      div = this._getErrorTemplate( pError ),
      closeBefore = this._expandedSisters();

    this.nestedReport.td        = tr.find('td');
    this.nestedReport.container = tr.find( '[class*='+this.classes.nestedReportDivContainer+']' );
    this.nestedReport.tr        = tr;

    closeBefore.nestedReport('collapse', closeDuration);  

    if ( closeBefore.length > 0 ) {
      closeDuration = this.settings.closeOtherDuration;
    }

    setTimeout( $.proxy(function(){
      this.nestedReport.container.html( div );
      this.nestedReport.tr.insertAfter( this.row );

      this.td.addClass( this.classes.tdExpanded );
      this.expanded = true;
      this.td.data('pretius-nestedReport-owner', this.element);

      this.changeBorderStyle();
      this.nestedReport.tr.show();

      if ( this.settings.isDefaultCallback && this.settings.isAddAnimation == false) {
        duration = 0;
      }

      this.nestedReport.container.slideDown( duration , $.proxy(function(){
        this.callbackExpanded();
      }, this));    
    }, this), closeDuration + 150);

    apex.debug.error(
      "Pretius APEX Nested Reports error:\n",
      "  "+pError.title.replace(/<[^>]+>/g, '')+"\n", 
      "    "+pError.text.replace(/<[^>]+>/g, '') 
    );

    if ( pError.hints.length > 0 ) {
      for ( var i = 0; i < pError.hints.length; i++ ) {
        apex.debug.warn(pError.hints[i].label+':', "\n\n"+pError.hints[i].value );
      }
    }

    if (  arguments.length > 1 ) {
      for ( var i = 1; i < arguments.length; i++ ) {
        apex.debug.warn('Additional info #'+(i-1)+':', arguments[i] );
      }
    }

    throw 'Plugin execution stopped.'
  },
//
//
  isAjaxRunning: function(){
    return this.ajax.running;
  },
//
//
  isExpanded: function(){
    return this.expanded;
  },
//
//
  toggle: function(){
    var
      closeDuration = 0,
      closeBefore;

    if ( this.expanded == true ) {
      this.collapse();
    }
    else {
      if ( this.settings.isCollapseExapnded == true) {
        closeBefore = this._expandedInReport();
      } else {
        closeBefore = this._expandedSisters();
      }

      if ( closeBefore.length > 0 ) {
        closeDuration = this.settings.closeOtherDuration;
        closeBefore.nestedReport('collapse', closeDuration);  

        setTimeout( $.proxy(function(){      
          this.show();
        }, this), closeDuration + 150);

      }
      else {
        this.show();
      }
    }
  },

//
//
  show: function(){
    
    if ( this.nestedReport.ajaxData == null ) {
      this.ajax.forced = true;
      this.ajaxFetchData();
      return void(0);
    }
    else {

      //dane są, sprawdz czy cache wlaczony
      if ( this.settings.isCacheResults == false && this.ajax.forced == false && this.ajax.isRefresh == false) {
        //zresetuj zawartość nested report, tak zeby wygenerowac go na nowo
        //this.nestedReport.tr.remove();
        this.nestedReport.tr = null;
        this.ajax.forced = true;
        this.ajaxFetchData();
        return;
      }
      else if ( this.settings.isCacheResults == false && this.ajax.forced == true && this.ajax.isRefresh == false) {
        this.ajax.forced = false;
      }
    }

    if ( this.settings.isDefaultCallback ) {
      this.doCallbackDefault();
    }
    else {
      this.doCallbackCustom()
    }
  },
//
//
  expand: function( pForceDuration ){
    var 
      duration = this.settings.animationTime;

    if ( this.settings.isAddAnimation == false) {
      duration = 0;
    }

    if ( pForceDuration != null && pForceDuration != undefined ) {
      duration = pForceDuration;      
    }

    this.animationRunning = true;
    //before slide down
    apex.event.trigger(this.affectedElement, 'pretius_default_callback', this.getEventData());

    //pretius-nestedReport-owner is used to find out triggering element
    //while scanning row or table for expanded cells
    this.td.data('pretius-nestedReport-owner', this.element);
    this.td.addClass( this.classes.tdExpanded );

    this.expanded = true;
    this.changeBorderStyle();
    
    this.nestedReport.tr.show();

    //after slide down
    this.nestedReport.container.slideDown( duration , $.proxy( this.callbackExpanded, this ));
  },
//
//
  collapse: function( pForceDuration ){
    var duration = pForceDuration == undefined ? this.settings.closeOtherDuration : pForceDuration;

    if ( this.settings.isAddAnimation == false) {
      duration = 0;
    }

    this.animationRunning = true;
    
    apex.event.trigger(this.affectedElement, 'pretius_default_callback', this.getEventData() );

    this.nestedReport.container.slideUp( duration , $.proxy( this.callbackCollapsed, this) );
  },
//
//
  doCallbackDefault: function(){
    var 
      newTr,
      nestedReportContent;

    if ( this.nestedReport.tr == null ) {
      // first drill down

      //create new nested report row
      newTr                       = this.createDefaultCallbackRow()
      //this.nestedReport.contentHere points td in newly created tr
      this.nestedReport.td        = newTr.find('td');
      this.nestedReport.container = newTr.find( '[class*='+this.classes.nestedReportDivContainer+']' );
      this.nestedReport.tr        = newTr;

      this.nestedReport.tr.insertAfter( this.row );

      if ( this.settings.isDefaultTemplate ) {

        nestedReportContent = this.renderTemplateDefault();

        this.nestedReport.contentHere.empty();
        this.nestedReport.contentHere.append( this.settings.defaultTemplateBefore );
        this.nestedReport.contentHere.append( nestedReportContent );
        this.nestedReport.contentHere.append( this.settings.defaultTemplateAfter );

      }
      else {
        nestedReportContent = this.renderTemplateCustom();
        this.nestedReport.contentHere.html( nestedReportContent )
      }

    }
    else {
      // next drill down, the content is only replaced when caching is turned off

      if ( this.ajax.isRefresh ) {
        //this.ajax.isRefresh = false;

        this.nestedReport.contentHere.empty();

        if ( this.settings.isDefaultTemplate ) {
          nestedReportContent = this.renderTemplateDefault();

          this.nestedReport.contentHere.append( this.settings.defaultTemplateBefore );
          this.nestedReport.contentHere.append( nestedReportContent );
          this.nestedReport.contentHere.append( this.settings.defaultTemplateAfter );
        }
        else {
          nestedReportContent = this.renderTemplateCustom();
          this.nestedReport.contentHere.html( nestedReportContent )
        }
       
      }
      else {
        //do nothing, the content is already rendered
        null;
      }
    }


    //bind nested report with manualy triggered event from APEX
    //ex: $(this.triggeringElement).trigger('nestedreportrefresh');
    this.nestedReport.tr.off('nestedreportrefresh').on('nestedreportrefresh', $.proxy( this.defaultCallbackEvent_refresh, this ) );

    //bind anchors with class ".nestedreport--refresh" to refresh content of nested report
    this.nestedReport.tr.off('click', '.nestedreport--refresh')   .on('click', '.nestedreport--refresh', $.proxy( this.defaultCallbackEvent_refresh, this ) );
    //bind anchors with class ".nestedreport--slideup" to manualy 
    //collapse nested report
    this.nestedReport.tr.off('click', '.nestedreport--slideup')   .on('click', '.nestedreport--slideup', $.proxy( this.defaultCallbackEvent_slideup, this ) );    
    //bind anchors with class ".nestedreport--slideupAll" to manualy 
    //collapse all nested reports
    this.nestedReport.tr.off('click', '.nestedreport--slideupAll').on('click', '.nestedreport--slideupAll', $.proxy( this.defaultCallbackEvent_slideupAll, this ) );
    //bind anchors with class ".nestedreport--expandAll" to manualy 
    //expand all nested reports matched with given selector as anchor attribute
    this.nestedReport.tr.off('click', '.nestedreport--expandAll').on('click', '.nestedreport--expandAll', $.proxy( this.defaultCallbackEvent_expandAll, this ) );        

    this.expand();
    
  },
//
  defaultCallbackEvent_expandAll: function( pEvent ){
    var 
      anchor   = $(pEvent.target),
      selector = anchor.attr('selector'),
      toBeExpanded = this.nestedReport.tr.find( selector );

    pEvent.stopPropagation();
    pEvent.preventDefault();

    //filter to only selectors from this nested report
    toBeExpanded = toBeExpanded.filter( $.proxy(function(pIndex, pElem){
      var closestNestedContainer = $(pElem).closest('[class*='+this.classes.nestedReportDivContainer+']')
      return closestNestedContainer.get(0) == this.nestedReport.container.get(0);
    }, this) );

    toBeExpanded.each( $.proxy( function( pIdx, pElem ){
      var self = $(pElem);

      if ( self.data('pretius-nestedReport') == undefined ) {
        self.trigger('click');
      }
      else if ( self.nestedReport('isExpanded') == false ) {
        self.nestedReport('expand');
      }
    }, this) );
    
  },
//
//
  defaultCallbackEvent_slideupAll: function( pEvent ){
    var 
      anchor              = $(pEvent.target),
      anchorAttrDuration  = anchor.attr('duration') == undefined  ? this.settings.animationTime : parseInt( anchor.attr('duration') ),
      duration            = isNaN(anchorAttrDuration)             ? this.settings.animationTime : anchorAttrDuration,
      expanded            = this._getExpandedFrom( this.nestedReport.tr );

    pEvent.stopPropagation();
    pEvent.preventDefault();

    expanded.nestedReport('collapse', duration);
  },
//
//  
  defaultCallbackEvent_slideup: function( pEvent ){
    var 
      anchor              = $(pEvent.target),
      anchorAttrDuration  = anchor.attr('duration') == undefined  ? this.settings.animationTime : parseInt( anchor.attr('duration') ),
      duration            = isNaN(anchorAttrDuration)             ? this.settings.animationTime : anchorAttrDuration;

    pEvent.stopPropagation();
    pEvent.preventDefault();
    
    this.collapse( duration );
  },
//
//
  defaultCallbackEvent_refresh: function( pEvent ){
    pEvent.stopPropagation();
    pEvent.preventDefault();
    
    this.ajaxFetchData( true );
  },

  doCallbackCustom: function(){
    var
      functionBody = "                                       \n"+
        "this.callback = {                                   \n"+
        "  'sqlResultObj'      : data,                       \n"+
        "  'triggeringElement' : $(da.triggeringElement),    \n"+
        "  'affactedReport'    : $(da.affectedElements[0]),  \n"+
        "  'renderedTemplate'  : templateContent,            \n"+
        "  'browserEvent'      : da.browserEvent,            \n"+
        "  //newly added in v1.1                             \n"+
        "  'dynamicAction'     : da,                         \n"+
        "  'pluginSettings'    : settings                    \n"+
        "};                                                  \n"+
        "//start of custom callback javascript               \n"+
        this.settings.customCallbackJs                     +"\n"+
        "//end of custom callback javascript                 \n",

      tempFunc = new Function("templateContent", "settings", "da", "data", functionBody),
      template;

    if ( this.settings.isDefaultTemplate ) {
      template = $('<div></div>').addClass( this.classes.nestedReportDivContainer ).append( this.renderTemplateDefault() );
    }
    else {
      template = this.renderTemplateCustom();
    }

    try {
      tempFunc( template, this.settings, this.options, this.nestedReport.ajaxData );
    } catch( thrownError ) {

      this.throwError( 
        {
          title: this.errorTypes.customFunction.title,
          text : 'While executing Custom Callback JavaScript error occured',
          pre  : [thrownError],
          hints : [
            this._hint( 'Custom callback JavaScript', tempFunc.toString() )
          ]
        } 
      );

    }
  },
//
//
  _ajaxStart: function(){
    this.ajax.running = true;

    if ( this.settings.isLoadingIndicator ) {
      this._showSpinner();      
    }
    
  },
//
//
  _ajaxEnd: function(){
    this.ajax.running = false;
    this._hideSpinner();
    
  },
//
//
  _ajaxSuccess: function(pData, pTextStatus, pJqXHR){
    this._ajaxEnd();

    for ( var i=0; i < pData.data.length; i++ ) {
      pData.data[i].rowClass = i % 2 == 0 ? 'odd' : 'even';
    }

    this.nestedReport.ajaxData = pData;
    this.show();  
  },
//
//
  _hint: function( pTitle, pValue ) {
    return {
      label: pTitle,
      value: pValue
    }
  },
  _ajaxError: function( pJqXHR, pTextStatus, pErrorThrown ){
    this._ajaxEnd();

    if ( pTextStatus == 'parsererror' ) {
      this.throwError({
        title: this.errorTypes.ajax.title,
        text : 'Ajax response could not be parsed as JSON',
        pre  : pErrorThrown.message,
        hints : [
          this._hint( 'Ajax response text', pJqXHR.responseText )
        ]
      });
      return void(0);
    }

    this.throwError({
      title: this.errorTypes.ajax.title,
      text : pJqXHR.responseJSON.addInfo,
      pre  : pJqXHR.responseJSON.error,
      hints : [
        this._hint( 'Ajax JSON', pJqXHR.responseJSON ),
        this._hint( 'Ajax error info', pJqXHR.responseJSON.addInfo ),
        this._hint( 'Ajax error thrown', pErrorThrown )
      ]
    });
  },  
//
//
  ajaxFetchData: function( pIsRefresh ){
    var 
      pAjaxCallbackName = this.ajax.id,
      pData = {
        //type      : "GET",
        //dataType  : "json",
        x01       : this.queryColumnsNames.join(':'), //nazwy kolumn
        x02       : this.queryColumnsValues.join(':') //wartości kolumn
      },
      pOptions;

    this.ajax.isRefresh = pIsRefresh == undefined ? false : pIsRefresh;
    
    pOptions = {
      success                   : $.proxy(this._ajaxSuccess, this),
      error                     : $.proxy(this._ajaxError  , this)
    };

    if ( !this.isAjaxRunning() ) {
      this._ajaxStart();

      if ( this.queryItems.length > 0 ) {
        pData.pageItems = '#'+this.queryItems.join(',#');
      }

      apex.server.plugin ( pAjaxCallbackName, pData, pOptions );
    }
  },  
//
//
  _ajaxCreateIndicatorTdIcon: function(){
    var 
      icon = $('<span class="'+this.classes.ajaxIndicatorIcon+'"></span>'),
      div = $('<div></div>');

    if ( this.settings.isSpinnerTdIcon ) {
      div.addClass( this.classes.ajaxIndicatorRight );  
    }
    else if ( this.settings.isSpinnerTdContent ) {
      div.addClass( this.classes.ajaxIndicatorContent );   
    }
    
    div.append(icon);
    return div;
  },  
//
//
  _showSpinner: function(){

    if ( this.settings.isSpinnerTdIcon ) {
      this.spinner = this._ajaxCreateIndicatorTdIcon();
      this.td.append( this.spinner );
    }
    else if ( this.settings.isSpinnerReport ) {
      this.spinner = apex.util.showSpinner( this.table );
    }
    else if ( this.settings.isSpinnerTdCell ) {
      this.spinner = apex.util.showSpinner( this.td );
    }
    else if ( this.settings.isSpinnerTdContent ) {
      this.spinner = this._ajaxCreateIndicatorTdIcon();
      if ( this.td.children().length > 0 ) {
        this.td.data('pretius-nestedReport-content', this.td.children().detach() );
      }
      else {
        this.td.data('pretius-nestedReport-content', this.td.text() );
      }
      
      this.td.html( this.spinner );
    }
    else {
      
      return  this.throwError({
        title: this.errorTypes.configuration.title,
        text : 'Unknown spinner option',
        pre  : ['attribute12: '+this.options.action.attribute12],
        hints : [],

        addInfo: 'Unknown spinner option',
        error: 'attribute12: '+this.options.action.attribute12
      }, this.errorTypes.configuration );

    }
  },
//
//
  _hideSpinner: function(){
    if ( this.settings.isLoadingIndicator ) {
      this.spinner.fadeOut(400, $.proxy(function(){ 
        this.spinner.remove();

        if ( this.settings.isSpinnerTdContent ) {
          this.td.html( this.td.data('pretius-nestedReport-content') )
        }
      }, this));
    }
  },

//
//
  renderTemplateCustom: function(){
    var 
      template = this.settings.customTemplate,
      rendered,
      dataObject = this.nestedReport.ajaxData,
      error = {
        addInfo: null,
        error: null
      },
      rendered,
      errorText;

    if ( dataObject.data.length == 0 ) {
      return this._renderNoDataFound();
    }

    try {
      rendered = Mustache.render( template, dataObject);
    } catch( error ) {

      error.addInfo = 'While rendering custom template unexpected error occured: ';
      error.error = error;
      return this._getErrorTemplate( error, 'configuration' );
    }

    return rendered;
  },  
//
//
  _renderNoDataFound: function(){
    return '<div class="noDataFound">'+this.settings.noDataFound+'</div>'
  },
//
//
  getTemplateDefaultBody: function(){
    var 
      dataObject = this.nestedReport.ajaxData,
      td_row_template = '',
      level = this.inception.level;


    for ( var i = 0; i < dataObject.headers.length; i++ ) {
      td_row_template += ''                                                                   +
        '<td'                                                                                 +
          ' headers="NR_'+level+'_'+dataObject.headers[i].COLUMN_NAME+'" '                    +
          ' level="'+level+'" '                                                               +
          ' class="'+this.classes.nestedReportCell+' '+dataObject.headers[i].COLUMN_TYPE+'"'  +
          ' type="'+dataObject.headers[i].COLUMN_TYPE+'"'                                     +
        '>'                                                                                   +
          '{{{'+ dataObject.headers[i].COLUMN_NAME +'}}}'                                     +
        '</td>';
    }

    td_row_template = '{{#data}}<tr class="{{rowClass}}">'+td_row_template+'</tr>{{/data}}';     
    return td_row_template;
  },
//
//
  getTemplateDefault: function(){
    var
      th_row_template = '',
      dataObject = this.nestedReport.ajaxData,
      template,
      headerHtml,
      headerArr,
      isHeaderIcon = false,
      tableClass = this.settings.isStrechReport ? this.classes.nestedReportTable+' '+this.classes.tableStrechReport : this.classes.nestedReportTable;

    for ( var i = 0; i < dataObject.headers.length; i++ ) {
      //icons fa-iconname
      if ( /^derivied[0-9]{1}[0-9]{1}_fa_[a-z]{3,}$/gi.test( dataObject.headers[i].COLUMN_NAME.toLowerCase()) ) {
        headerArr = dataObject.headers[i].COLUMN_NAME.split('_');
        headerHtml = '<span class="fa fa-'+headerArr[2].toLowerCase()+'"></span>';
        isHeaderIcon = true;
      }
      //icons fa-iconname-morename
      else if (/^derivied[0-9]{1}[0-9]{1}_fa_[a-z]{3,}_[a-z]{3,}$/gi.test( dataObject.headers[i].COLUMN_NAME.toLowerCase()) ) {
        headerArr = dataObject.headers[i].COLUMN_NAME.split('_');
        headerHtml = '<span class="fa fa-'+headerArr[2].toLowerCase()+'-'+headerArr[3].toLowerCase()+'"></span>';
        isHeaderIcon = true;
      }
      else if ( /^derivied[0-9]{1}[0-9]{1}_empty$/gi.test( dataObject.headers[i].COLUMN_NAME.toLowerCase()) ) {
        headerHtml = '<!-- '+dataObject.headers[i].COLUMN_NAME+' -->';
        isHeaderIcon = true;
      }
      else {
        isHeaderIcon = false;
        headerHtml = dataObject.headers[i].COLUMN_NAME;
      }

      if ( this.settings.isSortingSupported && isHeaderIcon == false ) {
        th_row_template += ''+
          '<th column="'+dataObject.headers[i].COLUMN_NAME+'"                                     '+
          '    class="'+this.classes.nestedReportHeader+' '+dataObject.headers[i].COLUMN_TYPE+'"> '+ 
          '  <div class="u-Report-sort">                                                          '+
          '    <span class="u-Report-sortHeading">                                                '+
          '      <a href="javascript:void(0)" title="Sort by this column">'+  headerHtml +'</a>   '+
          '    </span>                                                                            '+
          '    <span class="u-Report-sortIcon a-Icon icon-rpt-sort-desc"></span>                  '+
          '    <span class="u-Report-sortIcon a-Icon icon-rpt-sort-asc"></span>                   '+
          '  </div>                                                                               '+
          '</th>';  
      }
      else {
        th_row_template += '<th '+
          'class="'+this.classes.nestedReportHeader+' '+( isHeaderIcon ? 'ICON' : '' )+' '+dataObject.headers[i].COLUMN_TYPE+'"'+
          'column="'+dataObject.headers[i].COLUMN_NAME+'">'+ headerHtml +'</th>';
      }
    }

    th_row_template = '<tr>'+th_row_template+'</tr>';
    
    template = '<table class="'+tableClass+'"><thead>'+th_row_template+'</thead><tbody>'+ this.getTemplateDefaultBody() +'</tbody></table>';
    return template;

  },  
//
// Used by this.sort function to render tbody of nested report
  renderTemplateDefaultBody: function(){
    return Mustache.render( this.getTemplateDefaultBody(), this.nestedReport.ajaxData );
  },
//
//
  renderTemplateDefault: function(){
    var 
      content;

    if ( this.nestedReport.ajaxData.data.length == 0 ) {
      content = $(this._renderNoDataFound());
    }
    else {
      content = Mustache.render( this.getTemplateDefault(), this.nestedReport.ajaxData );
      content = $(content);

      content.css({
        'backgroundColor': this.settings.bgColor
      });

      content.find('th a').bind('click', $.proxy(this.sort, this));  
    }

    return content;
  },  
//
//
  createDefaultCallbackRow: function(){
    //do rozwazenia, nadawanie unikalnego ID
    var 
      tr            = $('<tr></tr>'),
      td            = $('<td></td>'),
      divInTd       = $('<div></div>'),
      divTdOverflow = $('<div></div>');

    //jesli wykorzystuje maxHeight to ustaw maxHeight oraz ustaw referencje gdzie pisać
    if ( this.settings.isSetMaxHeight ) {
      divTdOverflow.addClass( this.classes.nestedReportOverflowContainer )
      divTdOverflow.css('maxHeight', this.settings.maxHeight);
      divTdOverflow.appendTo( divInTd );
      this.nestedReport.contentHere = divTdOverflow;
    }
    else {
      this.nestedReport.contentHere = divInTd;
    }

    tr.attr('nested-level', this.inception.level );
    tr.addClass( this.classes.nestedReportTrContainer );
    td.attr('colspan', this.row.find('td').length);

    divInTd.addClass( this.classes.nestedReportDivContainer );

    td.on('mouseenter', $.proxy(this._highlight,this))
    td.on('mouseleave', $.proxy(this._removeHighlight,this));

    td.append( divInTd );
    tr.append( td );

    return tr;
  },
//
//
  _getErrorTemplate: function( pError ){
    var 
      title, div;


    if ( pError.pre instanceof Array ) {
      pError.pre = pError.pre.join("\n");
      pError.pre = pError.pre.replace(/</gi, '&lt;').replace(/>/gi, '&gt;');
    }
    else if ( pError.pre instanceof Object ) {
      pError.pre = JSON.stringify( pError.pre, null, 2 ).replace(/</gi, '&lt;').replace(/>/gi, '&gt;');
    }
    else if ( typeof pError.pre == "string") {
      pError.pre = pError.pre.replace(/</gi, '&lt;').replace(/>/gi, '&gt;'); 
    }
    else {
      apex.debug.info('_getErrorTemplate type of pError.pre:', (typeof pError.pre) )
    }

    //zrobic bardziej czytelne
    div = $(''+
      '<div class="pretius--error">                                    '+
      '  <div class="pretius--reason">                                 '+
      '    <span class="fa fa-warning"></span>                         '+
      '    <span class="pretius--errorTitle">'+pError.title+'</span>   '+
      '  </div>                                                        '+
      '  <div>                                                         '+
      '    <span class="pretius--errorAddInfo">'+pError.text+'</span>  '+
      '  </div>                                                        '+
      '  <div class="pretius--techError">                              '+
      '    <pre>'+pError.pre+'</pre>                                   '+
      '  </div>                                                        '+
      '</div>                                                          '+
    '');

    return div;
  },  

//
//
  _expandedInReport: function(){
    var expandedElements = $();

    this.table.find('td').each( function(){
      var 
        self = $(this),
        tdOwner = self.data('pretius-nestedReport-owner');

      if ( tdOwner != undefined && tdOwner.nestedReport('isExpanded') == true ) {
        expandedElements = expandedElements.add( tdOwner );
      }


    } );

    return expandedElements;
  },
//
//
  _expandedSisters: function(){
    var expandedElements = $();

    this.row.find('td').each( function(){
      var 
        self = $(this),
        tdOwner = self.data('pretius-nestedReport-owner');

      if ( tdOwner != undefined && tdOwner.nestedReport('isExpanded') == true ) {
        expandedElements = expandedElements.add( tdOwner );
      }
    } );

    return expandedElements;
  },  
//
//
  sort: function( pEvent ){
    var 
      anchor = $(pEvent.currentTarget),
      th = anchor.closest('th'),
      otherTh = th.prevAll().add( th.nextAll() ),
      div = th.find('.u-Report-sort'),
      headerText = anchor.text();

    //apex.debug.log('sort', 'nestedReportData', this.nestedReport.ajaxData);

    otherTh.find('.u-Report-sort').removeClass('sort--desc sort--asc sort');

    if ( !div.is('.sort') || div.is('.sort--asc')) {
      this.nestedReport.ajaxData.data.sort(this._sortFunc( headerText ));
      this.nestedReport.ajaxData.data.reverse();
      div.removeClass('sort--asc').addClass( 'sort sort--desc' );
    }
    else {
      this.nestedReport.ajaxData.data.sort(this._sortFunc( headerText ));
      div.removeClass('sort--desc').addClass( 'sort sort--asc' ); 
    }

    this.nestedReport.contentHere.find('tbody').html( this.renderTemplateDefaultBody() );
  },
//
//
  _sortFunc: function(pProperty) {
    var sortOrder = 1;

    if(pProperty[0] === "-") {
      sortOrder = -1;
      pProperty = pProperty.substr(1);
    }

    return function (a,b) {
      var result = (a[pProperty] < b[pProperty]) ? -1 : (a[pProperty] > b[pProperty]) ? 1 : 0;
      return result * sortOrder;
    }
  },
//
//
  _removeHighlight: function( pEvent ){
    pEvent.stopImmediatePropagation();

    if ( this.expanded ) {
      this.td.css( 'backgroundColor', this.settings.bgColor )
      this._forceBackgroundColor( this.td );

      this.nestedReport.td.css( 'backgroundColor', this.settings.bgColor );


      this.row.removeClass('pretius--hover');
      //blad gdy wylaczony cache i nastepuja proba odswiezenia nested report z poziomu nested report
      this.nestedReport.tr.removeClass('pretius--hover');
    }
  },
//
//
  _highlight: function( pEvent ){
    pEvent.stopImmediatePropagation();

    if ( this.expanded ) {
      this.td.css( 'backgroundColor', this.settings.BgColorhighlight );
      //its needed to override !important from APEX theme css
      this._forceBackgroundColor( this.td );

      this.nestedReport.td.css( 'backgroundColor', this.settings.BgColorhighlight );
      
      this.row.addClass('pretius--hover');
      this.nestedReport.tr.addClass('pretius--hover');
    }
  },
//
//
  changeBorderStyle: function(){
    var 
      otherTds    = this.td.prevAll('td').add( this.td.nextAll('td') ),
      borderStyle = 'solid',
      borderWidth = '1px',
      borderColor = this.settings.borderColor,
      bgColor     = this.settings.bgColor;

    if ( this.expanded ) {
      this.td.css({
        'border-left'    : borderWidth+' '+borderStyle+' '+borderColor,
        'border-top'     : borderWidth+' '+borderStyle+' '+borderColor,
        'border-right'   : borderWidth+' '+borderStyle+' '+borderColor,
        'border-bottom'  : borderWidth+' '+borderStyle+' '+bgColor,
        'backgroundColor': bgColor
      });

      this.nestedReport.td.css({
        'backgroundColor': bgColor,
        'borderLeft'     : borderWidth+' '+borderStyle+' '+borderColor,
        'borderRight'    : borderWidth+' '+borderStyle+' '+borderColor,
        'borderBottom'   : borderWidth+' '+borderStyle+' '+borderColor
      });

      otherTds.css('border-bottom', borderWidth+' '+borderStyle+' '+borderColor);
    }
    else {
      this.td.css({
        'border-left'    : '',
        'border-top'     : '',
        'border-right'   : '',
        'border-bottom'  : '',
        'backgroundColor': ''
      });

      if ( this.nestedReport.tr.is(':last-child') ) {
        this.nestedReport.tr.show();
        this.nestedReport.td.css('borderColor', this.td.css('borderTopColor'));
      }

      otherTds.css('border-bottom', '');
    }
  },
//
//
  _overrideApexTrHover: function( pFlag ){
    if ( this.isExpanded() ) {
      //ustaw kolor jak z konfiguracji
      this.td.css( 'backgroundColor', this.settings.bgColor );
      //its needed to override !important from APEX theme css
      this._forceBackgroundColor( this.td );
    }
  },
//
//
  _forceBackgroundColor: function( pElem ) {
    var 
      styles = pElem.attr('style'),
      arr = styles.split(';');

    for (var idx in arr) {
      if ( arr[idx].indexOf('background-color') > -1 ) {
        arr[idx] += ' !important'
      }
    }

    pElem.attr('style', arr.join(';'));
  },
//
//
  callbackExpanded: function(){
    this.animationRunning = false;
    apex.event.trigger(this.affectedElement, 'pretius_default_callback', this.getEventData());
  },
//
//
  getEventData: function(){
    var 
      isAfterRefresh = false,
      returnObject;

    //after refresh but animation is in progress (duration = 0)
    if ( this.ajax.isRefresh == true && this.animationRunning == true && this.expanded == true ) {
      isAfterRefresh = true;
    }
    //after refresh byt row is fully expanded
    else if ( this.ajax.isRefresh == true && this.animationRunning == false && this.expanded == true ) {
      isAfterRefresh = true;
      this.ajax.isRefresh = false;
    }

    returnObject = {
      'isCollapsing'      : this.animationRunning == true  && this.expanded == true  ? true : false,
      'isCollapsed'       : this.animationRunning == false && this.expanded == false ? true : false,
      'isExpanding'       : this.animationRunning == true  && this.expanded == false ? true : false,
      'isExpanded'        : this.animationRunning == false && this.expanded == true  ? true : false,
      'animationRunning'  : this.animationRunning,
      'afterRefresh'      : isAfterRefresh,
      //'plugin'            : this,
      'report'            : this.affectedElement,
      'triggeringTd'      : this.td,
      'triggeringElement' : this.element,
      'nestedReportRow'   : this.nestedReport.tr,
      'nestedReportData'  : this.nestedReport.ajaxData,
      'parent'            : this.inception
    };

    
    return returnObject;
  },
//
//
  callbackCollapsed: function(){
    this.td.removeClass( this.classes.tdExpanded );
    this.expanded = false;

    this.nestedReport.tr.hide();
    this.changeBorderStyle();

    if ( this.settings.isCacheResults == false) {
      this.nestedReport.tr.remove();
    }
    this.animationRunning = false;
    apex.event.trigger(this.affectedElement, 'pretius_default_callback', this.getEventData());
  }
});