package com.aquima.plugin.xslt;

import static org.junit.Assert.assertEquals;

import com.aquima.interactions.composer.model.Container;
import com.aquima.interactions.composer.model.Field;
import com.aquima.interactions.composer.model.Page;
import com.aquima.interactions.composer.model.RuntimeKeyGenerator;
import com.aquima.interactions.foundation.DataType;
import com.aquima.interactions.foundation.IPrimitiveValue;
import com.aquima.interactions.foundation.types.StringValue;
import com.aquima.interactions.portal.PortalEvent;
import com.aquima.plugin.xslt.ui.EmptyCheckboxValueFixer;

import org.junit.Test;

/**
 * Test case for the EmptyCheckboxValueFixerTestCase
 * 
 * @author d.roest
 * @since 9.0.6
 */
public class EmptyCheckboxValueFixerTestCase {

  /**
   * AQ-590: Conditional value list en required op pagina werkt niet samen
   */
  @Test
  public void radioButtonNoValueButRequired() {

    // SETUP
    PortalEvent portalEvent = new PortalEvent();
    EmptyCheckboxValueFixer fixer = new EmptyCheckboxValueFixer(portalEvent);

    Page page = new Page("page");
    Field field = new Field("person.hobbies", DataType.STRING, false, null, null);
    field.setRequired(true);
    IPrimitiveValue[] domain = new IPrimitiveValue[] { new StringValue("v1"), new StringValue("v2") };
    field.setDomain(domain);

    Container container = new Container("container");
    container.addElement(field);
    page.addElement(container);
    page.accept(new RuntimeKeyGenerator());

    // SUT && verify
    assertEquals(portalEvent.getUpdatedFields().length, 0);
    page.accept(fixer);
    assertEquals(portalEvent.getUpdatedFields().length, 1);
  }

}
