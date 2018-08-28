package com.aquima.plugin.xslt.ui;

import com.aquima.interactions.composer.ICompositeElement;
import com.aquima.interactions.composer.IElement;
import com.aquima.interactions.composer.IField;
import com.aquima.interactions.composer.IVisitor;
import com.aquima.interactions.composer.RuntimeKey;
import com.aquima.interactions.foundation.DataType;
import com.aquima.interactions.foundation.exception.AppException;
import com.aquima.interactions.portal.PortalEvent;

/**
 * This visitor can be used to add "empty" values to the event for empty check-boxes. Empty check-boxes are not passed
 * through the httpRequest.
 * 
 * since this is a HTTP-specific problem this is fixed in the webapplication.
 * 
 * @author Jon van Leuven
 * @since 5.0
 */
public class EmptyCheckboxValueFixer implements IVisitor {

  private final PortalEvent portalEvent;

  /**
   * Constructs the empty-check-visitor for the specified portal event.
   * 
   * @param portalEvent The portal event that should be modified.
   */
  public EmptyCheckboxValueFixer(PortalEvent portalEvent) {
    this.portalEvent = portalEvent;
  }

  @Override
  public IVisitor accept(IElement element) throws AppException {
    if (element instanceof IField) {
      IField field = (IField) element;
      if (!field.isReadonly() && field.isVisible()) {
        RuntimeKey runtimeKey = element.getRuntimeKey();
        // boolean field
        if (field.getDataType().equals(DataType.BOOLEAN) && field.getDomain() == null) {
          if (this.portalEvent.getValue(runtimeKey) == null) {
            this.portalEvent.setValues(runtimeKey, "false");
          }
        } else if (field.getDomain() != null && field.isMultiValue()) {
          // domain field with checkboxes
          // Only clear when it is a multi-value domain (as single value domains will not be shown with
          // checkboxes).
          if (this.portalEvent.getValue(runtimeKey) == null) {
            this.portalEvent.setValues(runtimeKey, "");
          }
        } else if (field.getDomain() != null && field.isRequired() && this.portalEvent.getValue(runtimeKey) == null) {
          // domain field with radio button is not submitted if no button is checked.
          // AQ-590: Conditional value list en required op pagina werkt niet samen
          this.portalEvent.setValues(runtimeKey, "");
        }
      }
    }

    return this;
  }

  @Override
  public void leave(ICompositeElement container, IVisitor childVisitor) throws AppException {
    // void
  }
}
