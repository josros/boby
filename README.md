1. Got to: Help -> Install New Software...
2. On the "Available Software" Dialog click "Add..."
3. Copy into the Location field:
jar:https://dl.dropboxusercontent.com/u/55014561/repo/de.jro.tools.boby.repository-1.0.0-SNAPSHOT.zip!/

and click "OK".
Select "Boby" and follow the installation procedure.
After restarting your IDE boby should be available.
4. In your java project create a file "<name>.boby"
Eclipse asks you if you want to convert your project into an Xtext project. Click "Yes".
6. Now edit your boby file. You can start with the following example:

package de.test {
	boby immutable TestVO {
		test: String
	}
}

See known issues to solve the null error.

7. Boby creates java files in the src-gen folder, convert the folder into a src-package from the context menu (right click) -> Build Path -> Use as Source Folder. Generated sources should now be acessible from within your java code.


Known issues

1. null - See error logs for details.
Workaround: Just make a little change and save your boby file again.




