package com.aquima.plugin.xslt.ui;

import com.aquima.interactions.composer.IPage;
import com.aquima.interactions.composer.RuntimeKey;
import com.aquima.interactions.foundation.DataType;
import com.aquima.interactions.foundation.IPrimitiveValue;
import com.aquima.interactions.foundation.IValueFormatter;
import com.aquima.interactions.foundation.exception.AppException;
import com.aquima.interactions.foundation.text.StringUtil;
import com.aquima.interactions.portal.PortalEvent;
import com.aquima.interactions.project.impl.ValueFormatter;
import com.aquima.interactions.project.impl.XssSafeValueFormatter;
import com.aquima.web.ui.IRuntimeKeyMapper;
import com.aquima.web.ui.IRuntimeKeyParser;
import com.aquima.web.ui.PageWard;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.context.request.WebRequest;

/**
 * Parses the portal even from the request. Ensures that portal keys are added and the rest is mapped to unknown values.
 * 
 * @author F. van der Meer
 * @since 5.0
 */
public class PortalEventParser {

  private static final Logger LOG = LoggerFactory.getLogger(PortalEventParser.class);
  // note: we're working with strings only, so the passed formatter does not need to understand other formats
  private static final IValueFormatter FORMATTER =
      new XssSafeValueFormatter(new ValueFormatter(null, null, null, null, null, null, null));

  private static final String EVENT = "event";

  private final WebRequest request;
  private final IPage currentPage;
  private final IRuntimeKeyParser runtimeKeyParser;

  /**
   * Constructs a new PortalEvent parser.
   * 
   * @param request the current request
   * @param currentPage the current page
   * @param runtimeKeyMapper The optional runtime key parser
   */
  public PortalEventParser(WebRequest request, IPage currentPage, IRuntimeKeyMapper runtimeKeyMapper) {
    if (runtimeKeyMapper == null) {
      throw new IllegalArgumentException("runtimeKeyMapper is mandatory");
    }

    this.request = request;
    this.currentPage = currentPage;
    this.runtimeKeyParser = runtimeKeyMapper.getParser(currentPage);
  }

  public PortalEvent parseRequest(PageWard pageWard) throws AppException {
    return this.parseRequest(pageWard, null);
  }

  /**
   * Parses the input parameters into a portal event. The input parameters are parsed and when a button input is found
   * it is set as the portal - event itself.
   * 
   * The portal event's event is either a runtime key of a field/container .. or a button which is pressed. All extra
   * request parameters are passed via the parameters in the event (String parameters)
   * 
   * @return PortalEvent instance or null when the request is not an expected submit.
   * @throws AppException This exception is raised when an error was encountered during the parse of the request.
   */
  public PortalEvent parseRequest(PageWard pageWard, String idPrefix) throws AppException {
    if (pageWard.isExpectedSubmit(this.request, idPrefix)) {
      // cast a new ward so we don't get unexpected parallel submits.
      pageWard.generateNewWard();
    } else {
      LOG.info("Unexpected request, expecting page ward '" + pageWard.getWard() + "'");
      return null;
    }

    PortalEvent portalEvent = new PortalEvent();

    for (String key : this.request.getParameterMap().keySet()) {

      String parsedKey = key;
      if (idPrefix != null && key.startsWith(idPrefix)) {
        parsedKey = key.substring(idPrefix.length());
      }

      String[] values = this.request.getParameterValues(key);
      values = (values == null) ? new String[0] : values;

      RuntimeKey pageElementKey = this.runtimeKeyParser.parse(this.removeImage(parsedKey));

      if (parsedKey.equalsIgnoreCase(EVENT)) {
        if (values.length > 1) {
          throw new IllegalArgumentException("event parameter contained multiple values.");
        }
        if (values.length == 1 && !StringUtil.isEmpty(values[0])) {
          String eventValue = values[0];
          if (idPrefix != null && eventValue.startsWith(idPrefix)) {
            eventValue = eventValue.substring(idPrefix.length());
          }
          RuntimeKey eventElementKey = this.runtimeKeyParser.parse(eventValue);
          portalEvent.setEvent(eventElementKey);
        }
        continue;
        // otherwise continue and it may be parsed
      } else if (pageElementKey != null && pageElementKey.getKeyString().indexOf("-B") >= 0) {
        if (StringUtil.isEmpty(this.request.getParameter(EVENT))) {
          // the value is the key, which was the button.
          portalEvent.setEvent(pageElementKey);
          continue;
        }
      }

      if (pageElementKey != null && pageElementKey.getKeyString().startsWith("P") && values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          String formattedValue = values[i];
          if (!StringUtil.isEmpty(formattedValue)) {
            final IPrimitiveValue formattedPrimitive = FORMATTER.parse(formattedValue, DataType.STRING);
            if (formattedPrimitive.isUnknown()) {
              formattedValue = "";
            } else {
              formattedValue = formattedPrimitive.stringValue();
            }
          }
          try {
            portalEvent.addValue(pageElementKey, formattedValue);
          } catch (IllegalArgumentException e) {
            portalEvent.addParameter(key, values[i]);
          }
        }
      } else {
        for (int i = 0; i < values.length; i++) {
          portalEvent.addParameter(key, values[i]);
        }
      }

    }

    // empty checkboxes are NOT passed by the httpRequest, set value to false for empty boolean fields on the
    // current page
    EmptyCheckboxValueFixer visitor = new EmptyCheckboxValueFixer(portalEvent);
    this.currentPage.accept(visitor);

    return portalEvent;
  }

  /**
   * When an image-submit button is pressed an 2 times the submit value is passed to the webserver
   * 
   * <pre>
   * key.x
   * </pre>
   * 
   * and
   * 
   * <pre>
   * key.y
   * </pre>
   * 
   * in which the coordinates of the click-action are held. These are stripped since they have no meaning in the portal
   * engine.
   * 
   * @param key submit value
   * @return removed the same or a new key with <b>.x</b> and <b>.y</b> removed.
   */
  private String removeImage(String key) {
    if (key.endsWith(".x") || key.endsWith(".y")) {
      return key.substring(0, key.length() - 2);
    }
    return (key);
  }
}
