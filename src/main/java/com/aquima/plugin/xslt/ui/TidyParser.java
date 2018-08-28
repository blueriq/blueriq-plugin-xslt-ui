package com.aquima.plugin.xslt.ui;

import com.aquima.plugin.xslt.dom.DocumentWrapper;

import org.apache.commons.io.output.NullWriter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.tidy.Tidy;
import org.w3c.tidy.TidyMessage;
import org.w3c.tidy.TidyMessageListener;

import java.io.PrintWriter;
import java.io.Reader;
import java.io.StringWriter;
import java.util.Properties;

/**
 * This class may be used to parse an html using Tidy with some default settings.
 * 
 * @author Jon van Leuven
 * @since 9.0
 */
public class TidyParser {

  private static final Logger LOG = LoggerFactory.getLogger(TidyParser.class);

  private final TidyMessageListener messageListener;

  public TidyParser() {
    this(new TidyLogger("default"));
  }

  public TidyParser(TidyMessageListener messageListener) {
    if (messageListener == null) {
      throw new IllegalArgumentException("Unable to construct a Tidy parser with no message listener");
    }
    this.messageListener = messageListener;
  }

  public Document parseHtml(Reader input) {
    Tidy tidy = new Tidy();
    tidy.setInputEncoding("UTF-8");
    tidy.setOutputEncoding("UTF-8");
    tidy.setXHTML(false);
    tidy.setMessageListener(this.messageListener);
    tidy.setErrout(new PrintWriter(new NullWriter())); // disable printing to stderr
    tidy.setTrimEmptyElements(false);
    tidy.setDropEmptyParas(false);
    Properties html5tags = new Properties(); // make configurable?
    html5tags.setProperty("new-blocklevel-tags",
        "article,aside,audio,bdi,canvas,command,datalist,details,embed,figcaption,figure,footer,header,hgroup,keygen,mark,meter,nav,output,progress,rp,rt,ruby,section,source,summary,time,track,video,wbr");
    html5tags.setProperty("new-empty-tags", "keygen,output,progress,source,track,wbr");
    html5tags.setProperty("new-inline-tags", "keygen,output,progress,source,track,wbr");
    tidy.setConfigurationFromProps(html5tags);
    if (LOG.isTraceEnabled()) {
      StringWriter settings = new StringWriter();
      tidy.getConfiguration().printConfigOptions(settings, true);
      LOG.trace("JTidy settings: " + settings.toString());
    }
    return new DocumentWrapper(tidy.parseDOM(input, null));
  }

  public static class TidyLogger implements TidyMessageListener {
    private final String name;

    protected TidyLogger(String name) {
      this.name = name;
    }

    @Override
    public void messageReceived(TidyMessage message) {
      if (message.getLevel() == TidyMessage.Level.ERROR) {
        LOG.error(formatMessage(message));
      } else if (message.getLevel() == TidyMessage.Level.WARNING) {
        LOG.warn(formatMessage(message));
      } else if (message.getLevel() == TidyMessage.Level.SUMMARY) {
        if (LOG.isDebugEnabled()) {
          LOG.debug(formatMessage(message));
        }
      } else if (message.getLevel() == TidyMessage.Level.INFO) {
        if (LOG.isDebugEnabled()) {
          LOG.debug(formatMessage(message));
        }
      }
    }

    private String formatMessage(TidyMessage message) {
      if (message.getLine() == 0 && message.getColumn() == 0) {
        return String.format("[%10s] %s", this.name, message.getMessage());
      }
      return String.format("[%10s] %s at line %s, column %s", this.name, message.getMessage(), message.getLine(),
          message.getColumn());
    }
  }

}
