package de.jro.tools.generation

import com.google.inject.Inject
import de.jro.tools.bob.Builder
import de.jro.tools.bob.CreatorBuilder
import de.jro.tools.bob.GenericBuilder
import de.jro.tools.bob.MockerBuilder
import de.jro.tools.bob.ObjectY
import de.jro.tools.bob.Property
import de.jro.tools.jvmmodel.BobyJvmModelInferrer
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.xbase.compiler.ImportManager
import org.eclipse.xtext.xbase.compiler.JvmModelGenerator
import org.eclipse.xtext.xbase.compiler.StringBuilderBasedAppendable
import org.eclipse.xtext.xbase.compiler.TypeReferenceSerializer

class BobyGenerator extends JvmModelGenerator {

	@Inject extension IQualifiedNameProvider
	@Inject extension TypeReferenceSerializer
	@Inject BobyJvmModelInferrer inferrer

	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		super.doGenerate(resource, fsa)
		for (b : resource.allContents.toIterable.filter(typeof(Builder))) {
			if(b != null) {
				fsa.generateFile(b.fullyQualifiedName.toString("/") + ".java", b.compile)	
			}
		}
	}

	def compile(Builder it) '''
		«val importManager = new ImportManager(true)» 
		«val body = body(importManager)»
		«IF eContainer != null»
			package «eContainer.fullyQualifiedName»;
		«ENDIF»
		
		«FOR i : importManager.imports»
			import «i»;
		«ENDFOR»
		
		«body»
	'''

	def body(Builder it, ImportManager importManager) {
		if (it instanceof GenericBuilder) {
			generic(it, importManager)
		} else if (it instanceof CreatorBuilder) {
			creator(it, importManager)
		} else if (it instanceof MockerBuilder) {
			mocker(it, importManager)
		}
	}

	def mocker(MockerBuilder mock, ImportManager importManager) '''
		import org.mockito.Mockito;
		
		public class «mock.name» extends «mock.generic.fullyQualifiedName»<«mock.name»> {
		  «mockMethod(mock.generic.bob, importManager)»
		}
	'''

	def mockMethod(ObjectY ob, ImportManager manager) '''
		public «ob.fullyQualifiedName» mock() {
		   «ob.fullyQualifiedName» mockObj = Mockito.mock(«ob.fullyQualifiedName».class);
		   «FOR prop : ob.properties»
		   	«mockParameter(prop, manager)»
		   «ENDFOR»
		   return mockObj;
		}
	'''

	def mockParameter(Property property, ImportManager manager) '''
		Mockito.when(mockObj.get«property.name.toString.toFirstUpper»()).thenReturn(«property.name»);
	'''

	def firstToUpperCase(Property property) {
		return property.name.toString.toFirstUpper
	}

	def creator(CreatorBuilder it, ImportManager importManager) '''
		public class «it.name» extends «it.generic.fullyQualifiedName»<«it.name»> {
		  «buildMethod(it.generic.bob, importManager)»
		}
	'''

	def buildMethod(ObjectY ob, ImportManager manager) '''
		public «ob.fullyQualifiedName» build() {
		  return new «ob.fullyQualifiedName»(«ob.parameters(manager)»);
		}
	'''

	def parameters(ObjectY ob, ImportManager manager) {
		val strBuild = new StringBuilder
		val propIterator = ob.properties.iterator
		while (propIterator.hasNext) {
			strBuild.append(propIterator.next.name)
			if (propIterator.hasNext) {
				strBuild.append(",")
			}
		}
		strBuild.toString
	}

	def generic(GenericBuilder it, ImportManager importManager) '''
		public class «it.name»<B extends «it.name»<B>> {
		  «attributes(it.bob, importManager)»
		  
		  «methodsGeneric(it.bob, importManager)»
		}
	'''

	def attributes(ObjectY ob, ImportManager importManager) {
		val strBuild = new StringBuilder
		val propIterator = ob.properties.iterator
		while (propIterator.hasNext) {
			strBuild.append(attribute(propIterator.next, importManager))
		}
		strBuild.toString
	}

	def attribute(Property property, ImportManager importManager) '''
		protected «property.type.shortName(importManager)» «property.name»;
	'''

	def methodsGeneric(ObjectY ob, ImportManager importManager) {
		val strBuild = new StringBuilder
		val propIterator = ob.properties.iterator
		while (propIterator.hasNext) {
			strBuild.append(methodGeneric(propIterator.next, importManager))
			if (propIterator.hasNext) {
				strBuild.append(System.getProperty("line.separator"))
			}
		}
		strBuild.toString
	}

	def methodGeneric(Property property, ImportManager importManager) '''
		@SuppressWarnings("unchecked")
		public B «property.name»(«property.type.shortName(importManager)» «property.name») {
		  this.«property.name» = «property.name»;
		  return (B) this;
		}
	'''

	def shortName(JvmTypeReference ref, ImportManager importManager) {
		val result = new StringBuilderBasedAppendable(importManager)
		ref.serialize(ref.eContainer, result);
		result.toString
	}

}
