package tools.vitruv.framework.userinteraction.impl

import java.util.Collection
import org.eclipse.jface.dialogs.Dialog
import org.eclipse.jface.dialogs.IDialogConstants
import org.eclipse.swt.SWT
import org.eclipse.swt.graphics.Point
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Control
import org.eclipse.swt.widgets.Label
import org.eclipse.swt.widgets.Shell
import org.eclipse.swt.widgets.Text
import org.eclipse.xtend.lib.annotations.Accessors
import java.util.ArrayList

class TestDialog extends Dialog {
    static public String topic = ""

    Text txtUser
    @Accessors
    String userInput = ""
    Collection<String> descriptionString

    new(Collection<String> description) {
        super(null as Shell)
        this.descriptionString = description
    }

    override protected Control createDialogArea(Composite parent) {
        var Composite container = (super.createDialogArea(parent) as Composite)
        var GridLayout layout = new GridLayout(1, false)
        layout.marginRight = 5
        layout.marginLeft = 10
        for (element : descriptionString) {
            container.setLayout(layout)
            var Label descriptioLabel = new Label(container, SWT.NONE)
            descriptioLabel.setText(element ?: "null")
        }
        txtUser = new Text(container, SWT.BORDER)
        txtUser.setLayoutData(new GridData(SWT.FILL, SWT.CENTER, true, false, 1, 1))
        txtUser.setText(userInput)
        txtUser.addModifyListener([ e|
            val textWidget = e.getSource() as Text
            val userText = textWidget.getText()
            userInput = userText;
        ])
        return container
    }

    def static void main(String[] args) {
        println(ask(#["TEST", "TEST", "TEST"]))
    }

    override protected void createButtonsForButtonBar(Composite parent) {
        createButton(parent, IDialogConstants.OK_ID, "Ok", true)
    }

    override protected Point getInitialSize() {
        return new Point(800, 300)
    }

    override protected isResizable() {
        return true
    }

    override protected void okPressed() {
        userInput = txtUser.text
        super.okPressed()
    }

    def static ask(Collection<String> input) {
        val text = new ArrayList<String>
        text.add(0, topic)
        text.addAll(input)
        val dialog = new TestDialog(text)
        dialog.open
        dialog.close
        return Integer.parseInt(dialog.userInput)
    }
}
