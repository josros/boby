# Boby beta test

This is a first demonstration version of the **boby** (builder and objects y) DSL.
As the name suggests **boby** creates classes for (immutable) data containers and its builders.
You write:

    package de.jro.demo.serviceone.test {
	
	  boby immutable TestVO {
	    test: String
	    test2: Integer
	  }
	
      generic builder GenericTestVOBuilder for TestVO
      build builder TestVOBuilder extends GenericTestVOBuilder
	
    }
    
And **boby** generates three classes for you:

* src-gen/de.jro.demo.serviceone.test.TestVO
* src-gen/de.jro.demo.serviceone.test.GenericTestVOBuilder
* src-gen/de.jro.demo.serviceone.test.TestVOBuilder

representing an immutable value object, a generic and a concrete builder.


# Executive Summary

### Prerequisites

1. Install Eclipse
2. Install java > 1.5.

### Boby Installation


1. Got to: `Help -> Install New Software...`
2. On the "Available Software" Dialog click "Add..."
3. Copy into the Location field:
jar:https://dl.dropboxusercontent.com/u/55014561/repo/de.jro.tools.boby.repository-1.0.0-SNAPSHOT.zip!/

and click "OK".
Select "Boby" and follow the installation procedure.
After restarting your IDE boby should be available.

#### Boby Application

1. In your java project create a file "<name>.boby"
Eclipse asks you if you want to convert your project into an Xtext project. Click "Yes".
2. Now edit your boby file. You can start with the following example:


    package de.test {
	    boby immutable TestVO {
		  test: String
	    }
    }


See known issues to solve the **null error**.

3. Boby creates java files in the src-gen folder, convert the folder into a src-package from the `context menu (right click) -> Build Path -> Use as Source Folder`. Generated sources should now be accessible from within your java code.


# Known issues

1. null - See error logs for details.
Workaround: Just make a little change and save your boby file again.