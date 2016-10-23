package de.jro.tools.generation

import com.google.inject.Inject
import de.jro.tools.bob.Builder
import de.jro.tools.bob.CreatorBuilder
import de.jro.tools.bob.GenericBuilder
import de.jro.tools.bob.MockerBuilder
import de.jro.tools.bob.ObjectY
import de.jro.tools.bob.Property
import de.jro.tools.jvmmodel.BobyJvmModelInferrer
import de.jro.tools.util.SuperTypeAnalyzer
import java.util.Iterator
import java.util.function.Function
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.common.types.JvmField
import org.eclipse.xtext.common.types.JvmTypeReference
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.xbase.compiler.ImportManager
import org.eclipse.xtext.xbase.compiler.JvmModelGenerator
import org.eclipse.xtext.xbase.compiler.StringBuilderBasedAppendable
import org.eclipse.xtext.xbase.compiler.TypeReferenceSerializer

/**
 * Responsible for generation of builders, uses BobyJvmModelInferrer to
 * compile remaining part of the model.
 * 
 * @author Rossa
 */
class BobyGenerator extends JvmModelGenerator {

	@Inject extension IQualifiedNameProvider
	@Inject extension TypeReferenceSerializer
	@Inject BobyJvmModelInferrer inferrer
	@Inject SuperTypeAnalyzer superTypeAnalyzer

	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		super.doGenerate(resource, fsa)
		for (b : resource.allContents.toIterable.filter(typeof(Builder))) {
			if (b != null) {
				fsa.generateFile(b.fullyQualifiedName.toString("/") + ".java", b.compile)
			}
		}
	}

	def private compile(Builder it) '''
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

	def private body(Builder it, ImportManager importManager) {
		if (it instanceof GenericBuilder) {
			generic(it, importManager)
		} else if (it instanceof CreatorBuilder) {
			creator(it, importManager)
		} else if (it instanceof MockerBuilder) {
			mocker(it)
		}
	}

// mock builder

	def private mocker(MockerBuilder mock) '''
		import org.mockito.Mockito;
		
		@SuppressWarnings("all")
		public class «mock.name» extends «mock.generic.fullyQualifiedName»<«mock.name»> {
		  «mockMethod(mock.generic.bob)»
		  
		  «spyMethod(mock.generic.bob)»
		}
	'''

	def private mockMethod(ObjectY ob) '''
		public «ob.fullyQualifiedName» mock() {
		   «ob.fullyQualifiedName» mockObj = Mockito.mock(«ob.fullyQualifiedName».class);
		   «var Function<String, String> mockFunction = [ String s | s.mockParameter ]»
		   «applyForAttributes(ob, mockFunction)»
		   return mockObj;
		}
	'''
	
	def private spyMethod(ObjectY ob) '''
		public «ob.fullyQualifiedName» spy() {
		   «ob.fullyQualifiedName» spyObj = Mockito.spy(«ob.fullyQualifiedName».class);
		   «var Function<String, String> spyFunction = [ String s | s.spyParameter ]»
		   «applyForAttributes(ob, spyFunction)»
		   return spyObj;
		}
	'''
	

	def private String spyParameter(String name) '''
		Mockito.doReturn(«name»).when(spyObj).get«name.toFirstUpper»();
	'''

	def private applyForAttributes(ObjectY ob, Function<String, String> applyingFunction) {
		val strBuild = new StringBuilder
		val propIterator = ob.properties.iterator
		if (ob.superType != null) {
			var Iterator<JvmField> patIterator = parentAttributes(ob).iterator
			while (patIterator.hasNext) {
				var JvmField field = patIterator.next
				strBuild.append(applyingFunction.apply(field.simpleName))
			}
		}
		while (propIterator.hasNext) {
			strBuild.append(applyingFunction.apply(propIterator.next.name))
		}
		strBuild.toString
	}

	def private String mockParameter(String name) '''
		Mockito.when(mockObj.get«name.toFirstUpper»()).thenReturn(«name»);
	'''

// build builder

	def private creator(CreatorBuilder it, ImportManager importManager) '''
		@SuppressWarnings("all")
		public class «it.name» extends «it.generic.fullyQualifiedName»<«it.name»> {
		  «buildMethod(it.generic.bob)»
		}
	'''

	def private buildMethod(ObjectY ob) '''
		public «ob.fullyQualifiedName» build() {
		  «IF ob.immutable»
		  	«buildMethodImmutable(ob)»
		  «ELSE»
		  	«buildMethodWithSetters(ob)»
		  «ENDIF»
		}
	'''

	def private buildMethodImmutable(ObjectY ob) '''
		return new «ob.fullyQualifiedName»(«ob.parameters()»);
	'''

	def private buildMethodWithSetters(ObjectY ob) '''
		«ob.fullyQualifiedName» obj = new «ob.fullyQualifiedName»();
		«val strBuild = new StringBuilder»
		«parentSetter(ob, strBuild)»
		«objSetter(ob, strBuild)»
		«strBuild.toString»
		return obj;
	'''

	def private parentSetter(ObjectY ob, StringBuilder strBuild) {
		var Iterator<JvmField> patIterator = parentAttributes(ob).iterator
		while (patIterator.hasNext) {
			var JvmField field = patIterator.next
			strBuild.append(setter(field.simpleName))
		}
	}

	def private objSetter(ObjectY ob, StringBuilder strBuild) {
		ob.properties.forEach [
			strBuild.append(setter(it.name))
		]
	}

	def private setter(String attrName) '''
		obj.set«firstToUpperCase(attrName)»(«attrName»);
	'''

	def private parameters(ObjectY ob) {
		val strBuild = new StringBuilder
		val propIterator = ob.properties.iterator
		if (ob.superType != null) {
			appendParentParameters(strBuild, ob, propIterator.hasNext)
		}
		while (propIterator.hasNext) {
			strBuild.append(propIterator.next.name)
			if (propIterator.hasNext) {
				strBuild.append(",")
			}
		}
		strBuild.toString
	}

	def private appendParentParameters(StringBuilder strBuild, ObjectY ob, boolean hasMore) {
		var Iterator<JvmField> patIterator = parentAttributes(ob).iterator
		while (patIterator.hasNext) {
			var JvmField field = patIterator.next
			strBuild.append(field.simpleName)
			if (patIterator.hasNext) {
				strBuild.append(",")
			} else if (hasMore) {
				strBuild.append(",")
			}
		}
	}

//generic builder

	def private generic(GenericBuilder it, ImportManager importManager) '''
		@SuppressWarnings("all")
		public class «it.name»<B extends «it.name»<B>> {
		  «attributes(it.bob, importManager)»
		  
		  «methodsGeneric(it.bob, importManager)»
		}
	'''

	def private attributes(ObjectY ob, ImportManager importManager) {
		val strBuild = new StringBuilder
		if (ob.superType != null) {
			appendParentAttributes(strBuild, ob, importManager)
		}
		val propIterator = ob.properties.iterator
		while (propIterator.hasNext) {
			var Property curProp = propIterator.next
			strBuild.append(attribute(curProp.type, curProp.name, importManager))
		}
		strBuild.toString
	}

	def private appendParentAttributes(StringBuilder strBuild, ObjectY ob, ImportManager importManager) {
		var Iterator<JvmField> patIterator = parentAttributes(ob).iterator
		while (patIterator.hasNext) {
			var JvmField field = patIterator.next
			strBuild.append(attribute(field.type, field.simpleName, importManager))
		}
	}

	def private attribute(JvmTypeReference type, String name, ImportManager importManager) '''
		protected «type.shortName(importManager)» «name»;
	'''

	def private methodsGeneric(ObjectY ob, ImportManager importManager) {
		val strBuild = new StringBuilder
		if (ob.superType != null) {
			appendParentMethods(strBuild, ob, importManager)
		}
		val propIterator = ob.properties.iterator
		while (propIterator.hasNext) {
			var Property curProp = propIterator.next
			strBuild.append(methodGeneric(curProp.type, curProp.name, importManager))
			if (propIterator.hasNext) {
				strBuild.append(System.getProperty("line.separator"))
			}
		}
		strBuild.toString
	}

	def private appendParentMethods(StringBuilder strBuild, ObjectY ob, ImportManager importManager) {
		var Iterator<JvmField> patIterator = parentAttributes(ob).iterator
		while (patIterator.hasNext) {
			var JvmField field = patIterator.next
			strBuild.append(methodGeneric(field.type, field.simpleName, importManager))
		}
	}

	def private methodGeneric(JvmTypeReference type, String name, ImportManager importManager) '''
		@SuppressWarnings("unchecked")
		public B «name»(«type.shortName(importManager)» «name») {
		  this.«name» = «name»;
		  return (B) this;
		}
	'''

// Utilities

	def private Iterable<JvmField> parentAttributes(ObjectY ob) {
		if (ob.immutable) {
			superTypeAnalyzer.superTypeFinalParametersRecursively(ob.superType)
		} else {
			superTypeAnalyzer.superTypeParametersRecursivelyWithPredicate(ob.superType, [!it.isStatic && !it.isFinal])
		}
	}

	def private shortName(JvmTypeReference ref, ImportManager importManager) {
		val result = new StringBuilderBasedAppendable(importManager)
		ref.serialize(ref.eContainer, result);
		result.toString
	}

	def private firstToUpperCase(String name) {
		return name.toString.toFirstUpper
	}

}
