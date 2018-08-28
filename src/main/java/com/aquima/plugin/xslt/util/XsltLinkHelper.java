package com.aquima.plugin.xslt.util;

import com.aquima.web.util.LinkHelper;

import org.springframework.web.util.UriComponentsBuilder;

public class XsltLinkHelper extends XsltPathHelper implements LinkHelper {

  public XsltLinkHelper(UriComponentsBuilder base) {
    super(base);
  }

}
