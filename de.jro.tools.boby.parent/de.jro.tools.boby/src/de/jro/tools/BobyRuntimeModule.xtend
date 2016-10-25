/*
 * generated by Xtext 2.10.0
 */
package de.jro.tools

import de.jro.tools.generation.BobyGenerator
import de.jro.tools.util.SuperTypeAnalyzer
import org.eclipse.xtext.generator.IGenerator

/**
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 */
class BobyRuntimeModule extends AbstractBobyRuntimeModule {
		
	override Class<? extends IGenerator> bindIGenerator() {
		return BobyGenerator
	}

	def Class<? extends SuperTypeAnalyzer> bindSuperTypeAnalyzer() {
		return SuperTypeAnalyzer
	}
	
}