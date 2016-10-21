package de.jro.tools.util;

import org.eclipse.emf.ecore.EObject;

/**
 * Check and resolve container objects
 * 
 * @author Rossa
 *
 */
public class EncapsulationAnalyzer {

	private EncapsulationAnalyzer() {}
	
	public static <T> boolean isEObjectWithinContainer(EObject eObj, Class<T> container) {
		while(eObj != null) {
			eObj = eObj.eContainer();
			if(container.isInstance(eObj)) {
				return true;
			}
		}
		return false;
	}
	
	@SuppressWarnings("unchecked")
	public static <T> T getContainerToEObject(EObject eObj, Class<T> container) {
		while(eObj != null) {
			eObj = eObj.eContainer();
			if(container.isInstance(eObj)) {
				return (T) eObj;
			}
		}
		throw new RuntimeException("EObject is not within container: " + container.getSimpleName());
	}
	
}
