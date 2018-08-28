package com.aquima.plugin.xslt.util;

import com.aquima.web.util.RedirectHelper;

import org.springframework.web.util.UriComponentsBuilder;

public class XsltRedirectHelper extends XsltPathHelper implements RedirectHelper {

  public XsltRedirectHelper(UriComponentsBuilder base) {
    super(base);
  }

}
