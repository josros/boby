package de.jro.tools.util

import java.util.ArrayList
import java.util.List
import org.eclipse.xtext.common.types.JvmDeclaredType
import org.eclipse.xtext.common.types.JvmField
import org.eclipse.xtext.common.types.JvmTypeReference
import java.util.function.Predicate

/**
 * @author Rossa
 */
class SuperTypeAnalyzer {
	
	def List<JvmField> superTypeFinalParametersRecursively(JvmTypeReference superType) {
		superTypeParametersRecursivelyWithPredicate(superType, [!it.static && it.final])
	}
	
	def List<JvmField> superTypeParametersRecursivelyWithPredicate(JvmTypeReference superType, Predicate<JvmField> predicate) {
		var List<JvmField> fields = new ArrayList();
		if (superType != null) {
			if (superType.getType() instanceof JvmDeclaredType) {
				var JvmDeclaredType declaredType = superType.getType() as JvmDeclaredType;
				if (declaredType.extendedClass != null) {
					fields.addAll(superTypeParametersRecursivelyWithPredicate(declaredType.extendedClass, predicate))
				}
				fields.addAll(declaredType.declaredFields.filter(predicate)) 
			}
		}
		return fields
	}
	
}