window.pretiusNestedReport = function(da, queryColumns, queryItems, pForceToggle, pPluginAppAttr){
  var 
    self = $(da.triggeringElement),
    duration = undefined;


/*  
  if ( da.affectedElements[0] == undefined ) {
    console.log(1234);
    console.log(da.action);

    if ( da.action.affectedElementsType == "JQUERY_SELECTOR" ) {
      return void(0);
    }

    self.nestedReport(da, queryColumns, queryItems, {
      throwError: {
        addInfo: 'Dynamic action "Affected element" does not exist in DOM.',
        error: ''+
          'Dynamic action affectedElementsType = "'+da.action.affectedElementsType+'"'+"\n"+
          'Dynamic action affectedRegionId = "'+da.action.affectedRegionId+'"        '
      }
    });

    return void(0);
  }
*/  
  
  //check whether Dynamic Action selector is children of affactedElement
  if ( da.affectedElements[0] != undefined && jQuery.contains( da.affectedElements[0], da.triggeringElement ) ) {

    if ( da.data != undefined && da.data.duration != undefined ) {
      duration = da.data.duration;
    }

    if ( self.data('pretius-nestedReport') != undefined ) {
      self.nestedReport('toggle', duration);
    }
    else {
      self.nestedReport(da, queryColumns, queryItems, {'forceToggle': pForceToggle, 'duration': duration}, pPluginAppAttr);
    }
  }
  else {
    null;
    //dynamic action fired by element that is not container within affected element
  }

}