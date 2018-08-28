package com.aquima.plugin.xslt.util;

import com.aquima.web.util.PathHelper;

import com.blueriq.component.api.IAquimaSession;

public interface IXsltPathHelper extends PathHelper {

  /**
   * Returns the path to the main page of the XSLT UI.
   * 
   * @param aquimaSessionId The Aquima Session Id for determining the Xslt UI Path
   */
  String getXsltUiPath(String aquimaSessionId);

  /**
   * Returns the path of the current page of the xslt
   * 
   * @param aquimaSession The Aquima Session for determining the Page Path
   */
  String getPagePath(IAquimaSession aquimaSession);
}
